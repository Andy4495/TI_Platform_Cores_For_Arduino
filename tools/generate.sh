#!/bin/zsh

# Tool to create processor core and tools archives for use by Arduino Board Manager
# Tars and compresses a directory tree, calculates SHA-256 checksum and file size

# 1. Get location of current archive (.tar.bz2 file) to use as starting point
#    - Or skip this step if you want to archive an existing directory tree
# 2. Get name of directory to use as the top-level archive directory
# 3. Pause to let user to update directory tree as needed
# 4. Clean out unnecessary artifacts 
#    - MacOS ".DS_Store" or "._" files
#    - Arduino "installed.json" file
# 5. Tar and compress (bz2) directory
# 6. Calculate and save filesize and sha-256 checksum in file "size-and-checksum.txt"

print "This script should be run from the directory where the archive will be created."
print "Do you want to uncompress an archive file or work on an existing directory [u/e]?"
read answer
if [[ $answer == "u" ]]
then
  print "Enter path of archive to decompress: "
  read archive_name
  if [ ! -f $archive_name ]
  then
    echo "File not found: $archive_name"
    exit 1
  fi
  tar xvf $archive_name
elif [[ $answer != "e" ]]
then
  echo "Invalid reponse. Exiting."
  exit 1
fi

print "Enter directory to archive: "
read directory_name
if [[ ! -d $directory_name ]]
then
  echo "Directory not found: $directory_name"
  exit 1
fi

print "Enter new archive name. It should end with .tar.bz2"
print "Example names are: msp430-3.0.0.tar.bz2, msp430-elf-gcc-8.3.0.16_macos.tar.bz2, msp430-elf-gcc-8.3.0.16_linux64.tar.bz2"
read new_archive_name

print "Update directory tree as needed and press Enter to continue:"
read wait_to_continue

print "Deleting MacOS Finder artifacts"
find $directory_name -name '.DS_Store' -type f -print -exec rm {} \;  
find $directory_name -name '._*' -type f -print -exec rm {} \;  
print "Deleting 'installed.json' Arduino artifact if necessary"
rm -f $directory_name/installed.json

print "Creating new archive"
tar cvjf $new_archive_name $directory_name

print "Calculate size and SHA-256 checksum and saving to file 'size_and_checksum.txt'"
ls -l $new_archive_name | awk '{print $5}' | read archive_size
shasum -a 256 $new_archive_name | awk '{print $1}' | read archive_shasum

print "$new_archive_name size (bytes): $archive_size" > size_and_checksum.txt
print "$new_archive_name checksum (SHA256): $archive_shasum" >> size_and_checksum.txt
cat size_and_checksum.txt

