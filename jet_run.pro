pro jet_run

  pipeline_aia_all $
    , config_file = dialog_pickfile(title = "Select jet configuration file") $
    , presets_file = dialog_pickfile(title = "Select presets file",$
                    file = 'presets_std.json')$
    , fps = 5

end