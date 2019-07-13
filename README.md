# monitoramento-link-internet

Monitoramento de link de internet com Zabbiz + Grafana

<img src=Monitoramento.png/>

Instalação

    # bash <( curl -Ss https://raw.githubusercontent.com/joserf/monitoramento-link-internet/master/install.sh)
        
Importe o template "Template Monitoramento de link de internet.xml" para seu Zabbix e a dashboard "Monitoramento de link de internet.json" para o Grafana.

<img src=host.png/>

Inserir a macro no seu host srvInternet

{$DOWNLOAD} com a velocidade do seu link de Download em Bytes.

{$UPLOAD} com a velocidade do seu link de Upload em Bytes.

Site para conversão: https://www.gbmb.org/mb-to-bytes

Essas medições são verdadeiras, pegamos o tráfego real do consumo de internet, faça a instalação no seu servidor de internet.
