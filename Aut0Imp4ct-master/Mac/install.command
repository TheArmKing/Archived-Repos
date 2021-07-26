#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cat <<EOF > /usr/local/bin/autoimpact.sh
#!/bin/sh
if [ ! -d "\$HOME/Library/Aut0Imp4ct" ]; then mkdir "\$HOME/Library/Aut0Imp4ct"; fi
if [ ! -f "\$HOME/Library/Aut0Imp4ct/details.txt" ] || [ "\$(tail -n +1 \$HOME/Library/Aut0Imp4ct/details.txt | head -n1)" == "" ] || [ "\$(tail -n +1 \$HOME/Library/Aut0Imp4ct/details.txt | head -n1)" == "" ] ; then
  if [ -f "\$HOME/Library/Aut0Imp4ct/details.txt" ]; then rm "\$HOME/Library/Aut0Imp4ct/details.txt"; fi
  echo  "\x1B[0;49;91mDetails were either corrupted or not found!\nEnter your details now!\x1B[0m\n"
  cbz=0
  while (( !cbz )); do
    read -e -p "Email:" email
    if [ "\$email" != "" ]; then cbz=1;
    else echo "Details Empty!"; fi
  done
  nzs=0
  while (( !nzs )); do
    read -s -p "Pass:" pass
    if [ "\$pass" == "" ]; then echo "Password cannot be Empty!";
    else
      echo
      read -s -p "Reconfirm Pass:" passe
      if [ "\$pass" == "\$passe" ]; then nzs=1;
      else echo "Passwords dont match"; fi
    fi
  done
  echo "\$email" >> \$HOME/Library/Aut0Imp4ct/details.txt
  echo "\$pass" >> \$HOME/Library/Aut0Imp4ct/details.txt
  echo  "\x1B[0;49;32mDetails Stored!\x1B[0m File is \x1B[1;49;39m\$HOME/Library/Aut0Imp4ct/details.txt\x1B[0m"
elif [ "\$(pgrep -x -- "Impactor")" == "" ]; then
  echo  "\x1B[0;49;91mImpactor Not Running!\x1B[0m\n"
  exit
fi
email="\$(tail -n +1 \$HOME/Library/Aut0Imp4ct/details.txt | head -n1)"
pass="\$(tail -n +2 \$HOME/Library/Aut0Imp4ct/details.txt | head -n1)"
osascript -e "tell application \"Impactor\"
activate
tell application \"System Events\" to keystroke (key code 48)
tell application \"System Events\" to keystroke \"\$email\"
tell application \"System Events\" to keystroke (key code 36)
tell application \"System Events\" to keystroke \"\$pass\"
tell application \"System Events\" to keystroke (key code 36)
end tell"
osascript -e "tell application \"Terminal\"
activate
end tell"
echo  "\x1B[1;49;92mAuto-Impacted!\x1B[0m\n"
EOF
chmod +x /usr/local/bin/autoimpact.sh
ln -s /usr/local/bin/autoimpact.sh /usr/local/bin/Impact
chmod +x /usr/local/bin/Impact
echo -en "\x1B[1;49;92mDone!\x1B[0m\n"
sleep 0.5
rm -rf $SCRIPTPATH
