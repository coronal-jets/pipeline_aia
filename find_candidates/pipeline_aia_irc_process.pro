pro pipeline_aia_irc_process,data, rd, par, snaps, pos, seed, regions

snaps = list()

pipeline_aia_irc_get_mask,data, rd, par.sigma1, cmask
PIPELINE_AIA_IRC_MORPH_FILTER, CMASK, par.border
pipeline_aia_irc_cluster, cmask, 1, clust
pipeline_aia_irc_cardinality_filter, cmask, clust, par.card1, rd = rd
regions = clust

;if max(clust) gt 0 then begin
;implot, median(abs(rd/data),5)<(median(abs(rd/data))*par.sigma1)
;loadct, 3,/silent
;contour, cmask, levels = [0.5],/overplot,color =150
;loadct,0,/silent
;wait, 0.2
;stop
;endif


;pipeline_aia_irc_get_mask, rd, par.sigma2, cmask
;pipeline_aia_irc_morph_filter, cmask
;pipeline_aia_irc_expand_mask, cmask, par.border, maskexp
;pipeline_aia_irc_cluster, maskexp, 0, clust
;pipeline_aia_irc_cluster_clean_exp, clust, cmask
;pipeline_aia_irc_cardinality_filter, clust, par.card2

crit = !NULL
jmin = !NULL
for k = 1, max(clust) do begin
    pipeline_aia_irc_get_cluster_coords, clust, k, x, y
    if n_elements(x) gt 0 then begin
        jcx = mean(x)
        jcy = mean(y)
    endif
    found = 0
    if n_elements(x) gt par.card1 then begin
        pipeline_aia_irc_principale_comps, x, y, vx, vy
        aspect = vx gt vy ? vx/vy : vy/vx
        j = {pos:pos, x:x, y:y, aspect:aspect, clust:k}
        if aspect gt par.ellipse then found = 1
    endif
    
    if found then begin
        if ~keyword_set(seed) then begin
            snaps.Add, j
        endif else begin
            critk = pipeline_aia_irc_same_cluster(seed, j, par, area)
            if critk ge 0 then begin
                if crit eq !NULL || critk lt crit then begin
                    crit = critk
                    jmin = j
                endif
            endif
        endelse
    endif    
endfor

if jmin ne !NULL then begin
    snaps.Add, jmin
endif
    
end
