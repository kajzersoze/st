# Info

`st` for Gentoo with some of the patches   
Enable the ones you wish to use with USE flags   

More patches could be added, I'm starting with these because that's what I use at the moment   
Feel free to add more via PR or ask for the ones you would like to see   

# Patches

* anysize
* blinkingcursor
* boxdraw
* clipboard
* externalpipe
* font2
* ligatures
* scrollback
* transparency
* visualbell2

# Usage

Copy `x11-wm/st` directory in your local overlay and emerge `st`   

if you already used `st` before with `savedconfig` USE flag enabled,   
you will need to backup that config file and delete it, in order for new config to be used.   

