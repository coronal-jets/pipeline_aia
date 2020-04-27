pro pipeline_remove_fullsun_aia
  dirs_to_remove = file_search(filepath('full_*',root_dir = 'aia_data'),/test_directory, /mark_directory)
  file_delete,dirs_to_remove,/recursive
end