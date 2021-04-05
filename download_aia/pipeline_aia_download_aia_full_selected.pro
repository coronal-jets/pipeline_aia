pro pipeline_aia_download_aia_full_selected, wave, aia_dir_add, config, down_message = down_message, downlist = downlist
compile_opt idl2

t0 = systime(/seconds)

n_frames = 3
urls = strarr(n_frames)
filenames = strarr(n_frames)
tt = dblarr(n_frames) 
tt[0] = anytim(config.tstart)
tt[2] = anytim(config.tstop)
tt[1] = (tt[0]+tt[2])/2

t0 = systime(/seconds)
n_done = 0

postponed = list()
post_n = 0

ds = ssw_jsoc_wave2ds(wave)
delt = wave gt 1000 ? 12 : 6
for k = 0, n_elements(tt)-1 do begin
    time_query =  ssw_jsoc_time2query(tt[k]-delt, tt[k]+delt)
    query = ds+'['+time_query+']'+'['+strcompress(wave, /remove_all)+']'
    query = query[0]
    urls[k] = ssw_jsoc_query2sums(query,/urls)
    index = ssw_jsoc(ds = query,/rs_list,/xquery)
    filenames[k] = ssw_jsoc_index2filenames(index)
endfor

swave = strcompress(wave, /remove_all)

foreach url, urls, j do begin
    time_download_started = systime(1)
    message, /info, "Wave fullimage " + swave + ": downloading "+filenames[j]+" from "+url+'...'
    filename = aia_dir_add + path_sep() + filenames[j]
    
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
            if rem lt 24*60*60 then remains = asu_sec2hms(rem, /issecs)
        endif
        if status eq 1 then message,/info, "Wave fullimage " + swave + ": " + fname + " downloaded succesfully in "+strcompress(time_download)+" seconds, est. remains " + remains
        if status eq 2 then message,/info, "Wave fullimage " + swave + ": " + fname + " is already present, est. remains " + remains
        
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
    if status ne 0 && outresult ne 0 then downlist.Add, {url:url, filename:filename}
endfor

;message, strcompress(string(systime(/seconds)-t0,format="('download performed in ',g0,' seconds')")), /cont
message, 'Fullimage download complete in ' + asu_sec2hms(systime(/seconds)-t0, /issecs), /info
  
end

