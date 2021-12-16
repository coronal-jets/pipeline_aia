pro jettests_win

v = pipeline_aia_all( $
;      config_file = 'g:\BIGData\UData\Jets\Devl_20211110\Configs\config20141004_100500.json' $
;      config_file = 'g:\BIGData\UData\Jets\Devl_20211110\Configs\config20120705_031800.json' $
;      config_file = 'g:\BIGData\UData\Jets\Devl_20211110\Configs\config20150510_181600.json' $
;      config_file = 'g:\BIGData\UData\Jets\Devl_20211110\Configs\config20100604_091600.json' $
;      config_file = 'g:\BIGData\UData\Jets\Devl_20211110\Configs\config20100620_110400.json' $
;      config_file = 'g:\BIGData\UData\Jets\Devl_20211110\Configs\config20100623_161300.json' $
;      config_file = 'g:\BIGData\UData\Jets\Devl_20211110\Configs\config20100627_022400.json' $
;      config_file = 'g:\BIGData\UData\Jets\Devl_20211110\Configs\config20100720_205400.json' $
;      config_file = 'g:\BIGData\UData\Jets\Devl_20211110\Configs\config20100721_064800.json' $
;      config_file = 'g:\BIGData\UData\Jets\Devl_20211110\Configs\config20100721_064800.json' $
;      config_file = 'g:\BIGData\UData\Jets\Devl_20211110\Configs\config20100703_191500.json' $
;      
;    , work_dir = 'g:\BIGData\UData\Jets\Devl_20211110\Jets' $

;-------------------------------------------------------------------------------------
;      config_file = 'g:\BIGData\UData\Jets\Tests_20211118\Configs\config20100720_205400.json' $
;      config_file = 'g:\BIGData\UData\Jets\Tests_20211118\Configs\config20141004_100500.json' $
;      config_file = 'g:\BIGData\UData\Jets\Tests_20211118\Configs\config20150510_181600.json' $

;      config_file = 'g:\BIGData\UData\Jets\Tests_20211118\Configs\config20150308_220800.json' $
;      config_file = 'g:\BIGData\UData\Jets\Tests_20211118\Configs\config20150308_150500.json' $
;      config_file = 'g:\BIGData\UData\Jets\Tests_20211118\Configs\config20150425_101500.json' $
;      config_file = 'g:\BIGData\UData\Jets\Tests_20211118\Configs\config20150121_205500.json' $
;      config_file = 'g:\BIGData\UData\Jets\Tests_20211118\Configs\config20150119_095000.json' $
 
;      config_file = 'g:\BIGData\UData\Jets\Tests_20211118\Configs\config20180517_201000.json' $
;      config_file = 'g:\BIGData\UData\Jets\Tests_20211118\Configs\config20181012_202930.json' $
;      config_file = 'g:\BIGData\UData\Jets\Tests_20211118\Configs\config20190104_202500.json' $

;    , work_dir = 'g:\BIGData\UData\Jets\Tests_20211118\Jets' $
;       
;-------------------------------------------------------------------------------------
;      config_file = 'g:\BIGData\UData\Jets\Tests_spec\Configs\config20140421_235500.json' $
;      config_file = 'g:\BIGData\UData\Jets\Tests_spec\Configs\config20140421_235500_t.json' $
      config_file = 'g:\BIGData\UData\Jets\Tests_spec\Configs\config20140421_235500_t2.json' $
;      config_file = 'g:\BIGData\UData\Jets\Tests_spec\Configs\config20150308_150500.json' $
    , work_dir = 'g:\BIGData\UData\Jets\Tests_spec\Jets' $
         
;-------------------------------------------------------------------------------------
         
    , presets_file = 's:\Projects\IDL\Work\presets_test.json' $
             
;    , cache_dir = '/home/stupishin/coronal_jets/Cache' $ ; does not need for remote_cutout
    , /no_load $
;    , /no_cut $
;    , /remote_cutout $
;    , /ref_images $
    , waves = [171] $
;    , waves = [94, 131] $
;    , waves = [94] $
    , maxtime = 24 $
;    , /use_jpg $
;    , harc = 300 $
;    , warc = 300 $
;    , /use_contour $
;    , graphtype = 1
;    , fps = 5 $
;    , method = 1 $
    , /test $
;    , /no_cand $
;    , /no_details $
        )

end
