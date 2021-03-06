#!/bin/bash

keep_files="('tools' =>1,
'sources' => 1,
"$(for arg in "$@"; do 
  clean_arg=$(printf '%s' "$arg" | xargs -0 basename)
  printf '%s\n' "'$clean_arg' => 1,"; 
done)")"



if [ -n "$LFS" ]; then
  
  rm -rf $LFS/tools/*
  
  if mountpoint $LFS/dev/pts -q; then
      umount $LFS/dev/pts
  fi
  if mountpoint $LFS/dev -q; then
    umount $LFS/dev
  fi 
  if mountpoint $LFS/proc -q; then
      umount $LFS/proc
  fi 
  if mountpoint $LFS/sys -q; then
      umount $LFS/sys
  fi 
  if mountpoint $LFS/run -q; then
      umount $LFS/run
  fi 
  #Switched from extended globbing because it started acting very unreasonably anytime I tried to do more 
  #than hard code the delete exceptions.
  #I would have prefered to do the filtering with grep but there was a frustrating bug associated with
  #newlines and null chars that would require a bunch of stupid hoops.
  #find's exclude uses globbing rather than regex so that was also out the window
  cd "$LFS" # I could have done this earlier but I want the rest of the path stuff more explicit.
  #I just happen to need to switch directories here.
  find . -maxdepth 1 -execdir basename -z {} \; | \
     perl -0x00 -e '
       my %keep_files = '"$keep_files"'; 
       while(<>){       
        chomp(my $k = $_); 
        print unless exists($keep_files{$k}) or $k eq "."; 
       }' | xargs -0 rm -rf
  echo "*****************************"
  cd -
else 
  echo "Could not safely clean up files"
  exit 1;
fi


if [ $(stat -c %u $LFS/tools) != $(id -u lfs) ]; then
  chown -R lfs $LFS/tools #sometimes we need to reset ownership if a previous run made it past the ch5 part  
fi

exit 0;
