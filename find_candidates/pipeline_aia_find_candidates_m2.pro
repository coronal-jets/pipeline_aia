function pipeline_aia_find_candidates_m2, work_dir, aia_dir_wave_sel, wave, obj_dir, config, files_in, presets, run_diff_src, data, ind_seq

t0 = systime(/seconds)

pipeline_aia_get_input_files, config, work_dir + path_sep() + aia_dir_wave_sel, files_in
pipeline_aia_read_prepare_data, files_in.ToArray(), run_diff, data, ind_seq
run_diff_src = run_diff

;preprocess run_dif
message,'Preprocessing data...',/info
pipeline_aia_irc_preprocess_rd, run_diff

message, ' preparation in ' + asu_sec2hms(systime(/seconds)-t0, /issecs), /info

t0 = systime(/seconds)

szr = size(run_diff)
n = szr[3]

prefix = work_dir + path_sep() + obj_dir + path_sep() + strcompress(fix(wave),/remove_all)

exp1 = max([presets.min_size, presets.fill_size, presets.border])
exp2 = exp1
exp3 = max([presets.min_size_t, presets.fill_size_t, presets.border_t])
lims1 = [exp1, -exp1-1]
lims2 = [exp2, -exp2-1]
lims3 = [exp3, -exp3-1]
cmask = intarr(szr[1]+2*exp1, szr[2]+2*exp2, szr[3]+2*exp3)

pipeline_aia_irc_get_mask_3d, run_diff, presets.mask_threshold, bmask, presets, rd_check
if presets.debug then initmask = bmask

;if presets.debug then save, filename = prefix + '_presets.debug.sav', run_diff, rd_check, bmask
;pipeline_aia_irc_get_mask_3d, run_diff2, 3.5, bmask2, presets.debug, rd_check2
;if presets.debug then save, filename = prefix + '_presets.debug.sav', run_diff, run_diff2, bmask1, bmask2
;bmask = bmask or bmask2
;if presets.debug then bmaskc = bmask

cmask[lims1[0]:lims1[1], lims2[0]:lims2[1], lims3[0]:lims3[1]] = bmask
message, ' mask preprocessing ' + asu_sec2hms(systime(/seconds)-t0, /issecs), /info

t0 = systime(/seconds)
;removing small objects
pattern = pipeline_aia_irc_pattern_3d(presets.min_size, presets.min_size, presets.min_size_t)
cmask = morph_open(cmask, pattern)
if presets.debug then cmask_open = cmask
message, ' morph_open ' + asu_sec2hms(systime(/seconds)-t0, /issecs), /info

t0 = systime(/seconds)
;filling large gaps
pattern = pipeline_aia_irc_pattern_3d(presets.fill_size, presets.fill_size, presets.fill_size_t)
;cmask = morph_close(cmask, pattern)
cmask = dilate(cmask, pattern)
if presets.debug then cmask_dilate = cmask
message, ' morph_close (dilate) ' + asu_sec2hms(systime(/seconds)-t0, /issecs), /info
t0 = systime(/seconds)
cmask = erode(cmask, pattern)
if presets.debug then cmask_erode = cmask
message, ' morph_close (erode) ' + asu_sec2hms(systime(/seconds)-t0, /issecs), /info

;t0 = systime(/seconds)
;;extend border
;pattern = pipeline_aia_irc_pattern_3d(presets.border, presets.border, presets.border_t)
;cmask = dilate(cmask, pattern)
;pipeline_aia_irc_get_mask_3d, run_diff, 1.5, bmask2, presets.debug, rd_check
;cmask[lims1[0]:lims1[1], lims2[0]:lims2[1], lims3[0]:lims3[1]] = cmask[lims1[0]:lims1[1], lims2[0]:lims2[1], lims3[0]:lims3[1]] and bmask2
;if presets.debug then cmask_border = cmask
;message, ' expand ' + asu_sec2hms(systime(/seconds)-t0, /issecs), /info

cmask = cmask[lims1[0]:lims1[1], lims2[0]:lims2[1], lims3[0]:lims3[1]]

clust3d = label_region(cmask, /all_neighbors, /ulong)
n_candidates = max(clust3d)
message,strcompress(n_candidates)+" candidates initially ",/info

;if presets.debug then save, filename = prefix + '_debug.sav', cmask_erode, cmask_border; run_diff, rd_check, cmask0, result ; , clust3d, data, ind_seq

t0 = systime(/seconds)
found_candidates = pipeline_aia_irc_filter_clusters_proc_all(clust3d, presets, rd_check)
message, ' filtering ' + asu_sec2hms(systime(/seconds)-t0, /issecs) + ', found ' + strcompress(found_candidates.Count()), /info

;t0 = systime(/seconds)
;pipeline_aia_irc_get_mask_3d, run_diff, 1.7, bmask2, presets.debug, rd_check
;cmask = intarr(szr[1]+2*exp1, szr[2]+2*exp2, szr[3]+2*exp3)
;cmask[lims1[0]:lims1[1], lims2[0]:lims2[1], lims3[0]:lims3[1]] = bmask
;pattern = pipeline_aia_irc_pattern_3d(presets.fill_size, presets.fill_size, presets.fill_size_t)
;patternd = pipeline_aia_irc_pattern_3d(presets.border, presets.border, presets.border_t)
;for k = 0, found_candidates.Count()-1 do begin
;    xmask = clust3d eq found_candidates[k].clust_n
;    cmask = intarr(szr[1]+2*exp1, szr[2]+2*exp2, szr[3]+2*exp3)
;    cmask[lims1[0]:lims1[1], lims2[0]:lims2[1], lims3[0]:lims3[1]] = xmask
;    cmask = dilate(cmask, patternd)
;    cmask = cmask[lims1[0]:lims1[1], lims2[0]:lims2[1], lims3[0]:lims3[1]]
;    amask = cmask and bmask2
;    emask = morph_close(amask, pattern)
;;    pipeline_aia_irc_get_cluster_coords, emask, 1, x, y
;        idxs = where(emask eq 1)
;        xy = array_indices(emask, idxs)
;        x = transpose(xy[0, *])
;        y = transpose(xy[1, *])
;;    found_candidates[k].frame[].xex.Add, x
;endfor 
;message, ' expand ' + asu_sec2hms(systime(/seconds)-t0, /issecs) + ', found ' + strcompress(found_candidates.Count()), /info

message,'Saving objects...',/info
pipeline_aia_csv_output, prefix + '.csv', found_candidates, ind_seq, presets = presets
save, filename = prefix + '.sav', found_candidates,  ind_seq

return, found_candidates.Count()
 
end