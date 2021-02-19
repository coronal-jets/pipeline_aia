pro jettests_batch

pipeline_aia_all_batch $
    , config_path = 's:\University\Work\Jets\Configs\2017' $
    , work_dir = 'd:\UData\Jets\CollectionBatch' $
    ;, cache_dir = 'd:\UCache\Jets' $ ; does not need for remote_cutout
    ;, remote_cutout = 0 $
    ;, /no_load $
    ;, /no_cut $
    , fps = 5 $
    , maxtime = 5 $
    , method = 0 $
    , graphtype = 1

end
