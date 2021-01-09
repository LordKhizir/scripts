#getLastScreenshot
#Get last screenshot from default folder, and move it at current dir with name last-screenshot.png
mv "`find ~/Desktop/Screenshots -name "Screenshot *.png" -print0 | xargs -0 ls -1 -t | head -1`" last_screenshot.png
