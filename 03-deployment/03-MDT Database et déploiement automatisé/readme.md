# 03 — MDT Database et déploiement automatisé

## Introduction

Après avoir étudié le fonctionnement de MDT et personnalisé le parcours du Deployment Wizard, l’étape suivante consiste à centraliser les paramètres de déploiement afin de limiter les saisies manuelles.

La MDT Database répond à cet objectif en associant à chaque ordinateur des propriétés de déploiement pouvant ensuite être récupérées automatiquement par MDT. L’identification de la machine, les paramètres du domaine, l’unité d’organisation, la Task Sequence, les paramètres régionaux ou encore les variables de contrôle du Wizard peuvent ainsi être stockés dans une même source de données.

Cette organisation permet de passer d’un déploiement configuré manuellement à un déploiement reposant sur des informations préparées à l’avance.

## 3.1. Mise en place de la MDT Database

### 3.1.1. Prérequis SQL

La MDT Database repose sur un moteur SQL Server. L’installation de SQL Server 2025 fournit le service de base de données nécessaire pour héberger les données utilisées par MDT.

Une fois SQL Server installé et opérationnel, une MDT Database peut être créée et configurée afin d’être exploitée par le Deployment Share.

Dans l’environnement mis en place, SQL Server utilise l’instance par défaut `MSSQLSERVER`.

### 3.1.2. Création et configuration de la MDT Database

La base MDT a été créée à l’aide des outils MDT, via le provider PowerShell, en ciblant directement le Deployment Share DS001:.

La commande utilisée est :

New-MDTDatabase `
    -Path "DS001:" `
    -SQLServer "localhost" `
    -Port 1433 `
    -Netlib "DBMSOCN" `
    -Database "MDTDB"

Cette commande crée la base MDTDB dans l’instance par défaut de SQL Server et génère la structure nécessaire au fonctionnement de la MDT Database. Le paramètre -Path "DS001:" permet d’associer directement la base au Deployment Share concerné.

La base obtenue, nommée MDTDB, contient ensuite les tables et vues utilisées par MDT pour stocker et récupérer les paramètres de déploiement.

## 3.2. Exploration de la structure de la MDT Database

L’exploration de `MDTDB` permet d’identifier la structure de la base, les tables disponibles ainsi que les propriétés manipulées par MDT.

Parmi les éléments observés figurent notamment `ComputerIdentity` et `ComputerSettings`.

ComputerIdentity contient les informations permettant d’identifier un ordinateur enregistré dans la base, notamment à travers des propriétés fréquemment utilisées comme Description et MacAddress.

Dans l’environnement mis en place, la propriété Description est utilisée pour représenter le département auquel l’ordinateur est rattaché.

`ComputerSettings` regroupe quant à elle les propriétés de déploiement associées à cette identité. L’exploration de cette structure montre que MDT peut stocker un ensemble important de paramètres, parmi lesquels :

```text
OSInstall
JoinDomain
DomainAdmin
DomainAdminDomain
MachineObjectOU
TimeZoneName
TaskSequenceID
KeyboardLocale
UserLocale
UILanguage
```

Des propriétés de contrôle du parcours du Wizard sont également présentes :

```text
SkipDomainMembership
SkipComputerName
SkipLocaleSelection
SkipSummary
SkipFinalSummary
SkipTimeZone
SkipTaskSequence
```

La base ne contient donc pas uniquement l’identité du poste. Elle regroupe également les paramètres nécessaires à son déploiement et au contrôle du parcours utilisateur.

L’association entre l’identité de l’ordinateur et ses paramètres permet ainsi à MDT de retrouver automatiquement les informations correspondant à la machine concernée.

## 3.3. Configuration des données de déploiement

Une fois la structure de la base identifiée, les informations nécessaires au déploiement sont renseignées pour chaque ordinateur.

Dans le cas étudié, l’adresse MAC permet d’identifier la machine, tandis que la valeur `Description` contient l’information de département :

```text
MacAddress  → 00:0C:29:81:76:9C
Description → RH
```

Les paramètres complémentaires définissent ensuite le comportement attendu du déploiement.

Par exemple :

```text
JoinDomain    → bilie.corps
MachineObjectOU → OU=RH,OU=Workstations,OU=Entreprise,DC=bilie,DC=corps
TaskSequenceID → W11-001
TimeZoneName  → Morocco Standard Time
UserLocale    → fr-FR
UILanguage    → fr-FR
```

Les informations ainsi enregistrées permettent de préparer le déploiement avant même son exécution.


## 3.4. Automatisation du parcours de déploiement

L’utilisation de la MDT Database permet de réduire les informations devant être saisies manuellement dans le Deployment Wizard.

Au démarrage du déploiement, le script ZTIGather.wsf collecte les propriétés de configuration à partir des différentes sources définies par MDT. Pour la MDT Database, il utilise notamment les paramètres SQLServer, Database, Table, Parameters et ParameterCondition afin d’interroger les données correspondant à l’ordinateur concerné.

Dans notre configuration, l’adresse MAC permet d’identifier l’ordinateur dans la base :

Adresse MAC
      ↓
ZTIGather.wsf
      ↓
MDT Database
      ↓
ComputerSettings
      ↓
Propriétés MDT

Les propriétés récupérées deviennent alors disponibles dans l’environnement MDT et peuvent être utilisées par les étapes suivantes du déploiement.

Parmi ces propriétés figurent notamment les variables Skip, qui permettent de contrôler le parcours du Deployment Wizard :

SkipDomainMembership = YES
SkipComputerName     = YES
SkipLocaleSelection  = YES
SkipTimeZone         = YES
SkipTaskSequence     = YES
SkipSummary          = YES
SkipFinalSummary     = YES

Le fonctionnement devient ainsi :

Identification du poste
        ↓
ZTIGather.wsf
        ↓
Récupération des paramètres dans MDTDB
        ↓
Variables MDT
        ↓
Contrôle du Deployment Wizard
        ↓
Déploiement automatisé

La MDT Database devient ainsi une source de configuration permettant à MDT de déterminer automatiquement les paramètres du poste et de réduire les interventions demandées à l’administrateur.


## 3.5. Exploitation des données dans la Task Sequence

Les propriétés récupérées depuis la MDT Database sont également exploitées par la Task Sequence.

Les informations associées à l’ordinateur permettent notamment de déterminer les paramètres de son intégration au domaine, son emplacement dans Active Directory et la Task Sequence à exécuter.

La valeur représentant le département peut également servir de référence pour appliquer la configuration et les applications prévues pour l’environnement correspondant.

La logique devient ainsi :

```text
Ordinateur
     ↓
Identification par la MDT Database
     ↓
Récupération des propriétés
     ↓
Variables MDT
     ↓
Task Sequence
     ↓
Configuration du poste
```

La Task Sequence ne constitue donc plus un ensemble de paramètres entièrement définis manuellement pour chaque poste. Elle exploite les informations préparées dans la base afin d’adapter automatiquement le déploiement.

## 3.6. Intégration de Wazuh au déploiement

La MDT Database fournit également les informations nécessaires au paramétrage de certains composants ajoutés au poste lors du déploiement.

Dans l’environnement réalisé, les variables utilisées pour Wazuh permettent notamment de transmettre les paramètres liés au serveur, au groupe et à l’identification de l’agent.

L’intégration de Wazuh est ainsi réalisée dans le même processus de déploiement automatisé, sans nécessiter une configuration manuelle complète après l’installation du système.

## 3.7. Résultat du déploiement automatisé

L’utilisation de la MDT Database permet finalement d’obtenir un parcours de déploiement beaucoup plus automatisé.

Pour un ordinateur enregistré dans la base, MDT peut :

```text
Identifier le poste
        ↓
Récupérer ses propriétés
        ↓
Sélectionner la configuration prévue
        ↓
Contrôler automatiquement le parcours du Wizard
        ↓
Exécuter la Task Sequence
        ↓
Configurer le poste selon les données enregistrées
```

La MDT Database devient ainsi le point central permettant de préparer les paramètres propres à chaque ordinateur tout en conservant une Task Sequence commune.

Cette évolution constitue le passage d’un déploiement principalement manuel à un déploiement préparé à l’avance et piloté par les données stockées dans MDT.
