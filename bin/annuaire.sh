#!/bin/bash

utilisateur="<utilisateur>>"
mdp="$(python -c "import keyring; print keyring.get_password('ad', '${utilisateur}')")"
serveur="<ad>"
# wget compilé avec support de NTLM
wget_bin=/home/yann/bin/wget/bin/wget

nom=$(cat /dev/null | dmenu -b -p "Nom : ")

IFS=$'\n'
carte=( $(ldapsearch -x -h ${serveur} -b 'dc=groupe,dc=int' -D "groupe\\${utilisateur}" -w ''${mdp}'' "(cn=${nom}*)" | awk -F': ' '/cn:|title:|mail:|mobile:|telephoneNumber:/{print $2}') )
nom_link=$(echo ${carte[O],,} | sed -e 's/[^ ]*/\u&/g' -e 's/ //g')
img_link=$(${wget_bin} --user=${utilisateur} --password=${mdp} -qO - http://link/xwiki/bin/view/XWiki/${nom_link} | sed -n 's#.*nbglobalprofilFoto.*src="\(.*\)" border.*#http://link\1#p')

${wget_bin} --user=${utilisateur} --password=${mdp} -O /tmp/img_link.jpg ${img_link}
notify-send -i /tmp/img_link.jpg "${carte[*]}"
