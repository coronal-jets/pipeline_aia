pro pipeline_aia_csv_output, filename, candlist, aiaseq, presets = presets

if n_elements(presets) eq 0 then mincard = 0 else mincard = presets.MIN_AREA

openw, fnum, filename, /GET_LUN

printf, fnum, 'T start', 'T max', 'T end', '#', 'Duration', 'Max. cardinality', 'Jet aspect ratio', 'Max. aspect ratio', 'LtoW aspect ratio', 'Speed est.', 'Total length', 'Av. width', 'X from', 'X to', 'Y from', 'Y to', $
     FORMAT = '(%"%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s")'

for i = 0, n_elements(candlist)-1 do begin
    jet = candlist[i]
    tstart = !NULL
    tmax = !NULL
    tend = !NULL
    maxcard = 0
    maxasp = 0
    xmin = !NULL
    xmax = !NULL
    sy2 = 0d
    ntot = 0L
    xbox = !NULL
    ybox = !NULL
    pstart = !NULL
    pend = !NULL
    ;      j = {pos:t, x:x, y:y, aspect:caspect, baspect:baspect, vbeta:vbeta, rotx:rotx, roty:roty, clust:k, totasp:total_aspects[k]}
    
    for j = 0, n_elements(jet)-1 do begin
        clust = jet[j]
        pos = clust.pos
        if tstart eq !NULL then begin
            tstart = aiaseq[pos].date_obs
            tmax = aiaseq[pos].date_obs
            pstart = pos
        endif
        tend = aiaseq[pos].date_obs
        pend = pos
        xarc = ([min(clust.x), max(clust.x)] - aiaseq[pos].CRPIX1)*aiaseq[pos].CDELT1 + aiaseq[pos].CRVAL1 
        yarc = ([min(clust.y), max(clust.y)] - aiaseq[pos].CRPIX2)*aiaseq[pos].CDELT2 + aiaseq[pos].CRVAL2 
        if xbox eq !NULL then begin
            xbox = xarc
            ybox = yarc
            xmin = min(clust.rotx)
            xmax = max(clust.rotx)
        endif
        xmin = min([xmin, min(clust.rotx)])
        xmax = max([xmax, max(clust.rotx)])
        sy2 += total(clust.roty*clust.roty)
        ntot += n_elements(clust.roty)
        xbox[0] = min([xbox[0], xarc[0]])
        xbox[1] = max([xbox[1], xarc[1]])
        ybox[0] = min([ybox[0], yarc[0]])
        ybox[1] = max([ybox[1], yarc[1]])
        maxcard = max([maxcard, n_elements(clust.x)], imax)
        if imax eq 1 then tmax = aiaseq[pos].date_obs
        if finite(clust.aspect) && n_elements(clust.x) ge mincard then maxasp = max([maxasp, clust.aspect])
    endfor
    
    dx = mean(jet[0].x) - mean(jet[n_elements(jet)-1].x)
    dy = mean(jet[0].y) - mean(jet[n_elements(jet)-1].y)
    moving = sqrt(dx^2 + dy^2)/(n_elements(jet)-1) * 0.6d*725d/12d
    
    avw = sqrt(sy2/ntot)
    totlng = xmax-xmin
    asplng = totlng/avw
    wsec = (pend - pstart) * 12;
    dmin = wsec/60
    dsec = wsec - dmin*60
    dur = string(dmin, "'", dsec, '"', FORMAT = '(I, A, I02, A)') 
    printf, fnum, tstart, tmax, tend, i+1, dur, maxcard, clust[0].totasp, maxasp, asplng, moving, totlng, avw, xbox[0], xbox[1], ybox[0], ybox[1] $
          , FORMAT = '(%"%s, %s, %s, %d, %s, %d, %5.2f, %5.2f, %5.2f, %6.0f, %6.1f, %6.1f, %7.1f, %7.1f, %7.1f, %7.1f")'
endfor    

close, fnum
FREE_LUN, fnum

end
