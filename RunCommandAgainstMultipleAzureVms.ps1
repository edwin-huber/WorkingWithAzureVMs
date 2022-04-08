# using env vars for subscription and resource group settings...
$subscriptionId = $env:PS_SUBSCRIPTION
$resourceGroup = $env:PS_RESOURCE_GROUP

if($null -eq $subscriptionId -or  "" -eq $subscriptionId ){
    $subscriptionId = "your subscription guid here"
    $resourceGroup = "your resource group name"
}

# Filter using tags
$tagName = "mytag"
$tagValue = "magic"

# Azure subscription
Write-Output "Running in subscription : "
Set-AzContext -Subscription $subscriptionId | Format-List Name

Write-Output "Getting VMs..."
# Get collection of Azure VMs according to selection criteria 
$azureVMs = Get-AzVM -ResourceGroupName $resourceGroup -status | Where-Object {$_.Tags[$tagName] -eq $tagValue -and $_.PowerState -eq "VM running" -and $_.StorageProfile.OSDisk.OSType -eq "Windows"}

Write-Output "Results:"
# You can run this operation in parallel 
# with the -Parallel parameter on the ForEach statement
# We assume the presence of a powershell script called script.ps1 
# in the same folder for this particular command run (see workspace)
$azureVMs | ForEach-Object {
    # if using with an automation account, you can use a managed identity
    # to pull secrets to access machines etc from a keyvault
    $out = Invoke-AzVMRunCommand `
        -ResourceGroupName $_.ResourceGroupName `
        -Name $_.Name  `
        -CommandId 'RunPowerShellScript' `
        -ScriptPath .\script.ps1 
    # Results can be output here, or output to storage
    $output = '{"machine":"' + $_.Name + '","context":"' + $out.Value[0].Message + '"}'
    $output   
}