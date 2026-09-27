# Wazuh Integration & Configuration

## Introduction

Dans le cadre du projet, Wazuh a été intégré à l’infrastructure afin d’ajouter une solution centralisée de supervision et de détection de sécurité pour les postes déployés par MDT.

L’environnement Wazuh a été installé sur un serveur **Ubuntu** et déployé avec **Docker Compose** selon l’architecture **single-node**. Cette architecture regroupe les trois composants centraux de Wazuh sur un même serveur, tout en les exécutant dans des conteneurs distincts.

Le serveur Wazuh utilisé dans le projet est :

```text
192.168.61.103
```

## 1. Architecture single-node

L’architecture mise en place repose sur trois composants principaux :

```text
Serveur Ubuntu
192.168.61.103
        │
        └── Docker Compose
              │
              ├── Wazuh Manager
              ├── Wazuh Indexer
              └── Wazuh Dashboard
```

### Wazuh Manager

Le **Wazuh Manager** constitue le composant central de la plateforme. Il reçoit les informations provenant des agents, analyse les événements et assure la gestion des agents.

### Wazuh Indexer

Le **Wazuh Indexer** assure le stockage et l’indexation des données de sécurité collectées par le Manager.

### Wazuh Dashboard

Le **Wazuh Dashboard** fournit l’interface graphique permettant de consulter les informations remontées par les agents et d’administrer la plateforme.

L’intérêt de cette organisation est de séparer les fonctions de traitement, de stockage et de visualisation tout en conservant une infrastructure centralisée.

## 2. Déploiement avec Docker Compose

Le déploiement est réalisé depuis le répertoire du stack Wazuh :

```bash
cd ~/wazuh-docker/single-node
```

Le démarrage de l’environnement est effectué avec :

```bash
docker compose up -d
```

L’état des conteneurs peut ensuite être vérifié avec :

```bash
docker compose ps
```

Dans une architecture single-node, les conteneurs du Manager, de l’Indexer et du Dashboard sont exécutés simultanément sur le même hôte.

## 3. Ports utilisés

Les principaux ports exposés par l’environnement sont :

```text
1514/TCP → communication des agents
1515/TCP → enrôlement des agents
55000/TCP → API Wazuh
9200/TCP → API Indexer
443/TCP  → Dashboard
```

Les ports `1514` et `1515` sont particulièrement importants pour l’intégration des postes Windows avec le Manager.

## 4. Intégration avec MDT

Wazuh est intégré directement au processus de déploiement MDT.

La Task Sequence MDT installe l’agent Wazuh puis lui transmet les paramètres nécessaires à sa configuration.

Les principales variables utilisées sont :

```text
WazuhServer
WazuhGroup
WazuhAgentName
```

Leur rôle est de permettre à la Task Sequence de déterminer :

```text
WazuhServer    → adresse du Manager
WazuhGroup     → groupe Wazuh du poste
WazuhAgentName → nom de l’agent
```

Pour le projet :

```text
WazuhServer = 192.168.61.103
```

Le nom et le groupe sont récupérés dynamiquement à partir des informations préparées par MDT.

Le flux global devient :

```text
MDT Database
      ↓
Variables MDT
      ↓
Task Sequence
      ↓
Installation de l'agent Wazuh
      ↓
Configuration
      ↓
Enrôlement
```

## 5. Configuration de l’agent

Le fichier principal de configuration de l’agent Windows est :

```text
C:\Program Files (x86)\ossec-agent\ossec.conf
```

Il permet notamment de définir l’adresse du Manager et le canal de communication utilisé par l’agent.

Dans l’environnement réalisé, l’agent communique avec :

```xml
<client>
    <server>
        <address>192.168.61.103</address>
        <port>1514</port>
        <protocol>tcp</protocol>
    </server>
</client>
```

L’adresse du serveur doit être adaptée lorsque l’adresse IP du serveur Wazuh change.

## 6. Vérification du fonctionnement

La présence du service Windows permet de vérifier que l’agent est installé :

```powershell
Get-Service WazuhSvc
```

La communication avec le Manager peut être testée avec :

```powershell
Test-NetConnection 192.168.61.103 -Port 1514
```

et :

```powershell
Test-NetConnection 192.168.61.103 -Port 1515
```

Les deux ports doivent être accessibles depuis le poste pour assurer respectivement la communication de l’agent et son enrôlement.

## Conclusion

L’intégration de Wazuh dans l’infrastructure repose donc sur une architecture centralisée déployée sur Ubuntu avec Docker Compose.

Le **Manager**, l’**Indexer** et le **Dashboard** constituent les trois composants centraux de l’environnement. L’agent Windows est ensuite intégré au processus MDT afin que sa configuration puisse être réalisée automatiquement lors du déploiement du poste.

Cette organisation permet de disposer d’une plateforme Wazuh centralisée tout en conservant MDT comme mécanisme d’automatisation de l’installation et de la configuration des postes.
