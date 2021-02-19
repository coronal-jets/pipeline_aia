pro pipeline_aia_all_batch, config_path = config_path, _extra = _extra

configs = file_search(filepath('config*.json', root_dir = config_path))

now = systime()
while (((pos = strpos(now, ' '))) ne -1) do strput, now, '_', pos
while (((pos = strpos(now, ':'))) ne -1) do strput, now, '_', pos

filename = config_path + path_sep() + 'report_' + now + '.txt' 
openw, U, filename, /GET_LUN
                          
foreach config_file, configs, i do begin
    CATCH, err_status
    if err_status ne 0 then begin
        printf, U, '***** config = ', file_basename(config_file), ' performed in ', strcompress(string(systime(/seconds)-t0)), ' sec' 
        message, strcompress(string(systime(/seconds)-t0,format="('******** CANDIDATES: removing low aspects in ',g0,' seconds')")), /cont
        printf, U, '  -> Error! ', !ERROR_STATE.MSG
        CATCH, /CANCEL
        continue
    endif
    
    t0 = systime(/seconds)
    pipeline_aia_all, config_file = config_file, _extra = _extra
    printf, U, '***** config = ', file_basename(config_file), ' performed in ', strcompress(string(systime(/seconds)-t0)), ' sec' 
    printf, U, '  -> Successfully'
                              
endforeach

close, U
FREE_LUN, U
                          
end