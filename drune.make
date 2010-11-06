core=7.x

projects[views][subdir] = contrib

projects[features][subdir] = contrib

projects[ctools][subdir] = contrib

projects[jplayer][type] = module
projects[jplayer][download][type] = "cvs"
projects[jplayer][download][module] = "contributions/modules/jplayer"
projects[jplayer][download][revision] = "HEAD:2010-11-05"
; Apply patch for D7 port
projects[jplayer][patch][] = "http://drupal.org/files/issues/jplayer_d7_1.patch"

libraries[jplayer][download][type] = "get"
libraries[jplayer][download][url] = "http://www.happyworm.com/jquery/jplayer/latest/jQuery.jPlayer.1.2.0.zip"

projects[getid3][subdir] = contrib
libraries[getid3][download][type] = "get"
libraries[getid3][download][url] = "http://downloads.sourceforge.net/project/getid3/getID3%28%29%201.x/1.7.9/getid3-1.7.9.zip"
