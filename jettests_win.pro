pro jettests_win

v = pipeline_aia_all( $

      work_dir = 'c:\Temp\Jet_test' $
    , config_file = 's:\Projects\IDL\Jets\pipeline_aia\config_sample.json' $
    , presets_file = 's:\Projects\IDL\Jets\pipeline_aia\presets_default.json' $
    
;    , waves = [171] $
;    , cache_dir = '/home/stupishin/coronal_jets/Cache' $ ; does not need for remote_cutout
;    , /no_load $
;    , /no_cut $
;    , /remote_cutout $
;    , /ref_images $
;    , maxtime = 24 $
;    , /use_jpg $
;    , harc = 300 $
;    , warc = 300 $
;    , /use_contour $
;    , graphtype = 1
;    , fps = 5 $
;    , method = 1 $
;    , /test $
;    , /no_cand $
;    , /no_details $
        )
end
