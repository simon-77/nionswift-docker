# nionswift-docker
Dockerfile for running Nion Swift GUI as docker container

## Nion Swift
<https://nionswift.readthedocs.io/en/stable/index.html>
The aim of this docker image is to run **Nion Swift** on a desktop computer without the need to install Nion Swift with all its python dependencies.
Instead only **docker** and the **X Window System** (Gnome, KDE, Xfce, ...) are required to be installed.

Visualizing, processing and analyzing Nion Swift projects is the main purpose of this docker container.

## Docker
Docker is used to encapsulate the Nion Swift software and all its dependencies from the host operating system. As Nion Swift uses a GUI and modifies local data, a few special setting have to be applied for running this container:

### GUI
The *X Window System* of the host is used for displaying all GUI elements.

Therefore the corresponding socket is mapped from the host to the docker container and on startup the docker container will authenticate the host X server via *xauth* utility.

### Project Directory
Changes made to the project directory (containing the `*.nsproj` file) should be persistent - in contrast to a docker container.

Therefore a bind mount is used to map the project directory of the host into the docker container

### User
The docker container will use a "normal" user with UID 1000 to avoid permission issues while working inside the project directory of the host.

The UID of this user could be altered in the *Dockerfile* to match the UID of your local user.

## Build Docker Image
To build the docker image on your computer, download this repository and run the following command inside the extracted folder:
```
$ docker image build -t nionswift .
```

## Run Docker Container

To run a container instance of the previously build docker image while making the current directory (project directory) available to the docker container:
```
$ docker container run --net=host -e XAUTH_HOST="$(xauth list $DISPLAY)" -e DISPLAY -v /tmp/.X11-unix -v $(pwd):/home/nion/Documents --rm nionswift
```

### Explaining container run options
- `--net=host` - required for the X server authentication
- `-e XAUTH_HOST="$(xauth list $DISPLAY)" -e DISPLAY` - export environment variables for authenticating the X server
- `-v /tmp/.X11-unix` - map the socket of the X Window System from the host to the docker container
- `-v $(pwd):/home/nion/Documents` - map current directory into docker container with read and write access
- `--rm` - automatically remove container when it exits

### Limitations
The Nion Swift configuration directory is inside the container and therefore no persistent changes to Nions Swift settings are possible that outlast the lifespan of the container.

If desired, one could easily map the relevant configuration directories of Nion Swift to persistent docker volumes.



# Issues

## New GUI element won't show up immediately
The first interactive window after starting the container is titled "Choose Project". This window does not show up by its own.

Workaround:
You have to switch to any other window temporarily for the new window to shows up on your host OS GUI.
