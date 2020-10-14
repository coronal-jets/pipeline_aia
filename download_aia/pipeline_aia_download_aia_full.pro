pro pipeline_aia_download_aia_full, wave, aia_dir_cache, config_file = config_file, down_message = down_message
compile_opt idl2

t0 = systime(/seconds)

pipeline_aia_read_down_config, config, config_file = config_file

ts = anytim(config.tstart)
te = anytim(config.tstop)
n_frames = (te-ts)/12

t0 = systime(/seconds)
n_done = 0

postponed = list()
post_n = 0

pipeline_aia_get_query, wave, config.tstart, config.tstop, urls, filenames
swave = strcompress(wave, /remove_all)

foreach url, urls, j do begin
    time_download_started = systime(1)
    if keyword_set(down_message) then message, /info, "Wave " + swave + ": downloading "+filenames[j]+" from "+url+'...'
    
    date = pipeline_aia_date_from_filename(filenames[j])
    date_dir = aia_dir_cache + path_sep() + date
    wave_dir = date_dir + path_sep() + swave
    file_mkdir, wave_dir

    filename = wave_dir + path_sep() + filenames[j]
    
    for itry = 1, config.count do begin
        sock_get, url, filename, status = status, /quiet
        if status eq 0 then begin
            message, /info, "Downloading failed (" + strcompress(itry) + ")"
            if itry lt config.count then wait, config.timeout
        endif else begin
            break
        endelse    
    endfor

    if status eq 0 then begin
        if post_n gt config.limit then begin
            message, "Too many downloads failed, session stopped"
        endif else begin
            postponed.Add, {url:url, filename:filename}
        endelse    
        break
    endif else begin
        curr_time = systime(1)
        time_download = curr_time - time_download_started
        parse = stregex(filenames[j],'.*AIA(.*)',/subexpr,/extract)
        fname = 'AIA' + parse[1]
        remains = '...'
        if n_done gt 0 then begin
            part = double(n_done)/ n_frames
            passed = curr_time - t0
            est = passed/part
            rem = est-passed
            if rem lt 24*60*60 then asu_sec2remain, rem, remains
        endif
        if status eq 1 then message,/info, "Wave " + swave + ": " + fname + " downloaded succesfully in "+strcompress(time_download)+" seconds, est. remains " + remains
        if status eq 2 then message,/info, "Wave " + swave + ": " + fname + " is already present, est. remains " + remains
        
        n_done++
    endelse
endforeach

for j = 0, n_elements(postponed)-1 do begin
    url = postponed[j].url
    filename = postponed[j].filename
    for itry = 1, config.count_post do begin
        sock_get, url, filename, status = status
        if status eq 0 then begin
            message, /info, "Postponed downloading failed (" + strcompress(itry) + ")"
            if itry lt config.count_post then wait, config.timeout_post
        endif    
    endfor
    if status eq 0 then message, "Postponed downloads failed, session stopped"
endfor

message, strcompress(string(systime(/seconds)-t0,format="('download performed in ',g0,' seconds')")), /cont
  
end

