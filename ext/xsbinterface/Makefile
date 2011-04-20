CC=gcc -shared
CFLAGS=-g -O2
LDFLAGS= -Wl,"--no-undefined","-dy"
LIBS=-lpthread -lm -ldl -lodbc 

DEFS=-DPACKAGE_NAME=\"\" -DPACKAGE_TARNAME=\"\" -DPACKAGE_VERSION=\"\" -DPACKAGE_STRING=\"\" -DPACKAGE_BUGREPORT=\"\" -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -D_XSB_PATH_DEPTH=2
SRCS=xsbinterface.c
OBJS=xsbinterface.o /usr/local/lib/xsb/xsb.o

# My targets

all : default install

default : compile link

compile : xsbinterface.c
	${CC} ${CFLAGS} -c -o xsbinterface.o ${DEFS} ${SRCS}

link : xsbinterface.o
	${CC} ${LDFLAGS} -o xsbinterface.so ${OBJS} ${LIBS}

install: xsbinterface.so
	cp -f xsbinterface.so ../../lib/
