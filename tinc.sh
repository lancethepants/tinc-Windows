#!/bin/bash

set -e
set -x

mkdir ~/tinc && cd ~/tinc

DEST=`pwd`
SRC=$DEST/src
WGET="wget --prefer-family=IPv4"

LDFLAGS="-L$DEST/lib"
CPPFLAGS="-I$DEST/include"
CONFIGURE="./configure --host=x86_64-w64-mingw32 --prefix=$DEST"

MAKE="make -j`nproc`"
mkdir -p $SRC

######## ####################################################################
# ZLIB # ####################################################################
######## ####################################################################

mkdir $SRC/zlib && cd $SRC/zlib
$WGET http://zlib.net/zlib-1.2.8.tar.gz
tar zxvf zlib-1.2.8.tar.gz
cd zlib-1.2.8

CROSS_PREFIX=x86_64-w64-mingw32- \
./configure \
--prefix=$DEST \
--static

$MAKE
make install

####### #####################################################################
# LZO # #####################################################################
####### #####################################################################

mkdir $SRC/lzo2 && cd $SRC/lzo2
$WGET http://www.oberhumer.com/opensource/lzo/download/lzo-2.09.tar.gz
tar zxvf lzo-2.09.tar.gz
cd lzo-2.09

$CONFIGURE

$MAKE
make install

########### #################################################################
# OPENSSL # #################################################################
########### #################################################################

mkdir $SRC/openssl && cd $SRC/openssl
$WGET https://www.openssl.org/source/openssl-1.0.2h.tar.gz
tar zxvf openssl-1.0.2h.tar.gz
cd openssl-1.0.2h

CROSS_COMPILE="x86_64-w64-mingw32-" \
./Configure mingw64 \
--prefix=$DEST zlib \
--with-zlib-lib=$DEST/lib \
--with-zlib-include=$DEST/include

make
make install

########### #################################################################
# NCURSES # #################################################################
########### #################################################################

mkdir $SRC/ncurses && cd $SRC/ncurses
$WGET http://ftp.gnu.org/pub/gnu/ncurses/ncurses-6.0.tar.gz
tar zxvf ncurses-6.0.tar.gz
cd ncurses-6.0

$CONFIGURE \
--enable-widec \
--enable-overwrite \
--enable-term-driver \
--enable-sp-funcs

$MAKE
make install
ln -s libncursesw.a $DEST/lib/libcurses.a

######## ####################################################################
# TINC # ####################################################################
######## ####################################################################

mkdir $SRC/tinc1.1 && cd $SRC/tinc1.1
$WGET http://www.tinc-vpn.org/packages/tinc-1.1pre14.tar.gz
tar zxvf tinc-1.1pre14.tar.gz
cd tinc-1.1pre14

LDFLAGS=$LDFLAGS \
CPPFLAGS=$CPPFLAGS \
./configure \
--host=x86_64-w64-mingw32 \
--sysconfdir='C:/Program\ Files' \
--localstatedir='C:/Program\ Files/tinc' \
--prefix='C:/Program\ Files/tinc' \
--with-curses=$DEST \
--disable-readline \
--with-zlib=$DEST \
--with-lzo=$DEST \
--with-openssl=$DEST

$MAKE
