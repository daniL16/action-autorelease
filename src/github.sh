#!/usr/bin/env bash

GITHUB_API_URI="https://api.github.com"
GITHUB_API_HEADER="Accept: application/vnd.github.v3+json"

github::create_pr(){
  head="$1"
  title="$2"
  body="$3"
  data="{\"title\":\"${title}\",\"base\":\"master\",\"head\": \"${head}\",\"body\": \"${body}\"}"
  response=$(curl -sSL -H "$GITHUB_API_HEADER" -H "Authorization: token ${GITHUB_TOKEN}" "$GITHUB_API_URI/repos/$GITHUB_REPOSITORY/pulls" -d "$data")
  pr_number=$(echo ${response} | jq .number -r)
  github::set_release_label $pr_number
}

github::get_lastReleaseDate(){
    release=$(curl -sSL -H "$GITHUB_API_HEADER" -H "Authorization: token ${GITHUB_TOKEN}" "https://api.github.com/search/issues?q=is:pr%20is:merged%20label:Release%20base:master%20repo:$GITHUB_REPOSITORY&per_page=1")
    releaseDate=$(echo "$release" | jq --raw-output '.items[] | .created_at')
    echo "$releaseDate"
}

github::get_version(){
    latestVersion=$(curl -sSL -H "$GITHUB_API_HEADER" -H "Authorization: token ${GITHUB_TOKEN}" "$GITHUB_API_URI/repos/$GITHUB_REPOSITORY/releases/latest" | jq .tag_name -r)
    mayor=$(echo $latestVersion | cut -f1 -d.)
    minor=$(echo $latestVersion | cut -f2 -d.)
    minor=$((minor+1))
    echo "${mayor}.${minor}.0"
}

github::getReleaseDescription(){
    if [ -z "$1" ]
    then
      dateFrom=$(date +%Y-%m-%dT%H:%M:%S -d "yesterday")
    else
      dateFrom="$1"
    fi
    body=$(curl -sSL -H "$GITHUB_API_HEADER" -H "Authorization: token ${GITHUB_TOKEN}" "https://api.github.com/search/issues?q=is:pr%20is:merged%20updated:>${dateFrom}%20base:develop%20repo:$GITHUB_REPOSITORY")
    pulls=$(echo "$body" | jq --raw-output '.items[] | {number: .number,title:.title, body:.body} | @base64')

    releaseBody=''

    for pr in $pulls; 
    do
        pull="$(echo "$pr" | base64 -d)"
        title=$(echo "$pull" | jq --raw-output '.title')
        number=$(echo "$pull" | jq --raw-output '.number')
        link=$(echo "$pull" | jq --raw-output '.body' | grep -Eo 'https://[^ >]+' )
        releaseBody="${releaseBody} <br> #${number} ${title} ${link}"
    done
    
    
    echo "$releaseBody"
    
}

github::set_release_label(){
    pr_number="$1"
    curl -sSL \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "${GITHUB_API_HEADER}" \
        -X POST \
        -H "Content-Type: application/json" \
        -d "{\"labels\":[\"Release\"]}" \
        "${GITHUB_API_URI}/repos/${GITHUB_REPOSITORY}/issues/${pr_number}/labels"
  

}
