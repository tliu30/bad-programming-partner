#!/bin/bash

good=$(cat <<'EOF'


            .. ..
           :-.    ..
         ..        ...
                    ...
        .      .   +*=..
        . ..-=-.  .+:-..
       ...-. .... .*#-:..
       ..      .. :+. ..:
     ....     ... :+   .-+.
     ......:-. .-:++....:=:
      ..          ..... .-
                     ....-
                     ....:
      ..              ...-.
      ...             ..:-:
      ...... ..........:===:
  @=   ...:...........-=====-.
EOF
)

decent=$(cat << 'EOF'
:+=:                   .:=+#%@@%@@@
..                      -*%@@@@@@@@
                        +#%@@@@@@@@
            -@@@@@@@@    -@@@@@@@@@
       :  @@@@@@@@@@@@@#.  @@@@@@@@
      .==@@@@@@@@@@@@@@@#   @@@@@@@
      . @@@@@@@@@@@@@@@@.    #%#%%%
        @@@@@@%%@@@@@@=       #####
        =#:      =@@@         %@%##
               .=-@@*         .##*#
              ==*@@@=          =***
      :+:       +@@@#          =##*
  # - +@@@@@@@@@@%@@@          .##*
 :=@-+*@@@@@@@#%@@@@=           ###
  @@-%*@@@@@=+@@%-              *##
   @@*@@@@@#@@@@@@@%-           .#*
     *@@@@@@@#%@@@@@=-.          #*
     +%@@@@@@@@@@@@@@@*  .@:     :+
      *@@@@@@@@@@@@@@@@-          =
      :#@@@@@@@@@@@@@@@%=         -
       -%@@@@@@@@@@@@@@@.
         *@@@@@@@@@@@@+
    .=
  @@#=-
EOF
)

bad=$(cat << 'EOF'

         @@@@@@@@@@@@@@@@@
        @@@@@@@@@@@@@@@@@@
        =@@@@+      @@@.
                     @@
              =      @@@
              *@@*    @@
   =       %@@#        .
       :@@@@   *@:  @@@#
  %=.* @@@@. * %@:
  #+   =@@
  #+@    .  .%:.
        @%=@.@@@@@@@
        @@@@@= -@@@@          =



EOF
)

fatal=$(cat << 'EOF'
   =*:.:=+. .-*: :==.:-
     :**=    ++  .    .. .:............
      -=. .::::::::...............     ..
      =---:.      .....      ..............
                   ....              ......
                   ...                 .....
                    ::                ....
   .+-*+=:::=-      ..:-   .-=:. .::......   ..
         :::        .:.:      .:...............
                     ....      ................
                      ..:-      .....::.......
                               ............:.:
                           -:          .....:
                                         .:-
                 ==--:         .   . .. :::.
                  .:.....:::..:::.......:-:
                 :-.  ..   ...............
                         ........       ..
                  :........ .. ..       ..
                 .-. ..    .           .:.
                        ..... .......  .




EOF
)

slowecho() {
    IN_STRING=$1
    RATE=$2

    LEN=${#IN_STRING}

    for ((i = 0; i < LEN; i++)); do
        echo -n "${IN_STRING:i:1}"
        sleep $RATE
    done

    echo -ne "\n"
}

getPrompt() {
    SEVERITIES=$1
    FOUND=0

    if [ -z "$SEVERITIES" ]; then
        echo -e "\e[32mLet's get coding! \e[0m"
        FOUND=1
    else
        if [ $(echo "$SEVERITIES" | jq .warning) != "null" ]; then
            ms[0]="\e[33mThere was a warning ... watch out buddy! \e[0m"
            ms[1]="\e[33mBad job! You suck ... \e[0m"
            ms[2]="\e[33mBe careful there hon ... \e[0m"
            ms[3]="\e[33mThat's a warning ... you better be careful ...\e[0m"
            ms[4]="\e[33mWoah ... you better be careful there hotshot!\e[0m"
            ms[5]="\e[33mTry to write better code please? Please?\e[0m"

            echo -e ${ms[$(( RANDOM % ${#ms[@]} ))]}
            FOUND=1
        fi

        if [ $(echo "$SEVERITIES" | jq .error) != "null" ]; then
            ms2[0]="\e[31mError?! Try to write better code, fool ...\e[0m"
            ms2[1]="\e[31mMaybe ask for a refund from your cs-school?\e[0m"
            ms2[2]="\e[31mMy two year old can program better than you, idiot!\e[0m"
            ms2[3]="\e[31mCan you do me a favor and throw me into a big burning fire?\e[0m"
            echo -e ${ms2[$(( RANDOM % ${#ms2[@]} ))]}
            FOUND=1
        fi
    fi

    if [ $FOUND -ne 1 ]; then
        ms3[0]="Let's get coding!"
        ms3[1]="Let's make some shit!"
        ms3[2]="Yeah ... make use of my processor(s) ... "
        echo ${ms3[$(( RANDOM % ${#ms3[@]} ))]}
        # echo "Let's get coding! "
    fi
}

getFace() {
    SEVERITIES=$1
    FOUND=0
    FACE=""

    if [ -z "$SEVERITIES" ]; then
        FACE="$good"
        FOUND=1
    else
        if [ $(echo "$SEVERITIES" | jq .warning) != "null" ]; then
            FACE="$bad"
            FOUND=1
        fi

        if [ $(echo "$SEVERITIES" | jq .error) != "null" ]; then
            FACE="$fatal"
            FOUND=1
        fi
    fi

    if [ $FOUND -ne 1 ]; then
        FACE="$good"
    fi

    slowecho "$FACE" 0.0001
}


getRandomFromArray() {
    my_array=$1
    echo ${my_array[$((RANDOM % ${#my_array[@]}))]}
}

getSoundbite() {
    SEVERITIES=$1
    FOUND=0
    MSG=$2

    if [ -z "$SEVERITIES" ]; then
        VOICE="Good News"
        RATE=100
        FOUND=1
    else
        if [ $(echo "$SEVERITIES" | jq .warning) != "null" ]; then
            VOICE="Bad News"
            RATE=100
            FOUND=1
        fi

        if [ $(echo "$SEVERITIES" | jq .error) != "null" ]; then
            VOICE="Trinoids"
            RATE=100
            FOUND=1
        fi
    fi

    if [ $FOUND -ne 1 ]; then
        VOICE="Good News"
        RATE=100
    fi

    (say -v "$VOICE" -r "$RATE" "$MSG" &)
}

getMaxLen() {
    local FNAME=$1

    local max=0
    while read -r line; do
        local cur_ct=$(( $(echo -n "$line" | wc -m ) ))
        if [ $cur_ct -gt $max ]; then
            max=$cur_ct
        fi
    done < $FNAME

    echo $max
}

repeatChar() {
    local input="$1"
    local count="$2"
    printf -v myString '%*s' "$count"
    printf '%s\n' "${myString// /$input}"
}

padString() {
    local S=$1
    local N=$(( $2 ))

    local cur_ct=$(( $(echo -n "$S" | wc -m) ))

    spaces=$(repeatChar " " $(( N - cur_ct )))

    echo -n "$S $spaces"
}

attachSeveritiesToLines() {
    local FNAME=$1
    local SEVERITIES=$2

    local paddedLength=$(( $(getMaxLen $FNAME) ))

    local line_ix=0
    local big_str=""
    while read -r line; do
        line_ix=$((line_ix + 1))
        local annotation=$(echo "$SEVERITIES" | jq ".\"$line_ix\"")
        local padded=$(padString "$line" "$paddedLength")

        if [ "$annotation" != "null" ]; then
            big_str="$big_str$padded  // $annotation\n"
        else
            big_str="$big_str$padded\n"
        fi
    done < $FNAME

    echo -e "$big_str"
}


testFun() {
    FNAME=$1
    rm -f $FNAME

    clear
    echo "Your file starts here ->"
    echo ""

    PROMPT=$(getPrompt)

    while :
    do
        # IFS= read -rp "$PROMPT" userInput
        slowecho "$PROMPT" 0.01
        IFS= read -rp ">>> " userInput

        clear

        if [ "$userInput" = "/quit" ]; then
            break
        fi

        echo "$userInput" >> $FNAME



        lintOutput=$(oxlint --format=json $FNAME)

        annotationsByLine=$(echo "$lintOutput" | jq -r '.diagnostics | map({ (.labels[0].span.line | tostring): .severity }) | add')
        attachSeveritiesToLines $FNAME "$annotationsByLine" > /tmp/out.ts

        echo "Your file starts here ->"
        echo ""
        echo ""
        bat /tmp/out.ts
        echo ""
        echo ""
        # echo "$lintOutput" | jq -r '[.diagnostics[].severity]'

        # echo "$lintOutput" | jq -r '[.diagnostics[] | {message, code, causes, severity, labels: .labels[].span.line}]'

        # echo "$good"

        severities=$(echo "$lintOutput" | jq -r '[.diagnostics[] | {message, code, causes, severity, labels: .labels[].span.line}]' | jq 'reduce .[] as $diagnostic ({}; .[$diagnostic.severity] += 1)')

        PROMPT=$(getPrompt "$severities")

        getSoundbite "$severities" "$(echo -e "$PROMPT" | sed 's/\x1b\[[0-9;]*m//g')"

        echo ""
        echo ""
        getFace "$severities"
        echo ""
        echo ""


        # slowecho "$PROMPT" 0.01
    done
}
