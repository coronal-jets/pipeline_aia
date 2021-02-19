pro pipeline_aia_read_down_config, config, config_file = config_file, waves = waves, warc = warc, harc = harc

if not keyword_set(config_file) then config_file = "config.json"

config_data = asu_read_json_config(config_file)

config = {tstart:config_data["TIME_START"], tstop:config_data["TIME_STOP"], tref:config_data["TIME_START"] $
        , xc:config_data["X_CENTER"], yc:config_data["Y_CENTER"], wpix:300, hpix:300 $
        , waves:config_data["WAVES"] $
        , timeout:3, count:3, limit:30, timeout_post:5, count_post:3}

if n_elements(waves) ne 0 then begin
    wlist = list()
    foreach vwave, waves do wlist.Add, vwave
    config.waves = wlist
endif

config.wpix = asu_get_safe_json_key(config_data, "WIDTH_PIX", config.wpix)
config.wpix = asu_get_safe_json_key(config_data, "WIDTH_ARC", config.wpix)
if n_elements(warc) ne 0 then config.wpix = warc

config.hpix = asu_get_safe_json_key(config_data, "HEIGHT_PIX", config.hpix)
config.hpix = asu_get_safe_json_key(config_data, "HEIGHT_ARC", config.hpix)
if n_elements(harc) ne 0 then config.hpix = harc

config.hpix = fix(config.hpix/0.6)
config.wpix = fix(config.wpix/0.6)

;time = stregex(config.tstart,'([0-9]+)-([0-9]+)-([0-9]+) ([0-9]+):([0-9]+):*([0-9]*)',/subexpr,/extract)
;if time[6] eq '' then time[6] = '00' 
;time_rel = time[1] + time[2] + time[3] + '_' + time[4] + time[5] + time[6]
;time = stregex(config.tstop,'([0-9]+)-([0-9]+)-([0-9]+) ([0-9]+):([0-9]+):*([0-9]*)',/subexpr,/extract)
;if time[6] eq '' then time[6] = '00' 

config.tref = asu_get_safe_json_key(config_data, "TIME_REF", config.tref)
config.timeout = asu_get_safe_json_key(config_data, "TRY_TIMEOUT", config.timeout)
config.count = asu_get_safe_json_key(config_data, "TRY_COUNT", config.count)
config.limit = asu_get_safe_json_key(config_data, "TRY_LIMIT", config.limit)
config.timeout_post = asu_get_safe_json_key(config_data, "TRY_TIMEOUT_POST", config.timeout_post)
config.count_post = asu_get_safe_json_key(config_data, "TRY_COUNT_POST", config.count_post)

end
