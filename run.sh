# #!/bin/bash

# # Create output directory if it doesn't exist
# mkdir -p outputs

# # Input files (you can replace image.mp4 with your input video files)
# input1="input1.mp4"
# input2="input2.mp4"

# # Transition options
# transitions=(
#     "custom"
#     "fade"
#     "wipeleft"
#     "wiperight"
#     "wipeup"
#     "wipedown"
#     "slideleft"
#     "slideright"
#     "slideup"
#     "slidedown"
#     "circlecrop"
#     "rectcrop"
#     "distance"
#     "fadeblack"
#     "fadewhite"
#     "radial"
#     "smoothleft"
#     "smoothright"
#     "smoothup"
#     "smoothdown"
#     "circleopen"
#     "circleclose"
#     "vertopen"
#     "vertclose"
#     "horzopen"
#     "horzclose"
#     "dissolve"
#     "pixelize"
#     "diagtl"
#     "diagtr"
#     "diagbl"
#     "diagbr"
#     "hlslice"
#     "hrslice"
#     "vuslice"
#     "vdslice"
#     "hblur"
#     "fadegrays"
#     "wipetl"
#     "wipetr"
#     "wipebl"
#     "wipebr"
#     "squeezeh"
#     "squeezev"
#     "zoomin"
#     "fadefast"
#     "fadeslow"
#     "hlwind"
#     "hrwind"
#     "vuwind"
#     "vdwind"
#     "coverleft"
#     "coverright"
#     "coverup"
#     "coverdown"
#     "revealleft"
#     "revealright"
#     "revealup"
#     "revealdown"
# )

# # Duration and offset settings
# duration=2
# offset=1
# easing="cubic-in-out"

# # Loop over each transition and apply it
# for transition in "${transitions[@]}"; do
#     output_file="outputs/${transition}.mp4"
#     echo "Processing transition: ${transition} -> ${output_file}"
    
#     # Run the ffmpeg command
#     ./ffmpeg -i "$input1" -i "$input2" -filter_complex "
#         xfade=duration=${duration}:offset=${offset}:easing=${easing}:transition=${transition}
#         " "$output_file" -y
# done

# echo "All transitions processed and saved in the 'outputs' folder."
# ==================
#!/bin/sh

# # Input video
# input_video="long.mp4"

# # Define start times
# start_time1=0
# start_time2=10
# start_time3=20
# start_time4=30
# start_time5=40

# # Extract 5 parts, each of 3 seconds, with re-encoding for accurate cuts
# ffmpeg -ss $start_time1 -i "$input_video" -t 3 -c:v libx264 -c:a aac "input1.mp4" -y
# ffmpeg -ss $start_time2 -i "$input_video" -t 3 -c:v libx264 -c:a aac "input2.mp4" -y
# ffmpeg -ss $start_time3 -i "$input_video" -t 3 -c:v libx264 -c:a aac "input3.mp4" -y
# ffmpeg -ss $start_time4 -i "$input_video" -t 3 -c:v libx264 -c:a aac "input4.mp4" -y
# ffmpeg -ss $start_time5 -i "$input_video" -t 3 -c:v libx264 -c:a aac "input5.mp4" -y
# echo "Extraction complete!"

# ==============================
##!/bin/bash

# Create output directory if it doesn't exist
# Working Iteration 1
# mkdir -p outputs

# # Input files (all images in the folder 'images/')
# transition="gl_perlin"
# input_dir="images"
# output_file="outputs/output_combined.mp4"
# duration=1  # Transition duration (1 second for transition between images)
# image_display_duration=3  # Display each image for 3 seconds

# # Build the input string for ffmpeg (for 10 images)
# inputs=""
# for i in {1..10}; do
#     inputs+="-loop 1 -t $((image_display_duration + duration)) -i ${input_dir}/abc${i}.jpg "
# done

# # Build the filter_complex string for transitions between all 10 images
# filter_complex=""
# for i in {0..9}; do
#     filter_complex+="[$i:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,setsar=1,format=yuv420p[v$i];"
# done

# filter_complex+="[v0][v1]xfade=transition=$transition:duration=$duration:offset=$image_display_duration,format=yuv420p[v01];"
# for i in {2..9}; do
#     prev="v$((i-2))$((i-1))"
#     current="v$i"
#     out="v$((i-1))$i"
#     filter_complex+="[$prev][$current]xfade=transition=$transition:duration=$duration:offset=$((image_display_duration*(i-1))),format=yuv420p[$out];"
# done

# # Remove the last semicolon from filter_complex
# filter_complex=${filter_complex%?}

# # Calculate total duration
# total_duration=$((10 * image_display_duration + 9 * duration))

# # Run ffmpeg with the generated filter graph
# ./ffmpeg $inputs -filter_complex "$filter_complex" -map "[v89]" -c:v libx264 -pix_fmt yuv420p -t $total_duration -y "$output_file" -y

# echo "Video with transitions saved as: ${output_file}"

# ==============================
#!/bin/bash

# Create output directory if it doesn't exist
# Create output directory if it doesn't exist
mkdir -p outputs

# Input files (all images in the folder 'images/')
transition="DISSOLVE"
input_dir="images"
output_file="outputs/output_combined.mp4"
duration=1  # Transition duration (1 second for transition between images)
image_display_duration=3  # Display each image for 3 seconds

# Build the input string for ffmpeg (for 10 images)
inputs=""
for i in {1..10}; do
    inputs+="-loop 1 -t $((image_display_duration + duration)) -i ${input_dir}/abc${i}.jpg "
done

# Build the filter_complex string for transitions between all 10 images
filter_complex=""

# Scale and pad each image
for i in {0..9}; do
    filter_complex+="[$i:v]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,setsar=1,format=yuv420p[v$i];"
done

# Add transitions
for i in {0..8}; do
    filter_complex+="[v$i][v$((i+1))]xfade=transition=$transition:duration=$duration:offset=$((image_display_duration * (i + 1))),format=yuv420p[v$((i+1))];"
done

# Final output should refer to the last transition's output
filter_complex=${filter_complex%?}  # Remove the last semicolon

# Run ffmpeg with the generated filter graph
./ffmpeg $inputs -filter_complex "$filter_complex" -map "[v9]" -c:v libx264 -pix_fmt yuv420p -t $((10 * image_display_duration + 9 * duration)) -y "$output_file"

echo "Video with transitions saved as: ${output_file}"
