function Get-AADusersFromGraph
    {
        [CmdletBinding()] 
            Param (
                [Parameter(Mandatory=$True,Position=0,HelpMessage='Full object returned from Graph when asking for token')]$GraphToken
                  )
    Begin {
        Write-Progress "Getting users" -Id 1 -PercentComplete 10

        #Setting variables
        Write-Progress -Activity "Setting variables for later use" -PercentComplete 20 -Id 2 -ParentId 1
        Write-Verbose "Setting variables"
        
        $uri = 'https://graph.microsoft.com/v1.0/users?$select=givenname,surname,displayname,mobilephone,companyname,jobTitle,mail&$top=999'

        Write-Progress -Activity "Setting variables for later use" -Id 2 -ParentId 1 -Completed

        #Preparing array to store users in
        Write-Verbose "Creating array"
        $UsersFromAAD = @()

        }

    Process {
        #Grabbing users from Graph
        Write-Verbose "Invoking first rest call"
        Write-Progress -Activity "Invoking REST call" -PercentComplete 30 -Id 2 -ParentId 1
                
        $RESTcall = Invoke-RestMethod -Method Get -Uri $uri -ContentType "application/json" -Headers @{Authorization = "Bearer $($GraphToken.access_token)"}
        Write-Verbose "Ran first rest call, adding value to array"
        
        $UsersFromAAD += $RESTcall.value
        Write-Verbose "Added users to array, array now contains $($UsersFromAAD.count) users"

        #Looping if nextlink exists
        Write-Verbose "Entering loop if nextlink exists"
        while ($RESTcall.'@odata.nextlink') {
            Write-Progress -Activity "Looping through all pages" -PercentComplete 39 -Id 2 -ParentId 1
            Write-Verbose "nextlink exists, getting next page"
            $RESTcall = Invoke-RestMethod -Method Get -Uri $RESTcall.'@odata.nextlink' -ContentType "application/json" -Headers @{Authorization = "Bearer $($GraphToken.access_token)"}

            Write-Verbose "Finished rest call, adding users to array. Array now contains $($UsersFromAAD.count) users"
            $UsersFromAAD += $RESTcall.value
        }
        
        Write-Progress -Activity "Invoking REST call" -Completed -Id 2 -ParentId 1        
        }

    End {
        #Outputting object returned from Graph
        Write-Progress -Activity "Outputting users" -Id 1 -PercentComplete 55
        Write-Verbose "Outputting object from Graph"
        
        $UsersFromAAD
        
        Write-Progress -Activity "Outputting users" -Id 1 -Completed
        Write-Verbose "All done"	
        }
    
        
<#
 .Synopsis
  Pulls list of users from AAD
 .Description
  This function will connect to Graph and pull a list of users
 .Parameter GraphToken
  An object containing the token for authentication with Graph
 .Example
  $token = Get-GraphTokenForApp -TenantName something.OnMicrosoft.com -ApplicationID cfee9999-df99-9fa9-9af9-9a9f9999e99 -AppKey vP6OzdfsCwp=OA:yR*r
  Get-AADusersFromGraph -GraphToken $token
  Pulls a list of users from Azure AD and displays them
 .Link
  http://cloud.kemta.net
 #>
}