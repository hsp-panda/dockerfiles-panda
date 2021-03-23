# Dockerfiles
Dockerfiles and related scripts for the Panda setup

- [Why Docker?](#why-docker)
- [Terminology](#terminology)
- [Set up Docker](#set-up-docker)
- [Set up nvidia-container-runtime](#set-up-nvidia-container-runtime)
- [Set up Singularity](#set-up-singularity)
- [How to use dockerfiles on the Panda workstation](#how-to-use-dockerfiles-on-the-panda-workstation)
- [Bonus content](#bonus-content)

## Why Docker?

Docker is a virtualization platform that allows for easy development and deployment of **container images**, i.e. isolated software packages that only share the host OS kernel. This enables developers to work in a virtualized environment containing only their application, its dependencies and configuration files, that can be packaged and easily deployed. A good example of this workflow is website design: a website can be developed locally, then packaged and deployed on a hosting server.

In our case, there are a bunch of reasons to use containerization in our workflow:

- robotic applications can be developed and debugged on other machines (e.g. personal laptops) and only at the end deployed on the machine
- software for robotic applications tends to be a dependency hell. Developing a ROS package with a lot of dependencies, some of them manually compiled from source, and requiring specific configuration files is time-consuming. Packaging and deployment through container images solves this issue
- many different users can have their own workspace, install and uninstall system dependencies, or even work in different linux distributions without stepping on each other's toes
- users have the chance to customize their workspace and easily port it on the workstation without disrupting the workspace of others
- more users can work simultaneously on the same workstation
- and more.

## Terminology

- **Image** - software package containing everything needed to run your stuff. It can be generated from a Dockerfile or obtained as a snapshot of an existing container
- **Container** - instance of an image. Any number of containers can be spawned from the same image, each isolated and generally unaware of the presence of the others. You typically work on containers, not on images
- **Dockerfile** - recipe for an image. One of the ways to create images
- **Host** - the host machine (or OS, depending on context) on top of which containers are virtualized
- **Build** - create an image from a dockerfile
- **Spawn** or **Run** - create a new container from an image.

## Set up Docker

Docker is already set up on the workstation. Nonetheless, you can follow the same instructions to set it up on your own machine, so you can develop locally and then deploy on the workstation.

Docker runs on top of every recent Linux distro I've tried (Ubuntu and Ubuntu-based, Arch and Arch-based, Debian, etc.), and you can install it by following the [official Docker Engine tutorial](https://docs.docker.com/engine/install/). On Mac and Windows, I honestly have no idea. Use Linux though.

In case you are using Ubuntu 16.04, 18.04, 20.04, follow along [the official tutorial](https://docs.docker.com/engine/install/ubuntu/). For a quick reference, the main steps are:

1. Remove old versions of Docker, that used to have different names. Just in case:
```
 $ sudo apt-get remove docker docker-engine docker.io containerd runc
```
1. Set up the repository for installation as a package
```
$ sudo apt-get update
```
```
$ sudo apt-get install \
       apt-transport-https \
       ca-certificates \
       curl \
       gnupg \
       lsb-release
```
```
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
```
$ echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
1. View the available Docker Engine versions
```
$ sudo apt-get update
$ apt-cache madison docker-ce
```
1. Install the latest version of Docker Engine
```
$ sudo apt-get install docker-ce docker-ce-cli containerd.io
```
or install a specific version
```
sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io
```
1. Go through some of the [post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/) if you fancy some of these. The only mandatory step is to assign your local user to the docker sudoer group:
```
$ sudo groupadd docker
$ sudo usermod -aG docker $USER
$ newgrp docker
```
1. Verify you can run `docker` without `sudo`
```
$ docker run --rm hello-world
```

**Important**: if you are a Docker noob, please take the time to go through the [basics tutorial](https://docs.docker.com/get-started/).

## Set up nvidia-container-runtime

Thanks to the `nvidia-docker` project, you can make your nVidia GPU available to your Docker containers for things such as rendering, hardware acceleration and deep learning.

![docker-container-toolkit](https://cloud.githubusercontent.com/assets/3028125/12213714/5b208976-b632-11e5-8406-38d379ec46aa.png)

Make sure that you have an nVidia driver installed (435+). Configure the repo using the instructions at [this link](https://nvidia.github.io/nvidia-container-runtime/). On Ubuntu, you can then install `nvidia-container-runtime` using
```
$ sudo apt-get install nvidia-container-runtime
```

Verify the installation:

```
$ sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

The output should look just like running `nvidia-smi` on your host system!

```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 440.64       Driver Version: 440.64       CUDA Version: 10.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 1650    Off  | 00000000:01:00.0 Off |                  N/A |
| N/A   36C    P8     1W /  N/A |      0MiB /  3911MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```

## Set up Singularity

Working with Docker might be overwhelming for newbies. We understand. The workstation has also been equipped with an installation of [Singularity](https://github.com/hpcng/singularity), which is similar to Docker in functionality but with way less hassle. 

If you wish to install it yourself, it has to be compiled from source. The installation process is relatively easy, and instructions are provided [in the official project page](https://github.com/hpcng/singularity/blob/master/INSTALL.md). 

On Ubuntu: 

1. Set up system dependencies
```
$ sudo apt-get update && \
  sudo apt-get install -y build-essential \
  libseccomp-dev pkg-config squashfs-tools cryptsetup
```
1. Install Golang. On Ubuntu, you can simply install it from `apt`
```
$ sudo apt-get install golang-go
```
1. Decide where you want your Go environment to reside and set up your environment accordingly. For instance, we might want to install both Go and Singularity in the `/opt/` directory. This requires admin privileges, so you'll have to `sudo` some of the commands
```
$ echo 'export GOPATH=/opt/go' >> ~/.bashrc
$ echo 'export PATH=${PATH}:${GOPATH}/bin' >> ~/.bashrc
$ source ~/.bashrc
$ sudo mkdir -p ${GOPATH}/bin
```
1. (Optional) Install `golangci-lint`
```
$ sudo curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b $(go env GOPATH)/bin v1.21.0
```
1. Clone the Singularity source code and check out a stable release tag
```
$ sudo mkdir -p ${GOPATH}/src/github.com/sylabs && \
    cd ${GOPATH}/src/github.com/sylabs && \
    sudo git clone https://github.com/sylabs/singularity.git && \
    cd singularity
$ git checkout v3.7.1
```
1. Configure build and install directory for Singularity. As for Go, we are using the `/opt/` directory but you can choose whatever works for you
```
$ echo 'export SINGULARITY_PATH=/opt/singularity' >> ~/.bashrc
$ source ~/.bashrc
$ cd ${GOPATH}/src/github.com/sylabs/singularity
$ ./mconfig -b ./buildtree -p ${SINGULARITY_PATH}
```
1. Build Singularity. Depending on your CPU, this might take a while, so go get yourself a drink.
```
$ cd ${GOPATH}/src/github.com/sylabs/singularity/buildtree
$ make -j8
```
1. Install Singularity and set up your environment.
```
$ sudo make install
$ echo 'export PATH=${PATH}:${SINGULARITY_PATH}/bin' >> ~/.bashrc
$ source ~/.bashrc
```
1. Test the installation!
```
$ singularity version
3.7.1
```

On the Panda workstation, Go has been installed under `/opt/go` and Singularity under `/opt/singularity`, and their functionality are of course available to the non-root user.

## How to use dockerfiles on the Panda workstation

The GPU-equipped workstation on the Panda setup is already set up with a Docker and `nvidia-container-runtime` installation. Since you'll be only able to log in as user without administrative privileges, pretty much your only choice is to use a containerized workspace. This repository contains examples of how you can do this, that you can fork and modify as you please. For instance:

- [ros_cudagl](https://github.com/hsp-panda/dockerfiles/tree/main/ros_cudagl) - full ROS installation with built in CUDA and OpenGL sharing already enabled. Pretty much your bread and butter for building your ROS-based experiment

**Important**: please create a directory with your own name or handle under `/home/panda-user/users` and work there. Do not create directories all over the place, because there is no guarantee that anything outside of `/home/panda-user/users` will not be deleted. 

## Bonus content

If you have gotten this far, congratulations! Have yourself a cookie. And mess it up.

![cookie](https://media4.giphy.com/media/HGe4zsOVo7Jvy/200.gif)
