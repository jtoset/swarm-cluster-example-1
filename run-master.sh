apt install -y git
curl https://get.docker.com | sudo bash

mkdir -p /srv/docker 
mkdir -p /srv/nfs
BASERANGE=$(ip -4 a show dev ens4  | awk '/inet/ {print $2}' | cut -d\. -f1-3)
#	Configurar NFS
echo 'instance-1:/srv/nfs /srv/docker nfs defaults,nfsvers=3 0 0' >> /etc/fstab
apt install -y nfs-kernel-server
echo '/srv/nfs '$BASERANGE'.0/24(rw,no_root_squash,no_subtree_check)' >> /etc/exports
systemctl start nfs-kernel-server
exportfs -r
mount -a

docker swarm init 
docker swarm join-token manager|grep join  > /srv/docker/join.sh
chmod +x !$

cd /srv/docker
git clone https://github.com/kpeiruza/swarm-cluster-example

docker network create proxy -d overlay
docker network create portainer_agent -d overlay


