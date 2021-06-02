function pipeline_aia_find_candidates_m2, work_dir, aia_dir_wave_sel, wave, obj_dir, config, files_in, presets

t0 = systime(/seconds)

pipeline_aia_get_input_files, config, work_dir + path_sep() + aia_dir_wave_sel, files_in
pipeline_aia_read_prepare_data, files_in.ToArray(), run_diff, data, ind_seq

message, '******** CANDIDATES: preparation in ' + asu_sec2hms(systime(/seconds)-t0, /issecs), /info

t0 = systime(/seconds)

szr = size(run_diff)
n = szr[3]

pipeline_aia_irc_get_mask_3d, run_diff, presets.mask_threshold, cmask

;removing small objects
radius = presets.min_size
pattern = pipeline_aia_irc_pattern_3d(radius, radius, presets.min_size_t)
cmask = morph_open(cmask, pattern)

;filling large gaps
radius = presets.fill_size
pattern = pipeline_aia_irc_pattern_3d(radius, radius, presets.fill_size_t)
cmask = morph_close(cmask, pattern)

;extend border
radius = presets.border
pattern = pipeline_aia_irc_pattern_3d(radius, radius, presets.border_t)
cmask = dilate(cmask, pattern)

clust3d = label_region(cmask, all_neighbors = 1)
n_candidates = max(clust3d)
message,strcompress(n_candidates)+" candidates initially ",/info

pipeline_aia_irc_cardinality_filter, cmask, clust3d, presets.min_area*presets.min_duration
pipeline_aia_irc_renumber_clusters, clust3d
n_candidates = max(clust3d)
message,strcompress(n_candidates)+" candidates after cardinality ",/info
message, '******** CANDIDATES: finding in ' + asu_sec2hms(systime(/seconds)-t0, /issecs), /info

t0 = systime(/seconds)
pipeline_aia_irc_remove_short_clusters, clust3d, presets.min_duration
pipeline_aia_irc_renumber_clusters, clust3d
n_candidates = max(clust3d)
message,strcompress(n_candidates)+" candidates after removing short events ",/info
message, '******** CANDIDATES: removing short clusters ' + asu_sec2hms(systime(/seconds)-t0, /issecs), /info

t0 = systime(/seconds)
pipeline_aia_irc_aspect_filter_clusters, clust3d, presets.min_aspect, presets.min_aspect_area, presets.min_aspect_3d 
pipeline_aia_irc_renumber_clusters, clust3d
n_candidates = max(clust3d)
message,strcompress(n_candidates)+" candidates after removing events with low aspect ",/info
message, '******** CANDIDATES: removing low aspect clusters ' + asu_sec2hms(systime(/seconds)-t0, /issecs), /info

; fill found_candidates list
found_candidates = list()

sz = size(data)
n_frames = sz[3]

t0 = systime(/seconds)
for k =1, n_candidates do begin
    message,'Processing candidate '+strcompress(k)+" of " +strcompress(n_candidates)+'...',/info
    candidate = list()
    OK = pipeline_aia_irc_get_aspects_clusters(clust3d, k, presets.min_aspect, presets.min_aspect_area, presets.min_aspect_3d, max_aspect_2d, aspect_3d, candidate = candidate)
    if OK then found_candidates.add, candidate
endfor
message, '******** CANDIDATES: reported in ' + asu_sec2hms(systime(/seconds)-t0, /issecs), /info

message,'Saving objects...',/info
prefix = work_dir + path_sep() + obj_dir + path_sep() + strcompress(fix(wave),/remove_all)
pipeline_aia_csv_output, prefix + '.csv', found_candidates, ind_seq, presets = presets
prefix = work_dir + path_sep() + obj_dir + path_sep() + strcompress(fix(wave),/remove_all)
save, filename = prefix + '.sav', found_candidates,  ind_seq

return, found_candidates.Count()
 
end