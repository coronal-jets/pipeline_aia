pro pipeline_aia_irc_principale_comps, x0, y0, vx, vy

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

beta = 0.5d * atan(2*xy/(x2-y2))
kb = tan(beta)

sb = sin(beta)
cb = cos(beta)

Vx = sqrt(cb^2*x2 + 2*cb*sb*xy + sb^2*y2)/n
Vy = sqrt(sb^2*x2 - 2*sb*cb*xy + cb^2*y2)/n

end
