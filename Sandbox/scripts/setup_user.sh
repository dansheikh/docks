uid=$(id -u $USER)
gid=$(id -g $USER)
USERNAME=dev

mkdir -p /home/$USERNAME
mkdir -p /etc/sudoers.d

echo -e "dev:x:${uid}:${gid}:Dev:/home/dev:/bin/bash" >> /etc/passwd
echo -e "dev:x:${uid}:" >> /etc/group
echo -e "dev ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME

chmod 0440 /etc/sudoers.d/$USERNAME
chown "${uid}:${gid}" -R /home/$USERNAME
