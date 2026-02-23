# mbn-filescan-local
MBN Data filescan - on premise container solution
ClamAV 1.2.2

mkdir -p /opt/docker_persist

cd /opt/docker_persist

git clone https://github.com/CSIR-FB/mbn-filescan-local

cd /opt/docker_persist/mbn-filescan-local

docker compose up -d --build

docker logs -f mbn-filescan-local
