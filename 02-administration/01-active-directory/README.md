# 01 — Active Directory

## Introduction

Le service Active Directory Domain Services constitue le point central de gestion des identités et des objets Windows de l'environnement.

Son rôle général ayant déjà été présenté dans les parties précédentes, cette section se concentre sur la **construction et l'administration des objets Active Directory utilisés dans le projet**, ainsi que sur les relations qui existent entre eux.

L'organisation mise en place repose principalement sur :

* les utilisateurs ;
* les comptes ordinateurs représentant les postes de travail ;
* les groupes de sécurité ;
* les unités d'organisation ;
* les comptes de service.

L'objectif est de montrer comment ces objets sont organisés et comment leur association permet de construire une administration cohérente de l'environnement.

Une première configuration est réalisée manuellement afin de comprendre le fonctionnement de chaque objet. Les mécanismes d'automatisation utilisés ensuite dans le projet sont présentés dans les répertoires `scripts/` et `csv/`.

## 1. Organisation de la structure Active Directory

La structure principale utilisée dans le projet est organisée sous le domaine `bilie.corps`.

Une partie dédiée à l'entreprise a été créée afin de regrouper les objets spécifiques à l'environnement :


bilie.corps
│
├── Builtin
├── Computers
├── Domain Controllers
│
└── Entreprise
    │
    ├── Groups
    │   ├── Distribution
    │   ├── DomainLocal
    │   └── Global
    │
    ├── Policies
    │
    ├── Servers
    │
    ├── Service Account
    │
    ├── Users
    │   ├── Direction
    │   ├── RH
    │   ├── IT
    │   ├── Marketing
    │   └── Comptabilite
    │
    └── Workstations
        ├── Direction
        ├── RH
        ├── IT
        ├── Marketing
        └── Comptabilite


Cette organisation permet de séparer les différents types d'objets et de les regrouper selon leur fonction.

Elle permet également de préparer l'environnement pour les autres mécanismes d'administration, notamment les stratégies de groupe et les services de fichiers.

## 2. Utilisateurs

### 2.1 Rôle des comptes utilisateurs

Les comptes utilisateurs représentent les identités utilisées par les personnes dans le domaine.

Dans le projet, un utilisateur n'est donc pas uniquement un compte permettant d'ouvrir une session Windows. Il constitue également un élément utilisé par les différents mécanismes d'administration.

Un utilisateur peut notamment :

* être associé à un département ;
* appartenir à un ou plusieurs groupes de sécurité ;
* recevoir des configurations destinées aux utilisateurs ;
* accéder à des ressources selon les permissions qui lui sont attribuées ;
* être utilisé pour valider le fonctionnement de l'environnement du point de vue utilisateur.

La gestion des utilisateurs est donc directement liée à la gestion des groupes, des ressources et des politiques appliquées dans l'environnement.

### 2.2 Organisation des utilisateurs

Les utilisateurs sont organisés dans l'OU `Users`, elle-même située sous `Entreprise`.

Des OU distinctes ont été créées pour les différents départements :


Entreprise
└── Users
    ├── Direction
    ├── RH
    ├── IT
    ├── Marketing
    └── Comptabilite


Cette organisation permet de rattacher chaque identité à son contexte organisationnel.

Elle permet également de conserver une structure cohérente avec celle utilisée pour les postes de travail.

### 2.3 Création manuelle

La création d'un utilisateur peut être réalisée avec **Active Directory Users and Computers**.

La procédure consiste notamment à :

1. ouvrir `Active Directory Users and Computers` ;
2. accéder à `Entreprise > Users` ;
3. sélectionner l'OU correspondant au département ;
4. créer un nouvel objet `User` ;
5. renseigner l'identité de l'utilisateur ;
6. définir son nom d'ouverture de session ;
7. configurer son mot de passe et les paramètres du compte ;
8. valider la création ;
9. vérifier que l'utilisateur apparaît dans l'OU attendue.

La création manuelle permet de comprendre les propriétés de l'objet avant de reproduire la même opération automatiquement.

## 3. Workstations

### 3.1 Rôle des comptes ordinateurs

Lorsqu'un poste Windows est intégré au domaine, il est représenté dans Active Directory par un **compte ordinateur**.

Cet objet permet d'identifier le poste au sein du domaine et de l'intégrer aux mécanismes d'administration centralisée.

Dans le projet, les comptes ordinateurs sont particulièrement importants puisqu'ils constituent le lien entre le **poste physique ou virtuel déployé** et son environnement Active Directory.

Ils permettent notamment :

* d'identifier le poste ;
* de l'intégrer au domaine ;
* de l'organiser dans une OU ;
* de lui appliquer les configurations destinées aux ordinateurs ;
* de distinguer les postes appartenant aux différents départements.

### 3.2 Organisation des Workstations

Les postes sont organisés dans une structure parallèle à celle des utilisateurs :


Entreprise
└── Workstations
    ├── Direction
    ├── RH
    ├── IT
    ├── Marketing
    └── Comptabilite


Cette organisation permet de distinguer les postes selon leur contexte organisationnel.

Elle est également importante pour les mécanismes de gestion des stratégies de groupe puisque les configurations destinées aux ordinateurs peuvent être associées aux OU correspondantes.

### 3.3 Intégration d'un poste dans le domaine

Lorsqu'un poste rejoint le domaine pour la première fois, son compte ordinateur doit être associé à l'environnement correspondant à son département.

Dans le projet, le poste est placé dans l'OU `Workstations` correspondant à son département.

La logique peut être représentée ainsi :


                Poste Windows
                     │
                     ↓
             Identification
                     │
                     ↓
              Département
                     │
          ┌──────────┴──────────┐
          ↓                     ↓
        RH                      IT
          ↓                     ↓
Workstations/RH       Workstations/IT


Par exemple, un poste destiné au département RH doit être associé à :


Entreprise
└── Workstations
    └── RH


Cette organisation permet ensuite de différencier les configurations appliquées aux postes selon leur contexte.

### 3.4 Création et vérification manuelles

Un compte ordinateur peut être créé manuellement depuis **Active Directory Users and Computers**.

La procédure consiste notamment à :

1. accéder à l'OU `Workstations` ;
2. sélectionner le département concerné ;
3. créer un nouvel objet `Computer` ;
4. définir le nom du poste ;
5. valider la création ;
6. vérifier la présence du compte ordinateur dans l'OU attendue.

La vérification permet de confirmer que le compte ordinateur a été créé dans le bon emplacement avant l'intégration effective du poste.

Dans le processus de déploiement automatisé, cette logique de placement est ensuite prise en charge automatiquement selon les informations associées au poste.

## 4. Groupes de sécurité

Les groupes constituent un élément essentiel de l'organisation des identités.

Plutôt que d'attribuer directement des droits à chaque utilisateur, les utilisateurs peuvent être regroupés selon leur fonction ou leur département.

Dans le projet, les groupes sont organisés selon leur portée :


Entreprise
└── Groups
    ├── Distribution
    ├── DomainLocal
    └── Global


Cette séparation permet de distinguer les différentes utilisations des groupes dans l'environnement.

## 5. Groupes Global

Les groupes globaux ont été utilisés pour représenter les appartenances fonctionnelles ou départementales.

Les principaux groupes créés dans le projet sont notamment :


GG_Direction
GG_RH
GG_IT
GG_Marketing
GG_Compta


La logique consiste à associer les utilisateurs à leur groupe global correspondant à leur département.

Par exemple :


Utilisateur RH
      │
      ↓
   GG_RH


ou :


Utilisateur IT
      │
      ↓
   GG_IT


Cette organisation permet de représenter l'appartenance fonctionnelle d'un utilisateur sans attribuer directement des permissions à son compte.

### Création manuelle

Un groupe global peut être créé depuis **Active Directory Users and Computers** en sélectionnant l'OU `Groups > Global`.

La création consiste notamment à :

1. créer un nouvel objet groupe ;
2. définir son nom ;
3. sélectionner le type `Security Group` ;
4. sélectionner l'étendue `Global` ;
5. valider la création ;
6. ajouter les utilisateurs concernés comme membres.

## 6. Groupes Domain Local

Les groupes `Domain Local` sont utilisés dans le projet pour représenter les ensembles auxquels des permissions ou des accès peuvent être associés.

Plusieurs groupes ont notamment été créés pour différencier les niveaux d'accès :


DL_Compta...
DL_Direction...
DL_IT_Modify
DL_IT_Read
DL_Marketing...
DL_RH_Modify
DL_RH_Read


La distinction entre `Read` et `Modify` permet par exemple de différencier deux niveaux d'accès à une même catégorie de ressources.

La logique recherchée est ainsi de ne pas donner directement une permission à un utilisateur, mais de passer par une structure de groupes.

## 7. Relation entre les groupes et les utilisateurs

L'organisation des groupes permet de séparer **l'identité de l'utilisateur** de **la permission accordée sur une ressource**.

La logique peut être représentée ainsi :


                  Utilisateur
                       │
                       ↓
                Groupe Global
                       │
                       ↓
              Groupe Domain Local
                       │
                       ↓
                  Permission
                       │
                       ↓
                   Ressource


Par exemple :


Utilisateur RH
      │
      ↓
    GG_RH
      │
      ↓
  DL_RH_Read
      │
      ↓
Ressource RH


ou :


Utilisateur RH
      │
      ↓
    GG_RH
      │
      ↓
 DL_RH_Modify
      │
      ↓
Ressource RH


Cette organisation permet de gérer les permissions à travers les groupes plutôt que de modifier individuellement les droits de chaque utilisateur.

Elle devient particulièrement intéressante lorsque plusieurs utilisateurs doivent recevoir les mêmes droits.

## 8. Groupes Distribution

Une catégorie `Distribution` a également été prévue dans la structure `Groups`.

Les groupes de distribution sont destinés à représenter des groupes utilisés pour la distribution ou la communication plutôt que pour l'attribution de permissions de sécurité.

Ils sont donc distincts des groupes de sécurité utilisés pour contrôler les accès aux ressources.

La séparation des catégories permet de conserver une organisation claire des différents usages des groupes dans Active Directory.

## 9. Comptes de service

Les comptes de service sont des comptes Active Directory dédiés aux opérations techniques qui nécessitent une identité propre pour s'authentifier auprès de ressources du système d'information.

Dans l'environnement de laboratoire, deux comptes de service sont regroupés dans une OU dédiée :


Entreprise
└── Service Account
    ├── Service Account 1
    └── Service Account 2


### 9.1 Accès aux ressources de déploiement

Dans une infrastructure de déploiement, un compte de service peut être utilisé lorsqu'un composant ou une opération technique doit s'authentifier pour accéder à une ressource protégée du réseau.

Un exemple est l'accès aux ressources utilisées par MDT, notamment le **Deployment Share** ou d'autres ressources nécessaires au processus de déploiement.

Le principe est alors le suivant :


Compte de service
        ↓
Authentification
        ↓
Ressource réseau
        ↓
Deployment Share / ressources MDT
        ↓
Ressources nécessaires au déploiement


Dans le laboratoire, un des comptes de service peut notamment être utilisé comme identité d'authentification pour l'accès aux ressources liées à MDT, notamment dans le contexte de la connexion à la base ou aux ressources de déploiement.

L'utilisation d'un compte dédié permet de séparer les opérations techniques des comptes utilisateurs classiques et d'attribuer uniquement les droits nécessaires aux opérations concernées.

### 9.2 Intérêt des comptes de service

L'utilisation de comptes dédiés présente plusieurs intérêts :

* séparer les opérations techniques des comptes utilisateurs ;
* disposer d'une identité spécifique pour les processus d'administration ou de déploiement ;
* contrôler précisément les droits accordés ;
* faciliter l'identification des accès effectués par les composants techniques ;
* éviter d'utiliser un compte administrateur personnel pour une opération automatisée.

Le compte de service représente donc **l'identité utilisée pour s'authentifier**. Il ne définit pas à lui seul les permissions sur une ressource.

### 9.3 Organisation dans Active Directory

Les comptes sont placés dans une OU dédiée :


Entreprise
└── Service Account
    ├── Service Account 1
    └── Service Account 2


Cette organisation permet de distinguer les comptes techniques des comptes utilisateurs présents dans :


Entreprise
└── Users
    ├── Direction
    ├── RH
    ├── IT
    ├── Marketing
    └── Comptabilite


### 9.4 Création manuelle

La création d'un compte de service suit le même principe qu'un compte utilisateur Active Directory, mais avec une utilisation dédiée aux opérations techniques.

Depuis **Active Directory Users and Computers**, le compte est créé directement dans l'OU :


Entreprise
└── Service Account


Lors de sa création, les paramètres importants sont notamment :

* le nom du compte ;
* son mot de passe ;
* son état d'activation ;
* les restrictions éventuelles ;
* les groupes auxquels il doit appartenir, lorsque cela est nécessaire.

Les droits accordés au compte doivent ensuite être définis au niveau des ressources auxquelles il doit accéder.

### 9.5 Relation avec les autres objets

Il est important de distinguer trois éléments :


Compte de service
        ↓
      Identité
        ↓
Groupe de sécurité
        ↓
   Gestion des accès
        ↓
Permission
        ↓
Ressource


Le **compte de service** représente l'identité.

Le **groupe de sécurité**, lorsqu'il est utilisé, permet de regrouper les identités et de simplifier leur gestion.

Les **permissions** déterminent ensuite ce que cette identité ou ce groupe peut réellement faire sur une ressource.

Dans le contexte du déploiement :


Compte de service
        ↓
Authentification
        ↓
Ressource MDT
        ↓
Deployment Share
        ↓
Fichiers et ressources nécessaires au déploiement


Cette organisation permet ainsi d'intégrer les comptes de service dans l'architecture globale d'administration et de déploiement sans les confondre avec les comptes utilisateurs classiques.


## 10. Relations entre les objets Active Directory

La structure mise en place prend tout son sens lorsque les différents objets sont considérés comme un ensemble.

Deux chaînes principales peuvent être distinguées.

### 10.1 Gestion des identités et des permissions


Utilisateur
     │
     ↓
Groupe Global
     │
     ↓
Groupe Domain Local
     │
     ↓
Permission
     │
     ↓
Ressource


Cette chaîne permet de séparer :

* l'identité de la personne ;
* son appartenance organisationnelle ;
* le niveau d'accès qui lui est accordé ;
* la ressource protégée.

### 10.2 Gestion des postes et des configurations


Poste
  │
  ↓
Département
  │
  ↓
OU Workstations
  │
  ↓
Configuration ordinateur


Les utilisateurs suivent une organisation parallèle :


Utilisateur
  │
  ↓
Département
  │
  ↓
OU Users
  │
  ↓
Configuration utilisateur


Les deux structures sont donc complémentaires :


                  Département
                  /          \
                 /            \
                ↓              ↓
             Users        Workstations
                │              │
                ↓              ↓
             Groupes           GPO
                │              │
                ↓              ↓
            Permissions    Configurations


Cette organisation permet de faire correspondre le contexte organisationnel d'un utilisateur et celui d'un poste.

## 11. Création manuelle avant automatisation

La création manuelle des objets constitue une étape importante dans le projet.

Elle permet de comprendre concrètement :

* comment créer un utilisateur ;
* comment créer un ordinateur ;
* comment créer un groupe ;
* comment ajouter un membre à un groupe ;
* comment organiser les objets dans les OU ;
* comment vérifier les propriétés des objets ;
* comment établir les relations entre les différents objets.

Cette approche permet également de vérifier le fonctionnement de la structure avant d'introduire l'automatisation.

Les captures d'écran présentes dans le dossier `screenshots/` permettent de documenter ces différentes opérations.

## 12. Automatisation de la création des objets

Une fois la structure comprise et validée manuellement, les mêmes opérations ont été automatisées dans le cadre du projet.

L'objectif est de remplacer les opérations répétitives par une logique reproductible.

Les données sont séparées de la logique d'exécution :


                         CSV
                          │
          ┌───────────────┼────────────────┐
          ↓               ↓                ↓
     Structure.csv    Users.csv       computers.csv
          │               │                │
          └───────────────┼────────────────┘
                          ↓
                    PowerShell
                          │
          ┌───────────────┼────────────────┐
          ↓               ↓                ↓
        Users        Workstations       Groups
                          │
                          ↓
                  Active Directory


Les fichiers CSV décrivent les éléments à créer tandis que les scripts PowerShell assurent leur traitement et leur création dans Active Directory.

Cette séparation présente plusieurs avantages :

* reproductibilité ;
* réduction des opérations manuelles ;
* réduction des erreurs de saisie ;
* modification plus simple des données ;
* possibilité de reconstruire une partie de l'environnement ;
* cohérence entre les différents objets.

### Scripts et données

Les scripts utilisés pour cette automatisation sont disponibles dans :


scripts/


Les fichiers de données utilisés par ces scripts sont disponibles dans :


csv/


La documentation de cette section présente d'abord le fonctionnement manuel afin que la logique des scripts puisse ensuite être comprise plus facilement.

## 13. Vérification de la configuration

Après la création des objets, une série de vérifications permet de confirmer que la structure obtenue correspond à la configuration attendue.

Les vérifications portent notamment sur :


OU
│
├── Users
│   ├── Direction
│   ├── RH
│   ├── IT
│   ├── Marketing
│   └── Comptabilite
│
├── Workstations
│   ├── Direction
│   ├── RH
│   ├── IT
│   ├── Marketing
│   └── Comptabilite
│
└── Groups
    ├── Distribution
    ├── DomainLocal
    └── Global


Il faut ensuite vérifier :

* la présence des utilisateurs ;
* leur emplacement ;
* la présence des comptes ordinateurs ;
* leur emplacement ;
* la présence des groupes ;
* le type et la portée des groupes ;
* les appartenances aux groupes ;
* la présence des comptes de service ;
* la cohérence générale des relations entre les objets.

Ces vérifications constituent une étape préalable avant l'utilisation de ces objets par les autres mécanismes d'administration.

## 14. Lien avec les autres composants du projet

Les objets Active Directory créés dans cette partie servent de base aux mécanismes présentés dans les parties suivantes.

Les utilisateurs et les groupes pourront notamment être utilisés pour gérer les accès aux ressources du serveur de fichiers.

Les OU `Users` et `Workstations` pourront servir de points d'application aux stratégies de groupe.

Les comptes ordinateurs permettront d'identifier les postes intégrés au domaine.

Enfin, la structure des utilisateurs, des postes et des groupes constitue un élément important du contexte dans lequel le processus de déploiement Windows est exécuté.

La relation générale peut être représentée ainsi :


             Active Directory
                    │
        ┌───────────┼───────────┐
        ↓           ↓           ↓
      Users    Workstations   Groups
        │           │           │
        │           ↓           ↓
        │          OU       Permissions
        │           │           │
        └───────────┼───────────┘
                    ↓
             Administration
                    │
        ┌───────────┼───────────┐
        ↓           ↓           ↓
       GPO    File Services  Deployment


## Conclusion

La gestion d'Active Directory dans ce projet repose donc sur une organisation structurée des identités, des postes, des groupes et des unités d'organisation.

Les utilisateurs sont organisés par département dans `Users`, tandis que les postes sont organisés selon la même logique dans `Workstations`.

Les groupes globaux permettent de représenter les appartenances fonctionnelles, tandis que les groupes `Domain Local` permettent de structurer l'attribution des accès et des permissions. Les groupes de distribution sont séparés des groupes utilisés pour la sécurité, et les comptes de service disposent d'une OU dédiée.

L'intérêt de cette organisation réside surtout dans les **relations entre les objets** : les utilisateurs sont associés à des groupes, les postes sont associés à des OU, les groupes peuvent être associés à des permissions et les OU constituent des points d'organisation pour les configurations centralisées.

La création manuelle permet de comprendre cette logique. L'automatisation présentée dans les répertoires `scripts/` et `csv/` permet ensuite de reproduire cette structure de manière cohérente et reproductible.
