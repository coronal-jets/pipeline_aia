pro jettests_batch_win

vntot = pipeline_aia_all_batch( $
      config_path = 'g:\BIGData\UData\Jets\Devl_20211231\Configs' $
    , work_dir = 'g:\BIGData\UData\Jets\Devl_20211231\Jets' $
    , presets_file = 's:\Projects\IDL\Work\presets_test_med.json' $     
;    , cache_dir = '/home/stupishin/coronal_jets/Cache' $ ; does not need for remote_cutout
    , /no_load $
;    , /no_cut $
;    , /remote_cutout $
;    , /ref_images $
    , waves = [171] $
;    , maxtime = 24 $
;    , /use_jpg $
;    , harc = 300 $
;    , warc = 300 $
;    , /use_contour $
;    , graphtype = 1
;    , fps = 5 $
;    , method = 1 $
    , /test $
;       , /no_details $
    )
    
end
