<#
.SYNPOSIS
Ensure existence of terraform resource group and storage account for specified environment.

.DESCRIPTION
Ensure existence of terraform resource group and storage account for specified environment:
- Resource Group: [environment]-[customer]-[project]-terraform, e.g. dev-mycx-myproj-terraform
- Blob Storage Account: [environment][customer][project]terraformsa, e.g. devmycxmyprojterraformsa

The script leverages the Az PowerShell modules.
It also requires to be run in a pre-authenticated session, the current subscription already set to the subscription of the ADLS Gen2 storage account.

Required Az-Modules and tested Version:
- Az.Storage 3.6.0
- Az.Resources 3.5.0


Further dependencies:
- IAM Role
  - [Contributor](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#all) on subscription, to create resource group and storage account

.EXAMPLE
PS> Set-AzContext -Subscription "COIN – Agile Supply Chain – Dev"
PS> Set-TerraformStorageAccount -Environment $Environment -Customer $Customer -Project $Project -Location $Location

.LINK
https://docs.microsoft.com/en-us/powershell/module/az.accounts/Connect-AzAccount?view=azps-6.4.0#examples
https://docs.microsoft.com/en-us/powershell/module/az.accounts/set-azcontext?view=azps-6.4.0#examples
https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az?view=azps-6.4.0
https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-access-control


#>
param (
    [Parameter (Mandatory=$false)]
    [String] $Environment = "dev",

    [Parameter (Mandatory=$false)]
    [String] $Customer = "mycx",

    [Parameter (Mandatory=$false)]
    [String] $Project = "myproj",

    [Parameter (Mandatory=$false)]
    [String] $Location = "WestEurope"
)


function Set-TerraformStorageAccount {
    param (
        [Parameter (Mandatory=$true)]
        [String] $Environment,

        [Parameter (Mandatory=$true)]
        [String] $Customer,

        [Parameter (Mandatory=$true)]
        [String] $Project,

        [Parameter (Mandatory=$true)]
        [String] $Location
    )


    Write-Verbose ("Set-TerraformStorageAccount with environment '{0}', customer '{1}', project '{2}' and location '{3}'" -f $Environment, $Customer, $Project, $Location)

    $resourceGroupName = ("{0}-{1}-{2}-terraform" -f $Environment, $Customer, $Project)
    $storageAccountName = ("{0}{1}{2}terraformsa" -f $Environment, $Customer, $Project).ToLower()
    $containerName = "tfstate"

    Write-Verbose ("Ensuring existance of storage account '{0}' in resource group '{1}' within current subscription" -f $storageAccountName, $resourceGroupName)

    $rg = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction Ignore
    if ($null -eq $rg) {
        Write-Verbose ("+ Creating resource group '{0}' in location '{1}'" -f $resourceGroupName, $Location)
        $rg = New-AzResourceGroup -Name $resourceGroupName -Location $Location
    } else {
        Write-Verbose ("= Resource group '{0}' already exists" -f $resourceGroupName)
    }

    $sa = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -ErrorAction Ignore
    if ($null -eq $sa) {
        Write-Verbose ("+ Creating storage account '{0}' in location '{1}'" -f $storageAccountName, $Location)
        $saParam = @{
            ResourceGroupName      = $resourceGroupName
            Name                   = $storageAccountName
            Location               = $Location
            SkuName                = "Standard_LRS"
            Kind                   = "StorageV2"
            EnableHttpsTrafficOnly = $true 
            AssignIdentity         = $true 
            AllowBlobPublicAccess  = $false 
            MinimumTlsVersion      = "TLS1_2"
        }
        $sa = New-AzStorageAccount @saParam
    } else {
        Write-Verbose ("= Storage account '{0}' already exists" -f $storageAccountName)
    }

    Write-Verbose ("Ensuring existance of container '{0}' in storage account '{1}'" -f $containerName, $storageAccountName)
    $c = $sa.Context | Get-AzStorageContainer -Name $containerName -ErrorAction Ignore
    if ($null -eq $c) {
        Write-Verbose ("+ Creating container '{0}' in storage account '{1}'" -f $containerName, $storageAccountName)
        $c = $sa.Context | New-AzStorageContainer -Name $containerName
    } else {
        Write-Verbose ("= Container '{0}' already exists" -f $containerName)
    }

}


# enforcing rules to ensure valid code - see https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/set-strictmode
Set-StrictMode -Version 3.0

# stop on first error
$ErrorActionPreference = "Stop"

# Enable verbose log
$VerbosePreference = "Continue"

Set-TerraformStorageAccount -Environment $Environment -Customer $Customer -Project $Project -Location $Location