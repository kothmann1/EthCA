#!/bin/bash

geth --identity "miner2" --networkid 48758293 --datadir "~/Desktop/privchain/miner2" --nodiscover --mine --port "30304" --unlock 0 --password ~/Desktop/privchain/miner2/password.sec
