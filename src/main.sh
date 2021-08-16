source "$SRC_DIR/src/github.sh"

main(){

export GITHUB_TOKEN="$1"

version=$(github::get_version)
branch_name=release/${version}

dateLastRelease=$(github::get_lastReleaseDate)
 if [ -z "$dateLastRelease" ]
    then
      dateLastRelease=$(date +%Y-%m-%dT%H:%M:%S -d "yesterday")
fi

echo "$dateLastRelease"
bodyRelease=$(github::getReleaseDescription ${dateLastRelease})

git fetch --all;
git checkout develop;
git checkout -b ${branch_name};
git push --set-upstream origin "HEAD:${branch_name}";
github::create_pr ${branch_name} "Release ${version}" "${bodyRelease}"
exit 1;


}
