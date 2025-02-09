# Dock

Dock: the most compatible package manager to exist.<br>
_see the [specification](spec.md)_

_This is a joke piece of software do not use this_
## Features

- Every package is in a different docker container
- Each package can use a different OS and package manager
- Updating packages updates the entire container
- Packages are isolated for better security

## Progress

- [x] Allow running container programs outside of docker
- [x] Save items to file
- [x] dock install
- [x] dock remove
- [x] dock update
- [x] dock list
- [x] dock search
- [ ] file system integration
- [ ] better support for multiple package managers

## Installation

Requires [Docker](https://docs.docker.com/get-docker/) (obviously)

### Linux/MacOS
```sh
curl https://raw.githubusercontent.com/Desyncfy/dock/refs/heads/main/install.sh | sh
```

### Windows
```bat
# TODO: Windows support 
```
