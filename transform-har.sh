# this cli package can be used to pre-process HAR files that have handlebars variables in them
npm list -g | grep handlebars-cmd || npm install -g handlebars-cmd

# parse the hostname from the url
HOST=$( echo $BASE_URL | sed -E "s/https?:\/\/([^\/]*)\/?(.*)/\1/")

echo "BASE_URL: $BASE_URL"
echo "HOST: $HOST"

# transform the HAR template with variables passed in
cat /tmp/JuiceShop_Template.har | handlebars --base_url $BASE_URL --host $HOST > /tmp/$OUT_FILE
