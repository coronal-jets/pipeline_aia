function l_pipeline_aia_find_candidates_index, index

return, {date_obs:index.date_obs, t_obs:index.t_obs, WAVELNTH:index.WAVELNTH $
         , naxis1:index.naxis1, naxis2:index.naxis2 $
         , CRPIX1:index.CRPIX1, CRPIX2:index.CRPIX2, CDELT1:index.CDELT1, CDELT2:index.CDELT2, CRVAL1:index.CRVAL1, CRVAL2:index.CRVAL2 $
         , exptime:index.exptime}

end

pro pipeline_aia_read_prepare_data, files_in_arr, run_diff, data_full, index

;reading AIA files
message,'Reading data...',/info
read_sdo_silent, files_in_arr, ind_seq, data_full, /silent, /use_shared, /hide
n_files = n_elements(files_in_arr)
ind0 = l_pipeline_aia_find_candidates_index(ind_seq[0])
index = replicate(ind0, n_files)
;normalizing exposure
data_full = float(data_full > 1); change to double if necessary
for i = 0, n_files-1 do begin
    index[i] = l_pipeline_aia_find_candidates_index(ind_seq[i])
    exptime = ind_seq[i].exptime
    data_full[*,*,i] = data_full[*,*,i]/exptime
endfor
;running difference
;data_full = (data_full[*,*,1:*] + data_full[*,*,0:-2])*0.5

;run_diff = data_full[*,*,1:*] - data_full[*,*,0:-2]
;data_full = data_full[*,*,0:-1]
;index = index[0:-1]

run_diff = data_full[*,*,1:*] - data_full[*,*,0:-2]
data_full = data_full[*,*,0:-2]
index = index[0:-2]

;preprocess run_dif
message,'Preprocessing data...',/info
pipeline_aia_irc_preprocess_rd, run_diff

end
