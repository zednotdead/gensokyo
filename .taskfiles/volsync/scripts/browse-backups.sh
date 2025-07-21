result=$(kubectl get replicationsources -A -o=json | jq -r '.items[].metadata | "\(.namespace) \(.name)"' | fzf)
IFS=' ' read -r -a array <<< "$result"
echo $result
