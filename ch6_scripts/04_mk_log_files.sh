#!/bin/bash

touch /var/log/{btmp,lastlog,faillog,wtmp} &&
chgrp -v utmp /var/log/lastlog &&
chmod -v 664 /var/log/lastlog && 
chmod -v 600 /var/log/btmp &&
{ echo "Winner at logs!"; exit 0; } ||
{ echo "Loser at logs!"; exit 1; }
