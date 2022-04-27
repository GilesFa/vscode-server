#/bin/bash
user=coder
project=demo
outside_port=80
inside_port=8080
PASSWORD=abc123

#環境變數設定
cat >.env<<EOF 
project_path=/home/${user}/${project}
outside_port=${outside_port}
inside_port=${inside_port}
EOF

mkdir ./conf
cat >./conf/config.yaml<<EOF 
bind-addr: 127.0.0.1:${inside_port}
auth: password
cert: false
password: ${PASSWORD}
EOF


#1. 設定專案目錄路徑與權限
useradd ${user}
mkdir /home/${user}/${project}
project_path=/home/${user}/${project}
echo "set folder ok"

#2. 建立vscode server容器
docker pull codercom/code-server
docker-compose up -d
docker exec -it code-server sudo chown -R ${user}:${user} ${project_path}
echo "set contanier ok"

#3. 容器系統更新與安裝python3
docker exec -it code-server sudo apt update
docker exec -it code-server sudo apt-get install python3 pip -y
docker exec -it code-server pip --version
echo "vscode update & install python3 ok"

#5. 設定vscode 密碼
#docker exec -it code-server sed -i '/password:/d' .config/code-server/config.yaml
#docker exec -it code-server  bash -c "echo 'password: ${PASSWORD}' >> .config/code-server/config.yaml"
docker exec -it code-server cat /home/coder/.config/code-server/config.yaml |grep password:
echo "please copy password"

#6. 重啟docker
docker-compose restart
echo "login web is http://serverip:${outside_port}"
/usr/bin/sleep 10
docker-compose ps
