FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

# Following
# developer.nvidia.com/blog/updating-the-cuda-linux-gpg-repository-key

ENV DEBIAN_FRONTEND=noninteractive

# Fix GPG issues with the cudagl images
RUN apt-key del 7fa2af80 && \
    rm /etc/apt/sources.list.d/cuda.list && \
    rm /etc/apt/sources.list.d/nvidia-ml.list

RUN apt-get update && \
    apt-get install -y wget && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb

RUN rm cuda-keyring_1.0-1_all.deb && \
    apt-get update && \
    apt-get remove -y wget && \
    rm -rf rm -rf /var/lib/apt/lists/*