#!/bin/bash
# Total de download (hora atual)
tempin1=$(vnstat -h| tail -n 2| awk -F\  '{ print $8}'| tail -n 1| awk -F\, '{ print $1}')
tempin2=$(vnstat -h| tail -n 2| awk -F\  '{ print $8}'| tail -n 1| awk -F\, '{ print $2}')
i=$tempin1$tempin2
bandwidth_in_unit=$(vnstat -h| tail -n 9| awk -F\) '{ print $5}'| head -n 1|awk -F\( '{ print $2}')
case "$bandwidth_in_unit" in
KiB)    bandwidth_in_number_Byte=$(echo "$i*1024"| bc)
;;
MiB)    bandwidth_in_number_Byte=$(echo "$i*1024*1024"|bc)
;;
GiB)    bandwidth_in_number_Byte=$(echo "$i*1024*1024*1024"|bc)
;;
TiB)    bandwidth_in_number_Byte=$(echo "$i*1024*1024*1024*1024"|bc)
;;
esac
echo $bandwidth_in_number_Byte
