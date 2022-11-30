#!/bin/bash

# function to get the output of command being run into an array (arr) as well as in stdout

get_prev_cmd_output()
{
    usage()
    {
        echo "Usage: alphabet [ -h | --help ]
        [ -s | --sep SEP ]
        [ -v | --var VAR ] \"command\""
    }
    
    ARGS=$(getopt -a -n alphabet -o hs:v: --long help,sep:,var: -- "$@")
    if [ $? -ne 0 ]; then usage; return 2; fi
    eval set -- $ARGS
    
    local var="arr"
    IFS=$(echo -en '\n\b')
    for arg in $*
    do
        case $arg in
            -h|--help)
                usage
                echo " -h, --help : opens this help"
                echo " -s, --sep  : specify the separator, newline by default"
                echo " -v, --var  : variable name to put result into, arr by default"
                echo "  command   : command to execute. Enclose in quotes if multiple lines or pipelines are used."
                shift
                return 0
                ;;
            -s|--sep)
                shift
                IFS=$(echo -en $1)
                shift
                ;;
            -v|--var)
                shift
                var=$1
                shift
                ;;
            -|--)
                shift
                ;;
            *)
                cmd=$option
                ;;
        esac
    done
    if [ ${#} -eq 0 ]; then usage; return 1; fi
    
    echo $* > /tmp/exe
    ERROR=$( { bash /tmp/exe > /tmp/out; } 2>&1 )
    if [ $ERROR ]; then echo $ERROR; return 1; fi
    
    local a=()
    exec 3</tmp/out
    while read -u 3 -r line
    do
        a+=($line)
    done
    exec 3<&-
    print_arr $var
    eval $var=\(\${a[@]}\)
}


# function to print an array

print()
{
    eval echo \${$1[@]}
}


# function to print contents of an array line-by-line

print_arr()
{
    eval local arr=\(\${$1[@]}\)
    for x in ${arr[@]}
    do
        echo $x
    done
}
