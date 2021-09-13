OPTION=$(osascript -e 'tell app "System Events" to display dialog "Welcome to Block League Chat" buttons {"Block", "Unblock"}')
if [ "$OPTION" = "button returned:Block" ]
then
    echo "blocking"
    TARGET_IP=$(dig +short na2.chat.si.riotgames.com | tail -1)
    echo "Target IP is $TARGET_IP"
    PF_RULE="block drop from any to $TARGET_IP"
    CHECK_EXIST=$(sudo grep -r "$PF_RULE" /etc/pf.conf)
    if [ -z "$CHECK_EXIST" ]
    then
        # rule does not exist, adding
        echo "Adding Rule [$PF_RULE] to /etc/pf.conf"
        sudo sh -c "echo '$PF_RULE #league chat' >> /etc/pf.conf"
        sudo pfctl -e -f /etc/pf.conf
    else
        echo "Rule exists, enjoy the privacy"
    fi
else
    echo "unblocking"
    sudo sed -i '' '/#league chat/d' /etc/pf.conf
    sudo pfctl -e -f /etc/pf.conf
fi
osascript -e 'tell application "Terminal" to close (every window whose name contains ".command")' &
exit