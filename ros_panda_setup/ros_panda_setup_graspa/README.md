# Franka Emika Panda + GRASPA docker image

This dockerfile is an attempt at packaging whatever necessary to use a Franka Emika Panda robot arm for vision-based grasp planning and execution. It also packages some utilities to allow straightforward usage of the Panda arm with the GRASPA benchmark.

## Target setup

<center>

![setup pic](https://user-images.githubusercontent.com/33027628/166487803-2f22f660-de40-445a-897a-efd16b38b830.png)

</center>

We assume a setup equipped with

- a Franka Emika robot arm (firmware version >= 4.0)
- a Franka Hand gripper
- one or more Intel Realsense cameras (mounted on the hand and on the setup)
- Franka Hand mount for the Intel Realsense camera ([Franka camera mount](https://download.franka.de/panda_camera_mount.zip))
- GRASPA layout boards ([printables](https://github.com/hsp-iit/GRASPA-benchmark/tree/master/data/scenes/grasping/printable_layouts))
- GRASPA marker cube for the Franka Hand ([printable cube and markers](https://github.com/hsp-panda/aruco_board_detect/tree/main/assets))
- a workstation where Docker 19.03+ and a Real-Time kernel are installed[1].


[1] a good guide on how to install a RT linux kernel can be found in the official [Franka Control Interface documentation](https://frankaemika.github.io/docs/installation_linux.html#setting-up-the-real-time-kernel).

## Content

This Docker image contains

- a ROS Melodic installation
- `libfranka` and our customized `franka_ros`
- MoveIt!
- a customized MoveIt! configuration for the Panda
- `librealsense2` and `realsense_ros`
- a ROS primitive server (`panda_grasp_server`)
- a ROS segmentation module (`tabletop_segment`)
- a ROS ArUCO detection module (`aruco_board_detect`).

## How to install

Either build the image locally

```shell
$ docker build -t ghcr.io/hsp-panda/ros_panda_setup_graspa:latest .
```

or just pull the image from the container registry

```shell
$ docker pull ghcr.io/hsp-panda/ros_panda_setup_graspa:latest
```

## How to run

The shell scripts provided in this directory can be used to start the GRASPA ROS pipeline in a Docker container (with GUI support through X). Make sure to adapt the arguments in the files to your own setup.

### run.sh

This brings up everything needed for benchmarking grasp planners with GRASPA. Runfile arguments are

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

### run_reachability_calibration.sh

This brings up everything needed for performing the calibration and reachability protocol for GRASPA and starts the procedure. Runfile arguments are

- `ROBOT_IP` - quite self-explanatory
- `GRASP_SERVER_CONFIG` - one of [these](https://github.com/hsp-panda/panda_grasp_server/tree/panda_graspa/config) files
- `TABLE_HEIGHT` - Z height of the table surface in the robot root reference frame. If provided, this will override what is already specified in the `GRASP_SERVER_CONFIG` file.
- `HAND_CAMERA_SERIAL` and `SETUP_CAMERA_SERIAL` - serial IDs of realsense cameras (one for the setup, one for the robot hand). Check `realsense-viewer` in order to obtain the IDs.

Refer to the [`panda_grasp_server`](https://github.com/hsp-panda/panda_grasp_server/tree/panda_graspa/README.md), [`tabletop_segment`](https://github.com/fbottarel/utility-ros-nodes/src/tabletop_segment/README.md) and [`aruco_board_detect`](https://github.com/hsp-panda/aruco_board_detect/blob/main/README.md) readmes for further instructions on usage.
