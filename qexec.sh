#This file needs to be on the router, if not you will face No such file found when you execute experiment-runner.sh 
#Script to clear the queue and reinstall it. 
#This helps to make the previously dropped packets value again to 0 
sudo tc qdisc del dev eth6 root
sudo tc qdisc replace dev eth6 root red limit 700000 min 30000 max 31500 avpkt 1500 burst 21 probability 1 ecn bandwidth 1000Mbit
