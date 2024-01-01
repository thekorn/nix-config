function git-open() {
    isgithub=$(git remote get-url origin | grep -c "github.com")
    isbitbucket=$(git remote get-url origin | grep -c "bitbucket.org")

    branch=$(git rev-parse --abbrev-ref HEAD)
    dirlen=$(git rev-parse --show-toplevel | wc -c)

    if [[ $isgithub -eq 1 ]]; then
        origin=$(git remote get-url origin | sed -e "s/^git@github.com://" -e "s/^https:\/\/github.com\///" -e "s/.git$//")

        for path in "$@"; do
            open "https://github.com/${origin}/tree/${branch}/$(realpath "${path}" | cut -c "${dirlen}"-)"
        done

        if [[ "$#" -eq 0 ]]; then
            open "https://github.com/${origin}/tree/${branch}/$(pwd | cut -c "${dirlen}"-)"
        fi
    else
        if [[ $isbitbucket -eq 1 ]]; then
            origin=$(git remote get-url origin | sed -e "s/^git@bitbucket.org://" -e "s/^https:\/\/bitbucket.org\///" -e "s/.git$//")

            for path in "$@"; do
                open "https://bitbucket.org/${origin}/src/${branch}/$(realpath "${path}" | cut -c "${dirlen}"-)"
            done

            if [[ "$#" -eq 0 ]]; then
                open "https://bitbucket.org/${origin}/src/${branch}/$(pwd | cut -c "${dirlen}"-)"
            fi
        fi
    fi
}
