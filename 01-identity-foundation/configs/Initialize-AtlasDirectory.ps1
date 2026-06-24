# Initialize-AtlasDirectory.ps1
# Creates the ATLAS OU structure, role groups, and user accounts.
# Safe to run multiple times - checks before creating, never overwrites.

$ErrorActionPreference = "Stop"

$domainRoot = "DC=corp,DC=atlas,DC=test"
$atlasOU    = "OU=ATLAS,$domainRoot"
$groupsOU   = "OU=Groups,$atlasOU"
$usersOU    = "OU=Users,$atlasOU"

# --- OU Structure ---

Write-Host "`n=== OUs ==="

$exists = Get-ADOrganizationalUnit -Filter "Name -eq 'ATLAS'" -SearchBase $domainRoot -ErrorAction SilentlyContinue
if ($exists) {
    Write-Host "EXISTS: ATLAS"
} else {
    New-ADOrganizationalUnit -Name "ATLAS" -Path $domainRoot -ProtectedFromAccidentalDeletion $true
    Write-Host "CREATED: ATLAS"
}

$exists = Get-ADOrganizationalUnit -Filter "Name -eq 'Users'" -SearchBase $atlasOU -ErrorAction SilentlyContinue
if ($exists) {
    Write-Host "EXISTS: Users"
} else {
    New-ADOrganizationalUnit -Name "Users" -Path $atlasOU -ProtectedFromAccidentalDeletion $true
    Write-Host "CREATED: Users"
}

$exists = Get-ADOrganizationalUnit -Filter "Name -eq 'Computers'" -SearchBase $atlasOU -ErrorAction SilentlyContinue
if ($exists) {
    Write-Host "EXISTS: Computers"
} else {
    New-ADOrganizationalUnit -Name "Computers" -Path $atlasOU -ProtectedFromAccidentalDeletion $true
    Write-Host "CREATED: Computers"
}

$exists = Get-ADOrganizationalUnit -Filter "Name -eq 'Groups'" -SearchBase $atlasOU -ErrorAction SilentlyContinue
if ($exists) {
    Write-Host "EXISTS: Groups"
} else {
    New-ADOrganizationalUnit -Name "Groups" -Path $atlasOU -ProtectedFromAccidentalDeletion $true
    Write-Host "CREATED: Groups"
}

# --- Role Groups ---

Write-Host "`n=== Groups ==="

$groups = @(
    @{ Name = "GG-Engineering"; Description = "Engineering department members" },
    @{ Name = "GG-Finance";     Description = "Finance department members" },
    @{ Name = "GG-Helpdesk";    Description = "Tier 1 helpdesk - delegated password reset rights" },
    @{ Name = "GG-LinuxAdmins"; Description = "Linux administrators - populated at Session 10" }
)

foreach ($g in $groups) {
    $exists = Get-ADGroup -Filter "Name -eq '$($g.Name)'" -SearchBase $groupsOU -ErrorAction SilentlyContinue
    if ($exists) {
        Write-Host "EXISTS: $($g.Name)"
    } else {
        New-ADGroup -Name $g.Name -SamAccountName $g.Name -GroupScope Global -GroupCategory Security `
            -Path $groupsOU -Description $g.Description
        Write-Host "CREATED: $($g.Name)"
    }
}

# --- Users ---

Write-Host "`n=== Users ==="

$users = @(
    @{ SamAccountName = "anna.schmidt";  GivenName = "Anna";  Surname = "Schmidt";  Group = "GG-Engineering" },
    @{ SamAccountName = "ben.meier";     GivenName = "Ben";   Surname = "Meier";    Group = "GG-Engineering" },
    @{ SamAccountName = "clara.fuchs";   GivenName = "Clara"; Surname = "Fuchs";    Group = "GG-Finance" },
    @{ SamAccountName = "helpdesk.tom";  GivenName = "Tom";   Surname = "Helpdesk"; Group = "GG-Helpdesk" }
)

foreach ($u in $users) {
    $name = "$($u.GivenName) $($u.Surname)"
    $exists = Get-ADUser -Filter "SamAccountName -eq '$($u.SamAccountName)'" -SearchBase $usersOU -ErrorAction SilentlyContinue

    if ($exists) {
        Write-Host "EXISTS: $($u.SamAccountName)"
    } else {
        # Random password generated at runtime only - never hardcoded, never committed.
        $plainPassword  = -join ((48..57) + (65..90) + (97..122) + (33, 35, 36, 64) | Get-Random -Count 20 | ForEach-Object { [char]$_ })
        $securePassword = ConvertTo-SecureString $plainPassword -AsPlainText -Force

        New-ADUser -Name $name `
            -SamAccountName $u.SamAccountName `
            -UserPrincipalName "$($u.SamAccountName)@corp.atlas.test" `
            -GivenName $u.GivenName `
            -Surname $u.Surname `
            -Path $usersOU `
            -AccountPassword $securePassword `
            -ChangePasswordAtLogon $true `
            -Enabled $true

        Write-Host "CREATED: $($u.SamAccountName)"
        Write-Host "  Temporary password (record now, will not be shown again): $plainPassword"
    }

    $member = Get-ADGroupMember -Identity $u.Group -ErrorAction SilentlyContinue |
        Where-Object { $_.SamAccountName -eq $u.SamAccountName }

    if ($member) {
        Write-Host "EXISTS: $($u.SamAccountName) in $($u.Group)"
    } else {
        Add-ADGroupMember -Identity $u.Group -Members $u.SamAccountName
        Write-Host "ADDED: $($u.SamAccountName) to $($u.Group)"
    }
}

Write-Host "`n=== Done ==="
