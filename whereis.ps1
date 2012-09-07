# Copied from https://gist.github.com/2006265

function get-path{
    $env:path -split';'
}

function whereis
{
    $argument = $cmd, [string]$arguments = $args;
    foreach ($item in get-path){
#        echo "Looking for $thing in $item"
        foreach ($thing in gci $item -ErrorAction silentlycontinue){
            if($thing.Name.StartsWith($cmd + ".")){
                echo $item;
            }
        }
    }
}

whereis