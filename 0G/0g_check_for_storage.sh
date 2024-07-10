#!/bin/bash

Y='\033[1;33m'
N='\033[0m'
R='\033[1;31m'
G='\033[1;32m'
P='\033[1;35m'

echo -e "Please choose the type you want to test"
echo -e "JSON-RPC -> ${Y}PRESS 1${N}, STORAGE-NODE -> ${Y}PRESS 2${N}: "
read -p "" TEST_TYPE

if [[ $TEST_TYPE -eq 1 ]]; then

  echo -e "
+========================================================================================+
|            ${Y}_  ______  ___  _______  ___  ___   _  _____${N}    ____      ${P}___  _____${N}        |
|           ${Y}/ |/ / __ \/ _ \/ __/ _ )/ _ \/ _ | / |/ / _ \ ${N} / __/___  ${P}/ _ \/ ___/${N}        |
|          ${Y}/    / /_/ / // / _// _  / , _/ __ |/    / // /${N}  > _/_ _/ ${P}/ // / (_ /${N}         |
|         ${Y}/_/|_/\____/____/___/____/_/|_/_/ |_/_/|_/____/${N}  |_____/   ${P}\___/\___/${N}          |
|                                                                                        |
|                 ${G}Telegram${N}   Ctrl + Click -> ${G}https://www.t.me/nodebrand${N}                  |
|                 ${G}Blog${N}       Ctrl + Click -> ${G}https://www.nodebrand.xyz${N}                   |
|                 ${G}Mail${N}       admin@nodebrand.xyz                                         |
|                                                                                        |
|                 ${Y}Check Your BlockChain-RPC-ENDPOINT is available for storage node${N}       |
|                                                                                        |
+========================================================================================+
  "
  
  echo -e "Enter the log_sync_start_block_number ${R}(Enter in decimal)${N}"
  echo -e "You can check here -> https://nodebrand.xyz/entry/0G-Config"
  read -p "(Ex: 802): " BLOCK_HEIGHT
  echo -e "Enter your json-rpc endpoint to search ${R}(Enter in decimal)${N}"
  read -p "(Ex: https://0G-rpc.nodebrand.xyz, http://123.456.789:8545): " OG_JSON_ENDPOINT

  BLOCK_HEIGHT_HEX=$(printf '0x%x' "$BLOCK_HEIGHT")


  result=$(curl -s -X POST $OG_JSON_ENDPOINT -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["'"$BLOCK_HEIGHT_HEX"'",false],"id":1}' | jq)

  block_number=$(echo $result | jq -r '.result.number')

  echo -e "Parsed block number: $block_number"

  if [[ $block_number != "null" && $block_number != "" ]]; then
    echo -e "Result: ${Y}$result${N}"
    echo -e "${G}You can use this blockchain-rpc for Storage-Node${N}"
  else
    echo -e "Result: ${Y}$result${N}"
    echo -e "${R}You cannot use this blockchain-rpc for Storage-Node${N}"
  fi

elif [[ $TEST_TYPE -eq 2 ]]; then

  echo -e "
+========================================================================================+
|            ${Y}_  ______  ___  _______  ___  ___   _  _____${N}    ____      ${P}___  _____${N}        |
|           ${Y}/ |/ / __ \/ _ \/ __/ _ )/ _ \/ _ | / |/ / _ \ ${N} / __/___  ${P}/ _ \/ ___/${N}        |
|          ${Y}/    / /_/ / // / _// _  / , _/ __ |/    / // /${N}  > _/_ _/ ${P}/ // / (_ /${N}         |
|         ${Y}/_/|_/\____/____/___/____/_/|_/_/ |_/_/|_/____/${N}  |_____/   ${P}\___/\___/${N}          |
|                                                                                        |
|                 ${G}Telegram${N}   Ctrl + Click -> ${G}https://www.t.me/nodebrand${N}                  |
|                 ${G}Blog${N}       Ctrl + Click -> ${G}https://www.nodebrand.xyz${N}                   |
|                 ${G}Mail${N}       admin@nodebrand.xyz                                         |
|                                                                                        |
|                 ${Y}Check Your STORAGE-NODE is available                ${N}                   |
|                                                                                        |
+========================================================================================+
"

  echo -e "Enter your storage node's URL ${R}(Enter in decimal)${N}"
  read -p "(Ex: https://0G-ST.nodebrand.xyz, http://123.456.789:5678): " OG_STORAGE_URL


  result=$(curl -s -X POST $OG_STORAGE_URL -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"zgs_getStatus","params":[],"id":1}' | jq)

  logSyncHeight=$(echo $result | jq -r '.result.logSyncHeight')
  connectedPeers=$(echo $result | jq -r '.result.connectedPeers')
  logSyncBlock=$(echo $result | jq -r '.result.logSyncBlock')

  if [[ $logSyncHeight != "null" && $logSyncHeight != "" ]]; then
#    echo -e "Result: ${Y}$result${N}"
    echo -e "Connected Peers: ${G}$connectedPeers${N}"
    echo -e "Log sync Height: ${G}$logSyncHeight${N}"
    echo -e "Log sync block hash: ${G}$logSyncBlock${N}"
    echo -e "${G}Your storage-node is operating normally${N}"
  else
#    echo -e "Result: ${Y}$result${N}"
    echo -e "${R}Your Storage node is not available${N}"
  fi

else
  echo -e "${R}Invalid option selected. Please choose either 1 or 2.${N}"
fi
