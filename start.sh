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

getPrompt() {
    SEVERITIES=$1
    FOUND=0

    if [ -z "$SEVERITIES" ]; then
        echo "Let's get coding! "
        FOUND=1
    else
        if [ $(echo "$SEVERITIES" | jq .warning) != "null" ]; then
            echo "There was a warning... watch out buddy! "
            FOUND=1
        fi

        if [ $(echo "$SEVERITIES" | jq .error) != "null" ]; then
            echo "Error?! Try to write better code, fool... "
            FOUND=1
        fi
    fi

    if [ $FOUND -ne 1 ]; then
        echo "Let's get coding! "
    fi
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
        IFS= read -rp "$PROMPT" userInput

        clear

        if [ "$userInput" = "/quit" ]; then
            break
        fi

        echo "$userInput" >> $FNAME

        echo "Your file starts here ->"
        echo ""
        echo ""
        cat $FNAME
        echo ""
        echo ""

        lintOutput=$(oxlint --format=json $FNAME)

        # echo "$lintOutput" | jq -r '[.diagnostics[].severity]'

        # echo "$lintOutput" | jq -r '[.diagnostics[] | {message, code, causes, severity, labels: .labels[].span.line}]'

        # echo "$good"

        severities=$(echo "$lintOutput" | jq -r '[.diagnostics[] | {message, code, causes, severity, labels: .labels[].span.line}]' | jq 'reduce .[] as $diagnostic ({}; .[$diagnostic.severity] += 1)')

        PROMPT=$(getPrompt "$severities")

        # echo "$severities"
    done
}
