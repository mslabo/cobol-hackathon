dronelib:
	g++ -shared -fPIC -o dronelib.so dronelib.cpp `pkg-config opencv --cflags --libs`

captest:
	sh translate.sh captest.cob captest2.cob
	cobc -m captest2.cob
	mv captest2.so captest.so
