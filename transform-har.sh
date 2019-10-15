# this cli package can be used to pre-process HAR files that have handlebars variables in them
npm list -g | grep handlebars-cmd || npm install -g handlebars-cmd

# transform the HAR template with variables passed in
cat /tmp/JuiceShop_Template.har | handlebars --base_url http://$HOST --host $HOST > /tmp/output.har
