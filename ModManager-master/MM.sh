#!/bin/bash
declare -a tar
declare -a kar
get_id()
{
  webadd="$(xmllint --xpath "string(/MM/app[name=\"$1\"]/web)" $HOME/Library/ModManager/Main.xml)"
  idee="$(xmllint --xpath "string(/MM/app[.//name = \"$1\"]/@id)" $HOME/Library/ModManager/Main.xml)"
}
update_vers()
{
    if [ "$2" != "A4F" ]; then
      if [ "$2" == "" ]; then
        abc="$(curl -s "https://play.google.com/store/apps/details?id=$1")"
        ken="$(echo "$abc" | grep '<h1 class="AHFaub" itemprop="name">')"
        nem="$(echo "$ken" | awk 'gsub(/.*<span >|<\/span>.*/,"")')"
        len="$(echo "$abc" | grep 'Current Version')"
        vers="$(echo "$len" | awk 'gsub(/.*Current Version<\/div><span class="htlgb"><div><span class="htlgb">|<\/span>.*/,"")')"
      else
        abcd="$(curl -s "https://play.google.com/store/apps/details?id=$1" | grep 'Current Version')"
        vers="$(echo "$abcd" | awk 'gsub(/.*Current Version<\/div><span class="htlgb"><div><span class="htlgb">|<\/span>.*/,"")')"
        wbe="PS"
      fi
    fi
    if [ "$vers" == "Varies with Device" ] || [ "$2" == "A4F" ] ; then
      abcde="$(curl -s https://www.apk4fun.com/games/$1/ | grep "Latest Version:")"
      vers="$(echo "$abcde" | awk 'gsub(/.*">|<\/a>.*/,"")')"
      wbe="A4F"
    fi
}
make_list()
{
  xf="$(xml sel -t -m "//MM/app/name" -v "." -n $HOME/Library/ModManager/Main.xml)"
  xfh="$(xml sel -t -m "//MM/app/mversion" -v "." -n $HOME/Library/ModManager/Main.xml)"
  xfhe="$(xml sel -t -m "//MM/app/cversion" -v "." -n $HOME/Library/ModManager/Main.xml)"
  IFS=$'\n' read -rd '' -a ary <<< "$xf"
  IFS=$'\n' read -rd '' -a ary2 <<< "$xfh"
  IFS=$'\n' read -rd '' -a ary3 <<< "$xfhe"
  lgh=${#ary[@]}
    for (( i=0; i<$lgh; i++ ))
    do
      if [ "$1" == "NV" ] && [ "$2" != "S" ] ; then
        echo "$(expr $i + 1)) ${ary[i]}"
      elif [ $1 == "WV" ] && [ "$2" != "S" ] && [ "$2" != "M" ] ; then
        echo "$(expr $i + 1)) ${ary[i]} - ${ary2[i]}"
      elif [ $1 == "WV" ] && [ "$2" == "S" ] ; then
        tar[$i]="${ary[i]} - ${ary2[i]}"
      elif [ $1 == "WV" ] && [ "$2" == "M" ] ; then
        if [ "${ary2[i]}" != "${ary3[i]}" ]; then
          mess="$(echo -en "\x1B[5;49;91mOutdated!\x1B[0m New version is \x1B[1;49;39m${ary3[i]}\x1B[0m")"
        else
          mess="$(echo -en "\x1B[0;49;32mUp To Date!\x1B[0m")"
        fi
        kar[$i]="${ary[i]} - ${ary2[i]} | $mess"
      fi
    done
}
if [ ! -d "$HOME/Library/ModManager" ]; then
  mkdir "$HOME/Library/ModManager"
fi
if [ ! -f "$HOME/Library/ModManager/Main.xml" ]; then
  echo "<MM>" >> "$HOME/Library/ModManager/Main.xml"
  echo "<time>Never</time>" >> "$HOME/Library/ModManager/Main.xml"
  echo "</MM>" >> "$HOME/Library/ModManager/Main.xml"
fi
clear
all=0
while (( !all  )); do
  echo -en "\x1B[5;40;97m ModManager --> a Tool by TheArmKing! \x1B[0m\n"
  echo
  PS3="$(echo -en "\nChoose an Option: ")"
  select opt in "Update List" "Change Entry" "Help" "Quit" ; do
    if [[ -n $opt ]] ; then
      clear
      if [ "$opt" == "Update List" ]; then
        jkr=0
        while (( !jkr )); do
          lm="$(xmllint --xpath "string(/MM/time)" $HOME/Library/ModManager/Main.xml)"
          echo -en "\nLast Updated: $lm\n"
          make_list WV M
          PS3="$(echo -en "\nChoose an ID: " )"
          select woft in "${kar[@]}" "All" "Go Back" ; do
            if [[ -n "$woft" ]]; then
              clear
            fi
            if [[ -n "$woft" ]] && [ "$woft" != "Go Back" ] && [ "$woft" != "All" ]; then
              mcii="$(expr $REPLY - 1)"
              holi="${ary[mcii]}"
              get_id "$holi"
              update_vers "$idee" "$webadd"
              echo -e "cd /MM/app[name=\"$holi\"]/cversion\nset $vers\nsave" | xmllint --shell $HOME/Library/ModManager/Main.xml >&-
              tem="$(date)"
              echo -e "cd /MM/time\nset $tem\nsave" | xmllint --shell $HOME/Library/ModManager/Main.xml >&-
              break
            elif [ "$woft" == "Go Back" ]; then
              jkr=1
              break
            elif [ "$woft" == "All" ]; then
              lgh=${#kar[@]}
              jp="$(echo "1.9 * $lgh" | bc)"
              uoc=0
              while (( !uoc ));
              do
                read -e -p "Are You Sure? It will take around $lgh.0~$jp seconds! (y/n): " yna
                if [ "$yna" == "y" ]; then
                  for var in "${ary[@]}"
                  do
                    get_id "$var"
                    update_vers "$idee" "$webadd"
                    echo -e "cd /MM/app[name=\"$var\"]/cversion\nset $vers\nsave" | xmllint --shell $HOME/Library/ModManager/Main.xml >&-
                  done
                  tem="$(date)"
                  echo -e "cd /MM/time\nset $tem\nsave" | xmllint --shell $HOME/Library/ModManager/Main.xml >&-
                  uoc=1
                elif [ "$yna" != "n" ]; then
                  echo -en "\n\x1B[5;49;91mInvalid Choice\x1b[0m\n"
                else
                  uoc=1
                fi
              done
              break
            else
              echo -en "\n\x1B[5;49;91mInvalid Choice\x1b[0m\n"
              break
            fi
          done
        done
        break
      elif [ "$opt" == "Change Entry" ]; then
        mdj=0
        while (( !mdj )); do
          clear
          echo
          PS3="$(echo -en "\nAdd/Remove/Update? : ")"
          select bopt in "Add Entry" "Remove Entry" "Update Entry" "Back" ; do
            if [[ -n $bopt ]] ; then
              clear
              if [ "$bopt" == "Add Entry" ]; then
                echo
                echo "Current List:"
                make_list NV
                exd=0
                while (( !exd )); do
                  read -e -p "Bundle ID[type 'quit' to go back] " id
                  if [ "$id" == "quit" ]; then
                    exd=1
                  fi
                  zeb="$(grep "<app id=\"$id\">" $HOME/Library/ModManager/Main.xml)"
                  if [ "$zeb" == "" ] && [ "$exd" -eq 0 ]; then
                    if curl --output /dev/null --silent --head --fail "https://play.google.com/store/apps/details?id=$id"; then
                      update_vers "$id"
                      echo "<app id=\"$id\">" >> /tmp/prep.txt
                      echo "<name>$nem</name>" >> /tmp/prep.txt
                      echo "<mversion>$vers</mversion>" >> /tmp/prep.txt
                      echo "<cversion>$vers</cversion>" >> /tmp/prep.txt
                      echo "<web>$wbe</web>" >> /tmp/prep.txt
                      echo "</app>" >> /tmp/prep.txt
                      lmn="$(grep "</MM>" $HOME/Library/ModManager/Main.xml | cut -f1 -d:)"
                      xdsg="$(expr $lem -1)"
                      ed -s $HOME/Library/ModManager/Main.xml <<< "${xdsg}r "/tmp/prep.txt""$'\nw'
                      rm /tmp/prep.txt
                      clear
                      echo "Updated List:"
                      make_list NV
                    else
                      echo "Invalid Bundle ID"
                    fi
                  elif [ "$exd" -eq 0 ]; then
                    echo ALREDY
                  fi
                done
                break
              elif [ "$bopt" == "Remove Entry" ]; then
                ois=0
                while (( !ois )); do
                  echo
                  lmfg="$(xml sel -t -m "/MM/app/name" -v "." -n $HOME/Library/ModManager/Main.xml)"
                  IFS=$'\n' read -rd '' -a alist <<< "$lmfg"
                  PS3="$(echo -en "\nChoose an ID: ")"
                  select rekt in "${alist[@]}" "Go Back" ; do
                    if [[ -n "$rekt" ]]; then
                      clear
                    fi
                    if [[ -n "$rekt" ]] && [ "$rekt" != "Go Back" ] ; then
                      ask="$(xmllint --xpath "string(/MM/app[.//name = \"$rekt\"]/@id)" $HOME/Library/ModManager/Main.xml)"
                      xmlstarlet ed -d "/MM/app[@id=\"$ask\"]" $HOME/Library/ModManager/Main.xml > /tmp/foo.xml
                      rm $HOME/Library/ModManager/Main.xml
                      mv /tmp/foo.xml $HOME/Library/ModManager/Main.xml
                      break
                    elif [ "$rekt" == "Go Back" ]; then
                      ois=1
                      break
                    else
                      echo -en "\n\x1B[5;49;91mInvalid Choice\x1b[0m\n"
                      break
                    fi
                  done
                done
                break
              elif [ "$bopt" == "Update Entry" ]; then
                rto=0
                while (( !rto )); do
                  echo
                  make_list WV S
                  PS3="$(echo -en "\nChoose an ID: ")"
                  select rokt in "${tar[@]}" "Go Back" ; do
                    if [[ -n "$rokt" ]]; then
                      clear
                    fi
                    if [[ -n "$rokt" ]] && [ "$rokt" != "Go Back" ] ; then
                      mci="$(expr $REPLY - 1)"
                      hol="${ary[mci]}"
                      get_id "$hol"
                      update_vers "$idee" "$webadd"
                      echo -e "cd /MM/app[name=\"$hol\"]/mversion\nset $vers\nsave" | xmllint --shell $HOME/Library/ModManager/Main.xml >&-
                      echo -e "cd /MM/app[name=\"$hol\"]/cversion\nset $vers\nsave" | xmllint --shell $HOME/Library/ModManager/Main.xml >&-
                      echo -en "\n\x1B[0;49;32mUpdated List\x1B[0m\n"
                      break
                    elif [ "$rokt" == "Go Back" ]; then
                      rto=1
                      break
                    else
                      echo -en "\n\x1B[5;49;91mInvalid Choice\x1b[0m\n"
                      break
                    fi
                  done
                done
                break
              elif [[ "$bopt" == "Back" ]]; then
                mdj=1
                break
              fi
            else
              echo -en "\n\x1B[5;49;91mInvalid Choice\x1b[0m\n"
            fi
          done
        done
        break
      elif [ "$opt" == "Help" ]; then
        echo -en "\n\x1B[1;49;94mHow to invoke\x1B[0m: ModManager, MM.sh, AndroidM, or open the ModManager.app\n\n\x1B[1;49;94mUsage\x1B[0m:-\n\x1B[1;49;39mUpdate List\x1B[0m - Check for the current Play Store version of the App\n\x1B[1;49;39mChange Entry\x1B[0m - You can either add/remove/update a game in your list\n\x1B[1;49;39mAdd Entry\x1B[0m - Add a game that you hacked to your list, enter its bundle ID\n\x1B[1;49;39mRemove Entry\x1B[0m - if you are discontinuing support for a game and dont want it in the list anymore\n\x1B[1;49;39mUpdate Entry\x1B[0m - When you update the Game Mod, you this option so that the list records the Mod is up to date\n\n"
        break
      elif [ "$opt" == "Quit" ]; then
        exit
      fi
    else
      echo -en "\n\x1B[5;49;91mInvalid Choice\x1b[0m\n"
    fi
  done
done
