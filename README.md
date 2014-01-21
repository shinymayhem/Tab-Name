##Tab-Rename
Simple tab renaming with session persistence.
Based off [Mykola Golubyev's script](http://www.vim.org/scripts/script.php?script_id=1678) and partially [taboo](https://github.com/gcmt/taboo.vim)

###Compatibility
Only tested on Vim command-line version 7.2 and GUI version 7.3
It might work with other versions

###Installation

For tab names to be restored on session restore, the following session options need to be enabled. Add this line to your `~/.vimrc`
```vim
set sessionoptions+=tabpages,globals
```

####Manual
Copy the contents to the `~/.vim` directory

####Vundle
:Bundle 'shinymayhem/Tab-Rename'
:BundleInstall

###Usage

`:TabRename tab_page_name` - set name of tab-page
`:TabUnname` - remove tab page name

Map a shortcut
`:nnoremap <F2> :TabRename `
