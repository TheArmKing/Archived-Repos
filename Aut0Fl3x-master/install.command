#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
mkdir $HOME/Aut0Fl3x
echo "AlwaysPack:0 // Always Auto Build the IPA" >> "$HOME/Aut0Fl3x/config.txt"
echo "AutoName:0 // Match the Tweak.xm Name with the Folder Name and Copy Automatically!" >> "$HOME/Aut0Fl3x/config.txt" 
if [ ! -f "/opt/theos/bin/nic.pl" ]; then echo -en "\x1B[0;49;91mTheos Not Found\x1B[0m at /opt/theos/bin/nic.pl!\nInstall from https://github.com/theos/theos/wiki/Installation-macOS\n"; fi
if [ ! -d "$HOME/theos-jailed" ]; then echo -en "\x1B[0;49;91mTheos Jailed Not Found\x1B[0m at $HOME/theos-jailed!\nInstall from https://github.com/kabiroberai/theos-jailed/wiki/Installation\n"; fi
unzip $SCRIPTPATH/Aut0Fl3x.app.zip
mv $HOME/Aut0Fl3x.app $HOME/Aut0Fl3x/Aut0Fl3x.app
cat <<EOF > /usr/local/bin/AutoFlex.sh
#!/bin/bash
if [ ! -d "\$HOME/Aut0Fl3x" ]; then echo -en "\x1B[0;49;91mNo Aut0Fl3x Found!\x1B[0m Running Setup!\n" && mkdir "\$HOME/Aut0Fl3x" && echo "AlwaysPack:0 // Always Auto Build the IPA" >> "\$HOME/Aut0Fl3x/config.txt" && echo "AutoName:0 // Match the Tweak.xm Name with the Folder Name and Copy Automatically!" >> "\$HOME/Aut0Fl3x/config.txt" && exit; fi
if [ ! -f "/opt/theos/bin/nic.pl" ]; then echo -en "\x1B[0;49;91mTheos Not Found\x1B[0m at /opt/theos/bin/nic.pl!\n" && exit; fi
mnk="\$(find \$HOME/Aut0Fl3x -type f -maxdepth 1 -mindepth 1 -name '*.xm')"
if [ "\$mnk" == "" ]; then echo -en "\x1B[0;49;91mNo Tweak.xm Files Found\x1B[0m in \$HOME/Aut0Fl3x\n" && exit; fi
PS3="Choose : "
IFS=\$'\n' read -rd '' -a aro <<< "\$mnk"
func(){
  PS3="Choose a .xm File : "
  select jj in "\${aro[@]}"; do
    if [ -n "\$jj" ]; then
      jjk="\$jj"
      break
    else
      echo -en "\x1B[0;49;91mInvalid Option!\x1B[0m\n"
    fi
  done
}
ulta(){
  if [ "\$1" == "1" ]; then ult=0;
  else ult=1; fi
}
config(){
  local nfs=0
  while (( !nfs )); do
    local fre=()
    local namee="\$(tail -n +2 \$HOME/Aut0Fl3x/config.txt | head -n1)"
    local nu="\$(echo "\$namee" | awk 'gsub(/.*AutoName:| \/\/.*/,"")')"
    local pek="\$(tail -n +1 \$HOME/Aut0Fl3x/config.txt | head -n1)"
    local nup="\$(echo "\$pek" | awk 'gsub(/.*AlwaysPack:| \/\/.*/,"")')"
    ulta "\$nup"
    fre+=( "AlwaysPack is Set to \$nup! Set to \$ult?" )
    ulta "\$nu"
    fre+=( "AutoName is Set to \$nu! Set to \$ult?" )
    PS3="Choose : "
    select ias in "\${fre[@]}" "Back"; do
      if [ -n "\$ias" ]; then
        if [ "\$ias" == "Back" ]; then nfs=1 && break; fi
        jenk="\$(echo "\$ias" | awk 'gsub(/.* Set to |\?.*/,"")')"
        if [ "\$REPLY" == "1" ]; then sed -i -e "s/AlwaysPack:\${nup}/AlwaysPack:\${jenk}/g" \$HOME/Aut0Fl3x/config.txt;
      elif [ "\$REPLY" == "2" ]; then sed -i -e "s/AutoName:\${nu}/AutoName:\${jenk}/g" \$HOME/Aut0Fl3x/config.txt; fi
        if [ -f "\$HOME/Aut0Fl3x/config.txt-e" ]; then rm "\$HOME/Aut0Fl3x/config.txt-e"; fi
        echo -en "\x1B[0;49;92mDone!\x1B[0m\n"
        break
      else echo -en "\x1B[0;49;91mInvalid Option!\x1B[0m\n"
      fi

    done
  done
}
xdjs=0
while (( !xdjs )); do
  select df in "Make New Instance" "Configure Options" "Help" "Quit"; do
    if [ -n "\$df" ]; then
      if [ "\$REPLY" == "1" ]; then
        /opt/theos/bin/nic.pl
        k="\$(ls -td -- */ | head -n1)"
        echo -en "\x1B[1;49;30mTweak Folder - \$HOME/\$k\x1B[0m\n"
        te="Tweak.xm"
        kp="makefile"
        ler="\$HOME/\$k\$te"
        if [ -f "\$HOME/\$k\$kp" ]; then jkw="\$(grep "_IPA = " \$HOME/\$k\$kp)"; fi
        if [ ! -f "\$ler" ] || [ "\$jkw" == "" ]; then echo -en "\x1B[0;49;91mSeems like a Jailed Tweak wasnt found!\x1B[0m, either the Tweak.xm is missing or the makefile doesnt contain an IPA Path!\n" && exit; fi
        namee="\$(tail -n +2 \$HOME/Aut0Fl3x/config.txt | head -n1)"
        nu="\$(echo "\$namee" | awk 'gsub(/.*AutoName:| \/\/.*/,"")')"
        if [ "\$nu" == "1" ]; then
          for lo in "\${aro[@]}"; do
            ipo="\$(echo \$lo | awk 'gsub(/.*Aut0Fl3x\/|\.xm.*/,"")')"
            flk="\$(echo "\$ipo" | tr '[:upper:]' '[:lower:]')"
            if [ "\$HOME/\$k" == "\$HOME/\$flk/" ]; then
              jjk="\$lo"
            fi
          done
          if [ "\$jjk" == "" ]; then echo -en "\x1B[0;49;92mAutoName is on\x1B[0m but \x1B[0;49;91mno Folder was found!\x1B[0m Choose Manually Instead\n" && func;
        else echo -en "\x1B[0;49;92mFound!\x1B[0m\n"; fi
        else echo -en "\x1B[0;49;91mAutoName is Off\x1B[0m, Choose a Tweak.xm Manually!\n" && func; fi
        rm "\$ler"
        cp "\$jjk" "\$ler"
        echo -en "\x1B[0;49;92mFile Moved!\x1B[0m\n"
        pek="\$(tail -n +1 \$HOME/Aut0Fl3x/config.txt | head -n1)"
        nup="\$(echo "\$pek" | awk 'gsub(/.*AlwaysPack:| \/\/.*/,"")')"
        if [ "\$nup" == "1" ]; then echo -en "\x1B[0;49;92mAuto Packing!\x1B[0m\n" && cd "\$HOME/\$k" && make package CODESIGN_IPA=0 && echo -en "\x1B[0;49;92mDone!\x1B[0m\n";
        else
          nfc=0
          while (( !nfc )); do
            read -e -p "AlwaysPack is Off! Make IPA? [y/n]: " cho
            if [ "\$cho" == "y" ]; then fd=1 && nfc=1
            elif [ "\$cho" == "n" ]; then fd=0 && nfc=1
            else echo -en "\x1B[0;49;91mInvalid Option!\x1B[0m\n"
            fi
          done
          if [ "\$fd" -eq "1" ]; then
            cd "\$HOME/\$k"
            make package CODESIGN_IPA=0
            echo -en "\x1B[0;49;92mDone!\x1B[0m\n"
          else
            echo -en "\x1B[0;49;92mDone!\x1B[0m\n"
          fi
        fi
        xdjs=1
        break
      elif [ "\$REPLY" == "2" ]; then config && break;
    elif [ "\$REPLY" == "3" ]; then echo -en "\x1B[5;40;97mAut0Fl3x -> A tool by TheArmKing\x1B[0m\n\n\x1B[1;49;30mUsage:\x1B[0m \x1B[1;49;32mSimply\x1B[0m call the script by either\n1)AutoFlex.sh\n2)FlJail\n3)Open the App in \"\$HOME/Aut0Fl3x/\" \n\n\x1B[1;49;31mFunctionality\x1B[0m - This script simply invokes thoes, checks if a jailed tweak has been made, and copies your tweak.xm code into it! \n\n\x1B[1;49;31mAuto Features\x1B[0m: 1)AlwaysPack 2)AutoName (Use Configure Options)\n1)AlwaysPack - When the Tweak.xm is moved, it Automatically makes the package! \n2)AutoName - To make the process even faster, simple keep your project name same as its tweak.xm name, the tool will detect the same name of the files and folder and Auto-Copy! \n\n\x1B[1;49;91mStill have doubts?\x1B[0m \x1B[1;49;34mContact me on Discord:\x1B[0m \x1B[7;49;39mTheArmKing#6647\x1B[0m\n" && sleep 2 && break;
      elif [ "\$REPLY" == "4" ]; then exit; fi
    else
      echo -en "\x1B[0;49;91mInvalid Option!\x1B[0m\n"
      break
    fi
  done
done
EOF
chmod +x /usr/local/bin/AutoFlex.sh
ln -s /usr/local/bin/AutoFlex.sh /usr/local/bin/FlJail
rm -rf $SCIPTPATH
if [ -d "$HOME/__MACOSX" ]; then rm -rf "$HOME/__MACOSX"; fi
echo -en "\x1B[1;49;92mDone!\x1B[0m\n"
