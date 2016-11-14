pkill -9 iperf3
for i in {5005..5024..1}
do 
iperf3 -s -D -p $i
done

