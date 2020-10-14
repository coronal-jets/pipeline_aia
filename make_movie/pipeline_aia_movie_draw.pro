pro pipeline_aia_movie_draw, data, rd, jet, win, jtitle, rtitle, xstep, xshift, ystep, yshift, aia_lim, cm_aia, rdf_lim, cm_run_diff

;data[0, 0] = aia_lim[0]
;data[0, 1] = aia_lim[1]
sz = size(data)
x = indgen(sz[1])*xstep+xshift
y = indgen(sz[2])*ystep+yshift
dimage = image(data, x, y, RGB_TABLE = cm_aia, LAYOUT=[2,1,1], /CURRENT, TITLE = jtitle, FONT_SIZE = 16)
xax = axis('X', LOCATION=[x[0],y[0]], target = dimage)
xax.tickdir = 1
yax = axis('Y', LOCATION=[x[0],y[0]], target = dimage)
yax.tickdir = 1

; if cm_run_diff ne !NULL

;rd[0, 0] = rdf_lim[0]
;rd[0, 1] = rdf_lim[1]
rimage = image(rd, x, y, LAYOUT=[2,1,2], /CURRENT, TITLE = rtitle, FONT_SIZE = 16)
xax = axis('X', LOCATION=[x[0],y[0]], target = rimage)
xax.tickdir = 1
yax = axis('Y', LOCATION=[x[0],y[0]], target = rimage)
yax.tickdir = 1

jimage = image(jet, x, y, RGB_TABLE = cm_run_diff, OVERPLOT = rimage)
jimage.transparency = 50

end
