SYS_VENDOR=$(cat /sys/devices/virtual/dmi/id/sys_vendor | sed 's/,/,,/g')
PRODUCT_NAME=$(cat /sys/devices/virtual/dmi/id/product_name | sed 's/,/,,/g')
PRODUCT_SERIAL=$(cat /sys/devices/virtual/dmi/id/product_serial | sed 's/,/,,/g')
PRODUCT_UUID=$(cat /sys/devices/virtual/dmi/id/product_uuid | sed 's/,/,,/g')
PRODUCT_FAMILY=$(cat /sys/devices/virtual/dmi/id/product_family | sed 's/,/,,/g')

BOARD_VENDOR=$(cat /sys/devices/virtual/dmi/id/board_vendor | sed 's/,/,,/g')
BOARD_NAME=$(cat /sys/devices/virtual/dmi/id/board_name | sed 's/,/,,/g')
BOARD_SERIAL=$(cat /sys/devices/virtual/dmi/id/board_serial | sed 's/,/,,/g')
BOARD_VERSION=$(cat /sys/devices/virtual/dmi/id/board_version | sed 's/,/,,/g')

echo "type=1,manufacturer=$SYS_VENDOR,product=$PRODUCT_NAME,serial=$PRODUCT_SERIAL,uuid=$PRODUCT_UUID,family=$PRODUCT_FAMILY" > /etc/cloudyourmac/smbiosType1
echo "type=2,manufacturer=$BOARD_VENDOR,product=$BOARD_NAME,serial=$BOARD_SERIAL,version=$BOARD_VERSION" > /etc/cloudyourmac/smbiosType2
