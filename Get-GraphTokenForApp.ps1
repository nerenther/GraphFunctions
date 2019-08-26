function Get-GraphTokenForApp
    {
        [CmdletBinding()] 
            Param (
                [Parameter(Mandatory=$True,HelpMessage="Name of tenant, e.g. mytenant.onmicrosoft.com")][ValidateScript({$_.endswith(".onmicrosoft.com","CurrentCultureIgnoreCase")})][string]$TenantName,
                [Parameter(Mandatory=$True,HelpMessage="Application ID from Azure AD app registration")][string]$ApplicationID,
                [Parameter(Mandatory=$True,HelpMessage="Found under Settings for your App and Keys")][string]$AppKey
                )
    Begin {
        Write-Progress "Getting token" -Id 1 -PercentComplete 10

        #Setting variables
        Write-Progress -Activity "Setting variables for later use" -PercentComplete 20 -Id 2 -ParentId 1
        Write-Verbose "Setting variables"
        
        $endpoint = "https://login.microsoftonline.com/$($TenantName)/oauth2/v2.0/token"
        $resources = "https://graph.microsoft.com"
        $grantType = "client_credentials"
        $scope = "https://graph.microsoft.com/.default"
        
        Write-Progress -Activity "Setting variables for later use" -Id 2 -ParentId 1 -Completed
        }

    Process {
        #Composing body for rest call
        Write-Progress -Activity "Composing body to be used for REST call" -PercentComplete 25 -Id 2 -ParentId 1
        Write-Verbose "Composing body for rest call"
        
        $JSONBody = @{
            client_id = $ApplicationID
            client_secret = $AppKey
            resources = $resources
            grant_type = $granttype
            scope = $scope
            }
        
        Write-Progress -Activity "Composing body to be used for REST call" -Completed -Id 2 -ParentId 1

        #Invoking rest call
        Write-Progress -Activity "Invoking REST call" -PercentComplete 30 -Id 2 -ParentId 1
        Write-Verbose "Invoking rest"
        
        $RESTcall = Invoke-RestMethod -Method Post -Uri $endpoint -Body $JSONBody -ContentType 'application/x-www-form-urlencoded' -Headers @{'content_type' = 'application/x-www-form-urlencoded'}
        
        Write-Progress -Activity "Invoking REST call" -Completed -Id 2 -ParentId 1
        }

    End {
        #Outputting object returned from Graph
        Write-Progress -Activity "Outputting token" -Id 1 -PercentComplete 55
        Write-Verbose "Outputting object from Graph"
        
        $RESTcall
        
        Write-Progress -Activity "Outputting token" -Id 1 -Completed
        Write-Verbose "All done"
        }
    
        
<#
 .Synopsis
  Genereates Graph API token for an app
 .Description
  Authenticates againt Microsofts Graph API using an app registred in Azure Active Directory and generates a token
 .Parameter TenantName
  The name of your tenant, ending with .onmicrosoft.com. E.g. mytenant.onmicrosoft.com
 .Parameter ApplicationID
  Your apps ID, can be found in the Azure portal. Navigate to your Azure AD and look under application registrations
 .Parameter AppKey
  A secret key you generate for you app
  .Example
  Get-GraphTokenForApp -TenantName "M365x789673.onmicrosoft.com" -ApplicationID "03cc1835-4dda-4de1-abdc-f61cec10cfe2" -AppKey "lzmwCUt44RyqcjuOnQUNPy5XeI6Y1Ghkp6awbxLEMfI="
  Generates an access token for the application with the specified ID
 .Link
  http://cloud.kemta.net
 #>
}