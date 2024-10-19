#!/bin/bash

# Enable error handling
set -e

# Variables
NUM_CORES=$(nproc)
INSTALL_DIR="/usr/local"
PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"
LD_LIBRARY_PATH="/usr/local/lib"

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo "Please run as root (use sudo)"
        exit 1
    fi
}

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
    # Configure FFmpeg
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
        --enable-libavdevice \
        --enable-libavfilter \
        --enable-libavformat \
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
    make distclean
}

# Function to update system's dynamic linker configuration
update_library_links() {
    # Create config file for FFmpeg libraries
    echo "$INSTALL_DIR/lib" > /etc/ld.so.conf.d/ffmpeg.conf
    ldconfig

    # Update environment variables
    echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:\$LD_LIBRARY_PATH" >> /etc/profile
    echo "export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:\$PKG_CONFIG_PATH" >> /etc/profile
}

# Main installation process
main() {
    check_root
    
    echo "Installing dependencies..."
    install_dependencies
    
    echo "Compiling and installing FFmpeg..."
    compile_ffmpeg
    
    echo "Updating library configuration..."
    update_library_links
    
    # Verify installation
    echo "Verifying installation..."
    ffmpeg -version
    
    echo "FFmpeg installation completed successfully!"
    echo "Please run: source /etc/profile or restart your shell to update environment variables"
}

# Run the installation
main

# #!/bin/bash

# # Enable error handling
# set -e

# # Variables
# NUM_CORES=$(nproc)  # Automatically use all available CPU cores for compilation

# # Step 1: Navigate to the FFmpeg source directory (assumes script is run from inside the ffmpeg folder)
# echo "Configuring FFmpeg with desired options..."

# # Step 2: Install dependencies on Ubuntu
# echo "Installing dependencies on Ubuntu..."
# apt-get update
# apt-get install -y pkg-config libx264-dev libmp3lame-dev libopus-dev libvpx-dev libavcodec-extra

# # Step 3: Configure FFmpeg with provided options for dynamic linking
# ./configure \
#   --extra-cflags="-I/usr/local/include" \
#   --extra-ldflags="-L/usr/local/lib" \
#   --extra-libs="-lpthread -lm" \
#   --enable-gpl \
#   --enable-nonfree \
#   --enable-libx264 \
#   --enable-libmp3lame \
#   --enable-libopus \
#   --enable-libvpx \
#   --enable-filter=xfade \
#   --disable-static \
#   --enable-shared \
#   --disable-debug \
#   --disable-doc \
#   --disable-programs \
#   --disable-ffplay \
#   --enable-encoder=libx264,aac,mp3,opus,libvpx \
#   --enable-decoder=libx264,aac,mp3,opus,libvpx \
#   --enable-muxer=mp4,matroska,webm,ogg \
#   --enable-demuxer=mp4,matroska,webm,ogg \
#   --enable-ffmpeg \
#   --enable-ffprobe \
#   --enable-libavdevice \
#   --enable-libavfilter \
#   --enable-libavformat \
#   --arch=$(uname -m) \
#   --target-os=linux

# # Step 4: Compile FFmpeg using all available CPU cores
# echo "Compiling FFmpeg..."
# make -j$NUM_CORES

# # Step 5: Install FFmpeg and FFprobe binaries to the system
# echo "Installing FFmpeg..."
# make install

# # Completion message
# echo "FFmpeg has been successfully installed."

