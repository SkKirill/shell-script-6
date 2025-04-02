## Задание 6.  
**Сохранить в текстовый файл все текущие процессы (`ps aux`), запущенные НЕ от имени текущего пользователя (`whoami`).**  
> **Выполнил: Скоморохов Кирилл | Группа: 10-1 | Курс: 4**

**Приложил два решения к данной задаче, так как не мог выбрать, какое лучше.**

---

## Проблема  

В процессе написания столкнулся со случаем, где имя пользователя будет более 8 символов, а команда `ps` с параметром `aux` будет его срезать до 7 символов и знака `+`.  

#### Пример проблемы:  
```bash
sk-kirill@DELL-KIRILL:/mnt/d/VSU-Labs-git/8-sem/Framework$ ps aux | grep -v $(whoami)
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  1.2  0.0  21500 12804 ?        Ss   11:42   0:00 /sbin/init
root           2  0.0  0.0   2776  1920 ?        Sl   11:42   0:00 /init
root           7  0.0  0.0   2776   132 ?        Sl   11:42   0:00 plan9 --control-socket 7 --log-level 4 --server-fd 8 --pipe-fd 10 --log-truncate
root          52  0.4  0.1  50352 17588 ?        S<s  11:42   0:00 /usr/lib/systemd/systemd-journald
root          75  0.3  0.0  23992  5904 ?        Ss   11:42   0:00 /usr/lib/systemd/systemd-udevd
systemd+     146  0.3  0.0  21452 11924 ?        Ss   11:42   0:00 /usr/lib/systemd/systemd-resolved
systemd+     147  0.1  0.0  91020  6408 ?        Ssl  11:42   0:00 /usr/lib/systemd/systemd-timesyncd
root         153  0.0  0.0   4236  2680 ?        Ss   11:42   0:00 /usr/sbin/cron -f -P
message+     154  0.1  0.0   9620  5228 ?        Ss   11:42   0:00 @dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
root         164  0.3  0.0  17976  8236 ?        Ss   11:42   0:00 /usr/lib/systemd/systemd-logind
root         167  0.3  0.0 1756096 15952 ?       Ssl  11:42   0:00 /usr/libexec/wsl-pro-service -vv
root         181  0.0  0.0   3160  1076 hvc0     Ss+  11:42   0:00 /sbin/agetty -o -p -- \u --noclear --keep-baud - 115200,38400,9600 vt220
syslog       186  0.2  0.0 222508  5328 ?        Ssl  11:42   0:00 /usr/sbin/rsyslogd -n -iNONE
root         188  0.0  0.0   3116  1164 tty1     Ss+  11:42   0:00 /sbin/agetty -o -p -- \u --noclear - linux
root         199  0.3  0.1 107008 22500 ?        Ssl  11:42   0:00 /usr/bin/python3 /usr/share/unattended-upgrades/unattended-upgrade-shutdown --wait-for-signal
root         283  0.0  0.0   2784   204 ?        Ss   11:42   0:00 /init
root         284  0.0  0.0   2784   212 ?        S    11:42   0:00 /init
sk-kiri+     285  0.1  0.0   6072  5216 pts/0    Ss   11:42   0:00 -bash
root         286  0.0  0.0   6664  4628 pts/1    Ss   11:42   0:00 /bin/login -f
sk-kiri+     338  0.2  0.0  20264 11408 ?        Ss   11:42   0:00 /usr/lib/systemd/systemd --user
sk-kiri+     339  0.0  0.0  21144  1724 ?        S    11:42   0:00 (sd-pam)
sk-kiri+     352  0.0  0.0   6072  4848 pts/1    S+   11:42   0:00 -bash
sk-kiri+     372  0.0  0.0   8332  4244 pts/0    R+   11:43   0:00 ps aux
```

---

## Решение 1

> Проверка длины и уменьшение так же, как это делает параметр `aux`. 


``` bash
# Получаем имя текущего пользователя
user=$(whoami)

# Проверяем длину имени пользователя
if [[ ${#user} -gt 8 ]]; then
    # Срезаем имя до 7 символов и добавляем '+', 
    # так как стандарт aux выводит только 8 символов.
    # Например, пользователь 'sk-kirill' будет выводиться как 'sk-kiri+'.
    user="${user:0:7}+"
    echo "Имя пользователя слишком длинное. Будет производиться проверка по имени $user."
fi
```

---

## Решение 2

> Второе решение заключается в указании конкретного количества символов для вывода столбца с пользователями.
> Есть константа `LOGIN_NAME_MAX`, которая задает это значение. Однако столбец будет излишне длинным в большинстве случаев.

``` shell
sk-kirill@DELL-KIRILL:/mnt/d/VSU-Labs-git/8-sem/Framework/Solution-2$ getconf LOGIN_NAME_MAX
256
```

> Для того чтобы не брать максимум по константе, выясняется максимальная длина имени в системе.
> После чего длина столбца берется за максимальную длину имени в системе. 

``` bash
# Узнаем максимальную длину имени пользователя в системе
max_len=$(awk -F: '{print length($1)}' /etc/passwd | sort -nr | head -n 1)

echo "Самое длинное имя пользователя содержит $max_len символов."

# Получаем имя текущего пользователя
user=$(whoami)

echo "Начало записи в файл."
ps -eo user:$max_len,pid,%cpu,%mem,vsz,rss,tty,stat,start,time,command | grep -v $user > text.txt
```

---

### Git
* Для работы над лабораторной использовалась система контроля версий Git.
* Была создана ветка для работы со вторым решением, после чего она была слита с мастером.
