# OpenRV-Dockerfile
A Dockerfile centos7 based to build OpenRV from https://github.com/AcademySoftwareFoundation/OpenRV.git

# Build OpenRV with this Dockerfile
## 1. Clone this repository
## 2. Download qt5.15.2 libs
From page https://login.qt.io/login create a free account or sign-in. In download section select qt5.15.2 for linux. 
The package is pretty heavy and it includes QtCreator, source and gcc compiled libs (the most important part for us). 
Move the installed qt5.15.2 directory into `OpenRV-Dockerfile` one.

## 3. Install Docker
https://docs.docker.com/engine/install

## 4. Build image from this Dockerfile
Build the image from the `OpenRV-Dockerfile` directory: 
```
docker build -t openrv .
```
You may have to use sudo, depending on your configuration.

## 5. Run the docker openrv image
Run and mount a volume to point the `OpenRV-Dockerfile` directory (within qt5.15.2 installation)
```
docker run -ti -v /OpenRV-Dockerfile:/rv
```

## 6. Cmake config in the image terminal
In the image's interactive terminal change dir and launch the rv's cmake config: 
```
cd ./OpenRV
cmake -B cmake-build -DRV_DEPS_QT5_LOCATION=/rv/qt-5.15.2/5.15.2/gcc_64 -DCMAKE_INSTALL_PREFIX=/rv/openrv
```
Note that we're giving the qt mounted volume to let it find the gcc libs. And choose to install it into image's `/rv/openrv` directory.

## 7. Build OpenRV
Let's build it
```
cmake --build cmake-build --target rv
```

## 8. Install OpenRV
Change dir to the cmake-build and run cmake install
```
cd ./cmake-build
cmake install
```
All the built files will be configured and copied into the image's `/rv/openrv` directory

## 9. Get your OpenRV app
Exit the image's terminal.
You should have the OpenRV app installed into `OpenRV-Dockerfile/openrv`

Enjoy.

