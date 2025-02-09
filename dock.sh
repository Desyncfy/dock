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
  
        if [ -n "$(docker ps -all --filter "name=search-$manager" --format {{.Names}})" ]; then
          echo "Search container for $manager exists."
          docker start search-$manager > /dev/null # start the container quietly
          if docker exec -i search-$manager apt-cache show "$2" >/dev/null 2>&1; then
            echo "Package $2 exists. Attempting installation"

            # wooo now we can actually install the package
            docker run -dit --name $2 $image
            
            docker exec -i $2 apt-get update
            docker exec -i $2 apt-get install -y "$2"
            echo -e "\nPackage \"$2\" installed."
          else
            echo -e "\nE: Package $2 does not exist."
            exit 1
          fi

        else
          docker run -dit --name search-$manager $image
          docker exec -i search-$manager apt-get update
          echo "Creating new search container \"search-$manager\""
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
