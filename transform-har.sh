OUT_FILE=/tmp/output.har

# this cli package can be used to pre-process HAR files that have handlebars variables in them
npm list -g | grep handlebars-cmd || npm install -g handlebars-cmd

# parse the hostname from the url
HOST="$(awk -F/ '{print $3}' <<<$BASE_URL)"

# remove output file if exists
rm -f $OUT_FILE

# transform the HAR template with variables passed in
cat /tmp/JuiceShop_Template.har | handlebars --base_url $BASE_URL --host $HOST > $OUT_FILE
