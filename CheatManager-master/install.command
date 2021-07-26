#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
unzip $SCRIPTPATH/CheatManager.app.zip
mv $HOME/CheatManager.app $HOME/Desktop/CheatManager.app
cp $SCRIPTPATH/CM.sh /usr/local/bin/CM.sh
chmod +x /usr/local/bin/MM.sh
ln -s /usr/local/bin/CM.sh /usr/local/bin/CheatManager
ln -s /usr/local/bin/CM.sh /usr/local/bin/iOSM
if [ -d "$HOME/__MACOSX" ]; then
  rm -rf $HOME/__MACOSX
fi
if hash brew 2>/dev/null; then
        echo -en "\x1B[1;49;92mHome Brew is installed!\x1B[0m\n"
else
        echo -en "\x1B[1;49;91mHome Brew is not installed!\x1B[0m\n"
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null 2> /dev/null
        echo -en "\x1B[1;49;92mHome Brew is installed!\x1B[0m\n"
fi
if hash xmlstarlet 2>/dev/null; then
        echo -en "\x1B[1;49;92mxmlstarlet is installed!\x1B[0m\n"
else
        echo -en "\x1B[1;49;91mxmlstarlet is not installed!\x1B[0m\n"
        brew install xmlstarlet
        echo -en "\x1B[1;49;92mxmlstarlet is installed!\x1B[0m\n"
fi
sleep 0.3
echo -en "\nDone! Invoke Script by typing CM.sh or CheatManager or iOSM in Terminal, or Open the CheatManager.app in the Desktop Folder\n"
rm -rf $SCRIPTPATH
