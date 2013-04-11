<#
# Sample CorFlags.exe output
Version   : v4.0.30319
CLR Header: 2.5
PE        : PE32
CorFlags  : 9
ILONLY    : 1
32BIT     : 0
Signed    : 1

# TODO: use regex to gather values, put in a class and return. Provide default table formatter
Version\W*:\W*(v.+)
CLR\WHeader\W*:\W*(.+)
PE\W*:\W*(.+)
CorFlags\W*:\W*(.+)
ILONLY\W*:\W*(.+)
32BIT\W*:\W*(.+)
Signed\W*:\W*(.+)

# consider including the assembly's FileInfo for file name, path, etc
FileInfo

#>
