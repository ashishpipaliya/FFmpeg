#!/bin/bash

# Enable error handling
set -e

# Variables
NUM_CORES=$(nproc)
INSTALL_DIR="/usr/local"
PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"
LD_LIBRARY_PATH="/usr/local/lib"

# Function to install dependencies
install_dependencies() {
    apt-get update
    apt-get install -y \
        autoconf \
        automake \
        build-essential \
        cmake \
        git-core \
        libass-dev \
        libfreetype6-dev \
        libgnutls28-dev \
        libmp3lame-dev \
        libsdl2-dev \
        libtool \
        libva-dev \
        libvdpau-dev \
        libvorbis-dev \
        libxcb1-dev \
        libxcb-shm0-dev \
        libxcb-xfixes0-dev \
        meson \
        ninja-build \
        pkg-config \
        texinfo \
        yasm \
        zlib1g-dev \
        libx264-dev \
        libopus-dev \
        libvpx-dev \
        libavcodec-extra \
        nasm
}

# Function to configure and compile FFmpeg
compile_ffmpeg() {
    ./configure \
        --prefix="$INSTALL_DIR" \
        --extra-cflags="-I$INSTALL_DIR/include" \
        --extra-ldflags="-L$INSTALL_DIR/lib" \
        --extra-libs="-lpthread -lm" \
        --bindir="$INSTALL_DIR/bin" \
        --enable-gpl \
        --enable-nonfree \
        --enable-libx264 \
        --enable-libmp3lame \
        --enable-libopus \
        --enable-libvpx \
        --enable-filter=xfade \
        --enable-shared \
        --disable-static \
        --disable-debug \
        --enable-ffmpeg \
        --enable-ffprobe \
        --enable-avdevice \
        --enable-avfilter \
        --enable-avformat \
        --enable-pic \
        --enable-encoder=libx264,aac,mp3,opus,libvpx \
        --enable-decoder=libx264,aac,mp3,opus,libvpx \
        --enable-muxer=mp4,matroska,webm,ogg \
        --enable-demuxer=mp4,matroska,webm,ogg \
        --arch="$(uname -m)" \
        --target-os=linux

    # Compile
    make -j"$NUM_CORES"
    make install
    ldconfig
}

# Main installation process
echo "Installing dependencies..."
install_dependencies

echo "Compiling and installing FFmpeg..."
compile_ffmpeg

echo "Verifying installation..."
ffmpeg -version

echo "FFmpeg installation completed successfully!"