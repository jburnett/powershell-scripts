# Find all GIT directories
gci C:\ -filter ".git" -Force -Recurse -ErrorAction SilentlyContinue | 
    % {
        if ($true -eq $_.PSIsContainer) {
            write-host ' '
            write-host '===================='
            $gitLoc = $_.Parent.FullName
            write-host "Checking " $gitLoc
            push-location $gitLoc
      #  gci
            git-status -s
            pop-location
        }
    }
#    where-object {
#        $_.PSIsContainer
#    } | %{
        # With each GIT location
        write-host "Checking " $_.Parent.DirectoryName; 
      #  push-location $_.Parent.Path
      #  gci
      #  git-status -s
      #  pop-location
#        break
#    }
