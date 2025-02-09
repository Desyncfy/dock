# Dock

Dock: the most compatible package manager to exist.<br>
_see the [specification](spec.md)_

_This is a joke piece of software do not use this_
## Features

- Every package is in a different docker container
- Each package can use a different OS and package manager
- Updating packages updates the entire container
- Packages are isolated for better security
- All packages are kept track of in a json file so if you manually delete a package it will error on update 

## Progress

- [ ] Allow running container programs outside of docker
- [ ] Save items to json file
- [x] dock install
- [ ] dock remove
- [ ] dock update
- [ ] dock list
- [ ] dock search
