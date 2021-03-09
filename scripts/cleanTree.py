#!/usr/bin/env python3
import os

# cleandir - Clean current directory
# Remove unwanted files
# Remove comments

folder = "."
for subdir, dirs, files in os.walk(folder):
    for filename in files:
        filepath = subdir + os.sep + filename
        name, extension = os.path.splitext(filepath)
        extension = extension.lower()

        print(filepath)

        # Files to be removed
        if filename.lower() in (".ds_store", "thumbs.db", "desktop.ini") \
                or filename.startswith("._") \
                or extension == ".txt":
            print("\tRemoving it")
            os.remove(filepath)

        # Ascii OBJ and STL - Remove comments
        if extension in (".obj", ".stl"):
            print("\tChecking")
            cleanit = False
            try:
                with open(filepath, "r") as f:
                    lines = f.readlines()
                for line in lines:
                    if line.startswith("#"):
                        print("\tComment found.")
                        cleanit = True
                        break
            except UnicodeDecodeError:
                # Binary file, just continue
                continue

            if cleanit:
                print("\tCleaning")
                with open(filepath, "w") as f:
                    for line in lines:
                        if line.startswith("#"):
                            print("\t\tRemoved " + line)
                        else:
                            f.write(line)
