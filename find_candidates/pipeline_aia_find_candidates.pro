pro pipeline_aia_find_candidates, work_dir, aia_dir_wave_sel, wave, obj_dir, config_file = config_file, presets_file = presets_file

pipeline_aia_read_presets, presets, presets_file = presets_file 
pipeline_aia_read_down_config, config, config_file = config_file 

ts = anytim(config.tstart)
te = anytim(config.tstop)

files_in_all = file_search(filepath('*.fits', root_dir = work_dir + path_sep() + aia_dir_wave_sel))
n_files = n_elements(files_in_all)-1

if n_files lt 2 then begin
  message, "No AIA-fits to find jets, check config and input keys."
endif

files_in = list()
foreach file_in, files_in_all, i do begin
    tf = pipeline_aia_date_from_filename(file_in, /q_anytim)
    if tf ge ts && tf le te then files_in.Add, file_in
endforeach

;reading AIA files
message,'Reading data...',/info
read_sdo,files_in.ToArray(),ind_seq, data,/silent
n_files = n_elements(ind_seq)
;normalizing exposure
data = float(data>1); change to double if necessary
for i=0,n_files-1 do begin
    exptime = ind_seq[i].exptime
    data[*,*,i] = data[*,*,i]/exptime
endfor
;running difference
run_diff = data[*,*,1:*] - data[*,*,0:-2]
data = ((data[*,*,1:*] + data[*,*,0:-2])*0.5)

;preprocess run_dif
message,'Preprocessing data...',/info
pipeline_aia_irc_preprocess_rd, run_diff


szr = size(run_diff)
n = szr[3]
postponed = list()
postID = 0

sz = size(data)
clust3d = intarr(sz[1], sz[2], sz[3])
n_clust = 0
ctrl = 5
for i = 0, n-1 do begin
 ; if i eq 156 then stop
    pipeline_aia_irc_process, data[*,*,i], run_diff[*, *, i], presets,clust
    ind = where(clust gt 0)
    if ind[0] ne -1 then begin
      n_clust_cur = max(clust)
      clust[ind] += n_clust
      n_clust = n_clust + n_clust_cur
      clust3d[*,*,i] = clust    
    endif

    if double(i)/n*100d gt ctrl then begin
        print, 'find candidates, ' + strcompress(ctrl,/remove_all) + '%'
        ctrl += 5 
    endif
endfor

pipeline_aia_irc_merge_clusters, clust3d
pipeline_aia_irc_renumber_clusters, clust3d
n_candidates = max(clust3d)
message,strcompress(n_candidates)+" candidates found ",/info
;stop
pipeline_aia_irc_remove_short_clusters, clust3d
pipeline_aia_irc_renumber_clusters, clust3d
n_candidates = max(clust3d)
message,strcompress(n_candidates)+" candidates after removing short events ",/info

pipeline_aia_irc_aspect_filter_clusters, clust3d, presets.ellipse
pipeline_aia_irc_renumber_clusters, clust3d
n_candidates = max(clust3d)
message,strcompress(n_candidates)+" candidates after removing events with low aspect ",/info


; fill found_candidates list
found_candidates = list()


n_frames = sz[3]

for k =1, n_candidates do begin
  candidate = list()
  message,'Processing candidate '+strcompress(k)+" of " +strcompress(n_candidates)+'...',/info
  for t = 0, n_frames-1 do begin
    clust = clust3d[*,*,t]
    if total(clust eq k) gt 0 then begin
      pipeline_aia_irc_get_cluster_coords, clust, k, x, y
      pipeline_aia_irc_principale_comps, x, y, vx, vy
      aspect = vx gt vy ? vx/vy : vy/vx
      j = {pos:t, x:x, y:y, aspect:aspect[0], clust:k}
      candidate.add,j
    endif
  endfor
  found_candidates.add, candidate
endfor

message,'Saving objects...',/info
prefix = work_dir + path_sep() + obj_dir + path_sep() + strcompress(fix(wave),/remove_all)
pipeline_aia_csv_output, 42, prefix + '.csv', found_candidates, ind_seq
prefix = work_dir + path_sep() + obj_dir + path_sep() + strcompress(fix(wave),/remove_all)
save, filename = prefix + '.sav', found_candidates,  ind_seq



return

found_candidates = list()
while ~postponed.IsEmpty() do begin
    pipeline_aia_irc_process_multi,data, run_diff, postponed, par2, parcom, jet_seq
    if ~jet_seq.IsEmpty() then found_candidates.Add, jet_seq
endwhile 

print, ' '
print, 'Found ' + strcompress(n_elements(found_candidates),/remove_all) + ' candidates'
foreach cand, found_candidates, i do begin
    lng = n_elements(cand)
    limx = intarr(2)
    limy = intarr(2)
    limx[0] = 10000
    limy[0] = 10000
    for k = 0, lng-1 do begin
        pipeline_aia_irc_get_clust_val, cand[k], cx, cy, climx, climy
        limx[0] = min([limx[0], climx[0]])
        limx[1] = max([limx[1], climx[1]])
        limy[0] = min([limy[0], climy[0]])
        limy[1] = max([limy[1], climy[1]])
    endfor 
    print, strcompress(i,/remove_all) + ': ' + strcompress(cand[0].pos,/remove_all) + ' - ' + strcompress(cand[lng-1].pos,/remove_all) $
                       + ' [' + strcompress(fix(limx[0]),/remove_all) + '-' + strcompress(fix(limx[1]),/remove_all) + ']x[' $
                       + strcompress(fix(limy[0]),/remove_all) + '-' + strcompress(fix(limy[1]),/remove_all) + ']'        
endforeach

prefix = work_dir + path_sep() + obj_dir + path_sep() + strcompress(fix(wave),/remove_all)
save, filename = prefix + '.sav', found_candidates,  ind_seq
if n_elements(found_candidates) gt 0 then begin
    pipeline_aia_csv_output, 42, prefix + '.csv', found_candidates, ind_seq
endif
 
end