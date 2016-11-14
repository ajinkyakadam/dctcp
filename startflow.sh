duration=905
clientip= 
port1=5005
port2=5006
#port3=5007
#port4=5008
#port5=5009
#port6=5010

#port7=5011
#port8=5012
#port9=5013
#port10=5014
iperf3 -t $duration -c $client -p $port1 &

iperf3 -t $duration -c $client -p $port2 &
#iperf3 -t $duration -c $client -p $port3 &

#iperf3 -t $duration -c $client -p $port4 &
#iperf3 -t $duration -c $client -p $port5 &
#iperf3 -t $duration -c $client -p $port6 &

#iperf3 -t $duration -c $client -p $port7 &
#iperf3 -t $duration -c $client -p $port8 &
#iperf3 -t $duration -c $client -p $port9 &
#iperf3 -t $duration -c $client -p $port10 &
