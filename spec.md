# Dock Package Manager Specification
_world's worst package manager that creates a docker container for each package_

**USAGE: dock [command] [args]**

>dock install [pkg]

```
OPTIONAL ARGS:
-i OR --image <docker image>
-m OR --manager <package manager>
```

DOES: searchs for package to verify it exists, creates new container with image, runs package manager<br>
MISC: adds package to json file to remember what to update/with what manager

>dock search [pkg]

```
OPTIONAL ARGS:
-i OR --image <docker image>
-m OR --manager <package manager>
--full, --name-only (passed to package manager)
```

DOES: if no search container exists, creates a new one with image, runs \<manager> search \<args><br>
MISC: give warning if using a package manager that isn't associated with the image

>dock remove [pkg]

DOES: removes container with package name
MISC: removes package from json file

>dock update [pkg]

```
OPTIONAL ARGS:
--only <image1,image2,...>
```

DOES: goes through list of images and does package manager update for each (+ upgrade)<br>
MISC: updates the WHOLE system in each container

>dock list

```
OPTIONAL ARGS:
--from-image <image>
```

DOES: lists all packages in json file
MISC: can filter by image
