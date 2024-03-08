#!/bin/bash
prefix="Task-"
                    git pull
                    git checkout -B "master" "origin/master"
                    git pull
                    git checkout -B "branch_sync_hran" "origin/branch_sync_hran"
                    logof=$(git log --reverse master...branch_sync_hran --pretty=format:"%h;%s|" | tr -d '\r\n')
                    echo "Вывод лога: $logof"
                    IFS='|' read -ra my_array <<< "$logof"
                    echo "Вывод IFS: $IFS"
                    for i in "${my_array[@]}"
                        do
                            BranchName=($(echo $i | sed 's/.*;//' | grep -oP --regexp="$prefix\K\d+"))
                            BranchName=$prefix$BranchName                           
                            commit=($(echo $i | sed 's/;.*//'))
                            committext=$(git show -s --format=%s $commit)
                            git checkout -B "master" "origin/master"
                            git checkout -B "feature/${BranchName}" "origin/feature/${BranchName}" || git checkout -B "feature/${BranchName}"
                            git cherry-pick ${commit} --keep-redundant-commits --strategy-option recursive -X theirs
                            git diff --name-only --diff-filter=U | xargs git rm -f
                            git add .
                            git commit -m "feature/${BranchName} - ${committext}"
                            git push --set-upstream origin "feature/$i_branch"
                            git rm 'src/cf/VERSION'
                            git rm 'src/cf/dumplist.txt'
                            git push origin "feature/${BranchName}"
                        done
                    git checkout -B "branch_sync_hran" "origin/branch_sync_hran"
                    git merge "master"
                    git push origin "branch_sync_hran"
                    git checkout "master"