#!/bin/bash
file=$*
myvar="$( set -f; printf "%s" $* )";
if [ "$file" != "$myvar" ]; then
  mv "$*" "$myvar" >&-
  file="$myvar"
fi
IFS='.' read -r -a RA <<< "$file"
if [ "${#RA[@]}" -gt 1 ]; then
  if [ "${RA[${#RA[@]}-1]}" == "apk" ]; then
     cc=${RA[${#RA[@]}-1]}
  fi
fi
if [[ ( "$cc" == "apk" && -f "$file" ) || ( -d "$file" ) ]] ; then
  if [ -d "$file" ]; then
    if [ ! -f "$file/apktool.yml" ]; then
      echo -en "\x1B[1;49;91mDirectory doesn't contain apktool.yml \x1B[0m \n"
      sleep 1
      exit
    fi
  fi
  SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
  IFS='/' read -ra ADDRX <<< "$SCRIPTPATH"
  ptd=$HOME
  while read USER; do IFS=':' read -ra ADDRY <<< "$USER"; done < $ptd/AutoAPKEditor/Config.txt
  noname="${ADDRY[${#ADDRY[@]} - 1]}"
  echo -en "\x1B[1;49;34mAutoName for Signing is set to $noname \x1B[0m\n"
  read -e -p "Function[d, b, s, p, AutoName{0/1}, help, quit]: " fun
  if [ "$fun" == "quit" ]; then
    exit
  fi
  if [ "$fun" == "help" ]; then
    echo -en "\x1B[1;49;34mCommand List: \x1B[0m \n\x1B[1;49;36md \x1B[0m \x1B[1;49;30m- Decompiles an APK [Provide any APK] \x1B[0m\n\x1B[1;49;36mb \x1B[0m \x1B[1;49;30m- Builds an APK [Provide Decompiled Folder] \x1B[0m\n\x1B[1;49;36ms \x1B[0m \x1B[1;49;30m- Signs an APK [Provide any APK] \x1B[0m\n\x1B[1;49;36mp \x1B[0m \x1B[1;49;30m- Builds & Signs and APK [Provide Decompiled Folder] \x1B[0m\n\x1B[1;49;36mAutoName \x1B[0m - \x1B[1;49;30mOption to Automatically get the perfect name for your signed apk, edit its value from $ptd/AutoAPKEditor/Config.txt\x1B[0m\n\x1B[1;49;35mUsage: \x1B[0m Autoname 1 or Autoname 0\n\x1B[1;49;35m!NOTE: \x1B[0m Only works if your game name is at the end\n\x1B[1;49;35mExample - \x1B[0mcom.mycompany.gamename, signed apk will be 'gamename'.apk\nif its com.mycompany.gamename.extra then your output apk will be named 'extra.apk'\n"
    sleep 3
    exit
  elif [ "$fun" == "AutoName 0" ]; then
    rm $ptd/AutoAPKEditor/Config.txt
    echo -en "\x1B[1;49;92mAutoName : Off \x1B[0m \n"
    echo 'AutoName :0' >"$ptd/AutoAPKEditor/Config.txt"
    sleep 1
    exit
  elif [ "$fun" == "AutoName 1" ]; then
    rm $ptd/AutoAPKEditor/Config.txt
    echo -en "\x1B[1;49;92mAutoName : On \x1B[0m \n"
    echo 'AutoName :1' >"$ptd/AutoAPKEditor/Config.txt"
    sleep 1
    exit
  else
      if [ "$fun" == "s" ] && [ "$cc" == "apk" ] ; then
        if [ "$noname" != "1" ]; then
          read -e -p "OutputName[No need to add .apk]: " name
        else
          IFS='.' read -ra ADDRXO <<< "$file"
          name="${ADDRXO[${#ADDRXO[@]} - 2]}"
        fi
        ex2=".apk"
        echo -en "\x1B[1;49;92mNow Signing! \x1B[0m \n"
        java -jar signapk.jar testkey.x509.pem testkey.pk8 $file $name$ex2
        echo -en "\x1B[1;49;92mSigning Successfull \x1B[0m \n"
      elif [ "$fun" == "d" ] && [ "$cc" == "apk" ] ; then
        IFS='/' read -ra ADDR <<< "$file"
        tbr=".apk"
        dir="/${ADDR[1]}/${ADDR[2]}/${ADDR[${#ADDR[@]} - 1]}"
        fdir="${dir//$tbr/}"
        if [ -d "$fdir" ]; then
          fun="d -f"
        fi
        if [ "$fun" == "d" ]; then
          echo -en "\x1B[1;49;92mNow Decompiling! \x1B[0m \n"
        fi
        if [ "$fun" == "d -f" ]; then
          echo -en "\x1B[1;49;92mNow Force Decompiling! \x1B[0m \n"
        fi
        apktool $fun $file
        if [ "$fun" == "d" ]; then
          echo -en "\x1B[1;49;92mDecompiling Successfull! \x1B[0m \n"
        fi
        if [ "$fun" == "d -f" ]; then
          echo -en "\x1B[1;49;92mForce Decompiling Successfull! \x1B[0m \n"
        fi
      elif [ "$fun" == "p" ] && [ "$cc" != "apk" ] ; then
        dist="/dist/"
        IFS='/' read -ra ADDR <<< "$file"
        filename=${ADDR[${#ADDR[@]} - 1]}
        ext=".apk"
        final=$file$dist$filename$ext
        if [ "$noname" != "1" ]; then
          read -e -p "OutputName[No need to add .apk]: " name2
        else
          IFS='.' read -ra ADDRO <<< "$filename"
          name2=${ADDRO[${#ADDRO[@]} - 1]}
        fi
        echo -en "\x1B[1;49;92mNow Building! \x1B[0m \n"
        apktool b $file
        echo -en "\x1B[1;49;92mBuilding Successfull! \x1B[0m \n"
        echo -en "\x1B[1;49;92mNow Signing! \x1B[0m \n"
        java -jar signapk.jar testkey.x509.pem testkey.pk8 $final $name2$ext
        echo -en "\x1B[1;49;92mSigning Successfull! \x1B[0m \n"
      elif [ "$fun" == "b" ] && [ "$cc" != "apk" ] ; then
          echo -en "\x1B[1;49;92mNow Building! \x1B[0m \n"
          apktool b $file
          echo -en "\x1B[1;49;92mBuilding Successfull! \x1B[0m \n"
      else
        if [ "$cc" == "apk" ]; then
          echo -en "\x1B[1;49;91mInvalid Function, choose between [d, s, AutoName{0/1}, help, quit] \x1B[0m \n"
          if [ "$fun" == "b" ] || [ "$fun" == "p" ] ; then
            echo -en "\x1B[1;49;91mCan't Build an APK File \x1B[0m \n"
          fi
        fi
        if [ "$cc" != "apk" ]; then
          echo -en "\x1B[1;49;91mInvalid Function, choose between [b, p, AutoName{0/1}, help, quit] \x1B[0m \n"
          if [ "$fun" == "d" ]; then
            echo -en "\x1B[1;49;91mCan't Decompile a Directory \x1B[0m \n"
          fi
          if [ "$fun" == "s" ]; then
            echo -en "\x1B[1;49;91mCan't Sign a Directory \x1B[0m \n"
          fi
        fi
      fi
  fi
else
  if [ "$file" == "" ]; then
    echo -en "\x1B[1;49;34mCommand List: \x1B[0m \n\x1B[1;49;36md \x1B[0m \x1B[1;49;30m- Decompiles an APK [Provide any APK] \x1B[0m\n\x1B[1;49;36mb \x1B[0m \x1B[1;49;30m- Builds an APK [Provide Decompiled Folder] \x1B[0m\n\x1B[1;49;36ms \x1B[0m \x1B[1;49;30m- Signs an APK [Provide any APK] \x1B[0m\n\x1B[1;49;36mp \x1B[0m \x1B[1;49;30m- Builds & Signs and APK [Provide Decompiled Folder] \x1B[0m\n\x1B[1;49;36mAutoName \x1B[0m - \x1B[1;49;30mOption to Automatically get the perfect name for your signed apk, edit its value from $ptd/AutoAPKEditor/Config.txt\x1B[0m\n\x1B[1;49;35mUsage: \x1B[0m Autoname 1 or Autoname 0\n\x1B[1;49;35m!NOTE: \x1B[0m Only works if your game name is at the end\n\x1B[1;49;35mExample - \x1B[0mcom.mycompany.gamename, signed apk will be 'gamename'.apk\nif its com.mycompany.gamename.extra then your output apk will be named 'extra.apk'\n"
    sleep 1
    exit
  fi
  echo -en "\x1B[1;49;91mInvalid Directory/File \x1B[0m \n"
  exit
fi
