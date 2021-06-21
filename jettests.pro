pro jettests

v = pipeline_aia_all( $
      config_file = '/home/stupishin/coronal_jets/Configs/config20200103_071000.json' $
    , work_dir = '/home/stupishin/coronal_jets/Jets' $
;    , presets_file = '/home/stupishin/idl/lib/pipeline_aia/presets_std.json' $     
;    , cache_dir = '/home/stupishin/coronal_jets/Cache' $ ; does not need for remote_cutout
;    , /no_load $
;    , /no_cut $
;    , /remote_cutout $
;    , /ref_images $
;    , waves = [171, 193, 211, 304] $
;    , maxtime = 8 $
;    , /use_jpg $
;    , harc = 300 $
;    , warc = 300 $
;    , /use_contour $
;    , graphtype = 1
;    , fps = 5 $
;    , method = 1 $
;    , /test $
        )

end
