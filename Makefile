TARGET = ~/sw/p1/lib/ejabberd/ebin/

all:
	erl -pa . -pa ./ejabberd/deps/lager/ebin -pa ./ejabberd/ebin -pz ebin -make

install:
	cp ebin/*.beam $(TARGET)

clean:
	rm ebin/*.beam
