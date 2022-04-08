# WorkingWithAzureVMs

Small sample showing how to filter using tags on particular VMs.

Ops Team can use get-azvm to get a list of all VMs in the subscription, or use resource group to pre-filter before using Tags or other mechanisms to filter VMs on which to run commands.

AzVMRunCommand invocation can be added to Azure Automation or Azure DevOps as needed.