#!/bin/bash

strip --strip-debug /tools/lib/*; 
/usr/bin/strip --strip-unneeded /tools/{,s}bin/*; 
rm -rf /tools/{,share}/{info,man,doc} 
find /tools/{lib,libexec} -name \*.la -delete 
echo "Done with striping!";
exit 0;  


