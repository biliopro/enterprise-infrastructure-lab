# Gestion des stratégies de groupe (GPO)

## 1. Introduction

Les stratégies de groupe (Group Policy Objects ou GPO) sont utilisées dans l'infrastructure afin de centraliser l'application de configurations sur les utilisateurs et les ordinateurs du domaine `bilie.corps`.

Dans ce laboratoire, les GPO permettent principalement de :

* appliquer des configurations communes aux utilisateurs et aux ordinateurs ;
* différencier certaines configurations selon les départements ;
* appliquer automatiquement des paramètres lors de l'ouverture de session ;
* contrôler l'accès et le ciblage des stratégies ;
* vérifier leur application sur les machines clientes.

Les configurations mises en place restent volontairement simples. L'objectif principal est de vérifier le fonctionnement du mécanisme de stratégie de groupe et de mettre en pratique une démarche complète de configuration, d'application et de dépannage.

## 2. Gestion des GPO avec GPMC

La gestion des stratégies de groupe est réalisée depuis **Group Policy Management Console (GPMC)**, disponible sur Windows Server.

Cette console permet notamment de :

* créer et supprimer des GPO ;
* modifier leurs paramètres ;
* lier une GPO à une OU ;
* contrôler son état ;
* définir le filtrage de sécurité ;
* gérer les permissions via la délégation ;
* consulter les paramètres configurés ;
* vérifier les relations entre les GPO et les OU.

Le fonctionnement général utilisé dans le laboratoire est le suivant :

```text
Création de la GPO
        ↓
Configuration des paramètres
        ↓
Liaison à une OU
        ↓
Définition du ciblage
        ↓
Application sur l'environnement concerné
        ↓
Vérification côté client
```

## 3. Organisation des GPO

Les GPO du laboratoire sont organisées selon deux catégories principales :

* les GPO destinées aux utilisateurs ;
* les GPO destinées aux ordinateurs.

Elles sont également organisées par département afin de permettre un ciblage cohérent avec la structure Active Directory.

```text
GPO
│
├── Base
│   ├── GPO-Base-Users
│   └── GPO-Base-Computers
│
├── RH
│   ├── GPO-RH-Users
│   └── GPO-RH-Computers
│
├── IT
│   ├── GPO-IT-Users
│   └── GPO-IT-Computers
│
├── Direction
│   ├── GPO-Direction-Users
│   └── GPO-Direction-Computers
│
├── Marketing
│   ├── GPO-Marketing-Users
│   └── GPO-Marketing-Computers
│
└── Comptabilité
    ├── GPO-Comptabilite-Users
    └── GPO-Comptabilite-Computers
```

Cette organisation permet de séparer les stratégies selon le type d'objet auquel elles sont destinées.

La logique de ciblage est la suivante :

```text
Département
│
├── Users
│      └── GPO-<Département>-Users
│
└── Workstations
       └── GPO-<Département>-Computers
```

Ainsi, une GPO utilisateur est associée à l'environnement des utilisateurs tandis qu'une GPO ordinateur est destinée aux comptes ordinateurs correspondants.

## 4. Configuration de la GPO utilisateur RH

La GPO `GPO-RH-Users` a été utilisée comme exemple de configuration et de validation.

Sa configuration est volontairement simple afin de rendre son application facilement observable depuis une machine cliente.

Les paramètres sont configurés dans :

```text
User Configuration
```

L'objectif est de pouvoir constater directement le résultat lorsqu'un utilisateur du département RH ouvre une session.

### 4.1 GPO-RH-Users

La GPO `GPO-RH-Users` est liée à l'OU :

```text
bilie.corps
└── Entreprise
    └── Users
        └── RH
```

Elle contient les paramètres suivants :

```text
GPO-RH-Users
│
├── Desktop Wallpaper
│      └── RH.jpg
│
├── Drive Maps
│      └── R: → \\SERVERORCHERSTR\RH
│
└── Folders
       └── E:\RH-TEST
```

### 4.2 Fond d'écran

Un paramètre **Desktop Wallpaper** a été configuré afin d'appliquer automatiquement l'image du département RH :

```text
\\SERVERORCHERSTR\RH\RH.jpg
```

Le style d'affichage configuré est :

```text
Center
```

Ce paramètre permet de disposer d'un indicateur visuel immédiat de l'application de la stratégie.

### 4.3 Mappage du lecteur réseau

Une préférence de stratégie a également été configurée pour créer le lecteur réseau `R:` :

```text
Action:       Update
Letter:       R
Location:     \\SERVERORCHERSTR\RH
Reconnect:    Enabled
```

Une option importante a été activée dans les paramètres communs de cet objet :

```text
Run in logged-on user's security context
```

Cette option permet au traitement de l'élément de préférence d'être réalisé dans le contexte de sécurité de l'utilisateur connecté.

Elle est particulièrement importante dans ce scénario puisque le lecteur doit permettre à l'utilisateur concerné d'accéder à la ressource réseau correspondant à son département.

## 5. Vérification de l'application côté client

Une fois les paramètres configurés, leur application est vérifiée directement depuis la machine cliente.

La première étape consiste à forcer une actualisation des stratégies :

```powershell
gpupdate /force
```

La présence et l'application des stratégies peuvent ensuite être vérifiées avec :

```powershell
gpresult /r
```

Un rapport HTML peut également être généré :

```powershell
gpresult /h C:\Temp\gpresult.html
```

Ces commandes permettent de déterminer si la GPO attendue a réellement été appliquée au contexte utilisateur ou ordinateur.

La vérification ne se limite cependant pas à `gpresult`. Les résultats attendus sont également contrôlés directement sur le poste :

```text
Utilisateur RH
     ↓
Connexion
     ↓
GPO-RH-Users
     ↓
Wallpaper RH
     ↓
Lecteur R:
     ↓
Dossier de test
```

Cette vérification permet de distinguer deux situations :

* la GPO n'a pas été appliquée ;
* la GPO est appliquée mais un de ses éléments ne fonctionne pas comme prévu.

## 6. Diagnostic et résolution des problèmes

Lors de la mise en œuvre, certaines vérifications ont été nécessaires afin de déterminer pourquoi une configuration n'était pas immédiatement visible sur le poste client.

La démarche de diagnostic suivie est la suivante :

```text
GPO non visible ou configuration non appliquée
                ↓
        Vérification de l'OU
                ↓
        Vérification du Scope
                ↓
   Vérification Security Filtering
                ↓
      Vérification Delegation
                ↓
       Vérification du statut
                ↓
   Vérification de la configuration
        de l'objet GPP
                ↓
          gpupdate /force
                ↓
          gpresult /r
                ↓
       Vérification côté client
```

### 6.1 Vérification du ciblage

La première étape consiste à confirmer que l'utilisateur ou l'ordinateur se trouve bien dans l'OU correspondant à la GPO.

Une mauvaise organisation des objets dans Active Directory peut empêcher une stratégie liée à une OU de concerner l'objet attendu.

### 6.2 Vérification du filtrage et des permissions

Lorsque le ciblage est correct, les paramètres de **Security Filtering** et de **Delegation** sont vérifiés.

Cette étape permet de s'assurer que le compte concerné dispose des permissions nécessaires pour traiter la GPO.

### 6.3 Vérification du statut

Le statut de la GPO est ensuite contrôlé afin de s'assurer que celle-ci est active et que la configuration utilisateur ou ordinateur concernée n'est pas désactivée.

### 6.4 Vérification des Group Policy Preferences

Lorsque la GPO est correctement appliquée mais qu'un élément individuel ne produit pas le résultat attendu, la configuration de l'objet GPP est examinée.

Pour le lecteur réseau RH, l'option :

```text
Run in logged-on user's security context
```

a notamment été activée afin que le traitement du mappage soit réalisé dans le contexte de l'utilisateur connecté.

Cette vérification montre qu'il faut distinguer :

```text
Application de la GPO
        ↓
Traitement de l'objet GPP
        ↓
Résultat attendu
```

Une GPO peut donc être correctement ciblée et appliquée alors qu'un élément particulier nécessite encore une configuration adaptée à son contexte d'exécution.

## 7. Validation

La validation finale consiste à vérifier à la fois l'application de la stratégie et le résultat produit sur le poste client.

Pour la GPO utilisateur, plusieurs indicateurs permettent de confirmer son fonctionnement :

* présence de la GPO dans les résultats de stratégie ;
* application du fond d'écran correspondant ;
* présence du lecteur réseau attendu ;
* création du dossier de test ;
* absence d'erreur bloquante lors du traitement ;
* correspondance entre l'utilisateur connecté et son environnement départemental.

Cette méthode permet de valider non seulement l'existence de la GPO, mais également son comportement réel dans l'environnement cible.

## 8. Automatisation

Après avoir vérifié manuellement le fonctionnement des stratégies, leur création et leur gestion peuvent être intégrées dans le mécanisme d'automatisation du laboratoire.

Les scripts associés à cette partie sont notamment :

```text
scripts/
├── BuildGPO.ps1
├── liaisongpo.ps1
└── essaiecreationgpp.ps1
```

`BuildGPO.ps1` est utilisé pour automatiser la création et la configuration des GPO.

`liaisongpo.ps1` permet d'automatiser leur liaison aux OU correspondantes.

`essaiecreationgpp.ps1` est conservé dans cette partie pour documenter les travaux et essais réalisés autour de la création des Group Policy Preferences.

L'automatisation reprend ainsi les opérations qui ont d'abord été validées manuellement.

## 9. Conclusion

La mise en place des GPO dans ce laboratoire a permis de mettre en pratique le cycle complet de gestion d'une stratégie de groupe.

L'objectif n'était pas de mettre en œuvre des politiques particulièrement complexes, mais de vérifier de manière concrète :

* la création d'une GPO ;
* sa liaison à une OU ;
* son ciblage ;
* la gestion des permissions ;
* son application dans le contexte utilisateur ;
* le traitement des Group Policy Preferences ;
* la vérification côté client ;
* le diagnostic des problèmes d'application ;
* et enfin l'automatisation de sa mise en place.

Cette démarche constitue une base pour les mécanismes de configuration qui seront ensuite exploités dans les étapes de déploiement et d'automatisation du laboratoire.
