#!/bin/sh 

# Attempt 1: Use the most basic language that can actually do the thing

case $1 in
    "install")
        # check if package exists with $manager search
        if [ -z "$2" ]; then
            echo "Usage: dock install <package>"
            exit 1
        fi
        echo "checking if $2 is a valid package"
        ;;
    "remove")
        # if container exists, remove the whole container
        if [ -z "$2" ]; then
            echo "Usage: dock remove <package>"
            exit 1
        fi
        ;;
    "update")
        echo "Update"
        ;;
    "list")
        echo "List"
        ;;
    "search")
        echo "Results"
        ;;
    *)
        echo "Usage: dock [command] [args] <options>"
        echo ""
        echo "Software Management Commands:"
        echo "  install        install software in a new container"
        echo "  remove         remove a container"
        echo "  update         update a container's packages"
        echo ""
        echo "Query Commands:"
        echo "  list           list installed software containers"
        echo "  search         search for software with a specified name"
        ;;
esac
