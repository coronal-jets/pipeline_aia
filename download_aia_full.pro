pro download_aia_full
compile_opt idl2
  config_file = "config.json"
  ;read config
  config = read_json_config(config_file)
  
  t1 = config["TIME_START"]
  t2 = config["TIME_STOP"]
  waves = config["WAVES"]
  
  file_mkdir, 'aia_data'
  cd, 'aia_data'
  nw = n_elements(waves)
  for i =0, nw-1 do begin
    wave = strcompress(waves[i],/remove_all)
    subdir = "full_" + strcompress(wave,/remove_all)
    file_mkdir, subdir
    cd, subdir 
    ds = ssw_jsoc_wave2ds(wave)
    time_query =  ssw_jsoc_time2query(t1, t2)
    query = ds+'['+time_query+']'+'['+wave+']'
    query = query[0]
    urls = ssw_jsoc_query2sums(query,/urls)
    index = ssw_jsoc(ds = query,/rs_list,/xquery)
    filenames = ssw_jsoc_index2filenames(index)
    foreach url, urls, j do begin
      time_download_started = systime(1)
      message, /info, "downloading "+filenames[j]+" from "+url+'...'
      sock_get,url,filenames[j], status = status
      if status eq 0 then message, "Downloading failed"
      time_download = systime(1) - time_download_started
      if status eq 1 then message,/info, "Downloaded sucsesfully in "+strcompress(time_download)+" seconds"
      if status eq 2 then message,/info, "File "+filenames[j]+" is already present..."
    endforeach
    cd,'..'
  endfor
  cd,'..'
end

