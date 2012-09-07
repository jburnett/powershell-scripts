$Parameters = '/passive /norestart'
start-process $args[0] -ArgumentList $Parameters -Wait -PassThru