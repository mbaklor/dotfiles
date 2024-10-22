scoop export | jq -r '.buckets | .[] | .Name' > buckets.txt
scoop export | jq -r '.apps | .[] | .Name' > apps.txt
