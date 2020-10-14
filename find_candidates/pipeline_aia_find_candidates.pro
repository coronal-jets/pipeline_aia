pro pipeline_aia_find_candidates, work_dir, aia_dir_wave_sel, wave, obj_dir, config_file = config_file, presets_file = presets_file

pipeline_aia_read_presets, presets, presets_file = presets_file 
pipeline_aia_read_down_config, config, config_file = config_file 

ts = anytim(config.tstart)
te = anytim(config.tstop)

files_in_all = file_search(filepath('*.fits', root_dir = work_dir + path_sep() + aia_dir_wave_sel))
files_in = list()
foreach file_in, files_in_all, i do begin
    tf = pipeline_aia_date_from_filename(file_in, /q_anytim)
    if tf ge ts && tf le te then files_in.Add, file_in
endforeach

seq = !NULL
aia_lim = !NULL
rdf_lim = !NULL
n_files = n_elements(files_in)

if n_files lt 2 then begin
    message, "No AIA-fits to find jets, check config and input keys."
endif

ctrl = 5
foreach file_in, files_in, i do begin
    compile_opt idl2
    
;    read_sdo, file_in, index, data, /use_shared, /uncomp_delete
    read_sdo_silent, file_in, index, data, /use_shared, /uncomp_delete, /hide, /silent 
    if isa(seq, /NULL) then begin
        szd = size(data)
        seq = dblarr(szd[1], szd[2], n_files)
        ind_seq = replicate(index, n_files)
        run_diff = dblarr(szd[1], szd[2], n_files-1)
    endif
    seq[*, *, i] = data - mean(data)
    if aia_lim eq !NULL then begin
        aia_lim = dblarr(2)
        aia_lim[0] = min(data)
        aia_lim[1] = max(data)
    endif else begin
        aia_lim[0] = min([aia_lim[0], min(data)])
        aia_lim[1] = max([aia_lim[1], max(data)])
    endelse
         
    ind_seq[i] = index 
    if i gt 0 then begin
        pipeline_aia_irc_run_diff, seq[*, *, i], seq[*, *, i-1], rd
        run_diff[*, *, i-1] = rd
        if rdf_lim eq !NULL then begin
            rdf_lim = dblarr(2)
            rdf_lim[0] = min(rd)
            rdf_lim[1] = max(rd)
        endif else begin
            rdf_lim[0] = min([rdf_lim[0], min(rd)])
            rdf_lim[1] = max([rdf_lim[1], max(rd)])
        endelse 
    endif 
    if double(i)/n_files*100d gt ctrl then begin
        print, 'running difference, ' + strcompress(ctrl,/remove_all) + '%'
        ctrl += 5 
    endif
endforeach

par1 = presets.par1
par2 = presets.par2
parcom = presets.parcom

szr = size(run_diff)
n = szr[3]
postponed = list()
postID = 0

ctrl = 5
for i = 0, n-1 do begin
    pipeline_aia_irc_process, run_diff[*, *, i], par1, clusters, i
    for k = 0, n_elements(clusters)-1 do begin
        postponed.Add, {pos:i, ID:postID, cluster:clusters[k]}
        print, '   pos = ' + strcompress(i,/remove_all) + ', ID = ' + strcompress(postID,/remove_all)+ ', ' + pipeline_aia_irc_clust_verbose(clusters[k]) 
        postID++
    endfor
    if double(i)/n*100d gt ctrl then begin
        print, 'find candidates, ' + strcompress(ctrl,/remove_all) + '%'
        ctrl += 5 
    endif
endfor

found_candidates = list()
while ~postponed.IsEmpty() do begin
    pipeline_aia_irc_process_multi, run_diff, postponed, par2, parcom, jet_seq
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
save, filename = prefix + '.sav', found_candidates, aia_lim, rdf_lim, ind_seq
if n_elements(found_candidates) gt 0 then begin
    pipeline_aia_csv_output, 42, prefix + '.csv', found_candidates, ind_seq
endif
 
end