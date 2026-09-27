<#
===============================================================================
 EnterpriseDeploy
 LinkPolicies.ps1
-------------------------------------------------------------------------------
 Lie les GPO existantes aux OU correspondantes.

 Le script ne crée aucune GPO.
 Si une liaison existe déjà, elle est simplement ignorée.
===============================================================================
#>

Import-Module ActiveDirectory
Import-Module GroupPolicy

# ============================================================================
# Domaine
# ============================================================================

$DomainDN = (Get-ADDomain).DistinguishedName

# ============================================================================
# OU principales
# ============================================================================

$EnterpriseOU = "OU=Entreprise,$DomainDN"

$UsersOU = "OU=Users,$EnterpriseOU"

$WorkstationsOU = "OU=Workstations,$EnterpriseOU"

# ============================================================================
# Fonction de liaison
# ============================================================================

function Link-GPO
{
    param(
        [string]$GPOName,
        [string]$TargetOU
    )

    Write-Host ""
    Write-Host "[LINK] $GPOName"
    Write-Host "       -> $TargetOU"

    # ------------------------------------------------------------------------
    # Vérifier que la GPO existe
    # ------------------------------------------------------------------------

    $GPO = Get-GPO `
        -Name $GPOName `
        -ErrorAction SilentlyContinue

    if ($null -eq $GPO)
    {
        Write-Host "GPO introuvable : $GPOName" `
            -ForegroundColor Red

        return
    }

    # ------------------------------------------------------------------------
    # Vérifier si la GPO est déjà liée
    # ------------------------------------------------------------------------

    $Inheritance = Get-GPInheritance `
        -Target $TargetOU

    $ExistingLink = $Inheritance.GpoLinks |
        Where-Object {
            $_.DisplayName -eq $GPOName
        }

    if ($null -ne $ExistingLink)
    {
        Write-Host "Lien déjà présent." `
            -ForegroundColor Yellow

        return
    }

    # ------------------------------------------------------------------------
    # Création du lien
    # ------------------------------------------------------------------------

    New-GPLink `
        -Name $GPOName `
        -Target $TargetOU `
        -LinkEnabled Yes `
        -ErrorAction Stop | Out-Null

    Write-Host "Lien créé avec succès." `
        -ForegroundColor Green
}

# ============================================================================
# GPO BASE COMPUTERS
# ============================================================================

Link-GPO `
    -GPOName "GPO-Base-Computers" `
    -TargetOU $WorkstationsOU

# ============================================================================
# GPO BASE USERS
# ============================================================================

Link-GPO `
    -GPOName "GPO-Base-Users" `
    -TargetOU $UsersOU

# ============================================================================
# GPO SPECIFIQUES AUX DEPARTEMENTS
# ============================================================================

$Departments = @(
    "RH",
    "IT",
    "Direction",
    "Comptabilite",
    "Marketing"
)

foreach ($Department in $Departments)
{
    $DepartmentOU = "OU=$Department,$UsersOU"

    $GPOName = "GPO-$Department-Users"

    Link-GPO `
        -GPOName $GPOName `
        -TargetOU $DepartmentOU
}

# ============================================================================
# FIN
# ============================================================================

Write-Host ""
Write-Host "==============================================="
Write-Host "Liaisons GPO terminées."
Write-Host "==============================================="


