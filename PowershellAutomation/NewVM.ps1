# Base Configuration
$BasePath = "D:\VMs"  # Use D:\VMs as the storage path
$MemoryStartupBytes = 2147483648 # 2 GB
$MasterVHDPath = "$BasePath\Base_Ubuntu_Image.vhdx" # Path to the pre-installed master VHD
$DefaultSwitchName = "Default Switch" # Default Hyper-V switch
$CompanySwitchName = "company net" # Additional network switch

$VMName = "LoadBalancer"

# Define individual VM path
$VMPath = "$BasePath\$VMName"
$VHDPath = "$VMPath\$VMName.vhdx"

# Create VM folder
if (-Not (Test-Path -Path $VMPath)) {
    New-Item -ItemType Directory -Path $VMPath | Out-Null
}

# Copy the master VHD
Copy-Item -Path $MasterVHDPath -Destination $VHDPath

# Create VM parameters
$VM = @{
    Name = $VMName
    MemoryStartupBytes = $MemoryStartupBytes
    Generation = 2
    VHDPath = $VHDPath
    BootDevice = "VHD"
    Path = $VMPath
}

# Create VM
Write-Host "Creating VM: $VMName"
New-VM @VM

# Add network adapters
Write-Host "Attaching network switches to $VMName"
Add-VMNetworkAdapter -VMName $VMName -SwitchName $DefaultSwitchName -Name "DefaultAdapter"
Add-VMNetworkAdapter -VMName $VMName -SwitchName $CompanySwitchName -Name "CompanyAdapter"

Write-Host "VM has been created successfully with two network adapters."
