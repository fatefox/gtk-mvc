CCFLAGS=$(shell pkg-config --cflags gtk+-2.0)
LDFLAGS=$(shell pkg-config --libs gtk+-2.0)
CCLDFLAGS=$(CCFLAGS) $(LDFLAGS)

all: scroll-demo test-mvc

check: test-mvc
	./test-mvc

clean:
	rm -rf *.o libscoll.so scroll-demo test-mvc

libscroll_so_sources=\
	gtk-mvc.h \
	gtk-mvc-adaptor.c \
	gtk-mvc-adaptor.h \
	gtk-scroll-controller.c \
	gtk-scroll-controller.h \
	gtk-scroll-model.c \
	gtk-scroll-model.h \
	gtk-scroll-view.c \
	gtk-scroll-view.h \
	$(NULL)
libscroll_so_objects=$(patsubst %.c,%.o,$(filter %.c,$(libscroll_so_sources)))

%.o: %.c $(filter %.h,$(libscroll_so_sources))
	gcc -c -o $@ $< $(CCFLAGS)

libscroll.so: $(libscroll_so_objects)
	gcc -shared -o $@ $^ $(LDFLAGS)

scroll-demo: scroll-demo.c libscroll.so
	gcc -o $@ $< -L. -lscroll -Wl,"-rpath=$(shell pwd)" $(CCLDFLAGS)

test-mvc: test-mvc.c libscroll.so
	gcc -o $@ $< -L. -lscroll -Wl,"-rpath=$(shell pwd)" $(CCLDFLAGS)

