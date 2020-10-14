pro pipeline_aia_csv_output, fnum, filename, candlist, aiaseq 

openw, fnum, filename

printf, fnum, 'T start', 'T max', 'T end', 'Duration', 'Max cardinality', 'Max aspect ratio', 'Min aspect ratio', 'X from', 'X to', 'Y from', 'Y to', $
     FORMAT = '(%"%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s")'

for i = 0, n_elements(candlist)-1 do begin
    jet = candlist[i]
    tstart = !NULL
    tmax = !NULL
    tend = !NULL
    maxcard = !NULL
    maxasp = !NULL
    minasp = !NULL
    xbox = !NULL
    ybox = !NULL
    pstart = !NULL
    pend = !NULL
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
            maxcard = n_elements(clust.x)
            maxasp = clust.aspect
            minasp = clust.aspect
        endif
        xbox[0] = min([xbox[0], xarc[0]])
        xbox[1] = max([xbox[1], xarc[1]])
        ybox[0] = min([ybox[0], yarc[0]])
        ybox[1] = max([ybox[1], yarc[1]])
        maxcard = max([maxcard, n_elements(clust.x)], imax)
        if imax eq 1 then tmax = aiaseq[pos].date_obs
        maxasp = max([maxasp, clust.aspect])
        minasp = min([minasp, clust.aspect])
    endfor
    
    wsec = (pend - pstart) * 12;
    dmin = wsec/60
    dsec = wsec - dmin*60
    dur = string(dmin, "'", dsec, '"', FORMAT = '(I, A, I02, A)') 
    printf, fnum, tstart, tmax, tend, dur, maxcard, maxasp, minasp, xbox[0], xbox[1], ybox[0], ybox[1], FORMAT = '(%"%s, %s, %s, %s, %d, %5.2f, %5.2f, %6.1f, %6.1f, %6.1f, %6.1f")'
endfor    

close, fnum

end
