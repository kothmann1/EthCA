#!/bin/bash

geth --identity "miner1" --networkid 48758293 --datadir "~/Desktop/privchain/miner1" --nodiscover --mine --port "30303" --unlock 0 --password ~/Desktop/privchain/miner1/password.sec --ipcpath "~/Library/Ethereum/geth.ipc"
