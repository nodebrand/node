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
  echo -e "${G}To use the default value, just press enter:${N}"
  read -p ": " USER_INPUT
  VAR_VALUE="${USER_INPUT:-$DEFAULT_VALUE}"

  if grep -q "^export $VAR_NAME=" ~/.bash_profile; then
    sed -i "s|^export $VAR_NAME=.*|export $VAR_NAME=\"$VAR_VALUE\"|" ~/.bash_profile
  else
    echo "export $VAR_NAME=\"$VAR_VALUE\"" >> ~/.bash_profile
  fi

}

update_toml_files() {
  local OG_HOME="$1"
  local PROXY_APP_PORT="$2"
  local RPC_PORT="$3"
  local PPROF_PORT="$4"
  local P2P_PORT="$5"
  local EXTERNAL_IP="$6"
  local API_PORT="$7"
  local GRPC_PORT="$8"
  local GRPC_WEB_PORT="$9"

  sed -i.bak \
    -e "s/^indexer *=.*/indexer = \"kv\"/" \
    -e "s/\(proxy_app = \"tcp:\/\/\)\([^:]*\):\([0-9]*\).*/\1\2:$PROXY_APP_PORT\"/" \
    -e "s/\(laddr = \"tcp:\/\/\)\([^:]*\):\([0-9]*\).*/\1\2:$RPC_PORT\"/" \
    -e "s/\(pprof_laddr = \"\)\([^:]*\):\([0-9]*\).*/\1localhost:$PPROF_PORT\"/" \
    -e "/\[p2p\]/,/^\[/{s/\(laddr = \"tcp:\/\/\)\([^:]*\):\([0-9]*\).*/\1\2:$P2P_PORT\"/}" \
    -e "/\[p2p\]/,/^\[/{s/\(external_address = \"\)\([^:]*\):\([0-9]*\).*/\1${EXTERNAL_IP}:$P2P_PORT\"/; t; s/\(external_address = \"\).*/\1${EXTERNAL_IP}:$P2P_PORT\"/}" \
    $OG_HOME/config/config.toml

  sed -i.bak \
    -e "s/^pruning *=.*/pruning = \"custom\"/" \
    -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" \
    -e "s/^pruning-interval *=.*/pruning-interval = \"17\"/" \
    -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ua0gi\"/" \
    -e 's/address = "127.0.0.1:8545"/address = "0.0.0.0:8545"/' \
    -e 's|^api = ".*"|api = "eth,txpool,personal,net,debug,web3"|' \
    -e "/\[api\]/,/^\[/{s/\(address = \"tcp:\/\/\)\([^:]*\):\([0-9]*\)\(\".*\)/\1\2:$API_PORT\4/}" \
    -e "/\[grpc\]/,/^\[/{s/\(address = \"\)\([^:]*\):\([0-9]*\)\(\".*\)/\1\2:$GRPC_PORT\4/}" \
    -e "/\[grpc-web\]/,/^\[/{s/\(address = \"\)\([^:]*\):\([0-9]*\)\(\".*\)/\1\2:$GRPC_WEB_PORT\4/}" \
    $OG_HOME/config/app.toml
}

Y='\033[1;33m'  # Yellow
N='\033[0m'     # Reset color
R='\033[1;31m'  # Red
G='\033[1;32m'  # Green
P='\033[1;35m'  # Purple

echo -e "${G}1. Update .bash_profile with configuration variables${N}"
echo -e "${G}2. Update TOML configuration files with ports${N}"
read -p 'Choose an option (1 or 2): ' OPTION

case $OPTION in
  1)
    update_profile_variable "OG_HOME" 'Enter the exact path to the 0G directory (DO NOT INCLUDE Last "/")' "/root/.0gchain"
    update_profile_variable "MONIKER" "Enter the MONIKER you want to use" "nodebrand_moniker"
    update_profile_variable "WALLET_NAME" "Enter the WALLET NAME you want to use" "wallet"
    update_profile_variable "RPC_PORT" "Enter the port you want to use for RPC_PORT" "26657"
    update_profile_variable "PROXY_APP_PORT" "Enter the port you want to use for PROXY_APP_PORT" "26658"
    update_profile_variable "P2P_PORT" "Enter the port you want to use for P2P_PORT" "26656"
    update_profile_variable "PPROF_PORT" "Enter the port you want to use for PPROF_PORT" "6060"
    update_profile_variable "API_PORT" "Enter the port you want to use for API_PORT" "1317"
    update_profile_variable "GRPC_PORT" "Enter the port you want to use for GRPC_PORT" "9090"
    update_profile_variable "GRPC_WEB_PORT" "Enter the port you want to use for GRPC_WEB_PORT" "9091"
    update_profile_variable "CHAIN_ID" "Enter the CHAIN_ID" "zgtendermint_16600-2"
    EXTERNAL_IP=$(wget -qO- https://eth0.me)
    if grep -q '^export EXTERNAL_IP=' ~/.bash_profile; then
      sed -i 's|^export EXTERNAL_IP=.*|export EXTERNAL_IP="'"$EXTERNAL_IP"'"|' ~/.bash_profile
    else
      echo "export EXTERNAL_IP=\"$EXTERNAL_IP\"" >> ~/.bash_profile
    fi

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
|                 Your Variable Setting Updated ${G}Successfully.${N}                            |
+========================================================================================+

+========================================Variable========================================+
                   
                  OG_HOME: ${G}"$OG_HOME"${N}
                  PROXY_APP_PORT: ${G}"$PROXY_APP_PORT"${N}
                  RPC_PORT: ${G}"$RPC_PORT"${N}
                  PPROF_PORT: ${G}"$PPROF_PORT"${N}
                  P2P_PORT: ${G}"$P2P_PORT"${N}
                  EXTERNAL_IP: ${G}"$EXTERNAL_IP"${N}
                  API_PORT: ${G}"$API_PORT"${N}
                  GRPC_PORT: ${G}"$GRPC_PORT"${N}
                  GRPC_WEB_PORT: ${G}"$GRPC_WEB_PORT"${N}
+========================================================================================+
"
    ;;

  2)
    source ~/.bash_profile

    update_toml_files "$OG_HOME" "$PROXY_APP_PORT" "$RPC_PORT" "$PPROF_PORT" "$P2P_PORT" "$EXTERNAL_IP" "$API_PORT" "$GRPC_PORT" "$GRPC_WEB_PORT"
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
|                 Your .toml file Updated ${G}Successfully.${N}                                  |
+========================================================================================+

+========================================Variable========================================+
                   
                  OG_HOME: ${G}"$OG_HOME"${N}
                  PROXY_APP_PORT: ${G}"$PROXY_APP_PORT"${N}
                  RPC_PORT: ${G}"$RPC_PORT"${N}
                  PPROF_PORT: ${G}"$PPROF_PORT"${N}
                  P2P_PORT: ${G}"$P2P_PORT"${N}
                  EXTERNAL_IP: ${G}"$EXTERNAL_IP"${N}
                  API_PORT: ${G}"$API_PORT"${N}
                  GRPC_PORT: ${G}"$GRPC_PORT"${N}
                  GRPC_WEB_PORT: ${G}"$GRPC_WEB_PORT"${N}
+========================================================================================+
"
    ;;
  *)
    echo 'Invalid option. Please choose 1 or 2.'
    exit 1
    ;;
esac

exit 0
