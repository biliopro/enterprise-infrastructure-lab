<#
===============================================================================
 EnterpriseDeploy
 ConfigureDriveMaps.ps1
-------------------------------------------------------------------------------
 Configuration des Drive Maps pour les GPO utilisateurs.

 Serveur SMB :
     SERVERORCHERSTR

 Partages :
     \\SERVERORCHERSTR\RH
     \\SERVERORCHERSTR\IT
     \\SERVERORCHERSTR\Direction
     \\SERVERORCHERSTR\Comptabilite
     \\SERVERORCHERSTR\Marketing
===============================================================================
#>

Import-Module ActiveDirectory
Import-Module GroupPolicy

# ============================================================================
# Configuration
# ============================================================================

$ServerName = "SERVERORCHERSTR"

$Domain = Get-ADDomain

$DomainName = $Domain.DNSRoot

# ============================================================================
# Drive Maps
# ============================================================================

$DriveMaps = @(
    @{
        GPO   = "GPO-RH-Users"
        Drive = "R:"
        Share = "\\$ServerName\RH"
    },

    @{
        GPO   = "GPO-IT-Users"
        Drive = "I:"
        Share = "\\$ServerName\IT"
    },

    @{
        GPO   = "GPO-Direction-Users"
        Drive = "D:"
        Share = "\\$ServerName\Direction"
    },

    @{
        GPO   = "GPO-Comptabilite-Users"
        Drive = "F:"
        Share = "\\$ServerName\Comptabilite"
    },

    @{
        GPO   = "GPO-Marketing-Users"
        Drive = "M:"
        Share = "\\$ServerName\Marketing"
    }
)

# ============================================================================
# Fonction
# ============================================================================

function Configure-DriveMap
{
    param(
        [string]$GPOName,
        [string]$DriveLetter,
        [string]$NetworkPath
    )

    Write-Host ""
    Write-Host "==============================================="
    Write-Host "[GPO]   $GPOName"
    Write-Host "[DRIVE] $DriveLetter"
    Write-Host "[PATH]  $NetworkPath"
    Write-Host "==============================================="

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
    # Vérifier que le partage existe
    # ------------------------------------------------------------------------

    $ShareName = $NetworkPath.Split("\")[-1]

    $ShareExists = Get-SmbShare `
        -Name $ShareName `
        -ErrorAction SilentlyContinue

    if ($null -eq $ShareExists)
    {
        Write-Host "Partage SMB introuvable : $NetworkPath" `
            -ForegroundColor Red

        return
    }

    # ------------------------------------------------------------------------
    # Chemin SYSVOL de la GPO
    # ------------------------------------------------------------------------

    $GPOPath = "\\$DomainName\SYSVOL\$DomainName\Policies\{$($GPO.Id)}"

    $DrivePreferencePath = Join-Path `
        $GPOPath `
        "User\Preferences\Drives"

    # ------------------------------------------------------------------------
    # Création de l'arborescence GPP
    # ------------------------------------------------------------------------

    if (!(Test-Path $DrivePreferencePath))
    {
        New-Item `
            -Path $DrivePreferencePath `
            -ItemType Directory `
            -Force | Out-Null

        Write-Host "Dossier GPP créé."
    }
    else
    {
        Write-Host "Dossier GPP déjà présent."
    }

    # ------------------------------------------------------------------------
    # Affichage de la configuration
    # ------------------------------------------------------------------------

    Write-Host ""
    Write-Host "Configuration prévue :" `
        -ForegroundColor Cyan

    Write-Host "    GPO     : $GPOName"
    Write-Host "    Lecteur : $DriveLetter"
    Write-Host "    Partage : $NetworkPath"
    Write-Host "    SYSVOL  : $DrivePreferencePath"

    Write-Host ""
    Write-Host "GPO validée." -ForegroundColor Green
}

# ============================================================================
# Traitement
# ============================================================================

foreach ($Map in $DriveMaps)
{
    Configure-DriveMap `
        -GPOName $Map.GPO `
        -DriveLetter $Map.Drive `
        -NetworkPath $Map.Share
}

# ============================================================================
# Fin
# ============================================================================

Write-Host ""
Write-Host "==============================================="
Write-Host "Préparation des Drive Maps terminée."
Write-Host "==============================================="