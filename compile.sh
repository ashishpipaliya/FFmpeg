#!/bin/bash

# Variables
PREFIX_DIR="../ffmpeg-redistributable"  # Directory for the redistributable build
TARBALL_NAME="ffmpeg-redistributable.tar.gz"  # Output tarball name
NUM_CORES=$(nproc)  # Automatically use all available CPU cores for compilation
OUTPUT_DIR=$(pwd)  # Get the current directory to ensure correct tarball creation

# Step 1: Navigate to the FFmpeg source directory (assumes script is run from inside ffmpeg folder)
echo "Configuring FFmpeg with desired options..."

# Step 2: Configure FFmpeg with provided options
./configure \
  --pkg-config-flags="--static" \
  --extra-cflags="-I/usr/local/include" \
  --extra-ldflags="-L/usr/local/lib" \
  --extra-libs="-lpthread -lm" \
  --enable-gpl \
  --enable-nonfree \
  --enable-libx264 \
  --enable-libfdk-aac \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvpx \
  --enable-filter=xfade \
  --enable-static \
  --disable-shared \
  --disable-debug \
  --disable-doc \
  --disable-programs \
  --disable-ffplay

# Step 3: Compile FFmpeg using all available CPU cores
echo "Compiling FFmpeg..."
make -j$NUM_CORES

# Step 4: Create a directory for the redistributable FFmpeg build
echo "Creating redistributable directory: $PREFIX_DIR"
mkdir -p $PREFIX_DIR

# Step 5: Copy the FFmpeg and FFprobe binaries to the redistributable folder
echo "Copying binaries to $PREFIX_DIR"
cp ffmpeg $PREFIX_DIR/
cp ffprobe $PREFIX_DIR/

# Step 6: Create a tarball for easier distribution
echo "Packaging redistributable build into $TARBALL_NAME"
cd ..
tar -czvf $OUTPUT_DIR/$TARBALL_NAME ffmpeg-redistributable

# Completion message
if [ -f "$OUTPUT_DIR/$TARBALL_NAME" ]; then
    echo "FFmpeg redistributable build is now packaged as $TARBALL_NAME"
else
    echo "Error: Failed to create $TARBALL_NAME"
fi
