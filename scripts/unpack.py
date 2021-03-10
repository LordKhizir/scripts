#!/usr/bin/env python3
import os

# Unpack
# Extract RAR, ZIP and 7z files, and remove them
# Take care of NOT creating unnecessary nested dirs

folder = "."
for entry in os.scandir("."):
    if entry.is_file():  # and entry.path.endswith(".rar"):
        file = str(entry.path).removeprefix("./")
        name, extension = os.path.splitext(file)
        if extension.lower() in (".rar", ".zip", ".7z"):
            print("Unpacking " + file)
            newfolder = folder + "/" + name
            os.mkdir(newfolder)
            if extension.lower() == ".rar":
                # Rar5 is not supported by 7z
                os.system('unrar x "' + file + '" "' + name + '"')
            else:
                os.system('7z x "' + file + '" -o"' + name + '"')
            # We always force the creation of a folder... just to avoid spitting out files directly to current folder
            # But most times the packed file already included a folder... so we can end with unnecessary nesting
            if os.path.exists(newfolder + "/" + name):
                os.rename(newfolder, newfolder + "_DELETE")
                os.rename(newfolder + "_DELETE/" + name, newfolder)
                os.rmdir(newfolder + "_DELETE")
            os.remove(entry.path)
