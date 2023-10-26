#!/bin/bash
# 프로젝트 저장소의 git head와 remote의 origin을 비교해보고
# 변경점이 있을 시에 git pull을 받는 스크립트입니다.
# 

function git_update_check() {
    # git 현재 브랜치 얻어오기 코드 참조
    # - https://stackoverflow.com/questions/1593051/how-to-programmatically-determine-the-current-checked-out-git-branch
    # - https://stackoverflow.com/questions/6245570/how-do-i-get-the-current-branch-name-in-git
    # git branch --no-color | grep -E '^\*' | awk '{print $2}' || echo "master"
    # git symbolic-ref --short -q HEAD
    current_branch=$(git branch --show-current || echo "master")

    # git 변경사항 체크
    git fetch origin $current_branch
    git_behind_count=$(git rev-list HEAD..origin/$current_branch --count)
    if [[ "${git_behind_count}" == "0" ]]; then
        echo "false"
        return
    else
        echo "true"
        return
    fi
}


# git 갱신 사항이 있는지 확인하고, 없으면 스크립트 종료.
[ $(git_update_check) != "true" ] && exit 1


# git 갱신
git pull --recurse-submodules

