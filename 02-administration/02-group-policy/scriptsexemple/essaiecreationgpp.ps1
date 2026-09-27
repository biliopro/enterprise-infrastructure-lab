Import-Module GroupPolicy

# ============================================================
# EnterpriseDeploy - GPP Files Manager
# ============================================================

$Config = [PSCustomObject]@{
    Domain = "bilie.corps"

    Departments = @(

        [PSCustomObject]@{
            Name        = "RH"
            GPO         = "GPO-RH-Users"
            SourceFile  = "C:\project lab\EnterpriseDeploy\Shares\RH\RH.jpg"
            TargetFile  = "C:\ProgramData\EnterpriseDeploy\Departments\RH.jpg"
        }

        [PSCustomObject]@{
            Name        = "IT"
            GPO         = "GPO-IT-Users"
            SourceFile  = "C:\project lab\EnterpriseDeploy\Shares\IT\IT.jpg"
            TargetFile  = "C:\ProgramData\EnterpriseDeploy\Departments\IT.jpg"
        }

        [PSCustomObject]@{
            Name        = "Direction"
            GPO         = "GPO-Direction-Users"
            SourceFile  = "C:\project lab\EnterpriseDeploy\Shares\Direction\Direction.jpg"
            TargetFile  = "C:\ProgramData\EnterpriseDeploy\Departments\Direction.jpg"
        }

        [PSCustomObject]@{
            Name        = "Comptabilite"
            GPO         = "GPO-Comptabilite-Users"
            SourceFile  = "C:\project lab\EnterpriseDeploy\Shares\Comptabilite\Comptabilite.jpg"
            TargetFile  = "C:\ProgramData\EnterpriseDeploy\Departments\Comptabilite.jpg"
        }

        [PSCustomObject]@{
            Name        = "Marketing"
            GPO         = "GPO-Marketing-Users"
            SourceFile  = "C:\project lab\EnterpriseDeploy\Shares\Marketing\Marketing.jpg"
            TargetFile  = "C:\ProgramData\EnterpriseDeploy\Departments\Marketing.jpg"
        }
    )
}


# ============================================================
# FONCTION : NEW-GPPFILE
# ============================================================

function New-GPPFile {

    param (
        [Parameter(Mandatory)]
        [string]$Domain,

        [Parameter(Mandatory)]
        [string]$GPOName,

        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$SourceFile,

        [Parameter(Mandatory)]
        [string]$TargetFile
    )

    Write-Host ""
    Write-Host "==============================================="
    Write-Host "[GPP FILE]"
    Write-Host "==============================================="

    # --------------------------------------------------------
    # Vérification du fichier source
    # --------------------------------------------------------

    if (-not (Test-Path $SourceFile)) {

        Write-Host "[ERREUR] Fichier source introuvable :" `
            -ForegroundColor Red

        Write-Host "         $SourceFile" `
            -ForegroundColor Red

        return
    }


    # --------------------------------------------------------
    # Récupération de la GPO
    # --------------------------------------------------------

    try {

        $GPO = Get-GPO `
            -Name $GPOName `
            -Domain $Domain `
            -ErrorAction Stop

    }
    catch {

        Write-Host "[ERREUR] GPO introuvable :" `
            -ForegroundColor Red

        Write-Host "         $GPOName" `
            -ForegroundColor Red

        return
    }


    # --------------------------------------------------------
    # Informations GPO
    # --------------------------------------------------------

    $GPOGuid = $GPO.Id

    Write-Host "[GPO]        $($GPO.DisplayName)"
    Write-Host "[GUID]       $GPOGuid"
    Write-Host "[SOURCE]     $SourceFile"
    Write-Host "[DESTINATION] $TargetFile"


    # --------------------------------------------------------
    # Construction du chemin SYSVOL
    # --------------------------------------------------------

    $GPOPath =
        "\\$Domain\SYSVOL\$Domain\Policies\{$GPOGuid}"

    $FilesPath =
        Join-Path $GPOPath "User\Preferences\Files"

    $XmlPath =
        Join-Path $FilesPath "Files.xml"


    Write-Host "[SYSVOL]     $GPOPath"
    Write-Host "[FILES]      $FilesPath"
    Write-Host "[XML]        $XmlPath"


    # --------------------------------------------------------
    # Création du dossier GPP
    # --------------------------------------------------------

    if (-not (Test-Path $FilesPath)) {

        New-Item `
            -Path $FilesPath `
            -ItemType Directory `
            -Force |
            Out-Null

        Write-Host "[OK] Dossier Files créé."
    }
    else {

        Write-Host "[OK] Dossier Files déjà présent."
    }


    # --------------------------------------------------------
    # UID du nouvel élément GPP
    # --------------------------------------------------------

    $FileUid =
        "{" + [guid]::NewGuid().ToString().ToUpper() + "}"


    # --------------------------------------------------------
    # Date de modification
    # --------------------------------------------------------

    $Changed =
        Get-Date -Format "yyyy-MM-dd HH:mm:ss"


    # --------------------------------------------------------
    # Construction du XML
    # --------------------------------------------------------

    $XmlContent = @"
<?xml version="1.0" encoding="utf-8"?>
<Files clsid="{215B2E53-57CE-475c-80FE-9EEC14635851}">
  <File
    clsid="{50BE44C8-567A-4ed1-B1D0-9234FE1F38AF}"
    name="$Name"
    status="$Name"
    image="2"
    changed="$Changed"
    uid="$FileUid">
    <Properties
      action="U"
      fromPath="$SourceFile"
      targetPath="$TargetFile"
      readOnly="1"
      archive="1"
      hidden="0"
      suppress="0"/>
  </File>
</Files>
"@


    # --------------------------------------------------------
    # Écriture
    # --------------------------------------------------------

    $XmlContent |
        Set-Content `
            -Path $XmlPath `
            -Encoding UTF8


    # --------------------------------------------------------
    # Vérification
    # --------------------------------------------------------

    if (Test-Path $XmlPath) {

        Write-Host ""
        Write-Host "[OK] Files.xml créé." `
            -ForegroundColor Green

        Write-Host ""
        Write-Host "[CONTENU]"

        Get-Content $XmlPath -Raw
    }
    else {

        Write-Host "[ERREUR] Impossible de créer Files.xml." `
            -ForegroundColor Red
    }
}


# ============================================================
# EXÉCUTION
# ============================================================

Write-Host ""
Write-Host "==============================================="
Write-Host " EnterpriseDeploy - GPP Files Configuration"
Write-Host "==============================================="
Write-Host ""

foreach ($Department in $Config.Departments) {

    Write-Host ""
    Write-Host "-----------------------------------------------"
    Write-Host "DEPARTEMENT : $($Department.Name)"
    Write-Host "-----------------------------------------------"

    New-GPPFile `
        -Domain $Config.Domain `
        -GPOName $Department.GPO `
        -Name "$($Department.Name).jpg" `
        -SourceFile $Department.SourceFile `
        -TargetFile $Department.TargetFile
}

Write-Host ""
Write-Host "==============================================="
Write-Host " Configuration terminée"
Write-Host "==============================================="