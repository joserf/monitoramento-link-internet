#!/bin/bash
log=/tmp/vnstat.log
# Atualiza o vnstat
vnstat -u
#
if [ $? -ne 0 ]
then
   echo "Erro ao executar vnstat, $(date)" > "$log"
   exit 1 
else
   echo "vnstat iniciado com sucesso $(date)" > "$log"
fi
