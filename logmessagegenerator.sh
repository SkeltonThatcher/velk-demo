#!/bin/bash

# Demo log message generator

c=1
while [ $c -le 9999 ]
do
	echo "HAL: I've just picked up a fault in the AE35 unit. It's going to go 100% failure in 72 hours.. " >> /var/log/halmsg.log
	echo "HAL: Logging AE35 fault: halmsg 9 - AE35 unit" >> /var/log/halmsg.log
	echo "HAL: Reset Failure : AE35 Unit - Service degraded." >> /var/log/halmsg.log
	sleep 15
	(( c++ ))
done

