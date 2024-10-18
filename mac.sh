#!/bin/bash

# Enable error handling
set -e

# Variables
NUM_CORES=$(sysctl -n hw.ncpu)  # Automatically use all available CPU cores for compilation

# Step 1: Navigate to the FFmpeg source directory (assumes script is run from inside ffmpeg folder)
echo "Configuring FFmpeg with desired options..."

# Step 2: Install dependencies using Homebrew
echo "Installing dependencies..."
brew install pkg-config
brew install x264 fdk-aac lame opus libvpx

# Step 3: Configure FFmpeg with provided options for dynamic linking
./configure \
  --extra-cflags="-I/opt/homebrew/include" \
  --extra-ldflags="-L/opt/homebrew/lib" \
  --extra-libs="-lpthread -lm" \
  --enable-gpl \
  --enable-nonfree \
  --enable-libx264 \
  --enable-libfdk-aac \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvpx \
  --enable-filter=xfade \
  --disable-static \
  --enable-shared \
  --disable-debug \
  --disable-doc \
  --disable-programs \
  --disable-ffplay \
  --enable-encoder=libx264,aac,mp3,opus,libvpx \
  --enable-decoder=libx264,aac,mp3,opus,libvpx \
  --enable-muxer=mp4,matroska,webm,ogg \
  --enable-demuxer=mp4,matroska,webm,ogg \
  --enable-ffmpeg \
  --enable-ffprobe \
  --arch=arm64 \
  --target-os=darwin

# Step 4: Compile FFmpeg using all available CPU cores
echo "Compiling FFmpeg..."
make -j$NUM_CORES

# Step 5: Install FFmpeg and FFprobe binaries to the system
echo "Installing FFmpeg..."
sudo make install

# Completion message
echo "FFmpeg has been successfully installed."