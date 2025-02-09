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
          if docker exec -i search-$manager $manager show "$2" >/dev/null 2>&1; then
            echo "Package $2 exists. Attempting installation"

            # wooo now we can actually install the package
            docker run -dit --name $2 $image
            
            docker exec -i $2 $manager update
            docker exec -i $2 $manager install -y "$2"
            echo "adding \"$2\" to file."
            echo "$2,$manager,$image" >> ~/.dock/packages.txt
            echo -e "\nPackage \"$2\" installed.\n"
            echo "Adding \"$2\" to path."
            echo """#!/bin/sh
if [ -z "$(docker ps -q -f name=$2)" ]; then
  echo "W: Container \"$2\" not running. Starting $2..."
  docker start $2 > /dev/null
fi
docker exec -it $2 $2 \$@ # theoretically \$@ passes args to the container""" > ~/.dock/programs/$2
            chmod +x ~/.dock/programs/$2
          else
            echo -e "\nE: Package $2 does not exist."
            exit 1
          fi

        else
          docker run -dit --name search-$manager $image
          docker exec -i search-$manager $manager update
          echo "Creating new search container \"search-$manager\""
        fi
        ;;
    "remove")
        # if container exists, remove the whole container
        if [ -z "$2" ]; then
          echo "Usage: dock remove <package>"
          exit 1
        fi
        echo "Checking if $2 is a valid package"
        if [ -n "$(docker ps -all --filter "name=$2" --format {{.Names}})" ]; then
          echo "Container $2 exists. Attempting removal"
          docker rm -f $2 > /dev/null
          echo "removing \"$2\" from file."
          sed -i "/$2/d" ~/.dock/packages.txt
          echo -e "\nPackage \"$2\" removed."
        else
          echo -e "\nE: Package $2 does not exist."
          exit 1
        fi
        ;;
    "update")
        if [ "$2" = "--only" ]; then
          if [ -n "$3" ]; then
            echo "Checking if $3 is a valid package"
            if [ -n "$(docker ps -all --filter "name=$3" --format {{.Names}})" ]; then
              echo "Container $3 exists. Attempting update"
              docker start $3
              docker exec -i $3 $manager update 
              docker exec -i $3 $manager upgrade -y
              echo -e "\nPackage \"$3\" updated."
            fi
          else
            echo "Usage: dock update --only <package>"
            exit 1
          fi
        fi

        # honestly not really sure what's going on but maybe this'll work
        for i in $(cat ~/.dock/packages.txt); do 
          IFS=',' read -ra tokens <<< "$i"
          count=0
          for token in "${tokens[@]}"; do 
            count=$((count+1))
            if [ $count == 1 ]; then
              docker start $token > /dev/null
              docker exec -i $token $manager update 
              docker exec -i $token $manager upgrade -y
              echo -e "\nPackage \"$token\" updated."
            fi
          done
        done
        ;;
    "list")
        cat ~/.dock/packages.txt
        ;;
    "search")
        echo "E: Not implemented"
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
        echo "  --manager      specify a package manager (only for install, remove, & search)"
        echo "  --image        specify a container image (only for install & remove)"
        echo "  --only         only update one container (only for update)"
        ;;
esac
