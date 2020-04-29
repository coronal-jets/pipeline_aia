function xy2carrington, x_arcsec, y_arcsec, time_ref
compile_opt idl2
  wcs_ref = wcs_2d_simulate(4096, 4096, date_obs = time_ref)
  n = n_elements(x_arcsec)
  crd = dblarr(2,n)
  crd[0,*] = x_arcsec
  crd[1,*] = y_arcsec
  wcs_convert_from_coord, wcs_ref, crd, 'HG', cr_lon, cr_lat,/carrington
  return, {cr_lon: cr_lon, cr_lat:cr_lat}

end

pro pipeline_aia_fits_cutout, fits_in, fits_out, center, size_px
compile_opt idl2
  cdelt = [0.6d, 0.6d]
  read_sdo, fits_in, index_in, data_in, /use_shared, /uncomp_delete
  data_in = float(data_in)
  wcs_in = fitshead2wcs(index_in)
  wcs_convert_to_coord, wcs_in, crval, 'HG', center.cr_lon, center.cr_lat, /carrington
  
  index_out = index_in
  index_out.cdelt1 = cdelt[0]
  index_out.cdelt2 = cdelt[1]
  index_out.naxis1 = size_px[0]
  index_out.naxis2 = size_px[1]
  index_out.crval1 = crval[0]
  index_out.crval2 = crval[1]
  index_out.crpix1 = size_px[0]*0.5
  index_out.crpix2 = size_px[1]*0.5
  wcs_out = fitshead2wcs(index_out)
  data_out = wcs_remap(data_in, wcs_in, wcs_out)
  
  ;exposure_normalisation
  data_out /= index_in.exptime
  index_out.exptime =1.0
  
  writefits, fits_out, float(data_out), index_out
end

pro pipeline_aia_dir_cutout, dir_in, dir_out, center, size_px
  files_in = file_search(filepath('*.fits', root_dir = dir_in))
  files_out = filepath(file_basename(files_in), root_dir = dir_out)
  foreach file_in, files_in, i do begin
    file_out =  files_out[i]
    pipeline_aia_fits_cutout, file_in, file_out, center, size_px
  endforeach
end


pro pipeline_aia_cutout
  config_file = "config.json"
  ;read config
  config = read_json_config(config_file)
  x_center = config["X_CENTER"]
  y_center = config["Y_CENTER"]
  width_pix = config["WIDTH_PIX"]
  height_pix = config["HEIGHT_PIX"]
  time_ref = config["TIME_REF"]
  
  center = xy2carrington(x_center, y_center, time_ref)
  wave_dirs_in = file_search(filepath('full_*', subdirectory = 'aia_data', root_dir = '.'), /test_directory)
  foreach dir_in, wave_dirs_in do begin
    dir_out = str_replace(dir_in, 'full_', '')
    file_mkdir, dir_out
    pipeline_aia_dir_cutout, dir_in, dir_out, center, [width_pix, height_pix]
  endforeach
  
end