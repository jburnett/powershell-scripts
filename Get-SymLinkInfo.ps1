# TODO: add param for starting path
dir . -recurse -force | ?{$_.LinkType} | select FullName,LinkType,Target