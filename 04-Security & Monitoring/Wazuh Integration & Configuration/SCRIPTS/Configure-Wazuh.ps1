
# ============================================================
# WAZUH - ENREGISTREMENT AUTOMATIQUE VIA MDT
# ============================================================
# Fonctionnement :
#   1. Récupère le serveur Wazuh depuis MDT
#   2. Récupère le groupe Wazuh depuis la Description MDT
#   3. Récupère le vrai nom du PC depuis Windows
#   4. Enregistre automatiquement l'agent auprès de Wazuh
#   5. Configure et démarre le service Wazuh
#   6. Vérifie que le service fonctionne
# ============================================================

$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
# 1. VARIABLES MDT
# ------------------------------------------------------------

Write-Host "=========================================="
Write-Host "WAZUH - CONFIGURATION AUTOMATIQUE"
Write-Host "=========================================="

try {
    $tsenv = New-Object -ComObject Microsoft.SMS.TSEnvironment
}
catch {
    throw "Impossible d'accéder aux variables MDT : $($_.Exception.Message)"
}

$WazuhServer = $tsenv.Value("WazuhServer")
$WazuhGroup  = $tsenv.Value("WazuhGroup")

# IMPORTANT :
# On ne récupère plus le nom depuis %OSDComputerName%.
# Windows connaît directement son propre nom.
$WazuhAgentName = $env:COMPUTERNAME

# ------------------------------------------------------------
# 2. VERIFICATION DES VARIABLES
# ------------------------------------------------------------

if ([string]::IsNullOrWhiteSpace($WazuhServer)) {
    throw "Variable MDT WazuhServer vide."
}

if ([string]::IsNullOrWhiteSpace($WazuhGroup)) {
    throw "Variable MDT WazuhGroup vide."
}

if ([string]::IsNullOrWhiteSpace($WazuhAgentName)) {
    throw "Le nom de la machine Windows est vide."
}

Write-Host "Serveur Wazuh : $WazuhServer"
Write-Host "Groupe Wazuh  : $WazuhGroup"
Write-Host "Nom de l'agent: $WazuhAgentName"
Write-Host "=========================================="

# ------------------------------------------------------------
# 3. CHEMIN DE L'AGENT WAZUH
# ------------------------------------------------------------

$WazuhPath = "C:\Program Files (x86)\ossec-agent"
$AgentAuth = Join-Path $WazuhPath "agent-auth.exe"

Write-Host "Répertoire Wazuh : $WazuhPath"
Write-Host "agent-auth      : $AgentAuth"

if (-not (Test-Path $WazuhPath)) {
    throw "Le répertoire Wazuh est introuvable : $WazuhPath"
}

if (-not (Test-Path $AgentAuth)) {
    throw "agent-auth.exe introuvable : $AgentAuth"
}

Write-Host "agent-auth.exe trouvé."
Write-Host "=========================================="

# ------------------------------------------------------------
# 4. TEST DE CONNECTIVITE AU SERVEUR WAZUH
# ------------------------------------------------------------

Write-Host "Test de connectivité vers Wazuh..."

try {
    $TcpTest = Test-NetConnection `
        -ComputerName $WazuhServer `
        -Port 1515 `
        -WarningAction SilentlyContinue

    if (-not $TcpTest.TcpTestSucceeded) {
        throw "Impossible de joindre $WazuhServer sur le port 1515."
    }

    Write-Host "Connexion TCP 1515 : OK"
}
catch {
    throw "Test de connexion Wazuh échoué : $($_.Exception.Message)"
}

Write-Host "=========================================="

# ------------------------------------------------------------
# 5. ENREGISTREMENT AUPRES DU SERVEUR WAZUH
# ------------------------------------------------------------

Write-Host "Enregistrement de l'agent auprès de Wazuh..."
Write-Host ""
Write-Host "Commande :"
Write-Host "$AgentAuth -m $WazuhServer -A $WazuhAgentName -G $WazuhGroup"
Write-Host ""

# Arguments agent-auth
$Arguments = @(
    "-m"
    $WazuhServer
    "-A"
    $WazuhAgentName
    "-G"
    $WazuhGroup
)

try {

    $Process = Start-Process `
        -FilePath $AgentAuth `
        -ArgumentList $Arguments `
        -Wait `
        -PassThru `
        -NoNewWindow

    $ExitCode = $Process.ExitCode

}
catch {

    throw "Impossible d'exécuter agent-auth.exe : $($_.Exception.Message)"
}

Write-Host ""
Write-Host "Code retour agent-auth : $ExitCode"
Write-Host ""

# ------------------------------------------------------------
# 6. VERIFICATION DU RESULTAT
# ------------------------------------------------------------

if ($ExitCode -ne 0) {

    Write-Host "=========================================="
    Write-Host "ERREUR D'ENREGISTREMENT WAZUH"
    Write-Host "=========================================="
    Write-Host "Code retour : $ExitCode"
    Write-Host "Serveur     : $WazuhServer"
    Write-Host "Agent       : $WazuhAgentName"
    Write-Host "Groupe      : $WazuhGroup"
    Write-Host "=========================================="

    throw "L'enregistrement Wazuh a échoué avec le code retour $ExitCode."
}

Write-Host "Agent Wazuh enregistré avec succès."
Write-Host "=========================================="

# ------------------------------------------------------------
# 7. VERIFICATION DU FICHIER DE CLE
# ------------------------------------------------------------

$AuthKey = Join-Path $WazuhPath "client.keys"

if (Test-Path $AuthKey) {
    Write-Host "Fichier client.keys : présent"
}
else {
    Write-Host "ATTENTION : client.keys n'est pas trouvé."
}

# ------------------------------------------------------------
# 8. CONFIGURATION DU SERVICE WAZUH
# ------------------------------------------------------------

Write-Host "Configuration du service Wazuh..."

$WazuhService = Get-Service -Name "WazuhSvc" -ErrorAction SilentlyContinue

if ($null -eq $WazuhService) {
    throw "Le service WazuhSvc est introuvable."
}

Set-Service `
    -Name "WazuhSvc" `
    -StartupType Automatic

Write-Host "Type de démarrage : Automatic"

# ------------------------------------------------------------
# 9. DEMARRAGE / REDÉMARRAGE DU SERVICE
# ------------------------------------------------------------

Write-Host "Démarrage du service Wazuh..."

try {

    if ((Get-Service -Name "WazuhSvc").Status -eq "Running") {

        Write-Host "WazuhSvc est déjà en fonctionnement."
        Write-Host "Redémarrage du service..."

        Restart-Service `
            -Name "WazuhSvc" `
            -Force `
            -ErrorAction Stop
    }
    else {

        Start-Service `
            -Name "WazuhSvc" `
            -ErrorAction Stop
    }

}
catch {

    throw "Impossible de démarrer/redémarrer WazuhSvc : $($_.Exception.Message)"
}

# ------------------------------------------------------------
# 10. ATTENTE DU SERVICE
# ------------------------------------------------------------

Write-Host "Attente du démarrage du service..."

Start-Sleep -Seconds 5

$Service = Get-Service -Name "WazuhSvc"

Write-Host "Etat WazuhSvc : $($Service.Status)"

if ($Service.Status -ne "Running") {
    throw "WazuhSvc n'est pas en fonctionnement."
}

# ------------------------------------------------------------
# 11. FIN
# ------------------------------------------------------------

Write-Host ""
Write-Host "=========================================="
Write-Host "WAZUH - CONFIGURATION TERMINEE"
Write-Host "=========================================="
Write-Host "Serveur : $WazuhServer"
Write-Host "Groupe  : $WazuhGroup"
Write-Host "Agent   : $WazuhAgentName"
Write-Host "Service : $($Service.Status)"
Write-Host "=========================================="

exit 0

