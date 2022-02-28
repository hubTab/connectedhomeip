#!/bin/bash
# Name - script.sh (bash read file names list from file)
# Author - Vivek Gite under GPL v2.x+
# Usage - Read filenames from a text file and take action on $file 
# ----------------------------------------------------------------

mkdir -p st/matter/generated/zap_clusters/
cp st/clusters/init.lua st/matter/generated/zap_clusters/

./process_files.sh st/clusters/cluster/init.lua
./process_files.sh st/clusters/cluster/server/attributes/init.lua
./process_files.sh st/clusters/cluster/server/attributes/attributes.lua
./process_files.sh st/clusters/cluster/server/commands/init.lua
./process_files.sh st/clusters/cluster/server/commands/commands.lua
./process_files.sh st/clusters/cluster/server/types/init.lua
./process_files.sh st/clusters/cluster/server/types/types.lua