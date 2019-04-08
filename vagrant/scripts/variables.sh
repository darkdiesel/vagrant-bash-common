#!/usr/bin/env bash

function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("__")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

eval $(parse_yaml /vagrant/default.yml)

if [ -f "${VAGRANT__PATH}/settings.yml" ]; then
    eval $(parse_yaml ${VAGRANT__PATH}/settings.yml)
fi

eval $(parse_yaml ${VAGRANT__PATH}/relative.yml)

#for i in `seq 1 ${SITES__COUNT}`;
#do
#    eval VAGRANT_SITE_DOMAIN='$'SITES__SITE_"$i"__DOMAIN
#    eval VAGRANT_SITE_DIR='$'SITES__SITE_"$i"__DIR
#    eval VAGRANT_SITE_PATH='$'SITES__SITE_"$i"__PATH
#
#    echo ${VAGRANT_SITE_DOMAIN}
#    echo ${VAGRANT_SITE_DIR}
#    echo ${VAGRANT_SITE_PATH}
#
#    if [ -d "$VAGRANT_SITE_PATH" ]; then
#        echo "----TRUE----"
#    else
#        echo "----FALSE----"
#    fi
#done
#
#exit 1