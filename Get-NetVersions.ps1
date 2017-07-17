function getNetFriendlyName($netRelease) {
		switch ($netRelease) {
			378389 { return '.NET Framework 4.5.0' }
			378675 { return '.NET Framework 4.5.1 (Windows 8.1 or Windows Server 2012 R2)' }
			378758 { return '.NET Framework 4.5.1 (Windows 8, Windows 7 SP1, or Windows Vista SP2)' }
			379893 { return '.NET Framework 4.5.2' }
			393295 { return '.NET Framework 4.6.0 (Windows 10)' }
			393297 { return '.NET Framework 4.6.0 (non-Windows 10)' }
			393295 { return '.NET Framework 4.6.1 (Windows 10)' }
			394271 { return '.NET Framework 4.6.1 (non-Windows 10)' }
			394802 { return '.NET Framework 4.6.2 (Windows 10)' }
			394806 { return '.NET Framework 4.6.2 (non-Windows 10)' }
		}
}

# info from https://msdn.microsoft.com/en-us/library/hh925568(v=vs.110).aspx
# .NET Framework 4.5	378389
# .NET Framework 4.5.1 installed with Windows 8.1	378675
# .NET Framework 4.5.1 installed on Windows 8, Windows 7 SP1, or Windows Vista SP2	378758
# .NET Framework 4.5.2	379893
# .NET Framework 4.6 installed with Windows 10	393295
# .NET Framework 4.6 installed on all other Windows OS versions	393297
# .NET Framework 4.6.1 installed on Windows 10	394254
# .NET Framework 4.6.1 installed on all other Windows OS versions	394271
# .NET Framework 4.6.2 installed on Windows 10 Anniversary Update	394802
# .NET Framework 4.6.2 installed on all other Windows OS versions	394806

function getNetNameOfKey([Microsoft.Win32.RegistryKey]$regKey) {

	get-itemproperty $regKey.PSPath | %{  # | fl *
		$frName = getNetFriendlyName $_.Release
#		$_ | add-member -MemberTypeNoteProperty -Name NETFxProductName -Value $frName
#		echo $_.PSChildName
		#return the friendly name and the installation type
		return "$frName ("+$_.PSChildName+")"
	}
}


#globals
$netFxv4RegPath = 'HKLM:/SOFTWARE/Microsoft/NET Framework Setup/NDP/V4' 
$forOutput = @()
$outputFormat = @{Expression={$_.ProductName};Label="Product Name";width=30}, `
				@{Expression={$_.Version};Label="Version";width=12}, `
				@{Expression={$_.Release};Label="Release #";width=12}, `
				@{Expression={$_.InstallType};Label="Install Type"}

if (test-path $netFxv4RegPath) {
	# navigate to the .NET Fx v4 location in registry
	push-location -Path $netFxv4RegPath

	# iterate the install types (Full & Client)
	get-childitem . | %{
		#build the friendly name
		get-itemproperty $_.PSPath | %{
			$frName = getNetFriendlyName $_.Release
			$frName += " ("+$_.PSChildName+")"
			
			#create hash table of properties for output
			$properties = @{}
			$properties.ProductName = $frName
			$properties.InstallType = $_.PSChildName
			$properties.Version = $_.Version.ToString().Trim()
			$properties.Release = $_.Release.ToString().Trim()
			
			#add properties to array of objects for output
			$forOutput += new-object -TypeName PSObject -Prop $properties
		}

	}
	
	#output the results in tabular format
	$forOutput | ft $outputFormat #-AutoSize

	pop-location
}
