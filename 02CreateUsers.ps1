#####################################################################################
#####################################################################################
##                                                                                 ##
##  Program           02CreateUsers.ps1                                            ##
##  Author            Jeff Canfield / Chris Johnston                               ##
##  CreateDt          20240901                                                     ##
##  Description       This program creates new users with a temporary password for ##
##                    any users that need to be created in the SupplyOne tenant    ##
##  Usage             1. Connect-MgGraph -Scopes "User.ReadWrite.All"              ##
##                    2. edit CSV location for variable $users                     ##
##                    3. run .\02CreateUsers.ps1                                   ##
##  Inputs            CSV specified in the below path with the following columns:  ##
##                         UserPrincipalName, MailNickName, displayName, surname,  ##
##                         givenName, jobTitle, Department, usageLocation,         ##
##                         OfficeLocation, companyname, Manager, Password          ##
##                    *** Note: the manager field may be left blank but the        ##
##                    column header must exist ***                                 ##
##                                                                                 ##
##                                                                                 ##
##                                                                                 ##
#####################################################################################
#####################################################################################
#####################################################################################


#Bypass script blocked:( Typically always needed:) 

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force 

 

#install Module 

#Install-Module -Name Microsoft.Graph 

 

# Connect to the Microsoft Graph API with the required scopes 

Connect-MgGraph -Scopes "User.ReadWrite.All" 



# Import the CSV file 

$users = Import-Csv -Path "C:\CSV\Prod\GLF\GLFusers2.csv" 

 

# Iterate over each user in the CSV file 

foreach ($user in $users) { 

    # Create a new user object 

    $newUser = New-MgUser -DisplayName $user.DisplayName -GivenName $user.GivenName -Surname $user.Surname -UserPrincipalName $user.UserPrincipalName -MailNickname $user.UserPrincipalName.Split("@")[0] -PasswordProfile @{ ForceChangePasswordNextSignIn = $true; Password = $user.Password } -JobTitle $user.JobTitle -Department $user.Department -UsageLocation $user.UsageLocation -OfficeLocation $user.OfficeLocation -CompanyName $user.CompanyName -AccountEnabled 

     

    # Write a message to the console indicating that the user was created 

    Write-Host "User created: $($newUser.UserPrincipalName)" -ForegroundColor Green 

} 