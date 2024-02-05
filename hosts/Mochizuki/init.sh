#/usr/bin/env bash
FILES="/home/kaguya/Pictures/*"
swww init
sleep 1
while :
do
    for f in $FILES
    do
        swww img $f
        sleep 30 
    done
done
