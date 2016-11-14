
sudo apt-get update
sudo apt-get install -y pv
sudo apt-get install -y build-essential
sudo apt-get install -y make 
sudo apt-get install -y vim
sudo apt-get install -y wireshark
sudo apt-get install -y ntp

sudo wget http://downloads.es.net/pub/iperf/iperf-3.1.2.tar.gz
sudo tar -xvf iperf-3.1.2.tar.gz
cd iperf-3.1.2
sudo ./configure 
sudo make 
sudo make install
sudo ldconfig
cd ..
sudo apt-get install -y lib32z1
sudo apt-get install -y libncurses-dev
sudo apt-get update
sudo apt-get -y install linux-generic-lts-vivid

wget https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-4.4.0.tar.gz
#tar -xvf iproute2-4.4.0.tar.gz
#cd iproute2-4.4.0
#./configure
#make
#sudo make install
#sudo ldconfig

#sudo apt-get install -y kexec-tools
#sudo /sbin/reboot
