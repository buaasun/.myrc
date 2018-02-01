#.bashrc
export LANG=C
export EDITOR=vim
#dedup_path PATH
function dedup_path()
{

    local varvalue=
    eval varvalue=\$$1
    if [ -n "$varvalue"  ]; then
        local old_PATH=$varvalue:; varvalue=
        while [ -n "$old_PATH"  ]; do
            x=${old_PATH%%:*}       # the first remaining entry
            case $varvalue: in
                *:"$x":*) ;;         # already there
                *) varvalue=$varvalue:$x;;    # not there yet
            esac
            old_PATH=${old_PATH#*:}
        done
        varvalue=${varvalue#:}
        unset old_PATH x
        eval $1=$varvalue

    fi
}

function addpath()
{
    local varname=$1;
    local varvalue=
    eval varvalue=\$$1;
    shift;
    for x in $@; do
        case ":$varvalue:" in
            *":$x:"*) :;; # already there
            *) varvalue="$x:$varvalue";;
        esac
    done
    varvalue=${varvalue%:}
    eval $varname=$varvalue
}

function remove_path()
{
    local varname=$1;
    local varvalue='';
    eval varvalue=\$$1;
    shift;
	varvalue=":$varvalue:"
    for x in $@; do
	   varvalue=${varvalue//:$x:/:}
    done
    varvalue=${varvalue%:}
	varvalue=${varvalue#:}
    eval $varname=$varvalue

}
function extract() # Handy Extract Program
{
    if [ -f $1  ] ; then
        case $1 in
            *.tar.bz2) tar xvjf "$1" ;;
            *.tar.gz) tar xvzf "$1" ;;
            *.tar.xz) tar xvJf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xvf "$1" ;;
            *.tbz2) tar xvjf "$1" ;;
            *.tgz) tar xvzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

function replace_file(){
oldstring=$1
newstring=$2
oldstring_=`echo $oldstring |sed 's/\\//\\\\\\//g'`
newstring_=`echo $newstring |sed 's/\\//\\\\\\//g'`
shift 2
sed -i "s/$oldstring_/$newstring_/g" $*

}
function relace_all_file(){
oldstring=$1
newstring=$2
dir=$3
replace_file oldstring newstring `grep $oldstring -rl $dir`
}
export -f replace_file
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
dedup_path PATH
dedup_path CLASSPATH
dedup_path LD_LIBRARY_PATH
dedup_path C_INCLUDE_PATH
dedup_path CPLUS_INCLUDE_PATH
export PATH
export BREW_HOME=~/.linuxbrew
function add_brew(){
addpath PATH ${BREW_HOME}/bin ${BREW_HOME}/sbin
addpath MANPATH /usr/share/man ${BREW_HOME}/share/man
addpath INFOPATH /usr/share/info ${BREW_HOME}/share/info
export PATH
export MANPATH
export INFOPATH
}
function remove_brew(){
remove_path PATH ${BREW_HOME}/bin ${BREW_HOME}/sbin
remove_path MANPATH  ${BREW_HOME}/share/man
remove_path INFOPATH  ${BREW_HOME}/share/info
export PATH
export MANPATH
export INFOPATH

}
function add_cuda(){
export CUDA_PATH=/usr/local/cuda
addpath PATH ${CUDA_PATH}/bin
}
function remove_cuda(){
remove_path PATH ${CUDA_PATH}/bin
unset CUDA_PATH;
}
function import_brew_bin(){
name=$1
f="function $name(){ ${BREW_HOME}/bin/$name \$*; return \$!; };"
echo $f;
eval $f ;


}

function unimport_brew_bin(){
name=$1
unset $name;

}
import_brew_bin tmux;
import_brew_bin mosh-server;
import_brew_bin vim;

#alias tmux="${BREW_HOME}/bin/tmux"
#alias mosh-server="${BREW_HOME}/bin/mosh-server"
#alias vim="${BREW_HOME}/bin/vim"
#add_brew;
