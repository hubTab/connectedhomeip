#!/bin/bash
# Name - build_st_matter_lua_library.sh
# Author - SmartThings 2022
# Usage -  ./shuild_st_matter_lua_library.sh
# ----------------------------------------------------------------
set -e

THIS_DIR=$(dirname `which $0`)
if [ $THIS_DIR == "." ]; then
  THIS_DIR=`pwd` 
fi

COMPILED_GENERATED_ST_CLUSTERS=$THIS_DIR/zzz_generated/st-clusters
GENERATED_ST_CLUSTERS=$COMPILED_GENERATED_ST_CLUSTERS/st/matter/generated/zap_clusters
# DOC_DIR="../hub-core/lib/scripting-engine/lua_libs/st/matter/generated/zap_clusters"

# doc_path="${1:-$DOC_DIR}"
doc_path="${1}"

echo "THIS_DIR: $THIS_DIR"
echo "COMPILED_GENERATED_ST_CLUSTERS: $COMPILED_GENERATED_ST_CLUSTERS"
echo "GENERATED_ST_CLUSTERS: $GENERATED_ST_CLUSTERS"
echo "doc_path: $doc_path"
 
# [ ! -d "$doc_path" ] && { echo "$0 - Directory $doc_path not provided. Usage $0 <lua_library_directory>"; exit 1; }
[ ! -d "$doc_path" ] && { mkdir -p "$doc_path"; }
echo "Generating Matter Lua Library to $doc_path"

cd $THIS_DIR



# Start from smartthings_zap_artifacts branch
git checkout smartthings_zap_artifacts

# Temporary solution till we get these PRs merged into master
# git checkout DoorLock_Type_Update_Issue_15528 -- src/app/zap-templates/zcl/data-model/chip/door-lock-cluster.xml
# git checkout OnOff_Type_Update_Issue_15528 -- src/app/zap-templates/zcl/data-model/chip/onoff-cluster.xml

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
# git rebase master

# Generate the ZAP Compiled Cluster code
mkdir -p $COMPILED_GENERATED_ST_CLUSTERS
scripts/tools/zap/generate.py --templates src/app/zap-templates/st-app-templates.json examples/st/st-clusters-app.zap -o $COMPILED_GENERATED_ST_CLUSTERS

# Segregate the ZAP Compiled Code into individual lua files 
cp src/app/zap-templates/templates/app/st/scripts/generate_clusters.sh $COMPILED_GENERATED_ST_CLUSTERS/
cp src/app/zap-templates/templates/app/st/scripts/process_files.sh $COMPILED_GENERATED_ST_CLUSTERS/
cd $COMPILED_GENERATED_ST_CLUSTERS/
./generate_clusters.sh

# Apply lua syntax checker across all lua files
NUMBER_OF_LUA_FILES=`find st/matter/ -type f | wc -l`
if find st/matter/ -maxdepth 1000 -type f -exec printf '%s\0' {} \; | xargs -0 luac -p  --; 
then
  echo "$NUMBER_OF_LUA_FILES Lua Files Syntax passed";

  # Copying generated Lua Library
  echo "Copying generated Lua Library to $doc_path"
  cp -r $GENERATED_ST_CLUSTERS/* ${doc_path}/
else
  echo "$NUMBER_OF_LUA_FILES Lua Files Syntax failed";
fi