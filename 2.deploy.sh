#!/bin/bash

echo -e "\033[0;32mDeploying updates to gitee...\033[0m"

# backup
git submodule update --remote
git config --global core.autocrlf false
git add .
git commit -m "site backup"
git push origin develop --force
