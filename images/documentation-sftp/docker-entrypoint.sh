#!/bin/bash

export_vars() {

  if [ -z "$USER_NAME" ]; then

		cat >&2 <<-'EOE'
			Error: USER_NAME variable is not defined.
		EOE

		exit 1
  fi
  if [ -z "$USER_PASS" ]; then

		cat >&2 <<-'EOE'
			Error: USER_PASS variable is not defined.
		EOE

		exit 1
  fi

  export USER_NAME=$USER_NAME 
  export USER_PASS=$USER_PASS
  export NEW_UID=${SFTP_UID:-82}
  export NEW_GID=${SFTP_GID:-82} 

}

install() {

  # Create a new user and a .ssh directory
  useradd -m -d /home/$USER_NAME -s /usr/sbin/nologin $USER_NAME
  mkdir -p /home/$USER_NAME/.ssh
  chown $USER_NAME:$USER_NAME /home/$USER_NAME/.ssh
  chmod 700 /home/$USER_NAME/.ssh

  # Change UID and GID to match the WebDAV user and encode password
  groupmod -g $NEW_GID $USER_NAME
  usermod --password $(openssl passwd -1 $USER_PASS) -u $NEW_UID $USER_NAME

  # Copy the public key
  # Ensure you replace 'docker_rsa.pub' with your actual public key file name
  touch /home/$USER_NAME/.ssh/authorized_keys

  # Set permissions for the public key
  chmod 600 /home/$USER_NAME/.ssh/authorized_keys
  chown $USER_NAME:$USER_NAME /home/$USER_NAME/.ssh/authorized_keys

  # Create a directory for SFTP that the user will have access to
  mkdir -p /home/$USER_NAME/sftp/html
  chown root:root /home/$USER_NAME /home/$USER_NAME/sftp
  chmod 755 /home/$USER_NAME /home/$USER_NAME/sftp
  chown $USER_NAME:$USER_NAME /home/$USER_NAME/sftp/html
  chmod 755 /home/$USER_NAME/sftp/html

  # Configure SSH for SFTP
  mkdir -p /run/sshd
  echo "Match User $USER_NAME" >> /etc/ssh/sshd_config
  echo "    ChrootDirectory /home/$USER_NAME/sftp/" >> /etc/ssh/sshd_config
  echo "    ForceCommand internal-sftp" >> /etc/ssh/sshd_config
  echo "    PasswordAuthentication yes" >> /etc/ssh/sshd_config
  echo "    PubkeyAuthentication yes" >> /etc/ssh/sshd_config
  echo "    PermitTunnel no" >> /etc/ssh/sshd_config
  echo "    AllowAgentForwarding no" >> /etc/ssh/sshd_config
  echo "    AllowTcpForwarding no" >> /etc/ssh/sshd_config
  echo "    X11Forwarding no" >> /etc/ssh/sshd_config

}

main() {
  export_vars
  install
  /usr/sbin/sshd -D -e
}

main

