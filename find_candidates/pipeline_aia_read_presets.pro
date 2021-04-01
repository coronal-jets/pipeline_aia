pro pipeline_aia_read_presets, presets, presets_file = presets_file 

pipeline_aia_read_presets_m0, presets0, presets_file = presets_file 

presets = {MASK_THRESHOLD:3.0 $
         , MIN_SIZE:2, FILL_SIZE:15, BORDER:2 $ % space morphology
         , MIN_SIZE_T:2, FILL_SIZE_T:15, BORDER_T:2 $ % space morphology
         , MIN_AREA:400, MIN_DURATION:10 $
         , MIN_ASPECT:3.0 $ ; SA, MM3D methods (1, 2)
         , par1:presets0.par1, par2:presets0.par2, parcom:presets0.parcom $ ; for AS method (0)
          }

if keyword_set(presets_file) then begin
    presets_data = asu_read_json_config(presets_file)
    
    presets.MASK_THRESHOLD = asu_get_safe_json_key(presets_data, "MASK_THRESHOLD", presets.MASK_THRESHOLD)
    presets.MIN_SIZE = asu_get_safe_json_key(presets_data, "MIN_SIZE", presets.MIN_SIZE)
    presets.FILL_SIZE = asu_get_safe_json_key(presets_data, "FILL_SIZE", presets.FILL_SIZE)
    presets.BORDER = asu_get_safe_json_key(presets_data, "BORDER", presets.BORDER)
    presets.MIN_SIZE_T = asu_get_safe_json_key(presets_data, "MIN_SIZE_T", presets.MIN_SIZE_T)
    presets.FILL_SIZE_T = asu_get_safe_json_key(presets_data, "FILL_SIZE_T", presets.FILL_SIZE_T)
    presets.BORDER_T = asu_get_safe_json_key(presets_data, "BORDER_T", presets.BORDER_T)
    
    presets.MIN_AREA = asu_get_safe_json_key(presets_data, "MIN_AREA", presets.MIN_AREA)
    presets.MIN_DURATION = asu_get_safe_json_key(presets_data, "MIN_DURATION", presets.MIN_DURATION)
    presets.MIN_ASPECT = asu_get_safe_json_key(presets_data, "MIN_ASPECT", presets.MIN_ASPECT)

endif

end
