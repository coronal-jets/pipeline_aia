pro jettests

v = pipeline_aia_all( $
    config_file = 's:\Projects\IDLWork\pipeline_aia\config20160428.json' $
;    , cache_dir = 'd:\UCache\Jets' $ ; does not need for remote_cutout
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
    , work_dir = 'd:\UData\Jets\Collection' $
        )

end
