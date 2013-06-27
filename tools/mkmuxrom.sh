SEL=$1
SET=$2

echo "always @(*) begin"
echo "    case ($SEL)"

i=0

while read line
do
	echo "        $i: $SET = $line;"
	i=$(($i+1))
done

echo "    endcase"
echo "end"
