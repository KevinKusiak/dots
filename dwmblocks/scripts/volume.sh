vol="$(pamixer --get-volume)"

if [ "$vol" -gt "70" ]; then
	icon="🔊"
elif [ "$vol" -gt "30" ]; then
	icon="🔉"
elif [ "$vol" -gt "0" ]; then
	icon="🔈"
else
        echo 🔇 && exit
fi

echo "$icon $vol%"
