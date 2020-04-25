
pro download_aia_full
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
    subdir = "full_" + strcompress(waves[i],/remove_all)
    file_mkdir, subdir
    cd, subdir 
    search_results = vso_search(t1,t2,instrument='aia',wave= strcompress(waves[i],/remove_all)+' Angstrom')
    foo = vso_get(search_results,/rice)
    cd,'..'
  endfor
  cd,'..'
end

