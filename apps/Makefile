CXX=g++
CXXFLAGS = -std=c++11 -O3 -mtune=native 
# -fopt-info-options=all

TARGETS = mulmat

all: $(TARGETS)

#memgrow: memgrow.o
#	$(CXX) $^ $(LIBS) -o $@

mulmat: mulmat.o
	$(CXX) $^ $(LIBS) -o $@

%.o : %.cpp
	$(CXX) $(CXXFLAGS) $< -c

clean:
	rm -f *.o mulmut

install: $(TARGETS)
	cp mulmat /usr/local/bin
