pro pipeline_aia_irc_remove_short_clusters, clust, threshold
  message,"Removing short clusters...",/info
  if n_elements(threshold) eq 0 then threshold = 20
  n = max(clust)
  for i=1, n do begin
    ind = where(clust eq i)
    ind3d = array_indices(clust, ind)
    ind3 = ind3d[2,*]
    uniq_ind = uniq(ind3, sort(ind3))
    if n_elements(uniq_ind) le threshold then clust[ind] = 0
  endfor
  uniq_val = clust[uniq(clust, sort(clust))]
  n = n_elements(uniq_val)
  for i=1,n-1 do begin
    ind = where(clust eq uniq_val[i])
    clust[ind] =i
  endfor

end