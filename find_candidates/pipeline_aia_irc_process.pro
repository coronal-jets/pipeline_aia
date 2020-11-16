pro pipeline_aia_irc_process,data, rd, par,  regions

pipeline_aia_irc_get_mask,data, rd, par.sigma1, cmask
PIPELINE_AIA_IRC_MORPH_FILTER, CMASK, par.border
pipeline_aia_irc_cluster, cmask, 1, clust
pipeline_aia_irc_cardinality_filter, cmask, clust, par.card1, rd = rd
regions = clust


    
end
