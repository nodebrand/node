#!/bin/bash

Y='\033[1;33m'
N='\033[0m'
R='\033[1;31m'
G='\033[1;32m'
P='\033[1;35m'

original_file="$ZGS_HOME/run/config.toml"
network_boot_nodes=$(grep -oP 'network_boot_nodes = \[.*?\]' "$original_file")

source ~/.bash_profile

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
|                 ${G}Check Your Variables & in file Variables Below${N}                         |
+========================================================================================+

${Y}VARIABLE SETTING IN .bash_profile${N}

ZGS_HOME: $ZGS_HOME
ENR_ADDRESS: $ENR_ADDRESS
BLOCKCHAIN_RPC_ENDPOINT: $BLOCKCHAIN_RPC_ENDPOINT
LOG_CONTRACT_ADDRESS: $LOG_CONTRACT_ADDRESS
MINE_CONTRACT_ADDRESS: $MINE_CONTRACT_ADDRESS
ZGS_LOG_SYNC_BLOCK: $ZGS_LOG_SYNC_BLOCK
NETWORK_BOOT_NODES:
$(echo $NETWORK_BOOT_NODES | sed 's/,/,\
/g')


${G}VARIABLE SETTING IN config.toml${N}

ZGS_HOME: $ZGS_HOME
ENR_ADDRESS: $(grep -oP 'network_enr_address = "\K[^"]+' $original_file)
BLOCKCHAIN_RPC_ENDPOINT: $(grep -oP 'blockchain_rpc_endpoint = "\K[^"]+' $original_file)
LOG_CONTRACT_ADDRESS: $(grep -oP 'log_contract_address = "\K[^"]+' $original_file)
MINE_CONTRACT_ADDRESS: $(grep -oP 'mine_contract_address = "\K[^"]+' $original_file)
ZGS_LOG_SYNC_BLOCK: $(grep -oP 'log_sync_start_block_number = \K\d+' $original_file)
NETWORK_BOOT_NODES:
$(grep -oP 'network_boot_nodes = \[\K[^\]]+' $original_file | awk '{gsub(/,/, ",\n")}1')
"
