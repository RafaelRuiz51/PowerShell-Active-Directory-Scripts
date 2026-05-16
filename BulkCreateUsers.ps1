Import-Module ActiveDirectory

$csvPath = "C:\Scripts\new_users.csv"
$users = Import-Csv -Path $csvPath

foreach ($user in $users) {

    $firstName = $user.FirstName
    $lastName = $user.LastName
    $username = $user.Username
    $password = $user.Password
    $department = $user.Department

    $fullName = "$firstName $lastName"
    $userPrincipal = "$username@rafaellab.local"
    $securePassword = ConvertTo-SecureString $password -AsPlainText -Force

    $exists = Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue

    if ($exists) {
        Write-Host "SKIPPED: $username already exists" -ForegroundColor Yellow
    }
    else {
        New-ADUser `
            -Name $fullName `
            -GivenName $firstName `
            -Surname $lastName `
            -SamAccountName $username `
            -UserPrincipalName $userPrincipal `
            -Department $department `
            -AccountPassword $securePassword `
            -Enabled $true `
            -ChangePasswordAtLogon $true

        Write-Host "CREATED: $fullName ($username) - $department" -ForegroundColor Green
    }
}

Write-Host "Done. Check Active Directory Users and Computers to verify." -ForegroundColor Cyan
