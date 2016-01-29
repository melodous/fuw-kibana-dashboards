# Copyright (c) 2012–2016 Elasticsearch <http://www.elastic.co>
# Modifications copyright 2016 Fundi Software
#            
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.         

# This is a modified copy of the file originally provided with the
# elastic/beats-dashboards GitHub project, commit 7391817, downloaded
# from GitHub on 2016-01-29.

# Modifications:
# yyyy-mm-dd  Description
# 2016-01-29  Inserted a copyright notice in the comment header:
#             the contents of the LICENSE file from the
#             elastic/beats-dashboards GitHub project,with a "Modifications..."
#             copyright notice added after the original copyright notice.
#             Removed code and usage text for index patterns.
#             Inserted usage text for searches.

param(
  [String] $l, [String] $url, 
  [String] $u, [String] $user, 
  [String] $i, [String] $index,
  [switch] $h = $false, [switch] $help = $false
)

# The default value of the variable. Initialize your own variables here
$ELASTICSEARCH="http://localhost:9200"
$CURL="Invoke-RestMethod"
$KIBANA_INDEX=".kibana"
$SCRIPT=$MyInvocation.MyCommand.Name

# Verify that Invoke-RestMethod is present. It was added in PS 3.
if (!(Get-Command $CURL -errorAction SilentlyContinue))
{
  Write-Error "$CURL cmdlet was not found. You may need to upgrade your PowerShell version."
  exit 1
}

function print_usage() {
  echo @"

Load the dashboards, visualizations and searches into the given
Elasticsearch instance.

Usage:
  $SCRIPT -url $ELASTICSEARCH -user admin -index $KIBANA_INDEX
Options:
  -h | -help
    Print the help menu.
  -l | -url
    Elasticsearch URL. By default is $ELASTICSEARCH.
  -u | -user
    Username and password for authenticating to Elasticsearch using Basic
    Authentication. The username and password should be separated by a
    colon (i.e. "user:secret"). By default no username and password are
    used.
  -i | -index
    Kibana index pattern where to save the dashboards, visualizations,
    searches. By default is $KIBANA_INDEX.

"@
}

if ($help -or $h) {
  print_usage
  exit 0
}
if ($args -ne "") {
  Write-Error "Error: Unknown option $args"
  print_usage
  exit 1
}

if ($l -ne "" ) {
  $ELASTICSEARCH=$l
}
if ($url -ne "") {
  $ELASTICSEARCH=$url
}
if ($ELASTICSEARCH -eq "") {
  Write-Error "Error: Missing Elasticsearch URL"
  print_usage
  exit 1
}

if ($u -ne "" ){
  $user = $u
}
if ($user -ne "") {
  $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}" -f $user)))
  $headers=@{Authorization=("Basic $base64AuthInfo")}
}

if ($i -ne "") {
  $KIBANA_INDEX=$i
}
if ($index -ne "") {
  $KIBANA_INDEX=$index
}
if ($KIBANA_INDEX -eq "") {
  Write-Error "Error: Missing Kibana index pattern"
  print_usage
  exit 1
}

$DIR="./dashboards"
echo "Loading dashboards to $ELASTICSEARCH in $KIBANA_INDEX"  

ForEach ($file in Get-ChildItem "$DIR/search/" -Filter *.json) {
  $name = [io.path]::GetFileNameWithoutExtension($file.Name)
  echo "Loading search $($name):"
  &$CURL -Headers $headers -Uri "$ELASTICSEARCH/$KIBANA_INDEX/search/$name" -Method PUT -Body $(Get-Content "$DIR/search/$file")
}

ForEach ($file in Get-ChildItem "$DIR/visualization/" -Filter *.json) {
  $name = [io.path]::GetFileNameWithoutExtension($file.Name)
  echo "Loading visualization $($name):"
  &$CURL -Headers $headers -Uri "$ELASTICSEARCH/$KIBANA_INDEX/visualization/$name" -Method PUT -Body $(Get-Content "$DIR/visualization/$file")
}

ForEach ($file in Get-ChildItem "$DIR/dashboard/" -Filter *.json) {
  $name = [io.path]::GetFileNameWithoutExtension($file.Name)
  echo "Loading dashboard $($name):"
  &$CURL -Headers $headers -Uri "$ELASTICSEARCH/$KIBANA_INDEX/dashboard/$name" -Method PUT -Body $(Get-Content "$DIR/dashboard/$file")
}

# ForEach ($file in Get-ChildItem "$DIR/index-pattern/" -Filter *.json) {
#   $json = Get-Content "$DIR/index-pattern/$file" -Raw | ConvertFrom-Json
#   $name = $json.title
#   echo "Loading index-pattern $($name):"
#   &$CURL -Headers $headers -Uri "$ELASTICSEARCH/$KIBANA_INDEX/index-pattern/$name" -Method PUT -Body $(Get-Content "$DIR/index-pattern/$file")
# }
