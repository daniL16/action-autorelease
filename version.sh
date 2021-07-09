 #!/bin/bash

repo="bulevipcom/stripe-mirakl-connector-1"
dateFrom="2021-06-01T08:36:01Z"
body=$(curl "https://api.github.com/search/issues?q=is:pr%20is:closed%20label:release%20base:master%20repo:${repo}&per_page=1")
pulls=$(echo "$body" | jq --raw-output '.items[] | .created_at')

echo $pulls
