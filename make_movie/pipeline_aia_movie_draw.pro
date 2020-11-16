pro pipeline_aia_movie_draw, data, rd, jet,  jtitle, rtitle, xstep,$
 xshift, ystep, yshift, aia_lim,  rdf_lim,  wave = wave

data[0, 0] = aia_lim[0]
data[0, 1] = aia_lim[1]
data = data>aia_lim[0]<aia_lim[1]
sz = size(data)
x = findgen(sz[1])*xstep+xshift
y = findgen(sz[2])*ystep+yshift
;dimage = image(data, x, y, RGB_TABLE = cm_aia, LAYOUT=[2,1,1], /CURRENT, TITLE = jtitle, FONT_SIZE = 16)
;xax = axis('X', LOCATION=[x[0],y[0]], target = dimage)
;xax.tickdir = 1
;yax = axis('Y', LOCATION=[x[0],y[0]], target = dimage)
;yax.tickdir = 1
!p.multi = [2,2,1]
aia_lct,wave = wave,/load
implot,comprange(data,2,/global),x,y,/iso,title = jtitle


; if cm_run_diff ne !NULL

rd[0, 0] = rdf_lim[0]
rd[0, 1] = rdf_lim[1]
rd = rd>rdf_lim[0]<rdf_lim[1]
;rimage = image(rd, x, y, LAYOUT=[2,1,2], /CURRENT, TITLE = rtitle, FONT_SIZE = 16)
;xax = axis('X', LOCATION=[x[0],y[0]], target = rimage)
;xax.tickdir = 1
;yax = axis('Y', LOCATION=[x[0],y[0]], target = rimage)
;yax.tickdir = 1
loadct,0,/silent
implot, rd,x,y,/iso,title = rtitle

;jimage = image(jet, x, y, RGB_TABLE = cm_run_diff, OVERPLOT = rimage)
;jimage.transparency = 50
;
;contour,jet,x,y,levels=[0.5],/overplot
contour, gauss_smooth(jet,3,/edge_truncate),x,y, levels =[0.05],/overplot, color = 255, thick =2

!p.multi = 0

end
