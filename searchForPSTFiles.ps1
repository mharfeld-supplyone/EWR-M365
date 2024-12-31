# Get all mounted drives
$drives = Get-PSDrive -PSProvider FileSystem

# Initialize an empty array to store the results
$results = @()

# Loop through each drive
foreach ($drive in $drives) {
    # Get the drive letter
    $driveLetter = $drive.Name + ":\"

    # Search for .pst files on the current drive
    Write-Host "Searching for .pst files on $driveLetter..."

	#write the full file path plus name, the file size in bytes, and the last modified date to a CSV in the c:\ folder
    gci -path $driveLetter -recurse -ErrorAction SilentlyContinue -include *.pst|select-object fullname,length,lastwritetime|export-csv c:\pstList-$((Get-Date).ToString('yyyyMMdd')).csv 
}