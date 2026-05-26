testFun() {
    FNAME=$1
    rm -f $FNAME

    clear
    echo "Your file starts here ->"
    echo ""
    while :
    do
        IFS= read -rp "Let's get coding! " userInput

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

        echo "------- Lint Output ------------"
        oxlint --format=json $FNAME | python3 -m json.tool
        echo "--------------------------------"
        echo ""
    done
    # What do we need to do...
    #
    #
    # you run the command... (maybe with filepath?) and 
    # prompt is changed as soon as you run the command
    #
    # then every line you enter gets appended to that file
    #
    # whenver "enter" is pressed, the contents of the file is echoed, with your
    # appended line. and the prompt is changed...
    #
    # in addition, it gets run through linter / lsp to get warnings
    #
    # allow changeline to fix?
    #
    # Enter char - '\x0a'
    # 1Gj
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # 
}
