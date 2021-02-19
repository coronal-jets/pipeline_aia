pro pipeline_aia_dir_tree, work_dir, config, aia_dir_cache, event_rel, aia_wave_sel_rel, objects_rel, vis_data_rel, vis_data_wave_rel, cache_dir = cache_dir, method = method

;time = stregex(config.tstart,'([0-9]+)-([0-9]+)-([0-9]+) ([0-9]+):([0-9]+):*([0-9]*)',/subexpr,/extract)
;if time[6] eq '' then time[6] = '00' 
;time_rel = time[1] + time[2] + time[3] + '_' + time[4] + time[5] + time[6]
;time = stregex(config.tstop,'([0-9]+)-([0-9]+)-([0-9]+) ([0-9]+):([0-9]+):*([0-9]*)',/subexpr,/extract)
;if time[6] eq '' then time[6] = '00' 
;time_rel = time_rel + '_' + time[1] + time[2] + time[3] + '_' + time[4] + time[5] + time[6]

time = anytim(config.tstart, out_style = 'UTC_EXT')
time_rel = string(time.year,FORMAT = '(I04)') + string(time.month,FORMAT='(I02)') + string(time.day,FORMAT='(I02)') + '_' $
         + string(time.hour,FORMAT = '(I02)') + string(time.minute,FORMAT='(I02)') + string(time.second,FORMAT='(I02)')
time = anytim(config.tstop, out_style = 'UTC_EXT')
time_rel += '_' + string(time.year,FORMAT = '(I04)') + string(time.month,FORMAT='(I02)') + string(time.day,FORMAT='(I02)') + '_' $
                + string(time.hour,FORMAT = '(I02)') + string(time.minute,FORMAT='(I02)') + string(time.second,FORMAT='(I02)')

event_rel = time_rel $
    + '_' + strcompress(fix(config.xc),/remove_all) + '_' + strcompress(fix(config.yc),/remove_all) $ 
    + '_' + strcompress(fix(config.wpix),/remove_all) + '_' + strcompress(fix(config.hpix),/remove_all) 

if keyword_set(cache_dir) then begin
    aia_dir_cache = cache_dir
endif else begin
    global_rel = 'global_cache'
    aia_dir_cache = work_dir + path_sep() + global_rel
end
file_mkdir, aia_dir_cache

event_dir = work_dir + path_sep() + event_rel
file_mkdir, event_dir

if (n_elements(method) > 0) && (method eq 0) then smeth = '_m0' else smeth = '_m1'

aia_dir_rel = event_rel + path_sep() + 'aia_data'
file_mkdir, work_dir + path_sep() + aia_dir_rel
objects_rel = event_rel + path_sep() + 'objects' + smeth
objects = work_dir + path_sep() + objects_rel
file_mkdir, objects 
vis_data_rel = event_rel + path_sep() + 'visual_data' + smeth
vis_data = work_dir + path_sep() + vis_data_rel
file_mkdir, vis_data

aia_wave_sel_rel = strarr(n_elements(config.waves))
vis_data_wave_rel = strarr(n_elements(config.waves))
foreach wavelength, config.waves, i do begin
    strwav = strcompress(fix(wavelength),/remove_all)
    aia_wave_sel_rel[i] = aia_dir_rel + path_sep() + strwav
    aia_wave_sel = work_dir + path_sep() + aia_wave_sel_rel[i]
    file_mkdir, aia_wave_sel 
    vis_data_wave_rel[i] = vis_data_rel + path_sep() + strwav
    vis_data_wave = work_dir + path_sep() + vis_data_wave_rel[i]
    file_mkdir, vis_data_wave
endforeach 

end
