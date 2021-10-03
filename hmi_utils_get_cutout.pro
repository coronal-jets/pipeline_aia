pro hmi_utils_get_cutout, from, to, x, y, width, height, hmi_dir, cadence = cadence, fps = fps

if n_elements(cadence) eq 0 then cadence = 720d
if n_elements(fps) eq 0 then fps = 5

file_mkdir, hmi_dir

fitsdir = hmi_dir + path_sep() + 'hmi_data'
hmi_utils_download_cutout, from, to, x, y, width, height, fitsdir, cadence = cadence

visdir = hmi_dir + path_sep() + 'visual_data'
file_mkdir, visdir 

files_in_all = file_search(filepath('*.fits', root_dir = fitsdir))

windim = [1000, 1000]
foreach fits, files_in_all, i do begin
    hmi_utils_get_image, fits, win, windim
    outfile = visdir + path_sep() + 'hmi' + string(i, FORMAT = '(I05)') + '.png'
    win.Save, outfile, width = windim[0], height = windim[1], bit_depth = 2
    win.Close
endforeach

to_filename = visdir + path_sep() + 'video.mp4'
hmi_mask = visdir + path_sep() + 'hmi%05d.png'
asu_make_movie_by_frames, hmi_mask, to_filename, fps = fps

end
