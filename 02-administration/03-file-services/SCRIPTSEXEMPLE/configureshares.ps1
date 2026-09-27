<#
===============================================================================
 EnterpriseDeploy
 ConfigureShares.ps1
-------------------------------------------------------------------------------
 Configure les permissions NTFS et SMB des partages départementaux.

 Structure :
    GG_<DEPARTEMENT>
          ↓
    DL_<DEPARTEMENT>_Read
    DL_<DEPARTEMENT>_Modify
          ↓
    D:\Shares\<DEPARTEMENT>
          ↓
    \\SERVER\<DEPARTEMENT>
===============================================================================
#>

Import-Module ActiveDirectory

# ============================================================================
# Configuration
# ============================================================================

$ProjectRoot = Split-Path -Parent $PSScriptRoot

$ShareRoot = Join-Path $ProjectRoot "Shares"

$Departments = @(
    "RH",
    "IT",
    "Direction",
    "Comptabilite",
    "Marketing"
)

# ============================================================================
# Vérification
# ============================================================================

if (!(Test-Path $ShareRoot))
{
    Write-Host "Le dossier Shares n'existe pas :" -ForegroundColor Red
    Write-Host $ShareRoot
    exit
}

# ============================================================================
# Configuration des permissions
# ============================================================================

foreach ($Department in $Departments)
{
    Write-Host ""
    Write-Host "============================================"
    Write-Host "Département : $Department"
    Write-Host "============================================"

    $FolderPath = Join-Path $ShareRoot $Department

    $ReadGroup   = "DL_${Department}_Read"
    $ModifyGroup = "DL_${Department}_Modify"

    # ------------------------------------------------------------------------
    # Vérification du dossier
    # ------------------------------------------------------------------------

    if (!(Test-Path $FolderPath))
    {
        Write-Host "Dossier introuvable : $FolderPath" -ForegroundColor Red
        continue
    }

    # ------------------------------------------------------------------------
    # Vérification des groupes AD
    # ------------------------------------------------------------------------

    try
    {
        Get-ADGroup $ReadGroup -ErrorAction Stop | Out-Null
        Get-ADGroup $ModifyGroup -ErrorAction Stop | Out-Null
    }
    catch
    {
        Write-Host "Groupes AD manquants pour $Department" `
            -ForegroundColor Red

        Write-Host "Attendus :"
        Write-Host "  $ReadGroup"
        Write-Host "  $ModifyGroup"

        continue
    }

    # ========================================================================
    # NTFS
    # ========================================================================

    Write-Host ""
    Write-Host "[NTFS] Configuration de $FolderPath"

    # Héritage
    icacls $FolderPath /inheritance:r | Out-Null

    # Administrateurs : contrôle total
    icacls $FolderPath /grant "Administrators:(OI)(CI)(F)" | Out-Null

    # SYSTEM : contrôle total
    icacls $FolderPath /grant "SYSTEM:(OI)(CI)(F)" | Out-Null

    # Groupe Read
    icacls $FolderPath `
        /grant "${ReadGroup}:(OI)(CI)(RX)" | Out-Null

    # Groupe Modify
    icacls $FolderPath `
        /grant "${ModifyGroup}:(OI)(CI)(M)" | Out-Null

    Write-Host "Permissions NTFS configurées." `
        -ForegroundColor Green

    # ========================================================================
    # SMB
    # ========================================================================

    Write-Host ""
    Write-Host "[SMB] Configuration du partage"

    $Share = Get-SmbShare `
        -Name $Department `
        -ErrorAction SilentlyContinue

    if ($null -eq $Share)
    {
        Write-Host "Partage SMB introuvable : $Department" `
            -ForegroundColor Red

        continue
    }

    # Supprimer les permissions SMB existantes
    # afin de repartir sur une configuration propre.

    Revoke-SmbShareAccess `
        -Name $Department `
        -AccountName "Everyone" `
        -Force `
        -ErrorAction SilentlyContinue

    # Lecture
    Grant-SmbShareAccess `
        -Name $Department `
        -AccountName $ReadGroup `
        -AccessRight Read `
        -Force | Out-Null

    # Modification
    Grant-SmbShareAccess `
        -Name $Department `
        -AccountName $ModifyGroup `
        -AccessRight Change `
        -Force | Out-Null

    # Administrateurs
    Grant-SmbShareAccess `
        -Name $Department `
        -AccountName "Administrators" `
        -AccessRight Full `
        -Force | Out-Null

    Write-Host "Permissions SMB configurées." `
        -ForegroundColor Green
}

# ============================================================================
# Résultat
# ============================================================================

Write-Host ""
Write-Host "============================================"
Write-Host "Permissions configurées avec succès."
Write-Host "============================================"