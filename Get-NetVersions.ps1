function getNetFriendlyName($netRelease) {
		switch ($netRelease) {
			378389 { return '.NET Framework 4.5.0' }
			378675 { return '.NET Framework 4.5.1' } # included in Windows 8.1
			378758 { return '.NET Framework 4.5.1' }
			379893 { return '.NET Framework 4.5.2' }
		}
}


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
