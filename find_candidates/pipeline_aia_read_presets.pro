pro pipeline_aia_read_presets, presets, presets_file = presets_file 

presets = {sigma1:3.0, card1:400, border:2, ellipse:1.5}

if keyword_set(presets_file) then begin
    presets_data = asu_read_json_config(presets_file)
    
    presets.sigma1 = asu_get_safe_json_key(presets_data, "PASS1_SIGMA1", par1.sigma1)
    presets.card1 = asu_get_safe_json_key(presets_data, "PASS1_CARD1", par1.card1)
    presets.border = asu_get_safe_json_key(presets_data, "PASS1_BORDER", par1.border)
    presets.ellipse = asu_get_safe_json_key(presets_data, "PASS1_ELLIPSE", par1.ellipse)

endif
    


end