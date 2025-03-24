#!/bin/bash

#6. Сохранить в текстовый файл все текущие процессы (ps aux), 
#запущенные НЕ от имени текущего пользователя (whoami).

# Узнаем максимальную длинну имени пользователя в системе
max_len=$(awk -F: '{print length($1)}' /etc/passwd | sort -nr | head -n 1)

echo "Самое длинное имя пользователя $max_len символов"

# Получаем имя текущего пользователя
user=$(whoami)

echo "Начало записи в файл"
ps -eo user:$max_len,pid,%cpu,%mem,vsz,rss,tty,stat,start,time,command | grep -v $user > text.txt 

echo "Процессы, запущенные не от имени $user, сохранены в text.txt"
echo "Файл text.txt:"
cat text.txt
