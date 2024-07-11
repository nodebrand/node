#!/bin/bash

Y='\033[1;33m'
N='\033[0m'
R='\033[1;31m'
G='\033[1;32m'
P='\033[1;35m'

echo -e "${R}Before you run this .sh file, you must clear the following variables from .bash_profile${N}"
echo -e "If not, ${R}press Ctrl + C, enter -> sudo nano ~/.bash_profile, clear below variables, and start again.${N}"
echo -e "${R}
- ENR_ADDRESS
- BLOCKCHAIN_RPC_ENDPOINT
- LOG_CONTRACT_ADDRESS
- MINE_CONTRACT_ADDRESS
- ZGS_LOG_SYNC_BLOCK
- NETWORK_BOOT_NODES
- ZGS_HOME
- NODEBRAND_0G_STORAGE
${N}"

echo -e "Enter ${R}the exact path${N} to the directory containing /run/config.toml ${R}(DO NOT INCLUDE Last "/")${N}"
read -p "(Ex: /root/0g-storage-node): " CONFIG_PATH

echo "Enter your validator's JSON-RPC Endpoint"
echo -e "${R}If your validator node is not a full node, you must use a different full node${N}"
read -p "(Ex: http://127.0.0.1:8545 or https://blockchain.rpc): " JSONRPC

echo -e "Enter your MINER KEY ${R}(DO NOT INCLUDE LEADING 0x)${N}"
read -p "(Ex: 691U4BETG97843926TEFU1493RVH395NODEBRAND59371RYE139EI134EBA1B135): " MINER_KEY

ZGS_HOME=$CONFIG_PATH
ENR_ADDRESS=$(wget -qO- https://eth0.me)
BLOCKCHAIN_RPC_ENDPOINT=$JSONRPC
LOG_CONTRACT_ADDRESS='0x8873cc79c5b3b5666535C825205C9a128B1D75F1'
MINE_CONTRACT_ADDRESS='0x85F6722319538A805ED5733c5F4882d96F1C7384'
ZGS_LOG_SYNC_BLOCK='802'
NETWORK_BOOT_NODES='[\"/ip4/54.219.26.22/udp/1234/p2p/16Uiu2HAmTVDGNhkHD98zDnJxQWu3i1FL1aFYeh9wiQTNu4pDCgps\",\"/ip4/52.52.127.117/udp/1234/p2p/16Uiu2HAkzRjxK2gorngB1Xq84qDrT4hSVznYDHj6BkbaE4SGx9oS\",\"/ip4/18.167.69.68/udp/1234/p2p/16Uiu2HAm2k6ua2mGgvZ8rTMV8GhpW71aVzkQWy7D37TTDuLCpgmX\"]'
NODEBRAND_0G_STORAGE='v0.3.3'

echo "export ZGS_HOME=\"${ZGS_HOME}\"" >> ~/.bash_profile
echo "export ENR_ADDRESS=\"${ENR_ADDRESS}\"" >> ~/.bash_profile
echo "export BLOCKCHAIN_RPC_ENDPOINT=\"${BLOCKCHAIN_RPC_ENDPOINT}\"" >> ~/.bash_profile
echo "export LOG_CONTRACT_ADDRESS=\"${LOG_CONTRACT_ADDRESS}\"" >> ~/.bash_profile
echo "export MINE_CONTRACT_ADDRESS=\"${MINE_CONTRACT_ADDRESS}\"" >> ~/.bash_profile
echo "export ZGS_LOG_SYNC_BLOCK=\"${ZGS_LOG_SYNC_BLOCK}\"" >> ~/.bash_profile
echo "export NETWORK_BOOT_NODES=\"${NETWORK_BOOT_NODES}\"" >> ~/.bash_profile
echo "export NODEBRAND_0G_STORAGE=\"${NODEBRAND_0G_STORAGE}\"" >> ~/.bash_profile

source ~/.bash_profile

original_file="$ZGS_HOME/run/config.toml"
backup_file="$ZGS_HOME/run/config.toml.bak"
tmp_file=$(mktemp)

sudo cat "$original_file" | while IFS= read -r line; do
# network_boot_nodes
  if [[ $line == network_boot_nodes* ]]; then
    echo "network_boot_nodes = $NETWORK_BOOT_NODES" >> "$tmp_file"
    
# log_contract_address
  elif [[ $line == log_contract_address* ]]; then
    echo "log_contract_address = \"$LOG_CONTRACT_ADDRESS\"" >> "$tmp_file"

# log_sync_start_block_number
  elif [[ $line == log_sync_start_block_number* ]]; then
    echo "log_sync_start_block_number = $ZGS_LOG_SYNC_BLOCK" >> "$tmp_file"
    
# mine_contract_address
  elif [[ $line == mine_contract_address* ]]; then
    echo "mine_contract_address = \"$MINE_CONTRACT_ADDRESS\"" >> "$tmp_file"

# blockchain_rpc_endpoint
  elif [[ $line == blockchain_rpc_endpoint* ]]; then
    echo "blockchain_rpc_endpoint = \"$BLOCKCHAIN_RPC_ENDPOINT\"" >> "$tmp_file"

# miner_key
  elif [[ $line == miner_key* ]]; then
    echo "miner_key = \"$MINER_KEY\"" >> "$tmp_file"

# network_enr_address
  elif [[ $line == "network_enr_address = \"\"" ]]; then
    echo "network_enr_address = \"$ENR_ADDRESS\"" >> "$tmp_file"

# find_peer_timeout
  elif [[ $line == *find_peer_timeout* ]]; then
    echo "find_peer_timeout = \"10s\"" >> "$tmp_file"
    
# network_dir 
  elif [[ $line == *network_dir* ]]; then
    echo "network_dir = \"network\"" >> "$tmp_file"
    
# network_enr_tcp_port 
  elif [[ $line == *network_enr_tcp_port* ]]; then
    echo "network_enr_tcp_port = 1234" >> "$tmp_file"
    
# network_enr_udp_port 
  elif [[ $line == *network_enr_udp_port* ]]; then
    echo "network_enr_udp_port = 1234" >> "$tmp_file"
    
# network_libp2p_port 
  elif [[ $line == *network_libp2p_port* ]]; then
    echo "network_libp2p_port = 1234" >> "$tmp_file"
    
# network_discovery_port 
  elif [[ $line == *network_discovery_port* ]]; then
    echo "network_discovery_port = 1234" >> "$tmp_file"
    
# rpc_enabled 
  elif [[ "$line" == "# rpc_enabled"* ]]; then
    echo "rpc_enabled = true" >> "$tmp_file"
    
# db_dir  
  elif [[ $line == *db_dir* ]]; then
    echo 'db_dir = "db"' >> "$tmp_file"
    
# log_config_file   
  elif [[ $line == *log_config_file* ]]; then
    echo 'log_config_file = "log_config"' >> "$tmp_file"
    
# log_directory   
  elif [[ $line == *log_directory* ]]; then
    echo 'log_directory = "log"' >> "$tmp_file"
    
  else
    echo "$line" >> "$tmp_file"
  fi
done

sudo mv "$original_file" "$backup_file"
if [ $? -ne 0 ]; then
  echo -e "${R}Failed to backup original file. Aborting.${N}"
  exit 1
fi

sudo mv "$tmp_file" "$original_file"
if [ $? -ne 0 ]; then
  echo -e "${R}Failed to update configuration file. Restoring original file.${N}"
  sudo mv "$backup_file" "$original_file"
  exit 1
fi

echo "Configuration updated and original file backed up as $backup_file"

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
|                 Configuration file updated successfully.                               |
+========================================================================================+
"
network_boot_nodes=$(grep -oP 'network_boot_nodes = \[.*?\]' "$original_file")
echo -e "+========================================${Y}Updated Configuration${N}========================================+"
echo "network_enr_address = $(grep -oP 'network_enr_address = "\K[^"]+' $original_file)"
echo "blockchain_rpc_endpoint = $(grep -oP 'blockchain_rpc_endpoint = "\K[^"]+' $original_file)"
echo "$network_boot_nodes"
echo "log_contract_address = $(grep -oP 'log_contract_address = "\K[^"]+' $original_file)"
echo "mine_contract_address = $(grep -oP 'mine_contract_address = "\K[^"]+' $original_file)"
echo "log_sync_start_block_number = $(grep -oP 'log_sync_start_block_number = \K\d+' $original_file)"
echo "storage_node_path = $ZGS_HOME"
echo -e "${R}+=====================================================================================================+${N}"
echo -e "${R}|                                                                                                     |${N}"
echo -e "${R}|                                                                                                     |${N}"
echo -e "${R}|miner_key(DO NOT SHARE IN DISCORD) = $(grep -oP 'miner_key = "\K[^"]+' $original_file)${N}"
echo -e "${R}|                                                                                                     |${N}"
echo -e "${R}|                                                                                                     |${N}"
echo -e "${R}+=====================================================================================================+${N}"
echo -e "${Y}Configuration update successful.${N}"
echo "You can check the variables set in .bash_profile on the web site below are set to be correct."
echo -e "${Y}(Ctrl + Click)->${N} https://nodebrand.xyz/entry/0G-Config"

