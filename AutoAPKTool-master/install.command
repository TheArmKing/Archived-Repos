#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
IFS='/' read -ra ADDR <<< "$SCRIPTPATH"
pts="$SCRIPTPATH/Files"
ptd="/Users/${ADDR[2]}"
ptd2="/usr/local/bin"
cd
mv $pts/a.sh $ptd2
chmod +x $ptd2/a.sh
ln -s $ptd2/a.sh /usr/local/bin/apk
echo -en "\x1B[1;49;92mMoved Main Script to $ptd2, run it by typing a.sh or apk in Terminal \x1B[0m \n"
mv $pts/signapk.jar $ptd
mv $pts/testkey.x509.pem $ptd
mv $pts/testkey.pk8 $ptd
mkdir $ptd/AutoAPKEditor
mv $pts/AutoApkConfig.txt $ptd/AutoAPKEditor/Config.txt
unzip $pts/AutoAPKEditor.app
mv $ptd/AutoAPKEditor.app $ptd/AutoAPKEditor/AutoAPKEditor.app
echo -en "\x1B[1;49;92mMoved Signing Files to /Users/${ADDR[2]} & Config.txt + App to $ptd/AutoAPKEditor \x1B[0m \n"
if hash apktool 2>/dev/null; then
    echo -en "\x1B[1;49;92mApktool is installed! \x1B[0m \n"
else
  echo -en "\x1B[1;49;91mApktool is not installed! Should I install it for you? \x1B[0m \n"
  select yn in "Yes" "No"; do
    case $yn in
        Yes ) mv $pts/apktool $ptd2
              mv $pts/apktool.jar $ptd2
              echo -en "\x1B[1;49;92mApktool Installed! \x1B[0m \n"
              break;;
        No )  echo -en "\x1B[1;49;91m:( \x1B[0m \n"
              break;;
    esac
  done
fi
echo -en "\x1B[1;49;92mInstallation Complete! \x1B[0m \n"
sleep 1
echo -en "\x1B[1;49;91mDeleting Source Files in 2 Seconds! \x1B[0m \n"
sleep 2
rm -r $ptd/__MACOSX 
rm -rf $SCRIPTPATH
