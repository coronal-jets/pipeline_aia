pro jettests

v = pipeline_aia_all( $

      work_dir = '/home/stupishin/Jet_test' $
    , config_file = '/home/stupishin/coronal_jets/pipeline_aia/config_sample.json' $
    
    , presets_file = '/home/stupishin/coronal_jets/pipeline_aia/presets_default.json' $
    , no_cand  = 0 $
    , no_visual = 0 $
    
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
;    , /no_details $
        )

end
