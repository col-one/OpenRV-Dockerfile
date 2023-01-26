FROM centos:7

# base deps
RUN yum -y update
RUN yum -y install wget git centos-release-scl
RUN yum-config-manager --enable rhel-server-rhscl-7-rpms
RUN yum -y install devtoolset-9
RUN yum -y install alsa-lib-devel autoconf automake \
avahi-compat-libdns_sd-devel bison bzip2-devel cmake-gui curl-devel \
flex glew-devel libXcomposite libXi-devel libaio-devel \
libffi-devel libncurses-devel libtool libxkbcommon openssl-devel \
pulseaudio-libs pulseaudio-libs-glib2 ocl-icd opencl-headers python3 \
python3-devel qt5-qtbase-devel readline-devel sqlite-devel tcl-devel \
tk-devel yasm zlib-devel meson tcsh

# graphics
RUN rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org && \
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm && \
yum -y install nvidia-detect.x86_64 && \
yum -y install $(nvidia-detect) -y && \
yum install -y opencl-headers

RUN yum -y install epel-release && \
yum -y install opencl-headers

# clone source
RUN git clone https://github.com/AcademySoftwareFoundation/OpenRV.git

# python deps
RUN python3 -m pip install -U pip setuptools
RUN cd ./OpenRV && python3 -m pip install -r requirements.txt && git submodule update --init --recursive

# enable devtools
RUN echo "source /opt/rh/devtoolset-9/enable" >> /etc/bashrc
SHELL ["/bin/bash", "--login", "-c"]

# build cmake 3.24
RUN wget https://github.com/Kitware/CMake/releases/download/v3.24.0/cmake-3.24.0.tar.gz && \
tar -zxvf cmake-3.24.0.tar.gz && cd cmake-3.24.0 && ./bootstrap --parallel=32 && make -j 32 && \
make install

# build nasm 2.15
RUN wget https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.gz && \
tar xf nasm-2.15.05.tar.gz && \
cd nasm-2.15.05 && \
./configure && \
make -j && \
make install


