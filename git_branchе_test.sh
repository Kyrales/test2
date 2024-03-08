#!/bin/bash
                    git pull
                    git checkout -B "master" "origin/master"
                    git pull
                    git checkout -B "branch_sync_hran" "origin/branch_sync_hran"
                    logof=$(git log --reverse master...branch_sync_hran --pretty=format:"%h;%s|" | tr -d '\r\n')
                    echo "Вывод лога: $logof"
                    IFS='|' read -ra my_array <<< "$logof"
                    for i in "${my_array[@]}"
                        do
                            BranchName=($(echo $i | sed 's/.*;//'))
                            echo "Это имя ветки: $BranchName"
                            commit=($(echo $i | sed 's/;.*//'))
                            echo "Это ИД коммита: $commit"
                        done
