# Franka Emika Panda + GRASPA docker image

This dockerfile is an attempt at packaging whatever necessary to use a Franka Emika Panda robot arm for vision-based grasp planning and execution.

## Target setup

<center>

![setup picture](https://i0.wp.com/dronebotworkshop.com/wp-content/uploads/2016/01/robot2-e1504969973917.png?resize=346%2C346)

</center>

We assume a setup equipped with

- a Franka Emika robot arm (firmware version >= 4.0)
- a Franka Hand gripper
- one or more Intel Realsense cameras (mounted on the hand and on the setup)
- Franka Hand mount for the Intel Realsense camera (PROVIDE LINK)
- a workstation where Docker 19.03+ and a Real-Time kernel are installed[1].


[1] a good guide on how to install a RT linux kernel can be found in the official [Franka Control Interface documentation](https://frankaemika.github.io/docs/installation_linux.html#setting-up-the-real-time-kernel).

## Content

This Docker image contains

- a ROS Melodic installation
- `libfranka` and our customized `franka_ros`
- MoveIt!
- a customized MoveIt! configuration for the Panda
- `librealsense2` and `realsense_ros`
- a ROS primitive server (`panda_grasp_server`).

## How to install

Either build the image locally

```shell
$ docker build -t ghcr.io/hsp-panda/ros_panda_setup:latest .
```

or just pull the image from the container registry

```shell
$ docker pull ghcr.io/hsp-panda/ros_panda_setup:latest
```

## How to run

The `run.sh` file provides a script to start the ROS pipeline in a Docker container (with GUI support through X). Make sure to adapt the arguments in the file to your own setup:

- `ROBOT_IP` - quite self-explanatory
- `GRASP_SERVER_CONFIG` - one of [these](https://github.com/hsp-panda/panda_grasp_server/tree/panda_graspa/config) files
- `TABLE_HEIGHT` - Z height of the table surface in the robot root reference frame. If provided, this will override what is already specified in the `GRASP_SERVER_CONFIG` file.

Start the pipeline with

```shell
$ ./run.sh
```

and open shells in it with

```shell
$ docker exec -it <container name> bash
```

Refer to the [`panda_grasp_server`](https://github.com/hsp-panda/panda_grasp_server/tree/panda_graspa/README.md) readme for further instructions on usage.