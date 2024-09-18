#!/usr/bin/env bash
FILES="/home/merutan1392/Pictures/*"
swww-daemon --format xrgb
sleep 1
while :
do
  for f in $FILES
  do
    swww img "$f"
    sleep 30
  done
done
