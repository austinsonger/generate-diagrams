#!/bin/bash

# Add the base-templates submodule
git submodule add https://github.com/austinsonger/base-templates.git templates

# Add the DevOps-Bash-tools submodule
git submodule add https://github.com/austinsonger/DevOps-Bash-tools.git bash-tools

# Initialize and update the submodules
git submodule init
git submodule update

# Stage the changes for the submodules
git add .gitmodules templates bash-tools

# Commit the changes
git commit -m "Add base-templates and DevOps-Bash-tools as submodules"

# Push the changes to the repository
git push
