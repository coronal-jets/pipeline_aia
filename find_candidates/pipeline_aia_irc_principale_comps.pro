pro pipeline_aia_irc_principale_comps, x0, y0, vx, vy, caspect = caspect, vbeta = vbeta, rotx = rotx, roty = roty, baspect = baspect

n = n_elements(x0)

x = double(x0)
y = double(y0)

x -= mean(x) 
y -= mean(y) 

x2 = x ## transpose(x)
y2 = y ## transpose(y)
xy = x ## transpose(y)

kyx = xy/x2
kxy = y2/xy

vbeta = 0.5d * atan(2*xy, (x2-y2))

if ~finite(vbeta) then begin
    stophere = 1
endif

kb = tan(vbeta)

sb = sin(vbeta)
cb = cos(vbeta)

vx = sqrt(cb^2*x2 + 2*cb*sb*xy + sb^2*y2)/n
vy = sqrt(sb^2*x2 - 2*sb*cb*xy + cb^2*y2)/n

if arg_present(caspect) then begin
    caspect = vx gt vy ? vx/vy : vy/vx
endif

if arg_present(rotx) or arg_present(roty) or arg_present(baspect) then begin
    mrot = [  [ cb, -sb] $
            , [ sb,  cb] ]
    crd = dblarr(n, 2)
    crd[*, 0] = x
    crd[*, 1] = y
    result = mrot ## crd
    rotx = result[*, 0]
    roty = result[*, 1]
    xmm = minmax(rotx)
    ymm = minmax(roty)
    baspect = (ymm[1]-ymm[0])/(xmm[1]-xmm[0])
endif

end
