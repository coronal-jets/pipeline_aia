pro pipeline_aia_make_movie_by_frames, prefix, from_dir, to_filename, fps = fps

if ~keyword_set(fps) then fps = 5

ffmpegpath = file_dirname((ROUTINE_INFO('pipeline_aia_make_movie', /source)).path, /mark)
aia_mask = from_dir + path_sep() + prefix + '_aia%05d.png'  
cmd = ffmpegpath + 'ffmpeg.exe -framerate ' + strcompress(long(fps),/remove_all) $
      + ' -i ' + aia_mask $
      + ' -y -vf scale="trunc(iw/2)*2:trunc(ih/2)*2" -c:v libx264 -profile:v high -pix_fmt yuv420p ' $
      + to_filename
print, cmd

spawn, cmd
  
;; ffmpeg -f image2 -framerate 30 -i lin_%05d.png foo.mp4

end
