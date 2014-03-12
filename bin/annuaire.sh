#!/bin/bash

utilisateur="<utilisateur>"
mdp='<mot de passe>'
# wget compilé avec support de NTLM
wget_bin=${LOCAL_BIN}/wget/bin/wget

nom=$(cat /dev/null | dmenu -b -p "Nom : ")

IFS=$'\n'
carte=( $(ldapsearch -x -h 172.16.204.45 -b 'dc=groupe,dc=int' -D "groupe\\${utilisateur}" -w ''${mdp}'' "(cn=${nom}*)" | awk -F': ' '/cn:|title:|mail:|mobile:|telephoneNumber:/{print $2}') )
nom_link=$(echo ${carte[O],,} | sed -e 's/[^ ]*/\u&/g' -e 's/ //g')
img_link=$(${wget_bin} --user=${utilisateur} --password=${mdp} -qO - http://link/xwiki/bin/view/XWiki/${nom_link} | sed -n 's#.*nbglobalprofilFoto.*src="\(.*\)" border.*#http://link\1#p')

${wget_bin} --user=${utilisateur} --password=${mdp} -O /tmp/img_link.jpg ${img_link}
notify-send -i /tmp/img_link.jpg "${carte[*]}"
