pro pipeline_aia_movie_draw, data, rd, jet,  jtitle, rtitle, xstep,$
 xshift, ystep, yshift, aia_lim,  rdf_lim,  wave = wave

data[0, 0] = aia_lim[0]
data[0, 1] = aia_lim[1]
data = data>aia_lim[0]<aia_lim[1]
sz = size(data)
x = findgen(sz[1])*xstep+xshift
y = findgen(sz[2])*ystep+yshift
!p.multi = [2,2,1]
aia_lct_silent,wave = wave,/load
implot,comprange(data,2,/global),x,y,/iso,title = jtitle

rd[0, 0] = rdf_lim[0]
rd[0, 1] = rdf_lim[1]
rd = rd>rdf_lim[0]<rdf_lim[1]
loadct,0,/silent
implot, rd,x,y,/iso,title = rtitle

contour, gauss_smooth(jet,3,/edge_truncate),x,y, levels =[0.05],/overplot, color = 'FF0000'x, thick =2

!p.multi = 0

end
