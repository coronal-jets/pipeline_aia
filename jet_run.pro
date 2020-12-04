pro jet_run

  pipeline_aia_all $
    , config_file = dialog_pickfile(title = "Select jet configuration file",filter=['config*.json','*.json']) $
    , presets_file = dialog_pickfile(title = "Select presets file",$
                    filter=['presets*.json','*.json'])$
    , fps = 5

end