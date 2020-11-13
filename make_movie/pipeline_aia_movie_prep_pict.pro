pro l_pipeline_aia_movie_get_scale, x, y, ind, xstep, xshift, ystep, yshift

xstep = ind.CDELT1
ystep = ind.CDELT2
 
xshift = (x - ind.CRPIX1)*ind.CDELT1 + ind.CRVAL1 
yshift = (y - ind.CRPIX2)*ind.CDELT2 + ind.CRVAL2 

end

pro pipeline_aia_movie_prep_pict, work_dir, obj_dir, wave, aia_dir_wave_sel, vis_data_dir_wave, details, config_file = config_file, no_save_empty = no_save_empty

pipeline_aia_read_down_config, config, config_file = config_file 
prefix = pipeline_aia_get_vis_prefix(config_file = config_file)

files_in = file_search(filepath('*.fits', root_dir = work_dir + path_sep() + aia_dir_wave_sel))
cand_mask = strcompress(fix(wave),/remove_all) + '.sav'
file_cand = file_search(filepath(cand_mask, root_dir = work_dir + path_sep() + obj_dir))
curr_seq = !NULL
pos0 = -1
aia_lim = !NULL
rdf_lim = !NULL
if file_cand eq '' then begin
    message, /info, "wave " + strcompress(wave,/remove_all) + " - no candidate file!"
    return 
endif else begin
    restore, file_cand
    if found_candidates.IsEmpty() then begin
        message, /info, "wave " + strcompress(wave,/remove_all) + " - no candidates!"
        if keyword_set(no_save_empty) then return
    endif
endelse

l_pipeline_aia_movie_get_scale, 0, 0, ind_seq[0], xstep, xshift, ystep, yshift

pipeline_aia_get_colormaps, wave, aia_lim, cm_aia, rdf_lim, cm_run_diff
 
data_prev = !NULL
;win = window(dimensions = [1000, 500])

;Use Z-buffer for generating plots
set_plot,'Z'
device,set_resolution = [1000,500], set_pixel_depth = 24, decomposed =0
!p.color = 0
!p.background = 255
!p.charsize=1.5

ctrl =0.
n_files = n_elements(files_in)
foreach file_in, files_in, i do begin
    read_sdo_silent, file_in, index, data, /use_shared, /uncomp_delete, /hide, /silent 
    rtitle = ''
    if data_prev ne !NULL then begin
        pos = i-1 ; position in run_diff
        pipeline_aia_irc_run_diff, data, data_prev, rd
        sz = size(rd)
        jet = dblarr(sz[1], sz[2])
        rtitle = ''
        for k = 0, n_elements(found_candidates)-1 do begin
            cand = found_candidates[k]
            for j = 0, n_elements(cand)-1 do begin
                snap = cand[j]
                if snap.pos eq pos then begin
                    card = n_elements(snap.x)
                    rtitle += ' ' + strcompress(card,/remove_all)
                    for n = 0, card-1 do begin
                        jet(snap.x[n], snap.y[n]) = 1
                    endfor
                endif    
            endfor
        endfor
        
        jtitle = str_replace(str_replace(index.t_obs, 'T', ' '), 'Z', '')
        ;win.Erase
        erase
        if double(i)/n_files*100d gt ctrl then begin
            message, 'Preparing movie , ' + strcompress(ctrl,/remove_all) + '%',/info
            ctrl += 5 
        endif
        pipeline_aia_movie_draw, data, rd, jet, win, jtitle, rtitle, xstep, xshift,$
           ystep, yshift, aia_lim, cm_aia, rdf_lim, cm_run_diff, wave = wave
        pngfile =  work_dir + path_sep() + vis_data_dir_wave + path_sep() + prefix + "_aia" + string(i, FORMAT = '(I05)') + ".jpg"
        ;write_png, pngfile, TVRD(/TRUE)
        if ~keyword_set(nosave) then write_jpeg, pngfile, tvrd(true=1), true =1, quality =100 
    endif
    data_prev = data
endforeach
;win.Close


frames_prev = 6
frames_post = 3
expandk = 1.4
minview = 15

details = list()
for k = 0, n_elements(found_candidates)-1 do begin
    cand = found_candidates[k]
    nc = n_elements(cand)
    xbox = !NULL
    ybox = !NULL
    for j = 0, nc-1 do begin
        snap = cand[j]
        if xbox eq !NULL then begin
            xbox = intarr(2)
            ybox = intarr(2)
            xbox[0] = min(snap.x)
            xbox[1] = max(snap.x)
            ybox[0] = min(snap.y)
            ybox[1] = max(snap.y)
        endif  
        xbox[0] = min([xbox[0], min(snap.x)])
        xbox[1] = max([xbox[1], max(snap.x)])
        ybox[0] = min([ybox[0], min(snap.y)])
        ybox[1] = max([ybox[1], max(snap.y)])
    endfor
    dx = xbox[1]-xbox[0]
    xexpand = fix(max([minview, dx*expandk])/2d)
    xbox[0] = max([0, xbox[0]-xexpand])  
    xbox[1] = min([ind_seq[0].naxis1-1, xbox[1]+xexpand])  
    dy = ybox[1]-ybox[0]
    yexpand = fix(max([minview, dy*expandk])/2d)
    ybox[0] = max([0, ybox[0]-yexpand])  
    ybox[1] = min([ind_seq[0].naxis2-1, ybox[1]+yexpand])  
    
    l_pipeline_aia_movie_get_scale, xbox[0], ybox[0], ind_seq[0], xstep, xshift, ystep, yshift
    from = max([1, cand[0].pos-frames_prev])
    to = min([cand[nc-1].pos+frames_post, n_elements(files_in)-1])
    data_prev = !NULL

    detname = "detail" + string(k+1, FORMAT = '(I02)')
    details.Add, detname 
    vis_data_wave_add = work_dir + path_sep() + vis_data_dir_wave + path_sep() + detname
    file_mkdir, vis_data_wave_add
    ctrl =0.
    n_files = n_elements(to - from+1)
    for i = from, to do begin
        file_in = files_in[i]
        read_sdo_silent, file_in, index, data0, /use_shared, /uncomp_delete
        if data_prev ne !NULL then begin
            pos = i-1 ; position in run_diff
            pipeline_aia_irc_run_diff, data0, data_prev, rd
            data = data0[xbox[0]:xbox[1], ybox[0]:ybox[1]]
            rd = rd[xbox[0]:xbox[1], ybox[0]:ybox[1]]
            sz = size(rd)
            jet = dblarr(sz[1], sz[2])
            rtitle = ''
            snap = !NULL
            for jc = 0, nc-1 do begin
                if pos eq cand[jc].pos then begin
                    snap = cand[jc]
                    break
                endif  
            endfor  
            if snap ne !NULL then begin
                card = n_elements(snap.x)
                rtitle = strcompress(card,/remove_all)
                for n = 0, card-1 do begin
                    jet(snap.x[n]-xbox[0], snap.y[n]-ybox[0]) = 1
                endfor
            endif
            
            jtitle = str_replace(str_replace(index.t_obs, 'T', ' '), 'Z', '')
            erase
            if double(i - from)/n_files*100d gt ctrl then begin
              message, 'Preparing movie , ' + strcompress(ctrl,/remove_all) + '%',/info
              ctrl += 5
            endif
            pipeline_aia_movie_draw, data, rd, jet, win, jtitle, rtitle, xstep, xshift, ystep, yshift, aia_lim, cm_aia, rdf_lim, cm_run_diff, wave = wave
            pngfile = vis_data_wave_add + path_sep() + prefix + "_aia" + string(i-from, FORMAT = '(I05)') + ".jpg"
            ;write_png, pngfile, TVRD(/TRUE)
            if ~keyword_set(nosave) then write_jpeg, pngfile, tvrd(true=1), true =1, quality =100
        endif
        data_prev = data0
    endfor
    
endfor
set_plot,'X'
end
