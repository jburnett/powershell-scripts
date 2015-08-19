# Open certificate store
push-location cert:

# Iterate through top level (eg., CurrentUser, LocalMachine)
gci | %{

Write-Host "Investigating "$_.Location

    # Iterate through cert containers
    gci | %{

    Write-Host "   Investigating "$_.Name

        # Find certificate
        $thumbprint = 'CDD4EEAE6000AC7F40C3802C171E30148030C072'
        gci -Path $thumbprint -ErrorAction SilentlyContinue
    }    

}

pop-location