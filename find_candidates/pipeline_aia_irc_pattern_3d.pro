function pipeline_aia_irc_pattern_3d, rx0, ry0, rz0

rx = double(rx0)
ry = double(ry0)
rz = double(rz0)

m = intarr(2*rx+1, 2*ry+1, 2*rz+1)

for kx = 0, 2*fix(rx) do begin
    for ky = 0, 2*fix(ry) do begin
        for kz = 0, 2*fix(rz) do begin
            ellipsis = ((kx - rx)/rx)^2 + ((ky - ry)/ry)^2 + ((kz - rz)/rz)^2
            m[kx, ky, kz] = ellipsis le 1 ? 1 : 0 
        endfor
    endfor
endfor

return, m

end
