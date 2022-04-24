#/bin/bash
user=coder
project=demo
port=80
PASSWORD=abc123

echo "project_path=/home/${user}/${project}" >> .env
echo "port=80" >> .env

#1. 設定專案目錄路徑與權限
useradd ${user}
mkdir /home/${user}/${project}
project_path=/home/${user}/${project}
echo "set folder ok"

#2. 建立vscode server容器
docker pull codercom/code-server
docker-compose up -d
docker exec -it code-server sudo chown ${user}:${user} ${project_path}
echo "set contanier ok"

#3. 容器系統更新與安裝python3
docker exec -it code-server sudo apt update
docker exec -it code-server sudo apt-get install python3 python3-pip -y
docker exec -it code-server pip3 --version
echo "vscode update & install python3 ok"


#5. 設定vscode 密碼
docker exec -it code-server sed -i '/password:/d' .config/code-server/config.yaml
docker exec -it code-server  bash -c "echo 'password: ${PASSWORD}' >> .config/code-server/config.yaml"
docker exec -it code-server cat .config/code-server/config.yaml |grep password:
echo "please copy password"

#6. 重啟docker
docker-compose restart
echo "login web is http://serverip:${port}"
