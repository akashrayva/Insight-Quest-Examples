#1. Define variables to retrieve parameter values stored as Azure Automation variables or credentials

$AzureASResource = Get-AutomationVariable -Name 'AzureASResource'
$Tenant = Get-AutomationVariable -Name 'FrontlineTenant'
$ResourceGroup = Get-AutomationVariable -Name 'BIResourceGroupName'

$AzureCred = Get-AutomationPSCredential -Name "AzureASRefreshCred"

#2. Authenticate with stored credential in Azure Automation

Connect-AzureRmAccount -Credential $AzureCred -Tenant $Tenant -ServicePrincipal  

#3. Capture Azure AS Server state

$ServerConfig = Get-AzureRmAnalysisServicesServer -ResourceGroupName $ResourceGroup -Name $AzureASResource

$ServerState = $ServerConfig.State

#4. Resume (start) the server if paused

If($ServerState -eq "Paused")
    {Resume-AzureRmAnalysisServicesServer -Name $AzureASResource -ResourceGroupName $ResourceGroup}
    Else {Write-Host "Server is already running"}