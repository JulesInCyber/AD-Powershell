# Path to import CSV

$UserCSV = Import-Csv 'Path/to/CSV-File'

## CSV Format
#FirstName,LastName,UserName,Description,OfficePhone,EmailAddress,HomePage,Department,Password,OU

foreach ($User in $UserCSV)
{
    $UserName = $User.UserName
    $Password = $User.Password
    $FirstName = $User.FirstName
    $LastName  = $User.LastName
    $Description = $User.Description
    $UserOU = $User.OU
    $PhoneNumber = $User.OfficePhone
    $EMail = $User.EmailAddress
    $HomePage = $User.HomePage
    $Department = $User.Department

    # Check if User exists
    if (Get-ADUser -F {SAMAccountName -eq $UserName})
    {
        Write-Warning "The User $UserName already exists in Active Directory"
    }

    else
    {
        New-ADUser `
        -SAMAccountName $UserName `
        -UserPrincipalName $UserName@medlab-bochum.de `
        -Name "$FirstName $LastName" `
        -GivenName $FirstName `
        -Surname $LastName `
        -DisplayName "$FirstName $LastName" `
        -Path $UserOU `
        -Description $Description `
        -OfficePhone $PhoneNumber `
        -EmailAddress $EMail `
        -HomePage $HomePage `
        -Department $Department `
        -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
        -Enabled $True `
        -ChangePasswordAtLogon $True `
        -PasswordNeverExpires $False `
    }
}
