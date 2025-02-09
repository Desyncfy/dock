#!/bin/sh 

# Attempt 1: Use the most basic language that can actually do the thing

# VARIABLES
manager="apt"
image="ubuntu:latest"


case $1 in
    "install")
        # check if package exists with $manager search
        
        # argument check
        if [ -z "$2" ]; then
          echo "Usage: dock install <package>"
          exit 1
        fi

        # actually do the thing
        echo "checking if $2 is a valid package"

        # options
        case $3 in
          "--manager")
            if [ -z "$4" ]; then
              echo "Usage: dock install <package> [--manager <manager>] [--image <image>]"
              exit 1
            fi
            manager=$4
            ;;
          "--image")
            if [ -z "$4" ]; then
              echo "Usage: dock install <package> [--manager <manager>] [--image <image>]"
              exit 1
            fi
            image=$4
            ;;
          "")
            ;;
          *)
            echo "Usage: dock install <package> [--manager <manager>] [--image <image>]"
            exit 1
            ;;
        esac
        
        # I hate code readability
        case $5 in
          "--manager")
            if [ -z "$6" ]; then
              echo "Usage: dock install <package> [--manager <manager>] [--image <image>]"
              exit 1
            fi
            manager=$6
            ;;
          "--image")
            if [ -z "$6" ]; then
              echo "Usage: dock install <package> [--manager <manager>] [--image <image>]"
              exit 1
            fi
            image=$6
            ;;
          "")
            ;;
          *)
            echo "Usage: dock install <package> [--manager <manager>] [--image <image>]"
            exit 1
            ;;
        esac




        
        # HERE: check if a container named "search-$manager" exists
        # if it does, then use that container otherwise create a new one
  
        if [ "$(docker ps --filter 'name=search-$manager' --format {{.Names}})" ]; then
          echo "Container exists"
        else
          docker run --name search-$manager $image
          echo "blamo"
        fi
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
        echo ""
        echo "Options:"
        echo "  --manager      specify a package manager (only for install & remove)"
        echo "  --image        specify a container image (only for install, remove, & update)"
        ;;
esac
