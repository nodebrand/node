#!/bin/bash

Y='\033[1;33m'
N='\033[0m'
R='\033[1;31m'
G='\033[1;32m'
P='\033[1;35m'

update_profile_variable() {
  local VAR_NAME="$1"
  local PROMPT="$2"
  local DEFAULT_VALUE="$3"

  echo -e "${R}${PROMPT}${N}"
  echo -e "${G}Ex: ${Y}${DEFAULT_VALUE}${N}"
  read -p ": " USER_INPUT
  VAR_VALUE="${USER_INPUT}"

  if grep -q "^export $VAR_NAME=" ~/.bash_profile; then
    sed -i "s|^export $VAR_NAME=.*|export $VAR_NAME=\"$VAR_VALUE\"|" ~/.bash_profile
  else
    echo "export $VAR_NAME=\"$VAR_VALUE\"" >> ~/.bash_profile
  fi

  export $VAR_NAME="$VAR_VALUE"
}

update_profile_variable_with_default() {
  local VAR_NAME="$1"
  local PROMPT="$2"
  local DEFAULT_VALUE="$3"

  echo -e "${R}${PROMPT}${N}"
  echo -e "${G}Ex: ${Y}${DEFAULT_VALUE}${N}"
  echo -e "${G}To use the default value, just press enter:${N}"
  read -p ": " USER_INPUT
  VAR_VALUE="${USER_INPUT:-$DEFAULT_VALUE}"

  if grep -q "^export $VAR_NAME=" ~/.bash_profile; then
    sed -i "s|^export $VAR_NAME=.*|export $VAR_NAME=\"$VAR_VALUE\"|" ~/.bash_profile
  else
    echo "export $VAR_NAME=\"$VAR_VALUE\"" >> ~/.bash_profile
  fi

}

update_toml_files() 
{
    update_profile_variable "BLOCKCHAIN_RPC_ENDPOINT" 'Enter the exact BLOCKCHAIN_RPC_ENDPOINT(JSON-RPC)' "https://json-rpc.com or http://123.456.789:8545"
    # update_profile_variable "PRIVATE_KEY" 'Enter the exact PRIVATE_KEY (DO NOT INCLUDE LEADING 0x)' "691U4BETG97843926TEFU1493RVH395NODEBRAND59371RYE139EI134EBA1B135"

    # sed -i.bak \
    #   -e "s|^\s*#\?\s*miner_key\s*=.*|miner_key = \"$PRIVATE_KEY\"|" \
    #   $CONFIG_FILE

    update_profile_variable_with_default "ZGS_HOME" 'Enter the ZGS_HOME' "$HOME/0g-storage-node"
    update_profile_variable_with_default "LOG_CONTRACT_ADDRESS" 'Enter the LOG_CONTRACT_ADDRESS' "0x8873cc79c5b3b5666535C825205C9a128B1D75F1"
    update_profile_variable_with_default "MINE_CONTRACT_ADDRESS" 'Enter the MINE_CONTRACT_ADDRESS' "0x85F6722319538A805ED5733c5F4882d96F1C7384"
    update_profile_variable_with_default "ZGS_LOG_SYNC_BLOCK" 'Enter the ZGS_LOG_SYNC_BLOCK' "802"
    update_profile_variable_with_default "CONFIG_FILE" 'Enter the CONFIG_FILE' "$ZGS_HOME/run/config.toml"
    
    ENR_ADDRESS=$(wget -qO- https://eth0.me)

    NETWORK_BOOT_NODE1="/ip4/54.219.26.22/udp/1234/p2p/16Uiu2HAmTVDGNhkHD98zDnJxQWu3i1FL1aFYeh9wiQTNu4pDCgps"
    NETWORK_BOOT_NODE2="/ip4/52.52.127.117/udp/1234/p2p/16Uiu2HAkzRjxK2gorngB1Xq84qDrT4hSVznYDHj6BkbaE4SGx9oS"
    NETWORK_BOOT_NODE3="/ip4/18.167.69.68/udp/1234/p2p/16Uiu2HAm2k6ua2mGgvZ8rTMV8GhpW71aVzkQWy7D37TTDuLCpgmX"
    NETWORK_BOOT_NODES="[\"$NETWORK_BOOT_NODE1\",\"$NETWORK_BOOT_NODE2\",\"$NETWORK_BOOT_NODE3\"]"

    if grep -q '^export ENR_ADDRESS=' ~/.bash_profile; then
      sed -i 's|^export ENR_ADDRESS=.*|export ENR_ADDRESS="'"$ENR_ADDRESS"'"|' ~/.bash_profile
    else
      echo "export ENR_ADDRESS=\"$ENR_ADDRESS\"" >> ~/.bash_profile
    fi
    
    if grep -q '^export NETWORK_BOOT_NODES=' ~/.bash_profile; then
      sed -i 's|^export NETWORK_BOOT_NODES=.*|export NETWORK_BOOT_NODES='\"'"$NETWORK_BOOT_NODES"'\"'|' ~/.bash_profile
    else
      echo "export NETWORK_BOOT_NODES=\'$NETWORK_BOOT_NODES\'" >> ~/.bash_profile
    fi

    source ~/.bash_profile

    sed -i.bak \
      -e "s|^\s*#\?\s*network_dir\s*=.*|network_dir = \"network\"|" \
      -e "s|^\s*#\?\s*network_enr_address\s*=.*|network_enr_address = \"$ENR_ADDRESS\"|" \
      -e "s|^\s*#\?\s*network_enr_tcp_port\s*=.*|network_enr_tcp_port = 1234|" \
      -e "s|^\s*#\?\s*network_enr_udp_port\s*=.*|network_enr_udp_port = 1234|" \
      -e "s|^\s*#\?\s*network_libp2p_port\s*=.*|network_libp2p_port = 1234|" \
      -e "s|^\s*#\?\s*network_discovery_port\s*=.*|network_discovery_port = 1234|" \
      -e "s|^\s*#\s*rpc_listen_address\s*=.*|rpc_listen_address = \"0.0.0.0:5678\"|" \
      -e "s|^\s*#\s*rpc_listen_address_admin\s*=.*|rpc_listen_address_admin = \"0.0.0.0:5679\"|" \
      -e "s|^\s*#\?\s*rpc_enabled\s*=.*|rpc_enabled = true|" \
      -e "s|^\s*#\?\s*db_dir\s*=.*|db_dir = \"db\"|" \
      -e "s|^\s*#\?\s*log_config_file\s*=.*|log_config_file = \"log_config\"|" \
      -e "s|^\s*#\?\s*log_directory\s*=.*|log_directory = \"log\"|" \
      -e "s|^\s*#\?\s*network_boot_nodes\s*=.*|network_boot_nodes = $NETWORK_BOOT_NODES|" \
      -e "s|^\s*#\?\s*log_contract_address\s*=.*|log_contract_address = \"$LOG_CONTRACT_ADDRESS\"|" \
      -e "s|^\s*#\?\s*mine_contract_address\s*=.*|mine_contract_address = \"$MINE_CONTRACT_ADDRESS\"|" \
      -e "s|^\s*#\?\s*log_sync_start_block_number\s*=.*|log_sync_start_block_number = "$ZGS_LOG_SYNC_BLOCK"|" \
      -e "s|^\s*#\?\s*blockchain_rpc_endpoint\s*=.*|blockchain_rpc_endpoint = \"$BLOCKCHAIN_RPC_ENDPOINT\"|" \
      -e "s|^\s*#\?\s*\[sync\].*|\[sync\]|" \
      -e "s|^\s*#\?\s*auto_sync_enabled\s*=.*|auto_sync_enabled = true|" \
      -e "s|^\s*#\?\s*find_peer_timeout\s*=.*|find_peer_timeout = \"10s\"|" \
      $CONFIG_FILE

    NETWORK_BOOT_NODES=$(grep -oP 'network_boot_nodes = \[\K[^\]]+' "$CONFIG_FILE" | awk '{gsub(/,/, ",\n                      ")}1')
    NETWORK_BOOT_NODES=$(echo "$NETWORK_BOOT_NODES" | sed '1s/^/                      /')
    NETWORK_ENR_ADDRESS=$(grep -oP 'network_enr_address = "\K[^"]+' $CONFIG_FILE)
    BLOCKCHAIN_RPC_ENDPOINT=$(grep -oP 'blockchain_rpc_endpoint = "\K[^"]+' $CONFIG_FILE)
    LOG_CONTRACT_ADDRESS=$(grep -oP 'log_contract_address = "\K[^"]+' $CONFIG_FILE)
    MINE_CONTRACT_ADDRESS=$(grep -oP 'mine_contract_address = "\K[^"]+' $CONFIG_FILE)
    ZGS_LOG_SYNC_BLOCK=$(grep -oP 'log_sync_start_block_number = \K\d+' $CONFIG_FILE)
    STORAGE_NODE_PATH=$ZGS_HOME

    echo -e "UPDATE YOUR ${R}PRIVATE_KEY${N} TO config.toml file"
    read -p "PRIVATE_KEY: " \
    priv_key && \
    sed -i \
      -e "s|^\s*#\?\s*miner_key\s*=.*|miner_key = \"$priv_key\"|" \
      $CONFIG_FILE


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
    |                 Your Variable Setting Updated ${G}Successfully.${N}                            |
    +========================================================================================+

    +========================================Variable========================================+
                      
                      STORAGE_NODE_PATH: ${G}"$STORAGE_NODE_PATH"${N}
                      NETWORK_ENR_ADDRESS: ${G}"$NETWORK_ENR_ADDRESS"${N}
                      BLOCKCHAIN_RPC_ENDPOINT: ${G}"$BLOCKCHAIN_RPC_ENDPOINT"${N}
                      LOG_CONTRACT_ADDRESS: ${G}"$LOG_CONTRACT_ADDRESS"${N}
                      MINE_CONTRACT_ADDRESS: ${G}"$MINE_CONTRACT_ADDRESS"${N}
                      ZGS_LOG_SYNC_BLOCK: ${G}"$ZGS_LOG_SYNC_BLOCK"${N}
                      NETWORK_BOOT_NODES:\n${G}${NETWORK_BOOT_NODES}${N}
    +========================================================================================+
    "
}

update_toml_files
