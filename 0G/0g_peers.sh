#!/bin/bash

# Define color codes
Y='\033[1;33m'
N='\033[0m'
R='\033[1;31m'

# Capture the list of peers
PEERS=$(curl -s -X POST https://testnet.0g.rpc.service.nodebrand.xyz -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"net_info","params":[],"id":1}' | jq -r '.result.peers[] | select(.connection_status.SendMonitor.Active == true) | "\(.node_info.id)@\(if .node_info.listen_addr | contains("0.0.0.0") then .remote_ip + ":" + (.node_info.listen_addr | sub("tcp://0.0.0.0:"; "")) else .node_info.listen_addr | sub("tcp://"; "") end)"' | tr '\n' ',' | sed 's/,$//')

# Format the peer list
formatted_peers=$(echo "$PEERS" | tr ',' '\n' | awk '{
    len = length($0)
    pad = (86 - len) / 2
    left_pad = int(pad)
    right_pad = 86 - len - left_pad
    printf "| %*s%s%*s |\n", left_pad, "", $0, right_pad, ""
}')

# Update the configuration file
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.0gchain/config/config.toml

# Check if the sed command was successful
if [ $? -eq 0 ]; then
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
|${R}                 PEER LIST :                                                            ${N}|
${R}$formatted_peers${N}
|                 Configuration file updated successfully with new peers.                |
+========================================================================================+
"
else
    echo "Failed to update configuration file."
fi
