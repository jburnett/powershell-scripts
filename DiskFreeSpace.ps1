# JB, 12/3/2010
Get-WMIObject Win32_LogicalDisk -filter "DriveType=3" | ft -autosize SystemName, DeviceID, VolumeName, @{Label="Size (GB)";Expression={"{0:N3}" -f($_.Size/1gb)}}, @{Label="Free (GB)";Expression={"{0:N3}" -f($_.Freespace/1gb)}}, @{Label="Pct Free";Expression={"{0:P2}" -f($_.FreeSpace / $_.Size)}}
