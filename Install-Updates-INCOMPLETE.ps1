gci *.msu | % {
    ft $_.Properties
    
    $psStartInfo = new-object System.Diagnostics.ProcessStartInfo $_  
    if ($psStartInfo) {
        $psStartInfo.Arguments = " /quiet /norestart ";
        $currUpd = [System.Diagnostics.Process]::Start($psStartInfo); 
        $currUpd.WaitForExit()
    }
}