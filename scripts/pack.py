#!/usr/bin/env python3
import os
import subprocess


# For each subfolder in current folder, repack all content as .7z
# For each individual file in current folder, if it is an STL or OBJ, also pack as indiviual 7z
# Settings for maximum compression
# Extra for OSX - dot_clean to remove .fu extra file
# Extra for OSX - At 7za, -xr to remove unwanted files: .DS_Store, Thumbs.db

def safe_execute(command):
    try:
        result = subprocess.run(command, shell=True, check=True)
    except subprocess.CalledProcessError:
        print("--- ERROR ---")
        exit(1)


safe_execute("dot_clean .")
safe_execute('find . \( -name ".DS_Store" -or -name "Thumbs.db" -or -name "desktop.ini" \) -delete ')

for entry in os.scandir("."):
    if entry.is_dir():
        safe_execute('7za a -t7z -m0=lzma2 -mx=9 -mqs=on -mfb=64 -md=1024m -ms=on ' +
                     '-xr!.DS_Store -xr!Thumbs.db -xr!desktop.ini ' +
                     '"' + entry.name + '.7z" "' + entry.name + '/"')
        os.rmdir(entry.name)
    elif entry.is_file():
        name, extension = os.path.splitext(entry.name)
        if extension.lower() in (".stl", ".obj"):
            safe_execute('7za a -t7z -m0=lzma2 -mx=9 -mqs=on -mfb=64 -md=1024m -ms=on ' +
                         '"' + name + '.7z" "' + entry.name + '"')
            os.remove(entry.name)
