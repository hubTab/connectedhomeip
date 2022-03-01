#!/bin/bash
# Name - build_st_matter_lua_library.sh
# Author - SmartThings 2022
# Usage -  ./shuild_st_matter_lua_library.sh
# ----------------------------------------------------------------
set -e
lua_library="${1:-matter lua library}"
 
[ ! -d "$lua_library" ] && { echo "$0 - Directory $lua_library not found."; exit 1; }
echo "LuaLibrary is $lua_library"

# Start from smartthings_zap_artifacts branch
git checkout smartthings_zap_artifacts

# Temporary solution till we get these PRs merged into master
git checkout DoorLock_Type_Update_Issue_15528 -- src/app/zap-templates/zcl/data-model/chip/door-lock-cluster.xml
git checkout OnOff_Type_Update_Issue_15528 -- src/app/zap-templates/zcl/data-model/chip/onoff-cluster.xml

# ###############################################################################
# # Alternative approach: generate Lua Library in the master branch
# ###############################################################################
# # # Create the patch on the fly. This allows for in place editing and development of the ST ZAP Templates
# # git diff master > smartthings_zap_artifacts-patch.patch

# # # Switch to master and apply the patch
# # git checkout master --recurse-submodules
# # git apply --whitespace=nowarn --verbose --ignore-whitespace smartthings_zap_artifacts-patch.patch

###############################################################################
# Current approach: generate Lua Library in this branch
###############################################################################
git rebase master

# Generate the ZAP Compiled Cluster code
mkdir -p zzz_generated/st-clusters
scripts/tools/zap/generate.py --templates src/app/zap-templates/st-app-templates.json examples/st/st-clusters-app.zap -o zzz_generated/st-clusters

# Segregate the ZAP Compiled Code into individual lua files 
cp src/app/zap-templates/templates/app/st/scripts/generate_clusters.sh zzz_generated/st-clusters/
cp src/app/zap-templates/templates/app/st/scripts/process_files.sh zzz_generated/st-clusters/
cd zzz_generated/st-clusters/
./generate_clusters.sh

# Apply lua syntax checker across all lua files
NUMBER_OF_LUA_FILES=`find st/matter/ -type f | wc -l`
if find st/matter/ -maxdepth 1000 -type f -exec printf '%s\0' {} \; | xargs -0 luac -p  --; 
then
  echo "$NUMBER_OF_LUA_FILES Lua Files Syntax passed";

  # Copy the Lua Library to the 
  echo "Copying generated Lua Libary to $lua_library"
  cp -r ./st/matter/generated/zap_clusters/* ${lua_library}/
else
  echo "$NUMBER_OF_LUA_FILES Lua Files Syntax failed";
fi