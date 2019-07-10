  #!/bin/sh
  # Telegram 
  BOT_TOKEN="" # Token (https://core.telegram.org/bots#3-how-do-i-create-a-bot)
  USER="" # ID do grupo 
  # Configurações
  diretorio=/tmp
  speedtest=/tmp/speedtest.txt
  speedtest_telegram=/tmp/speedtest_telegram.txt

  option="" 
  case  in 
     -v|-V)
        # Efetua o teste de velocidade  
        speedtest-cli --bytes > "" && date '+Data: %m/%d/%y|%H:%M:%S' >> ""
        ;; 
     -t|-T)  
        # Efetua o teste de velocidade e envia para o Telegram
        speedtest-cli --share > "" && date '+Data: %m/%d/%y|%H:%M:%S' >> "" && \
        cat  | grep "Share" | cut -c 15- | xargs wget -O /enviar.png | cat  | grep "Share" | cut -c 48- && \
        curl -k -s -X POST "https://api.telegram.org/bot/sendPhoto" -F chat_id="root" -F photo="@//enviar.png" > /dev/null && \
        rm /enviar.png
        ;;
     -h|-H) 
        # Exibe a versão 
        echo "José Rodrigues Filho"
        echo "Speedtest | Telegram | Zabbix - V1.0"
        ;;
     *)  
        echo "63:Opção inválida, use: [-v speedtest] | [-t speedtest telegram] [-h Versão]" 
        exit 1
        ;; 
  esac
