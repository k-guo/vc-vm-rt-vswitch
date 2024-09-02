# Import the VMware.PowerCLI module if it's not already loaded
if (-not (Get-Module -Name VMware.PowerCLI -ErrorAction SilentlyContinue)) {
    Import-Module VMware.PowerCLI
}

# Set your vCenter Server information
$server = "vcenter.vmware.com"
$username = ""
$password = ""

# Get the virtual machine name as the first command-line argument
$vmName = $args[0]

if (-not $vmName) {
    Write-Host "Please provide the virtual machine name as the first argument."
    Exit
}

$vmxSettings = @{
    "virtualHW.version" = "21"
#    "ethernet1.realtime" = "TRUE"
#    "vmxnet3.rev.90" = "TRUE"
#    "sched.mem.pin" = "TRUE"
#    "sched.mem.prealloc" = "TRUE"
#    "sched.mem.pinnedMainMem" = "TRUE"
#    "monitor.forceEnableMPTI" = "TRUE"
#    "sched.swap.vmxSwapEnabled" = “FALSE”
#    "numa.nodeAffinity" = "1"
    # Add more settings as needed
}

# Connect to the vCenter Server
Connect-VIServer -Server $server -User $username -Password $password

# Get the virtual machine by name
$vm = Get-VM -Name $vmName

if ($vm) {
    # Check the current power state of the VM
    $vmPowerState = $vm.PowerState

    # Reserve CPU resources with a value of 5188 MHz and set memory reservation.
    # Configure latency sensitivity to "high"
    $spec = New-Object VMware.Vim.VirtualMachineConfigSpec
    $spec.cpuAllocation = New-Object VMware.Vim.ResourceAllocationInfo
    $spec.cpuAllocation.Reservation = 5188  # Set your desired reservation in MHz
    $spec.memoryReservationLockedToMax = $true
    $spec.latencySensitivity = New-Object VMware.Vim.LatencySensitivity
    $spec.LatencySensitivity.Level = [VMware.Vim.LatencySensitivitySensitivityLevel]::high
    $vm.ExtensionData.ReconfigVM($spec)

     # Loop through the settings and update them in the virtual machine's .vmx file
    foreach ($key in $vmxSettings.Keys) {
        $value = $vmxSettings[$key]

        # Check if the setting exists, and if so, update it; otherwise, create a new setting
        $existingSetting = Get-AdvancedSetting -Entity $vm -Name $key -ErrorAction SilentlyContinue
        if ($existingSetting) {
            Set-AdvancedSetting -AdvancedSetting $existingSetting -Value $value -Confirm:$false
        } else {
            New-AdvancedSetting -Entity $vm -Name $key -Value $value -Confirm:$false
        }
    }
}
else {
    Write-Host "Virtual machine $vmName not found."
}

# Disconnect from the vCenter Server
Disconnect-VIServer -Server $server -Confirm:$false
