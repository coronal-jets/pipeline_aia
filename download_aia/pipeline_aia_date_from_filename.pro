function pipeline_aia_date_from_filename, filename, q_anytim = q_anytim

date = stregex(filename,'.*AIA([0-9][0-9][0-9][0-9])([0-9][0-9])([0-9][0-9])_([0-9][0-9])([0-9][0-9])([0-9][0-9]).*',/subexpr,/extract)

if ~keyword_set(q_anytim) then begin
    return, date[1]+date[2]+date[3]
endif else begin
    return, anytim(date[1]+'-'+date[2]+'-'+date[3]+' '+date[4]+':'+date[5]+':'+date[6])
endelse        


end
