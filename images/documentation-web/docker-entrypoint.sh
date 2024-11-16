#!/bin/bash
set -e
if [ -n "$SSH_PRIVATE_KEY" ]; then
    echo "Injecting private SSH key into /root/.ssh/id_rsa..."
    
    # SSH_PRIVATE_KEY=${SSH_PRIVATE_KEY}
    echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa
    chmod 600 /root/.ssh/id_rsa

    echo "SSH key injected successfully."
else
    echo "No SSH_PRIVATE_KEY environment variable set. Skipping key injection."
fi

# Pass control to the main process
exec "$@"
