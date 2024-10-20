#!/bin/bash

SSH_PRIVATE_KEY="-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACCvbYU572GbIXL8QpVMQjGllzw6I50x8tLoW/TYTQp/aQAAAKB3uNFyd7jR
cgAAAAtzc2gtZWQyNTUxOQAAACCvbYU572GbIXL8QpVMQjGllzw6I50x8tLoW/TYTQp/aQ
AAAEANrdbTW7C4HsrTMplfs+EvoBOmNiuKQMJFvqWBN91Nvq9thTnvYZshcvxClUxCMaWX
PDojnTHy0uhb9NhNCn9pAAAAFnJhaWxzQHN0dWR5LmthbnJpbi5iaXoBAgMEBQYH
-----END OPENSSH PRIVATE KEY-----"

  ##
  ## Run ssh-agent (inside the build environment)
  ##
 eval $(ssh-agent -s)

  ##
  ## Add the SSH key stored in SSH_PRIVATE_KEY variable to the agent store
  ## We're using tr to fix line endings which makes ed25519 keys work
  ## without extra base64 encoding.
  ## https://gitlab.com/gitlab-examples/ssh-private-key/issues/1#note_48526556
  ##
 echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add -

  ##
  ## Create the SSH directory and give it the right permissions
  ##
 mkdir -p ~/.ssh
 chmod 700 ~/.ssh

  ##
  ## Use ssh-keyscan to scan the keys of your private server. Replace gitlab.com
  ## with your own domain name. You can copy and repeat that command if you have
  ## more than one server to connect to.
  ##
 ssh-keyscan study.kanrin.biz >> ~/.ssh/known_hosts
 chmod 644 ~/.ssh/known_hosts
# ls -la ~/.ssh
# cat ~/.ssh/known_hosts

#if [ -f /.dockerenv ] || [ -f ./dockerinit ]; then
#fi
