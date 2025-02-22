#! /bin/bash

token=$1
repo_owner="Azbagheri"
repo_name="shell-linter"
tag_name="latest"
commit_sha=$(git log -n1 --format=format:"%H")

create_tag(){
command="curl -i \
--request POST \
-u username:$token \
--data '{\"ref\": \"refs/tags/$tag_name\",\"sha\": \"$commit_sha\"}' \
https://api.github.com/repos/${repo_owner}/${repo_name}/git/refs"

git tag $tag_name
eval "$command"
}

update_tag() {
command="curl -i \
--request PATCH \
-u username:$token \
--data '{\"sha\": \"$commit_sha\", \"force\":true}' \
https://api.github.com/repos/${repo_owner}/${repo_name}/git/refs/tags/$tag_name"

eval "$command"
}

if git tag --list | grep -Eq "$tag_name" ; then
    echo "Updating the 'latest' tag"
    update_tag
else
    echo "Creating the 'latest' tag"
    create_tag
fi