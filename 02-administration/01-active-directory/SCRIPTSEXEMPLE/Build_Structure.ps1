<#
===============================================================================
 EnterpriseDeploy
 BuildStructure.ps1
-------------------------------------------------------------------------------
 Description :
    Construit la structure Active Directory à partir du fichier
    Config\Structure.csv
===============================================================================
#>

Import-Module ActiveDirectory

# ============================================================================
# Configuration
# ============================================================================

# Dossier EnterpriseDeploy
$ProjectRoot = Split-Path -Parent $PSScriptRoot

# Fichier CSV
$ConfigFile = Join-Path $ProjectRoot "Config\Structure.csv"

# Vérifie que le CSV existe
if (!(Test-Path $ConfigFile))
{
    Write-Host ""
    Write-Host "ERREUR : Structure.csv introuvable." -ForegroundColor Red
    Write-Host "Chemin recherché :" -ForegroundColor Yellow
    Write-Host $ConfigFile
    exit
}

# Lecture du CSV
$Structure = Import-Csv $ConfigFile

# Domaine Active Directory
$DomainDN = (Get-ADDomain).DistinguishedName

# ============================================================================
# Création de la structure
# ============================================================================

foreach ($Item in $Structure)
{

    switch ($Item.Type)
    {

        "OU"
        {

            if ($Item.Path -eq "ROOT")
            {
                $ADPath = $DomainDN
            }
            else
            {
                $ADPath = "$($Item.Path),$DomainDN"
            }

            Write-Host "Création OU : $($Item.Name)"

            New-ADOrganizationalUnit `
                -Name $Item.Name `
                -Path $ADPath `
                -ProtectedFromAccidentalDeletion $true

        }

        "GROUP"
        {

            $ADPath = "$($Item.Path),$DomainDN"

            Write-Host "Création Groupe : $($Item.Name)"

            New-ADGroup `
                -Name $Item.Name `
                -GroupScope $Item.Scope `
                -GroupCategory $Item.Category `
                -Path $ADPath

        }

        default
        {
            Write-Host "Type inconnu : $($Item.Type)" -ForegroundColor Yellow
        }

    }

}

Write-Host ""
Write-Host "========================================"
Write-Host "Structure Active Directory créée."
Write-Host "========================================"