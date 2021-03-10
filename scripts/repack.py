#!/usr/bin/env python3
import os
import subprocess


# Unpack & repack, folder by folder
# It just re-compresses everything... and moves to "done" folder
# Use it for mass processes, to avoid generating huge pools of files
# It takes care of NOT creating unnecessary nested dirs

def safe_execute(command):
    try:
        result = subprocess.run(command, shell=True, check=True)
    except subprocess.CalledProcessError:
        print("--- ERROR ---")
        exit(1)


def fix_double_folder(name):
    # We always force the creation of a folder... just to avoid spitting out files directly to current folder
    # But most times the packed file already included a folder... so we can end with unnecessary nesting
    if os.path.exists(name + "/" + name):
        os.rename(name, name + "_DELETE")
        os.rename(name + "_DELETE/" + name, name)
        os.rmdir(name + "_DELETE")


workFolder = "TMPWRKFLDR"
safe_execute('mkdir -p "' + workFolder + '"')

for entry in os.scandir("."):
    if entry.is_file():
        name, extension = os.path.splitext(entry.name)
        if extension.lower() in (".rar", ".zip", ".7z"):
            print("Unpacking", entry.name)
            newFile = workFolder + '/' + name + '.7z'
            os.mkdir(name)
            if extension.lower() == ".rar":
                # Rar5 is not supported by 7z
                safe_execute('unrar x "' + entry.name + '" "' + name + '"')
            else:
                safe_execute('7z x "' + entry.name + '" -o"' + name + '"')
            fix_double_folder(name)

            print("Packing")
            safe_execute('7za a -t7z -m0=lzma2 -mx=9 -mqs=on -mfb=64 -md=1024m -ms=on ' +
                         '-xr!.DS_Store -xr!Thumbs.db -xr!desktop.ini ' +
                         '"' + newFile + '" "' + name + '/"')
            # Remove temp folder for the file
            safe_execute('rm -r "' + name + '"')

            # If the original file was already a 7z, check if new file is smaller than the first one
            # sometimes it happens, depending on compression method
            if extension.lower() == ".7z":
                oldSize = os.path.getsize(entry.name)
                newSize = os.path.getsize(newFile)
                print("Old size:", oldSize, " New size:", newSize)
                if oldSize < newSize:
                    print("Restoring original file, as it's smaller")
                    safe_execute('mv "' + entry.name + '"' + newFile + '"')
                else:
                    os.remove(entry.path)
            else:
                os.remove(entry.path)

# Move everything from working dir, and remove it
if os.path.exists(workFolder):
    safe_execute('mv ' + workFolder + '/* .')
    safe_execute('rm -r "' + workFolder + '"')
