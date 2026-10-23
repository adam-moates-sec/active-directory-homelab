# Create-ADUsers.ps1
# Automates creation of bulk users inside Active Directory

Import-Module ActiveDirectory

$Users = @(
    @{First="John"; Last="Doe"; Dept="IT"; Title="Systems Support"},
    @{First="Jane"; Last="Smith"; Dept="Operations"; Title="Plant Coordinator"},
    @{First="Mark"; Last="Taylor"; Dept="Finance"; Title="Accountant"}
)

foreach ($User in $Users) {
    $Username = ($User.First.Substring(0,1) + $User.Last).ToLower()
    $Password = ConvertTo-SecureString "TempPass123!" -AsPlainText -Force
    
    New-ADUser `
        -Name "$($User.First) $($User.Last)" `
        -GivenName $User.First `
        -Surname $User.Last `
        -SamAccountName $Username `
        -UserPrincipalName "$Username@corp.local" `
        -Department $User.Dept `
        -Title $User.Title `
        -AccountPassword $Password `
        -Enabled $true `
        -ChangePasswordAtLogon $true
        
    Write-Host "Created domain user: $Username"
}
