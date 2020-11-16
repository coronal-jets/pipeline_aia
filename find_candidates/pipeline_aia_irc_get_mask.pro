pro pipeline_aia_irc_get_mask,data, rd, sigma, cmask

rd_abs = median(abs(rd)/data,5)

; measuring stdev of a quiet 80% of the image
n= n_elements(ind)
st = median(rd_abs)

;therdolding
cmask = rd_abs gt  (sigma * st)

end
