pro pipeline_aia_read_down_config, config, config_file = config_file 

if not keyword_set(config_file) then config_file = "config.json"

config_data = asu_read_json_config(config_file)

config = {tstart:config_data["TIME_START"], tstop:config_data["TIME_STOP"], tref:config_data["TIME_START"] $
        , xc:config_data["X_CENTER"], yc:config_data["Y_CENTER"], wpix:config_data["WIDTH_PIX"], hpix:config_data["HEIGHT_PIX"] $
        , waves:config_data["WAVES"] $
        , timeout:3, count:3, limit:30, timeout_post:5, count_post:3}

config.tref = asu_get_safe_json_key(config_data, "TIME_REF", config.tref)
config.timeout = asu_get_safe_json_key(config_data, "TRY_TIMEOUT", config.timeout)
config.count = asu_get_safe_json_key(config_data, "TRY_COUNT", config.count)
config.limit = asu_get_safe_json_key(config_data, "TRY_LIMIT", config.limit)
config.timeout_post = asu_get_safe_json_key(config_data, "TRY_TIMEOUT_POST", config.timeout_post)
config.count_post = asu_get_safe_json_key(config_data, "TRY_COUNT_POST", config.count_post)

end
