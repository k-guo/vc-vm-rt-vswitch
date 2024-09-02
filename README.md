# vc-vm-rt-vswitch
Powershell script to set VM configuration for real-time settings and add parameters for VM to be Industrial vSwitch Compatible

The Powershell script reserves proper CPU (example shows 2 physical cores) and all memory assigned to the VM, and configures high-latency sensitivity. Additionally, it also adds the extra configuration parameters in the .vmx file for the VM to be compatible with Industrial vSwitch feature (currently in Beta).
![reserve_cpu_and_memory](https://github.com/user-attachments/assets/2861b904-57b7-4b8e-9c87-6e5f6b4a1a30)
![set_high_latency_sensitivity](https://github.com/user-attachments/assets/c57c5706-8f47-4173-b0bf-54580af227da)

### Script Usage
Run the script in Powershell with the virtual machine name as the only argument

Example syntax:
PS /Users/keng/Github/vc-vm-rt-vswitch> ./set-vm-rt-settings.ps1 <vm_name>