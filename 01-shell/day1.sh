#!/bin/sh

# Part 1

sum=0
while read -r line; do
	var=$(printf "%s\n" "$line" | tr -dc 0-9)
	number=$(printf "%d%d" "$(printf "%d" "$var" | head -c1)" "$(printf "%d\n" "$var" | tail -c2)")
	sum=$((sum + number))
done < input.txt
echo $sum

# Part 2

sum=0
while read -r line; do
	first=$(printf "%s\n" "$line" | rev | sed -nE "s/.*(eno|owt|eerht|ruof|evif|xis|neves|thgie|enin|[0-9]).*/\1/p" |
		sed "s/eno/1/;s/owt/2/;s/eerht/3/;s/ruof/4/;s/evif/5/;s/xis/6/;s/neves/7/;s/thgie/8/;s/enin/9/")
	last=$(printf "%s\n" "$line" | sed -nE "s/.*(one|two|three|four|five|six|seven|eight|nine|[0-9]).*/\1/p" |
		sed "s/one/1/;s/two/2/;s/three/3/;s/four/4/;s/five/5/;s/six/6/;s/seven/7/;s/eight/8/;s/nine/9/")
	sum=$((sum + $(printf "%d%d" "$first" "$last")))
done < input.txt
echo $sum
