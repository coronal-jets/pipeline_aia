pro pipeline_aia_config_prepare
  t1 = '2019-06-06 05:00:00'
  t2 = '2019-06-06 05:00:15'
  t_ref = t1
  x = 200.
  y = 300.
  width = 400
  height = 400
  waves = [171,304]
  
  config = {time_start:t1, time_stop:t2, time_ref:t1, x_center:x, y_center:y, width_pix:width, height_pix:height, waves:waves}
  json = json_serialize(config)
  openw, lun, "config_example.json",/get_lun 
  printf, lun, json
  close, lun
  free_lun, lun
  
end