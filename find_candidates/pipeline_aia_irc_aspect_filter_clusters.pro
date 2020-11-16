pro pipeline_aia_irc_aspect_filter_clusters, clust, aspect_threshold
  message,"Filtering clusters by aspect...",/info
  if n_elements(threshold) eq 0 then threshold = 4.0
  n = max(clust)
  for k=1, n do begin
    mask_3d = clust eq k
    ind = where(mask_3d)
    mask = total(mask_3d,3) gt 0
    pipeline_aia_irc_get_cluster_coords, mask, 1, x, y
    pipeline_aia_irc_principale_comps, x, y, vx, vy
    aspect = vx gt vy ? vx/vy : vy/vx
    if aspect lt aspect_threshold then begin
      clust[ind] = 0
    endif
  endfor

end