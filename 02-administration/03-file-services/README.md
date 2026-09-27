# Gestion des services de fichiers

## 1. Présentation du service

Le serveur de stockage est utilisé pour centraliser les ressources partagées entre les différents départements de l'environnement.

Le service repose sur **SMB** pour l'accès réseau aux dossiers et sur les **permissions NTFS** pour contrôler les opérations autorisées sur les fichiers et répertoires.

L'organisation retenue permet de disposer d'un espace distinct pour chaque département :

```text
Shares/
├── RH/
├── IT/
├── Direction/
├── Comptabilite/
└── Marketing/
```

Chaque dossier départemental correspond à un partage SMB accessible depuis le réseau.

## 2. Organisation du stockage

Les données sont regroupées dans un répertoire `Shares`, contenant un dossier par département.

Cette organisation permet de séparer les ressources tout en conservant une structure simple à administrer.

Les partages utilisés sont :

| Département  | Dossier        | Partage SMB             |
| ------------ | -------------- | ----------------------- |
| RH           | `RH`           | `\\SERVER\RH`           |
| IT           | `IT`           | `\\SERVER\IT`           |
| Direction    | `Direction`    | `\\SERVER\Direction`    |
| Comptabilité | `Comptabilite` | `\\SERVER\Comptabilite` |
| Marketing    | `Marketing`    | `\\SERVER\Marketing`    |

Le nom du serveur utilisé dans les scripts est `SERVERORCHERSTR`.

Les ressources sont donc accessibles selon le principe :

```text
\\SERVERORCHERSTR\<Departement>
```

## 3. Configuration des partages

Les dossiers départementaux sont exposés à travers des partages SMB.

Pour chaque partage, deux niveaux d'accès sont prévus :

* **Read** : consultation et lecture des fichiers ;
* **Modify / Change** : modification des fichiers et du contenu du dossier.

L'accès général `Everyone` est retiré au niveau du partage afin que les droits soient attribués explicitement aux groupes prévus.

Les administrateurs disposent d'un accès complet aux ressources.

La configuration obtenue suit cette logique :

```text
Partage départemental
        │
        ├── Lecture
        ├── Modification
        └── Administration
```

## 4. Gestion des permissions

Les permissions sont configurées à deux niveaux.

### Permissions NTFS

L'héritage est désactivé sur les dossiers départementaux afin de maîtriser directement les autorisations appliquées à ces ressources.

Les droits configurés sont :

| Groupe                    | Droit NTFS     |
| ------------------------- | -------------- |
| `Administrators`          | Full Control   |
| `SYSTEM`                  | Full Control   |
| `DL_<DEPARTEMENT>_Read`   | Read & Execute |
| `DL_<DEPARTEMENT>_Modify` | Modify         |

Les permissions sont appliquées aux dossiers, sous-dossiers et fichiers concernés.

### Permissions SMB

Les mêmes niveaux d'accès sont définis sur le partage :

| Groupe                    | Droit SMB |
| ------------------------- | --------- |
| `Administrators`          | Full      |
| `DL_<DEPARTEMENT>_Read`   | Read      |
| `DL_<DEPARTEMENT>_Modify` | Change    |

Les permissions NTFS et SMB sont ainsi utilisées conjointement pour contrôler l'accès aux ressources.

## 5. Automatisation

La configuration des ressources est automatisée avec :

```text
scripts/
└── ConfigureShares.ps1
```

Le script parcourt les départements définis dans sa configuration et effectue notamment les opérations suivantes :

1. vérification de l'existence du dossier départemental ;
2. vérification de l'existence des groupes de permissions ;
3. suppression de l'héritage NTFS ;
4. application des permissions NTFS ;
5. recherche du partage SMB correspondant ;
6. suppression de l'accès `Everyone` ;
7. application des permissions SMB.

Le script s'appuie sur les groupes de permissions déjà présents dans l'environnement. Il ne crée pas les groupes et ne réalise pas leur appartenance.

> **Remarque :** le script utilise un répertoire `Shares` relatif à l'emplacement du projet via `$PSScriptRoot`, tandis que son commentaire d'en-tête mentionne `D:\Shares`. Ces deux références devront être alignées si le script est destiné à être réutilisé tel quel.

## 6. Validation

La validation consiste à vérifier que les ressources sont accessibles depuis un poste client et que les droits correspondent au niveau attribué au compte utilisé.

Les contrôles portent notamment sur :

* l'accès au partage départemental ;
* la lecture des fichiers avec un compte disposant du droit `Read` ;
* la modification des fichiers avec un compte disposant du droit `Modify` ;
* l'absence d'accès non prévu ;
* la présence correcte des permissions NTFS et SMB.

L'objectif est de vérifier que la configuration du serveur de fichiers produit effectivement les niveaux d'accès définis.
