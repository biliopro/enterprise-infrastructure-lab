# Configuration initiale du système de déploiement

## 1. Présentation

La première étape du projet consiste à mettre en place l'environnement nécessaire au déploiement des postes Windows.

Plusieurs services interviennent dans cette phase :

* **DHCP** pour fournir automatiquement une adresse IP aux machines qui démarrent sur le réseau ;
* **Windows Deployment Services (WDS)** pour prendre en charge le démarrage PXE ;
* **Microsoft Deployment Toolkit (MDT)** pour préparer et exécuter le processus de déploiement.

Ces services sont utilisés conjointement afin de permettre à une machine cliente de démarrer depuis le réseau et d'accéder à l'environnement de déploiement.

Le fonctionnement général est le suivant :

```text
Client
   │
   │ Demande DHCP
   ▼
DHCP
   │
   │ Adresse IP
   ▼
Client
   │
   │ PXE
   ▼
WDS
   │
   │ Image de démarrage
   ▼
WinPE / LiteTouch
   │
   ▼
MDT
   │
   ▼
Task Sequence
   │
   ▼
Installation de Windows
```
## 2. Configuration du réseau PXE et de WDS

### DHCP

Le fonctionnement du démarrage PXE nécessite que le client puisse obtenir une configuration réseau avant de contacter le serveur de déploiement.

Dans le laboratoire, le réseau **Host-only** utilisé pour le déploiement dispose donc d'un service DHCP configuré spécifiquement pour les machines clientes.

Un **scope DHCP dédié au réseau PXE** a été créé afin de distribuer automatiquement des adresses IP aux machines qui démarrent sur ce réseau.

Le réseau Host-only permet ainsi d'isoler le trafic de déploiement et de fournir aux clients l'accès nécessaire à l'infrastructure WDS/MDT.

### WDS

**Windows Deployment Services (WDS)** est installé sur le serveur Windows utilisé pour l'infrastructure de déploiement.

Son rôle dans le projet est de prendre en charge le démarrage **PXE** des machines clientes et de leur fournir l'image de démarrage générée par MDT.

Lors de la configuration initiale de WDS, un problème a été rencontré au niveau du choix du mode d'intégration du serveur.

Le serveur Windows étant déjà membre du domaine Active Directory `bilie.corps`, l'option **« Serveur intégré à un domaine Active Directory »** avait initialement été sélectionnée.

Cette configuration ne correspondait cependant pas au fonctionnement retenu dans le laboratoire. WDS n'avait pas pour rôle de gérer directement les postes à partir d'une infrastructure de déploiement intégrée à Active Directory. Il était utilisé principalement comme **point de démarrage PXE permettant de charger l'environnement LiteTouch de MDT**.

La configuration a donc été reprise en sélectionnant le mode **« Serveur autonome (Standalone) »**.

Ce choix permet de conserver une architecture simple :

```text
DHCP
  │
  │ Attribution de l'adresse IP
  ▼
Client
  │
  │ Démarrage PXE
  ▼
WDS Standalone
  │
  │ Image LiteTouch
  ▼
WinPE / MDT
  │
  ▼
Deployment Share
  │
  ▼
Task Sequence
```

Le choix **Standalone** concerne le fonctionnement du service WDS et ne signifie pas que le serveur Windows est retiré du domaine Active Directory. Le serveur reste membre du domaine `bilie.corps` et continue d'utiliser les autres services de l'infrastructure.

Cette configuration correspondait donc au besoin du projet : utiliser WDS comme mécanisme de démarrage réseau et laisser **MDT gérer la logique du déploiement**.

Le répertoire utilisé par WDS dans le laboratoire est :

```text
E:\RemoteInstall
```

Après cette modification, le fonctionnement du démarrage PXE a pu être validé et l'intégration avec l'image de démarrage MDT a été poursuivie.


## 3. Installation et configuration de MDT

**Microsoft Deployment Toolkit (MDT)** est installé sur le même serveur que WDS.

Après son installation, un **Deployment Share** est créé afin de centraliser les éléments nécessaires au déploiement.

Le Deployment Share utilisé dans le laboratoire est :

```text
E:\DeploymentShare
```

Il contient notamment :

```text
DeploymentShare
├── Applications
├── Operating Systems
├── Out-of-Box Drivers
├── Packages
├── Scripts
├── Control
└── Boot
```

Cette organisation permet à MDT de regrouper les systèmes d'exploitation, applications, scripts et paramètres utilisés pendant les déploiements.


## 4. Intégration des applications

Afin de disposer d'un environnement de déploiement complet, plusieurs applications ont été intégrées au Deployment Share MDT. Cette étape permet de rendre les applications disponibles dans le Deployment Wizard et de pouvoir les installer pendant le déploiement du système.

Parmi les applications intégrées figuraient notamment :

* **7-Zip**
* **Firefox ESR**
* **Wazuh Agent**
* d'autres applications nécessaires à l'environnement de test.

Pour chaque application, un élément **Application** a été créé dans MDT en définissant les informations nécessaires à son installation, notamment la commande d'installation silencieuse et les fichiers sources associés.

Une fois les applications importées et le Deployment Share mis à jour, elles deviennent disponibles dans MDT et peuvent être utilisées dans les Task Sequences ou proposées dans la page de sélection des applications du Deployment Wizard.

Cette intégration constitue une étape préalable à la personnalisation du Wizard présentée dans la partie suivante. Elle permet notamment de disposer des applications comme éléments sélectionnables avant de mettre en place les règles permettant d'automatiser leur sélection selon le département.



## 5. Préparation du système d'exploitation

L'image de Windows utilisée pour le projet est importée dans MDT comme système d'exploitation disponible pour les déploiements.

Une **Task Sequence** est ensuite créée afin de définir les différentes étapes exécutées lors de l'installation.

Dans cette première configuration, l'objectif est d'obtenir une séquence capable d'effectuer un déploiement fonctionnel de Windows.

Les personnalisations supplémentaires seront ajoutées dans les étapes suivantes du projet.

## 6. Configuration de WinPE et LiteTouch

MDT génère une image de démarrage **LiteTouch** basée sur WinPE.

Cette image contient l'environnement minimal permettant de démarrer le processus de déploiement et d'établir la communication avec le Deployment Share.

La génération de l'image produit notamment :

```text
LiteTouchPE_x64.wim
```

L'image générée est ensuite intégrée à WDS afin qu'elle puisse être proposée aux machines démarrant en PXE.

Le processus devient alors :

```text
PXE
 ↓
WDS
 ↓
LiteTouchPE_x64.wim
 ↓
WinPE
 ↓
MDT Deployment Wizard
```

## 7. Intégration WDS et MDT

Une fois WDS et MDT configurés, l'image de démarrage générée par MDT est ajoutée à WDS.

Cette intégration permet de relier le mécanisme de démarrage réseau fourni par WDS au processus de déploiement fourni par MDT.

Le fonctionnement obtenu est donc :

```text
Client
  │
  │ DHCP
  ▼
Adresse IP
  │
  │ PXE
  ▼
WDS
  │
  │ LiteTouchPE_x64.wim
  ▼
WinPE
  │
  ▼
MDT Deployment Share
  │
  ▼
Task Sequence
  │
  ▼
Installation Windows
```

## 8. Première validation

Avant de passer à la personnalisation du Wizard, cette configuration est vérifiée à travers un premier démarrage PXE d'une machine cliente.

Les éléments vérifiés sont :

* obtention d'une adresse IP depuis le scope DHCP ;
* démarrage du client en PXE ;
* prise en charge du démarrage par WDS ;
* chargement de WinPE ;
* accès au Deployment Share ;
* apparition du MDT Deployment Wizard ;
* présence du système d'exploitation importé ;
* présence de la Task Sequence ;
* lancement du processus de déploiement.

Cette étape constitue la base fonctionnelle du système.

À ce stade, MDT permet déjà de réaliser un déploiement Windows, mais plusieurs paramètres doivent encore être renseignés ou sélectionnés manuellement.

La personnalisation du Wizard et les fichiers XML/VBS seront abordés dans la partie suivante consacrée au **déploiement manuel**.
