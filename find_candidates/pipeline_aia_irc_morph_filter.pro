pro pipeline_aia_irc_morph_filter,cmask, border
  radius = 2
  sz = radius*2+1
  
  ;removing small objects
  pattern = shift(dist(sz),radius,radius) le radius
  cmask = morph_open(cmask, pattern)
  
  ;filling large gaps
  radius = 15.
  sz = radius*2+1
  pattern = shift(dist(sz),radius,radius) le radius
  cmask = morph_close(cmask, pattern)
  
  ;extend border
  ;filling large gaps
  radius = border
  sz = radius*2+1
  pattern = shift(dist(sz),radius,radius) le radius
  cmask = dilate(cmask, pattern)
end