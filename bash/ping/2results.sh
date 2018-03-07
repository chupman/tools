#!/bin/bash

echo "" > Results.log
grep -B1 -e "4 received" -e "3 received" -e "2 received" -e "1 received" Ping.log  |grep stat |cut -d" " -f2 >> Results.log

