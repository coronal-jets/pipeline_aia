pro pipeline_aia_read_presets, presets, presets_file = presets_file 

presets = {MIN_SIZE:2, FILL_SIZE:15, MASK_THRESHOLD:3.0, BORDER:2, MIN_AREA:400, MIN_DURATION:10,MIN_ASPECT:2.0}

if keyword_set(presets_file) then begin
    presets_data = asu_read_json_config(presets_file)
    
    presets.MIN_SIZE = asu_get_safe_json_key(presets_data, "MIN_SIZE", presets.MIN_SIZE)
    presets.FILL_SIZE = asu_get_safe_json_key(presets_data, "FILL_SIZE", presets.FILL_SIZE)
    presets.MASK_THRESHOLD = asu_get_safe_json_key(presets_data, "MASK_THRESHOLD", presets.MASK_THRESHOLD)
    presets.BORDER = asu_get_safe_json_key(presets_data, "BORDER", presets.BORDER)
    
    presets.MIN_AREA = asu_get_safe_json_key(presets_data, "MIN_AREA", presets.MIN_AREA)
    presets.MIN_DURATION = asu_get_safe_json_key(presets_data, "MIN_DURATION", presets.MIN_DURATION)
    presets.MIN_ASPECT = asu_get_safe_json_key(presets_data, "MIN_ASPECT", presets.MIN_ASPECT)

endif

end