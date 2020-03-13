rm /home/pi/drone_photo/*
wget 'http://18.180.32.71:11111/init' -O /dev/null
echo `TZ=Asia/Tokyo date "+%Y%m%d%H%M%S"`"`printf '%-20s' $2`" > ~/info.txt
sleep 2
scp -i /home/pi/cobolhack-y-sakamoto-key-pair.pem ~/info.txt `printf 'ec2-user@18.180.32.71:/home/ec2-user/player_info/%d.txt' $1`

COB_PRE_LOAD=dronelib cobcrun captest $1

xdg-open 'http://18.180.32.71:11111/' > /dev/null 2> /dev/null &
