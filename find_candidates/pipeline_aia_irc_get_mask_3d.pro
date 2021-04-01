pro pipeline_aia_irc_get_mask_3d, rd, sigma, cmask

sz = size(rd)

cmask = intarr(sz[1], sz[2], sz[3])
for i = 0, sz[3]-1 do begin
    rd_abs_norm = median(abs(rd[*, *, i]),5)
    cmask[*, *, i] = rd_abs_norm gt  sigma 
endfor

end
