# ROS + Realsense Docker package

This is a simple Docker image built around the Intel Realsense SDK and ROS wrapper.

Unlike other dockerfiles in this repo, it is not meant to be operated as a development environment. It features the bare minimum to run the Realsense ROS node.

## Usage

Build the image first. At the moment, the image is about 2.5 gigs, since I haven't trimmed the fat from it yet.

```
chmod a+x build.sh run.sh
./build.sh
```

If there is no ROS master on your system yet, just run

```
$ ./run.sh
```

A ROS master will be spawned in the container, on the defalt location `http://localhost:11311`. If you already have a ROS master in the system and want the Realsense topic to be visible, simply run
```
$ ./run.sh '<HOST>'
```
where `<HOST>` is the machine running the nameserver, indicated via hostname or IP address. The prefix `http://` and suffix port `:11311` are added automatically. This happens because the `rossetip` and `rossetmaster` commands from package `ros-${ROS_DISTRO}-jsk-tools` are used!

## Usage example

```
$ ./run.sh 'iiticublap172'
```

<details>
  <summary>Click to see full output</summary>
```
$ ./run.sh 'iiticublap172'
  set ROS_IP and ROS_HOSTNAME to 192.168.100.17
  set ROS_MASTER_URI to http://iiticublap172:11311
  ... logging to /root/.ros/log/5d699324-8cb2-11eb-816a-50e085dd6dd2/roslaunch-iiticublap172-84.log
  Checking log directory for disk usage. This may take a while.
  Press Ctrl-C to interrupt
  Done checking log file disk usage. Usage is <1GB.

  started roslaunch server http://10.240.1.17:43889/

  SUMMARY
  ========

  PARAMETERS
   * /camera/realsense2_camera/accel_fps: -1
   * /camera/realsense2_camera/accel_frame_id: camera_accel_frame
   * /camera/realsense2_camera/accel_optical_frame_id: camera_accel_opti...
   * /camera/realsense2_camera/align_depth: True
   * /camera/realsense2_camera/aligned_depth_to_color_frame_id: camera_aligned_de...
   * /camera/realsense2_camera/aligned_depth_to_fisheye1_frame_id: camera_aligned_de...
   * /camera/realsense2_camera/aligned_depth_to_fisheye2_frame_id: camera_aligned_de...
   * /camera/realsense2_camera/aligned_depth_to_fisheye_frame_id: camera_aligned_de...
   * /camera/realsense2_camera/aligned_depth_to_infra1_frame_id: camera_aligned_de...
   * /camera/realsense2_camera/aligned_depth_to_infra2_frame_id: camera_aligned_de...
   * /camera/realsense2_camera/allow_no_texture_points: False
   * /camera/realsense2_camera/base_frame_id: camera_link
   * /camera/realsense2_camera/calib_odom_file:
   * /camera/realsense2_camera/clip_distance: -1.0
   * /camera/realsense2_camera/color_fps: -1
   * /camera/realsense2_camera/color_frame_id: camera_color_frame
   * /camera/realsense2_camera/color_height: -1
   * /camera/realsense2_camera/color_optical_frame_id: camera_color_opti...
   * /camera/realsense2_camera/color_width: -1
   * /camera/realsense2_camera/confidence_fps: 30
   * /camera/realsense2_camera/confidence_height: 480
   * /camera/realsense2_camera/confidence_width: 640
   * /camera/realsense2_camera/depth_fps: -1
   * /camera/realsense2_camera/depth_frame_id: camera_depth_frame
   * /camera/realsense2_camera/depth_height: -1
   * /camera/realsense2_camera/depth_optical_frame_id: camera_depth_opti...
   * /camera/realsense2_camera/depth_width: -1
   * /camera/realsense2_camera/device_type:
   * /camera/realsense2_camera/enable_accel: False
   * /camera/realsense2_camera/enable_color: True
   * /camera/realsense2_camera/enable_confidence: True
   * /camera/realsense2_camera/enable_depth: True
   * /camera/realsense2_camera/enable_fisheye1: False
   * /camera/realsense2_camera/enable_fisheye2: False
   * /camera/realsense2_camera/enable_fisheye: False
   * /camera/realsense2_camera/enable_gyro: False
   * /camera/realsense2_camera/enable_infra1: False
   * /camera/realsense2_camera/enable_infra2: False
   * /camera/realsense2_camera/enable_infra: False
   * /camera/realsense2_camera/enable_pointcloud: True
   * /camera/realsense2_camera/enable_pose: False
   * /camera/realsense2_camera/enable_sync: True
   * /camera/realsense2_camera/filters:
   * /camera/realsense2_camera/fisheye1_frame_id: camera_fisheye1_f...
   * /camera/realsense2_camera/fisheye1_optical_frame_id: camera_fisheye1_o...
   * /camera/realsense2_camera/fisheye2_frame_id: camera_fisheye2_f...
   * /camera/realsense2_camera/fisheye2_optical_frame_id: camera_fisheye2_o...
   * /camera/realsense2_camera/fisheye_fps: -1
   * /camera/realsense2_camera/fisheye_frame_id: camera_fisheye_frame
   * /camera/realsense2_camera/fisheye_height: -1
   * /camera/realsense2_camera/fisheye_optical_frame_id: camera_fisheye_op...
   * /camera/realsense2_camera/fisheye_width: -1
   * /camera/realsense2_camera/gyro_fps: -1
   * /camera/realsense2_camera/gyro_frame_id: camera_gyro_frame
   * /camera/realsense2_camera/gyro_optical_frame_id: camera_gyro_optic...
   * /camera/realsense2_camera/imu_optical_frame_id: camera_imu_optica...
   * /camera/realsense2_camera/infra1_frame_id: camera_infra1_frame
   * /camera/realsense2_camera/infra1_optical_frame_id: camera_infra1_opt...
   * /camera/realsense2_camera/infra2_frame_id: camera_infra2_frame
   * /camera/realsense2_camera/infra2_optical_frame_id: camera_infra2_opt...
   * /camera/realsense2_camera/infra_fps: -1
   * /camera/realsense2_camera/infra_height: -1
   * /camera/realsense2_camera/infra_rgb: False
   * /camera/realsense2_camera/infra_width: -1
   * /camera/realsense2_camera/initial_reset: False
   * /camera/realsense2_camera/json_file_path:
   * /camera/realsense2_camera/linear_accel_cov: 0.01
   * /camera/realsense2_camera/odom_frame_id: camera_odom_frame
   * /camera/realsense2_camera/ordered_pc: False
   * /camera/realsense2_camera/pointcloud_texture_index: 0
   * /camera/realsense2_camera/pointcloud_texture_stream: RS2_STREAM_COLOR
   * /camera/realsense2_camera/pose_frame_id: camera_pose_frame
   * /camera/realsense2_camera/pose_optical_frame_id: camera_pose_optic...
   * /camera/realsense2_camera/publish_odom_tf: True
   * /camera/realsense2_camera/publish_tf: True
   * /camera/realsense2_camera/rosbag_filename:
   * /camera/realsense2_camera/serial_no:
   * /camera/realsense2_camera/stereo_module/exposure/1: 7500
   * /camera/realsense2_camera/stereo_module/exposure/2: 1
   * /camera/realsense2_camera/stereo_module/gain/1: 16
   * /camera/realsense2_camera/stereo_module/gain/2: 16
   * /camera/realsense2_camera/tf_publish_rate: 0.0
   * /camera/realsense2_camera/topic_odom_in: camera/odom_in
   * /camera/realsense2_camera/unite_imu_method: none
   * /camera/realsense2_camera/usb_port_id:
   * /rosdistro: melodic
   * /rosversion: 1.14.10

  NODES
    /camera/
      color_rectify_color (nodelet/nodelet)
      points_xyzrgb_hw_registered (nodelet/nodelet)
      realsense2_camera (nodelet/nodelet)
      realsense2_camera_manager (nodelet/nodelet)

  auto-starting new master
  process[master]: started with pid [94]
  ROS_MASTER_URI=http://iiticublap172:11311

  setting /run_id to 5d699324-8cb2-11eb-816a-50e085dd6dd2
  process[rosout-1]: started with pid [105]
  started core service [/rosout]
  process[camera/realsense2_camera_manager-2]: started with pid [112]
  [ INFO] [1616598327.979890572]: Initializing nodelet with 12 worker threads.
  process[camera/realsense2_camera-3]: started with pid [113]
  [ INFO] [1616598328.581301990]: RealSense ROS v2.2.22
  [ INFO] [1616598328.581337252]: Built with LibRealSense v2.43.0
  [ INFO] [1616598328.581357681]: Running with LibRealSense v2.43.0
  [ INFO] [1616598328.599074739]:
  process[camera/color_rectify_color-4]: started with pid [133]
  ^C[ INFO] [1616598328.653794565]: Device with serial number 828112070068 was found.

  [ INFO] [1616598328.653822183]: Device with physical ID /sys/devices/pci0000:00/0000:00:14.0/usb2/2-1/2-1:1.0/video4linux/video0 was found.
  [ INFO] [1616598328.653832254]: Device with name Intel RealSense D435 was found.
  [ INFO] [1616598328.654166199]: Device with port number 2-1 was found.
  [ INFO] [1616598328.654184841]: Device USB type: 3.2
  [ INFO] [1616598328.655333318]: getParameters...
  [ INFO] [1616598328.702362539]: setupDevice...
  [ INFO] [1616598328.703258842]: JSON file is not provided
  [ INFO] [1616598328.703644512]: ROS Node Namespace: camera
  [ INFO] [1616598328.703987899]: Device Name: Intel RealSense D435
  [ INFO] [1616598328.704386974]: Device Serial No: 828112070068
  [ INFO] [1616598328.704678303]: Device physical port: /sys/devices/pci0000:00/0000:00:14.0/usb2/2-1/2-1:1.0/video4linux/video0
  [ INFO] [1616598328.704997610]: Device FW version: 05.12.06.00
  [ INFO] [1616598328.705009368]: Device Product ID: 0x0B07
  [ INFO] [1616598328.705022598]: Enable PointCloud: On
  [ INFO] [1616598328.705039803]: Align Depth: On
  [ INFO] [1616598328.705056176]: Sync Mode: On
  [ INFO] [1616598328.705103105]: Device Sensors:
  [ INFO] [1616598328.707391372]: Stereo Module was found.
  [ INFO] [1616598328.712838527]: RGB Camera was found.
  [ INFO] [1616598328.712867739]: (Confidence, 0) sensor isn't supported by current device! -- Skipping...
  [ INFO] [1616598328.712887469]: Add Filter: pointcloud
  [ INFO] [1616598328.713483605]: num_filters: 1
  [ INFO] [1616598328.713500430]: Setting Dynamic reconfig parameters.
  [ INFO] [1616598328.828848590]: Done Setting Dynamic reconfig parameters.
  [ INFO] [1616598328.830034041]: depth stream is enabled - width: 848, height: 480, fps: 30, Format: Z16
  [ INFO] [1616598328.831199113]: color stream is enabled - width: 640, height: 480, fps: 30, Format: RGB8
  [ INFO] [1616598328.834351158]: setupPublishers...
  [ INFO] [1616598328.838721221]: Expected frequency for depth = 30.00000
  [ INFO] [1616598328.869343689]: Expected frequency for color = 30.00000
  [ INFO] [1616598328.883772142]: Expected frequency for aligned_depth_to_color = 30.00000
  [ INFO] [1616598328.895302589]: setupStreams...
  [ INFO] [1616598328.896135735]: insert Depth to Stereo Module
  [ INFO] [1616598328.896163489]: insert Color to RGB Camera
  [ INFO] [1616598328.954701112]: SELECTED BASE:Depth, 0
  [ INFO] [1616598328.974828254]: RealSense Node Is Up!

```

</details>

## Integrating the Realsense in your Dockerfile

You can integrate the Realsense functionality in your Dockerfile pretty easily. Just mount the `/dev/` directory inside your Docker container by adding the `--volume=/dev:/dev` argument to your `docker run` command. Then, just install the Realsense SDK and ROS wrapper as you normally would.
