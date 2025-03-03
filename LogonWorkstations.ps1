# Some Users should only be allowed to logon on certain Workstations/Servers.
# This Script can be used to show, modify or reset the Parameter 'LogonWorkstations' for any AD-User


$Mode = $args[0]
$User = $args[1]
$Workstation = $args[2..$args.Count] -join ","

# Show Help
if ($Mode -eq "-help" -OR $null -eq $Mode)
{
    Write-Host "Modify allowed LogonWorkstations for a specific user"
    Write-Host "Usage: .\AD-LogonWorkstation [OPTIONS] [USER] [Workstation1] [Workstation2]"
    Write-Host
    Write-Host "Options:"
    Write-Host "-show`tShows the current LogonWorkstations for the specified user"
    Write-Host "-set`tSets the specified workstation(s) as allowed LogonWorkstations"
    Write-Host "-add`tadds the specified Workstations to the list of allowed LogonWorkstations"
    Write-Host "-remove`tremoves specified workstations"
    Write-Host "-clear`tclears the list of LogonWorkstations"
}
# Show Current configuration
if ($Mode -eq "-show")
{
    Get-ADUser -Identity $User -Properties LogonWorkstations | select LogonWorkstations
}
# Set Parameter LogonWorkstations
if ($Mode -eq "-set")
{
    Set-ADUser -Identity $User -LogonWorkstations "$Workstation"
}
if ($Mode -eq "-add")
# Append Paramater LogonWorkstations
{
    $AllowedWorkstations =  Get-ADUser -Identity $User -Properties LogonWorkstations | select -ExpandProperty LogonWorkstations
    Set-ADUser -Identity $User -LogonWorkstations "$AllowedWorkstations,$Workstation"
}
# Remove Workstation from LogonWorkstations
$Mode = $args[0]
$User = $args[1]
$Workstation = $args[2..$args.Count] -join ","

# Show Help
if ($Mode -eq "-help" -OR $null -eq $Mode)
{
    Write-Host "Add or allowed LogonWorkstations for a specific user"
    Write-Host "Usage: .\AD-LogonWorkstation [OPTIONS] [USER] [Workstation1] [Workstation2]"
    Write-Host
    Write-Host "Options:"
    Write-Host "-show`tShows the current LogonWorkstations for the specified user"
    Write-Host "-set`tSets the specified workstation(s) as allowed LogonWorkstations"
    Write-Host "-add`tadds the specified Workstations to the list of allowed LogonWorkstations"
    Write-Host "-remove`tremoves specified workstations"
}
# Show Current configuration
if ($Mode -eq "-show")
{
    Get-ADUser -Identity $User -Properties LogonWorkstations | select LogonWorkstations
}
# Set Parameter LogonWorkstations
if ($Mode -eq "-set")
{
    Set-ADUser -Identity $User -LogonWorkstations "$Workstation"
}
if ($Mode -eq "-add")
# Append Paramater LogonWorkstations
{
    $AllowedWorkstations =  Get-ADUser -Identity $User -Properties LogonWorkstations | select -ExpandProperty LogonWorkstations
    Set-ADUser -Identity $User -LogonWorkstations "$AllowedWorkstations,$Workstation"
}
# Remove Workstation from LogonWorkstations
if ($Mode -eq "-remove") {
    # Get-Current LogonWorkstations 
    $LogonWorkstations = (Get-ADUser -Identity $User -Properties LogonWorkstations).LogonWorkstations -split ","

    # Update list of Logonworkstations
    $UpdatedWorkstations = $LogonWorkstations | Where-Object { $_ -ne $Workstation }

    # Join with "," if not empty
    if ($UpdatedWorkstations) {
        $UpdatedWorkstations = $UpdatedWorkstations -join ","
    } else {
        $UpdatedWorkstations = $null  # Falls leer, setzen wir es auf NULL
    }

    # Set the modified List as LogonWorkstations
    Set-ADUser -Identity $User -LogonWorkstations $UpdatedWorkstations

    Write-Host "Workstation '$Workstation' was removed for '$User'."
}
# Clears LogonWorkstations
if ($Mode -eq "-clear")
{
    Set-ADUser -Identity $User -LogonWorkstations $null
}
