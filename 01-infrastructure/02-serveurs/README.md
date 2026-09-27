# 02 — Serveurs

## Introduction

L'infrastructure repose sur trois serveurs virtuels, chacun ayant un rôle spécifique dans le fonctionnement de l'environnement.

Les serveurs sont hébergés sur VMware Workstation et fonctionnent avec des systèmes d'exploitation adaptés aux services qu'ils assurent.

L'organisation retenue permet de séparer les principales fonctions de l'infrastructure :

* **ServerOrchestres1** : serveur principal chargé des services d'infrastructure, de l'annuaire, du déploiement et de l'administration du domaine.
* **Windows Server stockage** : serveur dédié au stockage et à la mise à disposition des ressources partagées.
* **Ubuntu** : serveur dédié à la supervision et à la sécurité de l'environnement à travers la plateforme Wazuh.

Les informations présentées dans cette partie concernent principalement les ressources attribuées aux machines virtuelles, leur configuration réseau, leur rôle et les services qu'elles prennent en charge.

---

# 01 — ServerOrchestres1

## 1. Présentation

**ServerOrchestres1** constitue le serveur principal de l'infrastructure.

Il centralise plusieurs services fondamentaux nécessaires au fonctionnement de l'environnement Windows. Il assure notamment la gestion du domaine, la résolution de noms, l'attribution des paramètres réseau ainsi que les mécanismes de déploiement et de gestion des postes clients.

Cette machine constitue donc un élément central de l'infrastructure et permet de fournir les services nécessaires aux autres équipements du laboratoire.

## 2. Caractéristiques de la machine virtuelle

| Caractéristique        | Configuration                   |
| ---------------------- | ------------------------------- |
| Système d'exploitation | Windows Server                  |
| Mémoire vive           | 6,5 GB                          |
| Processeurs virtuels   | 2                               |
| Stockage               | 60 GB + 40 GB                   |
| Nombre de disques      | 2                               |
| Réseau                 | Bridged (Automatic) + Host-only |
| Hyperviseur            | VMware Workstation              |

La machine dispose de deux interfaces réseau virtuelles afin de permettre sa connexion à différents segments de l'environnement de laboratoire.

## 3. Rôle du serveur

ServerOrchestres1 assure principalement les fonctions suivantes :

* gestion de l'annuaire et des comptes du domaine ;
* résolution de noms ;
* attribution de la configuration réseau aux clients ;
* déploiement des systèmes d'exploitation ;
* automatisation du déploiement des postes ;
* gestion des stratégies de groupe ;
* administration centralisée de l'environnement Windows.

## 4. Services gérés

### 4.1 Active Directory Domain Services

Le service **Active Directory Domain Services (AD DS)** fournit l'annuaire central de l'environnement Windows.

Il permet notamment de gérer :

* les utilisateurs ;
* les groupes ;
* les ordinateurs ;
* les unités d'organisation (OU) ;
* l'appartenance au domaine ;
* l'authentification des utilisateurs et des machines.

L'Active Directory constitue également la base utilisée par plusieurs autres services d'administration de l'environnement.

### 4.2 DNS

Le service **DNS (Domain Name System)** assure la résolution des noms dans l'environnement.

Il permet notamment :

* la résolution des noms des machines ;
* la résolution des ressources du domaine ;
* le fonctionnement des services dépendant du domaine Active Directory ;
* la localisation des services du domaine.

Le DNS est étroitement intégré à Active Directory dans cette infrastructure.

### 4.3 DHCP

Le service **DHCP (Dynamic Host Configuration Protocol)** permet d'attribuer automatiquement aux clients les paramètres réseau nécessaires à leur fonctionnement.

Il permet notamment de gérer :

* les adresses réseau ;
* les paramètres de passerelle ;
* les serveurs DNS ;
* les plages d'adresses disponibles ;
* les paramètres nécessaires aux clients lors de leur connexion au réseau.

### 4.4 Windows Deployment Services

**Windows Deployment Services (WDS)** est utilisé pour permettre le démarrage réseau des machines clientes.

Dans cette infrastructure, WDS intervient notamment dans le processus de déploiement en fournissant les mécanismes nécessaires au démarrage PXE.

Il constitue un élément du processus de déploiement automatisé des postes.

### 4.5 Microsoft Deployment Toolkit

**Microsoft Deployment Toolkit (MDT)** permet d'automatiser et de standardiser le déploiement des systèmes Windows.

Il est utilisé notamment pour :

* préparer les environnements de déploiement ;
* installer Windows ;
* appliquer les configurations nécessaires ;
* installer les applications ;
* intégrer les postes au domaine ;
* automatiser les différentes étapes du déploiement ;
* appliquer des paramètres en fonction des caractéristiques du poste.

MDT constitue ainsi la couche d'automatisation du processus de déploiement.

### 4.6 Group Policy

Les **Group Policy Objects (GPO)** permettent de centraliser l'application de paramètres aux utilisateurs et aux ordinateurs du domaine.

Elles peuvent notamment être utilisées pour :

* appliquer des paramètres de sécurité ;
* configurer les postes clients ;
* gérer des restrictions ;
* déployer certains paramètres système ;
* appliquer des configurations différentes selon les unités d'organisation.

Les GPO permettent ainsi d'assurer une gestion centralisée des postes intégrés au domaine.

## 5. Synthèse

ServerOrchestres1 regroupe les principaux services nécessaires au fonctionnement de l'environnement Windows.

Son rôle peut être résumé autour de quatre fonctions principales :

**Annuaire → Réseau → Déploiement → Administration**

Il constitue donc le point central de gestion de l'infrastructure Windows.

---

# 02 — Windows Server stockage

## 1. Présentation

Le serveur **Windows Server stockage** est dédié aux fonctions de stockage et de partage de ressources.

Son objectif est de séparer les besoins liés au stockage des services d'infrastructure assurés par le serveur principal.

Cette séparation permet d'organiser l'environnement en distinguant les services d'administration et d'annuaire des ressources destinées au stockage.

## 2. Caractéristiques de la machine virtuelle

| Caractéristique        | Configuration       |
| ---------------------- | ------------------- |
| Système d'exploitation | Windows Server      |
| Mémoire vive           | 4,6 GB              |
| Processeurs virtuels   | 2                   |
| Stockage               | 60 GB + 40 GB       |
| Nombre de disques      | 2                   |
| Réseau                 | Bridged (Automatic) |
| Hyperviseur            | VMware Workstation  |

La machine dispose de deux disques virtuels permettant de séparer les besoins du système et ceux liés au stockage des données.

## 3. Rôle du serveur

Le serveur est principalement chargé de fournir des ressources de stockage accessibles depuis les autres machines de l'environnement.

Ses fonctions comprennent notamment :

* stockage de données ;
* organisation des ressources partagées ;
* mise à disposition de dossiers sur le réseau ;
* gestion des accès aux ressources partagées ;
* centralisation de certaines données utilisées par l'infrastructure.

## 4. Services gérés

### 4.1 Stockage

Le serveur assure la gestion de l'espace de stockage destiné aux données de l'environnement.

L'organisation du stockage permet notamment de séparer les données du système d'exploitation des ressources destinées aux utilisateurs ou aux différents services.

### 4.2 Partages réseau

Les ressources peuvent être mises à disposition sur le réseau sous forme de **partages Windows**.

Ces partages permettent aux machines autorisées d'accéder aux fichiers et aux dossiers hébergés sur le serveur.

### 4.3 Gestion des permissions

L'accès aux ressources partagées peut être contrôlé grâce aux mécanismes de permissions de Windows Server.

La gestion des droits permet de déterminer :

* quels utilisateurs peuvent accéder aux ressources ;
* quels groupes disposent d'un accès ;
* quelles opérations peuvent être réalisées ;
* quelles ressources doivent rester protégées.

Lorsque le serveur est intégré au domaine, la gestion des accès peut également s'appuyer sur les comptes et groupes Active Directory.

## 5. Synthèse

Windows Server stockage fournit la couche de **stockage et de partage de fichiers** de l'infrastructure.

Son rôle est volontairement séparé du serveur principal afin de disposer d'une architecture mieux organisée entre :

**Services d'infrastructure → Stockage → Clients**

---

# 03 — Ubuntu

## 1. Présentation

Le serveur **Ubuntu** est dédié aux fonctions de supervision et de sécurité de l'environnement.

Il héberge la plateforme **Wazuh**, utilisée pour centraliser les informations de sécurité remontées par les systèmes supervisés.

Contrairement aux deux serveurs Windows, ce serveur fonctionne sous Ubuntu et utilise Docker pour héberger les différents composants de la plateforme Wazuh.

## 2. Caractéristiques de la machine virtuelle

| Caractéristique        | Configuration      |
| ---------------------- | ------------------ |
| Système d'exploitation | Ubuntu Server      |
| Mémoire vive           | 6,1 GB             |
| Processeurs virtuels   | 2                  |
| Stockage               | 60 GB              |
| Nombre de disques      | 1                  |
| Réseau                 | Custom (VMnet1)    |
| Hyperviseur            | VMware Workstation |

La machine utilise un réseau virtuel personnalisé VMware afin de communiquer avec les composants de l'environnement qui doivent être supervisés.

## 3. Rôle du serveur

Le serveur Ubuntu assure principalement les fonctions suivantes :

* supervision de la sécurité ;
* collecte des événements provenant des agents ;
* analyse des événements ;
* centralisation des informations de sécurité ;
* stockage des données de supervision ;
* visualisation des événements et alertes.

La plateforme Wazuh est déployée sous forme de plusieurs composants conteneurisés.

## 4. Services gérés

### 4.1 Docker

**Docker** fournit l'environnement d'exécution utilisé pour héberger les différents composants de Wazuh.

L'utilisation de conteneurs permet de séparer les composants de la plateforme tout en facilitant leur déploiement et leur administration.

### 4.2 Wazuh Manager

Le **Wazuh Manager** constitue le composant principal de la plateforme.

Il assure notamment :

* la communication avec les agents Wazuh ;
* la réception des événements ;
* l'analyse des données de sécurité ;
* la génération d'alertes ;
* la gestion des agents ;
* l'organisation des agents en groupes.

Les postes clients équipés de l'agent Wazuh peuvent ainsi transmettre leurs événements de sécurité au Manager.

### 4.3 Wazuh Indexer

Le **Wazuh Indexer** est utilisé pour l'indexation et le stockage des données générées par la plateforme.

Il permet de conserver et d'organiser les événements afin qu'ils puissent ensuite être recherchés et exploités.

### 4.4 Wazuh Dashboard

Le **Wazuh Dashboard** fournit l'interface graphique permettant d'administrer et de consulter la plateforme.

Il permet notamment de :

* consulter les agents ;
* visualiser les alertes ;
* rechercher les événements ;
* analyser les informations de sécurité ;
* suivre l'état de l'environnement supervisé.

## 5. Architecture Wazuh

La plateforme Wazuh déployée sur Ubuntu repose donc sur plusieurs composants complémentaires :


                    ┌──────────────────────┐
                    │     Postes clients   │
                    │    Wazuh Agent       │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │    Wazuh Manager     │
                    │ Collecte / Analyse   │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │    Wazuh Indexer     │
                    │ Indexation / Stockage│
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │   Wazuh Dashboard    │
                    │ Visualisation / Admin │
                    └──────────────────────┘
```

Les différents composants sont exécutés dans des conteneurs Docker sur le serveur Ubuntu.

---

# 04 — Vue d'ensemble des serveurs

L'organisation générale des serveurs peut être représentée comme suit :


                         INFRASTRUCTURE
                              │
             ┌────────────────┼────────────────┐
             │                │                │
             ▼                ▼                ▼
     ServerOrchestres1   Windows Server      Ubuntu
             │             stockage            │
             │                │                │
       ┌─────┼─────┐          │          ┌─────┼─────┐
       │     │     │          │          │     │     │
       ▼     ▼     ▼          ▼          ▼     ▼     ▼
      AD    DNS   DHCP     Stockage    Manager Indexer Dashboard
       │
       ├── WDS
       ├── MDT
       └── GPO
```

Cette organisation permet de répartir les responsabilités entre les différents serveurs :

| Serveur                     | Fonction principale     | Services principaux                                   |
| --------------------------- | ----------------------- | ----------------------------------------------------- |
| **ServerOrchestres1**       | Infrastructure Windows  | AD DS, DNS, DHCP, WDS, MDT, GPO                       |
| **Windows Server stockage** | Stockage                | Stockage, partages réseau, permissions                |
| **Ubuntu**                  | Sécurité et supervision | Docker, Wazuh Manager, Wazuh Indexer, Wazuh Dashboard |

## Conclusion

Les trois serveurs constituent les principales briques serveur de l'environnement.

**ServerOrchestres1** assure les services fondamentaux de l'infrastructure Windows et l'automatisation du déploiement.

**Windows Server stockage** fournit les ressources de stockage et les partages nécessaires à l'environnement.

**Ubuntu** héberge la plateforme Wazuh et assure les fonctions de supervision et de sécurité.

Cette séparation des rôles permet de disposer d'une infrastructure organisée, dans laquelle chaque serveur possède une fonction clairement définie.
