pro jettests_batch

pipeline_aia_all_batch $
    , config_path = 'd:\UData\Jets\testbatch' $
;    , cache_dir = 'd:\UCache\Jets' $ ; does not need for remote_cutout
;    , /no_load $
;    , /no_cut $
;    , remote_cutout = 1 $
;    , waves = [171, 193, 211, 304] $
;    , maxtime = 8 $
;    , use_jpg = 0 $
;    , harc = 300 $
;    , warc = 300 $
;    , use_contour = 1 $
;    , fps = 5 $
;    , method = 1 $
;    , graphtype = 1
    , work_dir = 'd:\UData\Jets\CollectionBatch'

end
