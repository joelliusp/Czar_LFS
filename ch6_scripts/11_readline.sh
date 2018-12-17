#!/bin/bash
. install_help.sh

install_app() {
sed -i '/MV.*old/d' Makefile.in &&
sed -i '/{OLDSUFF}/c:' support/shlib-install &&
./configure --prefix=/usr \
--disable-static \
--docdir=/usr/share/doc/readline-7.0 &&
make SHLIB_LIBS="-L/tools/lib -lncursesw" &&
make SHLIB_LIBS="-L/tools/lib -lncurses" install &&
mv -v /usr/lib/lib{readline,history}.so.* /lib &&
chmod -v u+w /lib/lib{readline,history}.so.* &&
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so &&
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so) /usr/lib/libhistory.so &&
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-7.0 
}

install_app_nest 'readline-7.0' "/sources"
