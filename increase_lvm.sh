#!/bin/bash

# Убедитесь, что вы запускаете скрипт с правами суперпользователя
if [ "$(id -u)" -ne 0 ]; then
    echo "Пожалуйста, запустите скрипт с правами суперпользователя."
    exit 1
fi


# Укажите устройство, которое вы хотите расширить (например, /dev/sda)
DEVICE="/dev/sda"
PARTITION="${DEVICE}3"  # Измените на нужный номер раздела, если необходимо


# Увеличение размера виртуального диска в VirtualBox (это нужно сделать вручную)
echo "Убедитесь, что вы увеличили размер виртуального диска в VirtualBox."


# Перепартиционирование с помощью parted
echo "Перепартиционирование $DEVICE..."
parted $DEVICE --script <<EOF
resizepart 3 100%
quit
EOF


# Обновление таблицы разделов
partprobe $DEVICE

# Увеличение физического тома
echo "Увеличиваем физический том..."
pvresize $PARTITION


# Увеличиваем логический том
echo "Увеличиваем логический том..."
sudo lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv

# Расширяем файловую систему
#echo "Расширяем файловую систему..."
resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
lvs
echo "Процесс завершен!"
