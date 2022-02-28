#!/bin/bash
# Name - build_st_matter_lua_library.sh
# Author - SmartThings 2022
# Usage -  ./shuild_st_matter_lua_library.sh
# ----------------------------------------------------------------

# Start from smartthings_zap_artifacts branch
git checkout smartthings_zap_artifacts

# Create the patch on the fly. This allows for in place editing and development of the ST ZAP Templates
git diff master > smartthings_zap_artifacts-patch.patch

# Switch to master and apply the patch
git checkout master --recurse-submodules
git apply --whitespace=nowarn --verbose --ignore-whitespace smartthings_zap_artifacts-patch.patch

# Generate the ZAP Compiled Cluster code
mkdir -p zzz_generated/st-clusters
scripts/tools/zap/generate.py --templates src/app/zap-templates/st-app-templates.json examples/st/st-clusters-app.zap -o zzz_generated/st-clusters

# Segregate the ZAP Compiled Code into individual lua files 
cp src/app/zap-templates/templates/app/st/scripts/generate_clusters.sh zzz_generated/st-clusters/
cp src/app/zap-templates/templates/app/st/scripts/process_files.sh zzz_generated/st-clusters/
cd zzz_generated/st-clusters/
./generate_clusters.sh

# Apply lua syntax checker across all lua files
find st/matter/ -maxdepth 1000 -type f -exec printf '%s\0' {} \; | xargs -0 luac -p  --
find st/matter/ -type f | wc -l
