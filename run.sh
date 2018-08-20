docker run -d -p 27015:27015 -p 27015:27015/udp -p 27005:27005 -p 27005:27005/udp -v /root/gmod-server:/gmod-volume --name gmod-test suchipi/gmod-server

#-e "ARGS="
