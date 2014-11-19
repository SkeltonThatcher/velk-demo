#!/bin/bash

# Demo log message generator

# Generate two 'random' numbers for creating clusters of log lines and reset attempt messages.
# 
# @robtthatcher - 2014 

c=1
while [ $c -le 9999 ]
do
        smallMIN=2
        smallMAX=8
        smallrnd=$(( $RANDOM % ($smallMAX + 1 - $smallMIN) + $smallMIN ))
        smallN=1

        bigMIN=0
        bigMAX=50
        bigrnd=$(( $RANDOM % ($bigMAX + 1 - $bigMIN) + $bigMIN ))
        bigN=1

        sleepMIN=2
        sleepMAX=8
        sleeprnd=$(( $RANDOM % ($sleepMAX + 1 - $sleepMIN) + $smallMIN ))
        
	while [ $smallN -le $smallrnd ]
                do
                        echo "HAL: AE35-Unit : I've just picked up a fault in the AE35 unit. It's going to go 100% failure in 72 hours.." >> /var/log/halmsg.log
                        ((smallN++))
                done;

        echo "HAL: AE35-Unit : Service degraded, reset scheduled" >> /var/log/halmsg.log
        echo "HAL: AE35-Unit : System initiated reset started" >> /var/log/halmsg.log

        while [ $bigN -le $bigrnd ]
                do
                        echo "HAL: AE35-Unit : Reset failure, MANUAL INTERVENTION REQUIRED" >> /var/log/halmsg.log
                        ((bigN++))
                done;
       (( c++ ))

       sleep $sleeprnd
done
