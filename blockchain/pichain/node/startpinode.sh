#!/bin/bash

geth --identity "pinode1"  --networkid 48758293 --datadir /home/pi/pichain/node --nodiscover --port "30303" --unlock 0 --password "/home/pi/pichain/node/password.sec" --ipcpath /home/pi/.ethereum/geth.ipc
