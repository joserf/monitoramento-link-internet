tempout1=$(vnstat -h| tail -n 2| awk -F\  '{ print $9}'| tail -n 1| awk -F\, '{ print $1}')
tempout2=$(vnstat -h| tail -n 2| awk -F\  '{ print $9}'| tail -n 1| awk -F\, '{ print $2}')
o=$tempout1$tempout2
bandwidth_out_unit=$(vnstat -h| tail -n 9| awk -F\) '{ print $6}'| head -n 1|awk -F\( '{ print $2}')
#echo $bandwidth_out_unit
case "$bandwidth_out_unit" in
KiB)    bandwidth_out_number_Byte=$(echo "$o*1024"| bc)
;;
MiB)    bandwidth_out_number_Byte=$(echo "$o*1024*1024"|bc)
;;
GiB)    bandwidth_out_number_Byte=$(echo "$o*1024*1024*1024"|bc)
;;
TiB)    bandwidth_out_number_Byte=$(echo "$o*1024*1024*1024*1024"|bc)
;;
esac
#echo $bandwidth_out_number_Byte

echo $bandwidth_out_number_Byte