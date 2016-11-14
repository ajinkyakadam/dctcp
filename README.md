# Instructions to Reproduce DCTCP Experiment 

##Instructions to Reproduce
* Total time needed to run the following set of experiments will be around 2 hours (excluding the time required to reserve resources). 
* Sometimes it is hard to get the resources up and running. Hence I am not mentioning this time explicitly as it may vary upon the current load on the aggregates 


##Using Cloud Lab
* Login using geni username and password
* In Actions menu create profile
* Create the topology as described below. 
* Instantiate topology to reserve resources
* Incase your request fails use [status](https://www.cloudlab.us/cluster-graphs.php) to monitor load on the aggregate sites. Use the site with less load. If you hover over the sites you can see how much machines are unoccupied. 

##Instructions  to reproduce Figure 4 from my report 
* Reserve 5 bare metal nodes at [cloud lab](https://www.cloudlab.us/), 3 servers, 1 client, 1 switch or 4 bare metal nodes whatever the maximum amount of nodes you get.
* Choose disk Image as Ubuntu 14.04 LTS
* copy install.sh to each node
* run `bash install.sh`
* Check BW 944Mbps
* Check RTT 590us
* Set reno as congestion control protocol. Repeat same set of steps for dctcp
`````
sysctl -w net.ipv4.tcp_congestion_control=reno
sysctl -w net.ipv4.tcp_congestion_control=dctcp
`````
* set pfifo queue on the interface of switch node connecting client
`````
tc qdisc add dev eth3 root pfifo limit 467
`````
* Check if SACK is enabled
`````
sysctl -w net.ipv4.tcp_sack=1
`````
* Start servers on client nodes. For 2 flows use the below command. For 20 flows use the script createflowsclient.sh
````
iperf3 -s -D -p 5005
iperf3 -s -D -p 5006
````

* Start flows from servers. For two flows you start from terminal for 20 flows you can use startflows.sh script. You will need to modify/uncomment the port numbers. Make sure you do that before executing the script.
* Monitor queue using queue monitor script on the switch  interface connected to client
* scp output file to your local machine 
* extract queue length using the first command for dctcp and second in case of tcp
````
cat outdctcp.txt | sed 's/\p / /g' | awk  '{ print $34 }' > qlendctcp.csv
cat outtcp.txt | sed 's/\p / /g' | awk  '{ print $23 }' >  qlentcp.csv
````
* Read the file in matlab using 
``````
dctcp = csvread('qlendctcp.csv');
tcp = csvread('qlentcp.csv');
``````
* Compute cdf using 
````
[f,x] = ecdf(dctcp);
[f1,x1] = ecdf(tcp);
````
* Plot using 
``````
plot(x,f);
``````

##Instructions to reproduce Figure 6 from report
* 3 servers preferable, 1 client ,1 switch
* scp install.sh to all the machines
* run 
````
bash install.sh
````
* Then reboot the machines so as to load new kernel 
* check with below command if new kernel is added 
`````
uname -r 
`````
* Enable ecn on all nodes using 
````
sudo sysctl -w net.ipv4.tcp_ecn=1
````
* copy incast.tgz to server3 and client machines using scp 
````
scp -P 22 incast.tgz username@machineip:~/ 
````
* login to server3 and client and untar the file incast.tgz
* First for TCP
> * set congestion control protocol to reno using below command on all nodes
`````
sudo sysctl -w net.ipv4.tcp_congestion_control=reno
`````
> * On switch port connected to client set pfifo queue discipline using 
`````
tc qdisc add dev eth3 root pfifo limit 100
`````
> * On client node start two iperf3 servers using 
````
iperf3 -s -D -p 5005
iperf3 -s -D -p 5006
````
> * On server 3 and client machine navigate to incast/app/src
> * Run `make`
> * On server 3 start the server by using 
````
./incast/app/src/server/a.out
```` 
> * Start iperf3 traffic from server 1 and server 2 towards client using 
````
iperf3 -t 900 -c client -p 5005
iperf3 -t 900 -c client -p 5006
````
> * on  the client node navigate to cd incast/app/scripts/
> * open the file node_list_all.txt, and add your server3 ip address 
> * From client start request 20KB chunk of data using 
````
./_run_servers_and_client.sh 1 20000 run_number

````

* For DCTCP 
> * set congestion control protocol to dctcp using below command on all nodes
`````
sudo sysctl -w net.ipv4.tcp_congestion_control=dctcp
`````
> * On switch port connected to client set RED queue discipline using 
`````
tc qdisc del dev eth3 root
sudo tc qdisc replace dev eth3 root red limit 700000 min 30000 max 31500 avpkt 1500 burst 21 probability 1 ecn
`````
> * On some machines the above commands need t be modified as follows 
````
sudo tc qdisc replace dev eth3 root red limit 700000 min 30000 max 31500 avpkt 1500 burst 21 probability 1 ecn bandwidth 1000Mbit
````
> * On client node start two iperf3 servers using 
````
iperf3 -s -D -p 5005
iperf3 -s -D -p 5006
````
> * On server 3 start the server by using 
````
./incast/app/src/server/a.out
```` 
> * Start iperf3 traffic from server 1 and server 2 towards client using 
````
iperf3 -t 900 -c client -p 5005
iperf3 -t 900 -c client -p 5006
````
> * on  the client node navigate to cd incast/app/scripts/
> * open the file node_list_all.txt, and add your server3 ip address 
> * From client start requesting 20KB chunk of data using 
````
./_run_servers_and_client.sh 1 20000 run_number

````
* Note run number stores the log files with the folder name given by the run_number in folder `incast/app/scripts/`

* After you finish both experiments process the log files present on the  client machine their itself suing the following commands, where 60 is the folder name. `client_1_20000.log` filename represents that client requested 20000 data from 1 server. I have mentioned this explicitly since when we process files to reproduce table 2 it will be helpful and you can modify the below command accordingly
````
cat 60/client_1_20000.log | grep "CurrTime (usec): " | sed 's|CurrTime (usec): ||' >> 60/60.csv
````
* Now you can find the csv files in the respective folders. Copy these to your machines using scp as follows
````
scp -P 22 username@pc30.utahddc.geniracks.net:/users/username/incast/app/scripts/logs/foldername/file.csv .
````
* You can use the following matlab commands to plot the figure. 

* Matlab Commands 
> * dctcp = csvread('60.csv');
> * tcp = csvread('61.csv');
> * dctcp = dctcp/1000;
> * tcp = tcp/1000;
> * [f1,x1] = ecdf(dctcp);
> * [f2,x2] = ecdf(tcp);
> * plot(x1,f1,'k.-');
> * hold on
> * plot(x2,f2,'r.-');


##Reproducing Table 2 and Table 3 from report 
* Repeat same set of steps for TCP reno. Note you run two experiments per protocol. One with two flows and one with twenty flows. we will start with dctcp and then do tcp
* Set protocol as dctcp
* Check whether congestion control protocol is now dctcp using
````
sysctl -a | grep congestion_control
````
* Check if ecn=1 else set ecn to 1 
````
sudo sysctl -w net.ipv4.tcp_ecn=1
````
* Start two servers on client nodes. When starting 20 server use `createflowsclient.sh` file.  
* Start two terminals on each server. 
* From one terminal of server start sending traffic. For two flows you can do it manually. For 10 flows you can use startflows.sh script with appropriate modifications
* On the other terminals start incast server by navigating to `incast/app/src/server` and running
```
./a.out
```
* before you run the above command make sure that you ran `make` in this folder `incast/app/src/` .
* Also check how to add the ip address as described in  the section `Reproduce fig21`. You will add ip address of both the nodes to `node_list_all.txt` file on client machine. 
* Then from client start request 200KB chunks of data. using 
````
./_run_servers_and_client.sh 2 200000 run_number
````
* Give whatever run number you want, just make sure it is different than what you used in previous experiments, else your data will get overriden and you may have to rerun the experiments. If you want maintain an excel file which logs the run number corresponding to your experiment.
* You can extract the query completion time using, where 35 is the run number (folder name) of your experiment. 
````
cat 35/client_1_20000.log | grep "CurrTime (usec): " | sed 's|CurrTime (usec): ||' >> 35/35.csv
````
* extract 95th percentile query completion time using following commands in matlab. Please note you will modify the following commands as per your filenames. This is just an example set which tells you what commands you will need. 
> * dctcp = csvread('60.csv');
> * tcp = csvread('61.csv');
> * dctcp = dctcp/1000;
> * tcp = tcp/1000;
> * prctile(dctcp,95);
> * prctile(tcp,95);
