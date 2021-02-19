pro hmi_utils_download_full_by_list, list, hmi_dir

file_mkdir, hmi_dir

time_window  = 720d

for k = 0, n_elements(list)-1 do begin
    t_ = anytim(list[k])
    t1 = t_ - time_window / 2d
    t2 = t_ + time_window / 2d
    file = gx_box_jsoc_get_fits(t1, t2, 'hmi.M_720s', 'magnetogram', hmi_dir)
endfor

end
