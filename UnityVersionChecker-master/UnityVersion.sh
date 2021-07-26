#!/bin/bash
abac="$BASH_VERSION"
IFS='.' read -r -a ARY <<< "$abac"
if [ "${ARY[0]}" -lt "4" ]; then
  esc="\x1B"
else
  esc="\e"
fi
thdpl(){
  echo -en "${esc}[1;49;96m==>${esc}[0m ${esc}[1m${1}...${esc}[0m\n"
}
prever(){
  abc="$(xxd -p -s 16 -l 16 "$1" | xxd -r -p)"
  abc="${abc// /}"
  thdpl "Your UnityVersion is "$abc""
}
zippidy(){
  unzip -p "$1" "$2" > "/tmp/j2vj2nl1moi3p1p"
  prever "/tmp/j2vj2nl1moi3p1p"
  rm "/tmp/j2vj2nl1moi3p1p"
}
if [ "$1" == "" ]; then read -p "File Path: " pat; else pat="$1"; fi
if [ ! -f "$pat" ]; then thdpl "File doesn't exist" && exit; fi
exion="$(echo "$pat" | tail -c 5)"
if [ "$exion" == ".apk" ]; then
  thdpl "APK Detected"
  teder="$(unzip -l "$pat" | grep "assets/bin/Data/Resources/unity_builtin_extra")"
  if [ "$teder" == "" ]; then
    teder="$(unzip -l "$pat" | grep "assets/bin/Data/unity default resources")"
    if [ "$teder" == "" ]; then
      thdpl "unity_builtin_extra or unity default resources not found!"
      exit
    else
      aqw="assets/bin/Data/unity\ default\ resources"
    fi
  else
    aqw="assets/bin/Data/Resources/unity_builtin_extra"
  fi
  zippidy "$pat" "$aqw"
elif [ "$exion" == ".ipa" ]; then
  thdpl "IPA Detected"
  spend="$(unzip -l "$pat" | grep "Data/Resources/unity_builtin_extra" | awk -F " " '{print $4}')"
  if [ "$spend" == "" ]; then
    thdpl "Payload/*/Data/Resources/unity_builtin_extra not found"
    exit
  fi
  zippidy "$pat" "$spend"
else
  thdpl "Single File Detected"
  prever "$pat"
fi
