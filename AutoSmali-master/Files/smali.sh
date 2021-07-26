#!/bin/bash
q=0
declare -a tbin
flile="${1//\\/}"
file="$flile/AndroidManifest.xml"
echo -en "\x1B[5;40;97mAutoSmali! ---> A tool by TheArmKing\x1B[0m\n"
if [ "$1" == "" ]; then
  echo -en "\n\x1B[1;49;36mUsage\x1B[0m - smali [decompiled folder]\n\nYou will then get to choose the code you want to copy, to make a new code paste it in a text file and move to \x1B[1;49;30m$HOME/AutoSmali\x1B[0m\n\nSome toasts require you to move a folder or image file, you can do that also, look at the SampleFolder in $HOME/AutoSmali, you must have a config.txt specifying the file/folder name, and the path\n\nIf any of your .txt code files or folder files dont appear in the select menu it could be 1 of the following reasons :-\n\n    1. the filename contains spaces\n    2. the specified filename ( in the config.txt ) doesnt exist\n\nIf you still have further doubts, contact me on \x1B[1;49;94mDiscord\x1B[0m. \x1B[7;49;32mTheArmKing#6647\x1B[0m\n\n"
  exit
fi
if [ -f "$file" ]; then
  unset options xfh
  unset zemo sem
  xdls="$(echo -en "\x1B[1;49;39mHelp\x1B[0m")"
  xdlsw="$(echo -en "\x1B[1;49;39mExit\x1B[0m")"
  while IFS= read -r -d $'\0' zps; do
    if [ -f "$zps" ] && [ ${zps: -4} == ".txt" ] && [ "$zps" == "${zps// /.}" ] ; then
      options[xfh++]="$zps"
      zemo[sem++]="$(echo -en "\x1B[1;49;36m$zps\x1B[0m")"
    fi
    if [ -d "$zps" ] && [ -f "$zps/config.txt" ] ; then
      IFS=':' read -r -a AR1 <<< "$(grep "OnCreateFile" $zps/config.txt)"
      IFS=':' read -r -a AR2 <<< "$(grep "FolderName" $zps/config.txt)"
      IFS=':' read -r -a AR3 <<< "$(grep "FileName" $zps/config.txt)"
      if [ -f "$zps/${AR1[1]}" ] && ([[ "${AR2[1]}" != "" && -d "$zps/${AR2[1]}" ]] || [ "${AR2[1]}" == "" ]) && ([[ "${AR3[1]}" != "" && -f "$zps/${AR3[1]}" ]] || [ "${AR2[3]}" == "" ]); then
        if [ "${AR1[1]}" == "${AR1[1]// /.}" ] && [ "${AR2[1]}" == "${AR2[1]// /.}" ] && [ "${AR3[1]}" == "${AR3[1]// /.}" ] ; then
          options[xfh++]="$zps"
          zemo[sem++]="$(echo -en "\x1B[1;49;34m$zps\x1B[0m")"
        fi
      fi
    fi
  done < <(find $HOME/AutoSmali -mindepth 1 -maxdepth 1 -print0)
  PS3="$(echo -en "\x1B[1;49;39mChoose a \x1B[0m"$(echo -e "\x1B[1;49;36mFile\x1B[0m")"/"$(echo -e "\x1B[1;49;34mFolder \x1B[0m")": ")"
  select zopt in "${zemo[@]}" "$xdls" "$xdlsw" ; do
    if [[ -n $zopt ]] && [ "$zopt" != "$xdls" ] && [ "$zopt" != "$xdlsw" ] ; then
        cop="$(expr $REPLY - 1)"
        opt="${options[cop]}"
        smeli="$opt"
        if [ -d "$opt" ]; then
          IFS=':' read -r -a AR1 <<< "$(grep "OnCreateFile" $opt/config.txt)"
          IFS=':' read -r -a AR2 <<< "$(grep "FolderName" $opt/config.txt)"
          IFS=':' read -r -a AR3 <<< "$(grep "FileName" $opt/config.txt)"
          smeli="$opt/${AR1[1]}"
          if [ "${AR2[1]}" != "" ]; then
            IFS=':' read -r -a AR4 <<< "$(grep "FolderPath" $opt/config.txt)"
            if [ -d "$flile/${AR4[1]}" ]; then
              cp -rf "$opt/${AR2[1]}" "$flile/${AR4[1]}"
              echo -en "\x1B[1;49;32mCopied Folder\x1B[0m \x1B[1;49;39m$opt/${AR2[1]}\x1B[0m \x1B[1;49;32mto\x1B[0m \x1B[1;49;39m$flile/${AR4[1]}\x1B[0m\n"
            else
              echo -en "\x1B[1;49;91mSpecified Path $flile/${AR4[1]} could not be found,\x1B[0m \x1B[1;49;32mMaking the directory ${AR4[1]} now\x1B[0m\n"
              ahs="${AR4[1]//\/\//\/}"
              cp -rf "$opt/${AR2[1]}" "$flile/${ahs}"
              echo -en "\x1B[1;49;32mCopied Folder\x1B[0m \x1B[1;49;39m$opt/${AR2[1]}\x1B[0m \x1B[1;49;32mto\x1B[0m \x1B[1;49;39m$flile/${ahs}\x1B[0m\n"
            fi
          fi
          if [ "${AR3[1]}" != "" ]; then
            IFS=':' read -r -a AR5 <<< "$(grep "FilePath" $opt/config.txt)"
            if [ -d "$flile/${AR5[1]}" ]; then
              cp -rf "$opt/${AR3[1]}" "$flile/${AR5[1]}"
              echo -en "\x1B[1;49;32mCopied File\x1B[0m \x1B[1;49;39m$opt/${AR3[1]}\x1B[0m \x1B[1;49;32mto\x1B[0m \x1B[1;49;39m$flile/${AR5[1]}\x1B[0m\n"
            else
              echo -en "\x1B[1;49;91mSpecified Path $flile/${AR5[1]} could not be found,\x1B[0m \x1B[1;49;32mMaking the directory ${AR5[1]} now\x1B[0m\n"
              ahsb="${AR4[1]//\/\//\/}"
              cp -rf "$opt/${AR3[1]}" "$flile/${ahsb}"
              echo -en "\x1B[1;49;32mCopied File\x1B[0m \x1B[1;49;39m$opt/${AR3[1]}\x1B[0m \x1B[1;49;32mto\x1B[0m \x1B[1;49;39m$flile/${ahsb}\x1B[0m\n"
            fi
          fi
        fi
        break
    elif [ "$zopt" == "$xdlsw" ]; then
        echo -en "\x1B[5;49;91mYou Chose to Exit\x1B[0m\n"
        exit
    elif [ "$zopt" == "$xdls" ]; then
        echo -en "\n\x1B[1;49;36mUsage\x1B[0m - smali [decompiled folder]\n\nYou will then get to choose the code you want to copy, to make a new code paste it in a text file and move to \x1B[1;49;30m$HOME/AutoSmali\x1B[0m\n\nSome toasts require you to move a folder or image file, you can do that also, look at the SampleFolder in $HOME/AutoSmali, you must have a config.txt specifying the file/folder name, and the path\n\nIf any of your .txt code files or folder files dont appear in the select menu it could be 1 of the following reasons :-\n\n    1. the filename contains spaces\n    2. the specified filename ( in the config.txt ) doesnt exist\n\nIf you still have further doubts, contact me on \x1B[1;49;94mDiscord\x1B[0m. \x1B[7;49;32mTheArmKing#6647\x1B[0m\n\n"
    else
        echo -en "\x1B[1;49;91mInvalid Option!\x1B[0m\n"
    fi
  done
  mkdir /tmp/AutoSmali
  cp "$file" /tmp/AutoSmali/File.xml
  b="$(grep -n "android.intent.category.LAUNCHER" /tmp/AutoSmali/File.xml | cut -f1 -d:)"
  c="$(expr $b + 1)"
  head -n $c /tmp/AutoSmali/File.xml >/tmp/AutoSmali/foo.txt
  f="$(awk '/activity/{k=$0}END{print k}' /tmp/AutoSmali/foo.txt)"
  echo $f >> /tmp/AutoSmali/xrap.xml
  echo "</activity>" >> /tmp/AutoSmali/xrap.xml
  sed -i -e 's/android:/d/g' /tmp/AutoSmali/xrap.xml
  h="$(xmllint --xpath "string(//activity/@dname)" /tmp/AutoSmali/xrap.xml)"
  sleep 0.2
  mkdir /tmp/Indent
  awk '{$1=$1};1' "$smeli" >/tmp/Indent/file.txt
  sed  's/^/    /'  /tmp/Indent/file.txt > /tmp/Indent/final.txt
  mv /tmp/Indent/final.txt "$smeli"
  rm -r /tmp/Indent
  echo -en "\x1B[1;49;32mFormatted Text File!\x1B[0m\n"
  bar="${h//.//}"
  cd "$flile"
  k="$(ls -d smali*)"
  a=0
  declare -a Smal
  for word in $k
  do
    Smal[$a]="$word"
    ((a=a+1))
  done
  for var in "${Smal[@]}"
  do
    if [ -f "$flile/${var}/$bar.smali" ]; then
      swar="$var"
      echo -en "\x1B[1;49;32mFound Main Smali File @ \x1B[0m\x1B[1;49;39m$flile/${var}/$bar.smali\x1B[0m\n"
      m="$flile/${var}/$bar.smali"
      cp "$flile/${var}/$bar.smali" "/tmp/AutoSmali/wtf.txt"
    fi
  done
  n="$(grep ".method" "$m" | grep "onCreate(Landroid/os/Bundle;)V")"
  d=$(grep -n "$n" "/tmp/AutoSmali/wtf.txt" | cut -f1 -d:)
  e="$(expr $d + 1)"
  g="$(tail -n +$e /tmp/AutoSmali/wtf.txt | grep -n -m 1 ".locals" | cut -f1 -d:)"
  i="$(expr $d + $g)"
  ed -s /tmp/AutoSmali/wtf.txt <<< "${i}r "$smeli""$'\nw'
  cp -rf "/tmp/AutoSmali/wtf.txt" "$flile/${swar}/$bar.smali"
  echo -en "\x1B[1;49;32mCopied Contents of \x1B[0m\x1B[1;49;39m$smeli \x1B[0m\x1B[1;49;32mto the Main Smali File @line:\x1B[0m\x1B[1;49;39m$i\x1B[0m\n"
  rm -r /tmp/AutoSmali
fi
