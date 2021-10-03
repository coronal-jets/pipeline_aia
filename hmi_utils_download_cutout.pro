pro hmi_utils_download_cutout, from, to, x, y, width, height, hmi_dir, cadence = cadence

file_mkdir, hmi_dir

if n_elements(cadence) eq 0 then cadence = 720d

case cadence of
    720: ds = 'hmi.M_720s'
     45: ds = 'hmi.M_45s'
   else: message, 'wrong dataset value: ' + strcompress(string(n_segment), /remove_all)  
endcase

factor = 1d/0.504
query = jsoc_get_query(ds, from, to, [], processing=processing, t_ref=from, x=x, y=y, width=width*factor, height=height*factor)

message,"Requesting data from JSOC...",/info
urls = jsoc_get_urls(query, processing = processing, file_names = filenames)
msg = "got "+strcompress(n_elements(urls),/remove_all)+" URLs"
message,msg,/info

message,'downloading with aria2...',/info
aria2_urls_rand, urls, hmi_dir
message, 'download complete', /info

end
