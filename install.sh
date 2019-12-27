#!/bin/bash -e
clear

if [ "$UID" -ne 0 ]; then
  echo "Por favor, execute como root"
  exit 1
fi

read -p 'Digite o ip do servidor Zabbix :' ZABBIX_SERVER_IP
echo Servidor Zabbix IP: $ZABBIX_SERVER_IP && sleep 2

read -p 'Digite a interface de rede na qual sera monitorada ex: (eth0) :' VNSTAT_REDE
echo Interface de rede: $VNSTAT_REDE && sleep 2

if [ -x /usr/bin/apt-get ]; then

  apt-get update && \
  apt-get install vnstat etherwake zabbix-agent python-pip -y && \
  pip install speedtest-cli
  sed -i "s/Server=127.0.0.1/Server=${ZABBIX_SERVER_IP}/" /etc/zabbix/zabbix_agentd.conf
  sed -i "s/ServerActive=127.0.0.1/ServerActive=${ZABBIX_SERVER_IP}/" /etc/zabbix/zabbix_agentd.conf
  HOSTNAME=`hostname` && sed -i "s/Hostname=Zabbix\ server/Hostname=$HOSTNAME/" /etc/zabbix/zabbix_agentd.conf
  sed -i '48i\DebugLevel=3' /etc/zabbix/zabbix_agentd.conf
  sed -i '65i\EnableRemoteCommands=1' /etc/zabbix/zabbix_agentd.conf
  sed -i '75i\LogRemoteCommands=1' /etc/zabbix/zabbix_agentd.conf
  sed -i '270iUserParameter=inbound.currenthour,/etc/zabbix/scripts/zabbix_total_inbound_for_current_hour.sh' /etc/zabbix/zabbix_agentd.conf
  sed -i '271iUserParameter=outbound.currenthour,/etc/zabbix/scripts/zabbix_total_outbound_for_current_hour.sh' /etc/zabbix/zabbix_agentd.conf
  sed -i '272iUserParameter=inbound.today,/etc/zabbix/scripts/zabbix_todays_total_inbound.sh' /etc/zabbix/zabbix_agentd.conf
  sed -i '273iUserParameter=outbound.today,/etc/zabbix/scripts/zabbix_todays_total_outbound.sh' /etc/zabbix/zabbix_agentd.conf
  sed -i '274iUserParameter=inbound.yesterday,/etc/zabbix/scripts/zabbix_yesterday_total_inbound.sh' /etc/zabbix/zabbix_agentd.conf
  sed -i '275iUserParameter=outbound.yesterday,/etc/zabbix/scripts/zabbix_yesterday_total_outbound.sh' /etc/zabbix/zabbix_agentd.conf
  sed -i '276iUserParameter=total.inbound.month,/etc/zabbix/scripts/zabbix_total_month_inbound_bandwidth.sh' /etc/zabbix/zabbix_agentd.conf
  sed -i '277iUserParameter=total.outbound.month,/etc/zabbix/scripts/zabbix_total_month_outbound_bandwidth.sh' /etc/zabbix/zabbix_agentd.conf
  sed -i '278iUserParameter=check.wanip,curl --silent https://checkip.amazonaws.com' /etc/zabbix/zabbix_agentd.conf
  # vnstat info
  sed -i "279iUserParameter=vnstat.total.inbound.month,vnstat --oneline | awk -F\; '{ print $9 }' |cut -di -f1" /etc/zabbix/zabbix_agentd.conf
  sed -i "280iUserParameter=vnstat.total.outbound.month,vnstat --oneline | awk -F\; '{ print $10 }' |cut -di -f1" /etc/zabbix/zabbix_agentd.conf
  #
  sed -i '21i\zabbix ALL=NOPASSWD: ALL' /etc/sudoers 
  vnstat -u -i ${VNSTAT_REDE}
  ufw allow 10050/tcp
  /etc/init.d/zabbix-agent restart
  # Pasta dos scripts
  mkdir /etc/zabbix/scripts
  # Telegram 
  cat <<EOF > /etc/zabbix/scripts/speedtest-telegram.sh
  #!/bin/sh
  # Telegram 
  BOT_TOKEN="" # Token (https://core.telegram.org/bots#3-how-do-i-create-a-bot)
  USER="" # ID do grupo 
  # Configurações
  diretorio=/tmp
  speedtest=/tmp/speedtest.txt
  speedtest_telegram=/tmp/speedtest_telegram.txt

  option="${1}" 
  case ${option} in 
     -v|-V)
        # Efetua o teste de velocidade  
        speedtest-cli --bytes > "$speedtest" && date '+Data: %m/%d/%y|%H:%M:%S' >> "$speedtest"
        ;; 
     -t|-T)  
        # Efetua o teste de velocidade e envia para o Telegram
        speedtest-cli --share > "$speedtest_telegram" && date '+Data: %m/%d/%y|%H:%M:%S' >> "$speedtest_telegram" && \\
        cat $speedtest_telegram | grep "Share" | cut -c 15- | xargs wget -O $diretorio/enviar.png | cat $speedtest_telegram | grep "Share" | cut -c 48- && \\
        curl -k -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendPhoto" -F chat_id="${USER}" -F photo="@/$diretorio/enviar.png" > /dev/null && \\
        rm $diretorio/enviar.png
        ;;
     -h|-H) 
        # Exibe a versão 
        echo "José Rodrigues Filho"
        echo "Speedtest | Telegram | Zabbix - V1.0"
        ;;
     *)  
        echo "`basename ${0}`:Opção inválida, use: [-v speedtest] | [-t speedtest telegram] [-h Versão]" 
        exit 1
        ;; 
  esac
EOF
  # Download dos scripts
  wget https://raw.githubusercontent.com/joserf/monitoramento-link-internet/master/zabbix_total_inbound_for_current_hour.sh -O /etc/zabbix/scripts/zabbix_total_inbound_for_current_hour.sh && \ 
  wget https://raw.githubusercontent.com/joserf/monitoramento-link-internet/master/zabbix_total_outbound_for_current_hour.sh -O /etc/zabbix/scripts/zabbix_total_outbound_for_current_hour.sh && \
  wget https://raw.githubusercontent.com/joserf/monitoramento-link-internet/master/zabbix_todays_total_inbound.sh -O /etc/zabbix/scripts/zabbix_todays_total_inbound.sh && \
  wget https://raw.githubusercontent.com/joserf/monitoramento-link-internet/master/zabbix_todays_total_outbound.sh -O /etc/zabbix/scripts/zabbix_todays_total_outbound.sh && \
  wget https://raw.githubusercontent.com/joserf/monitoramento-link-internet/master/zabbix_yesterday_total_inbound.sh -O /etc/zabbix/scripts/zabbix_yesterday_total_inbound.sh && \
  wget https://raw.githubusercontent.com/joserf/monitoramento-link-internet/master/zabbix_yesterday_total_outbound.sh -O /etc/zabbix/scripts/zabbix_yesterday_total_outbound.sh && \
  wget https://raw.githubusercontent.com/joserf/monitoramento-link-internet/master/zabbix_total_month_inbound_bandwidth.sh -O /etc/zabbix/scripts/zabbix_total_month_inbound_bandwidth.sh && \
  wget https://raw.githubusercontent.com/joserf/monitoramento-link-internet/master/zabbix_total_month_outbound_bandwidth.sh -O /etc/zabbix/scripts/zabbix_total_month_outbound_bandwidth.sh && \
  wget https://raw.githubusercontent.com/joserf/monitoramento-link-internet/master/bandwidth_update.sh -O /etc/zabbix/scripts/bandwidth_update.sh
  # 
  chmod +x /etc/zabbix/scripts/*
  exit 0
fi
