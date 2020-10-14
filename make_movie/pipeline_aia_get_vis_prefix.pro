function pipeline_aia_get_vis_prefix, config_file = config_file

pipeline_aia_read_down_config, config, config_file = config_file 

time = stregex(config.tstart,'([0-9]+)-([0-9]+)-([0-9]+) ([0-9]+):([0-9]+):([0-9]+)',/subexpr,/extract)
time_rel = time[1] + time[2] + time[3] + '_' + time[4] + time[5] + time[6]
prefix = time_rel $
    + '_' + strcompress(fix(config.xc),/remove_all) + '_' + strcompress(fix(config.yc),/remove_all) 

return, prefix

end
    