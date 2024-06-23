#!/usr/bin/env bash
cd /home/kori/JQuake/ || return
java -jar JQuake.jar -Xmx200m -Xms32m -Xmn2m -Djava.net.preferIPv4Stack=true
