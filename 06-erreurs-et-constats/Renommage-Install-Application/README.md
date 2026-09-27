# Renommage de l'étape « Install Application » dans une Task Sequence MDT

## 1. Contexte

Dans le cadre de la création de mes Task Sequences MDT, j'ai ajouté différentes étapes permettant d'installer les applications nécessaires aux postes selon leur département.

Lors de la configuration de ces étapes, MDT crée par défaut une étape nommée :

`Install Application`

Afin de rendre la Task Sequence plus lisible, j'ai souhaité renommer cette étape avec un nom correspondant à son utilisation.

Par exemple :

`Install Application` → `Application_RH`

L'objectif était uniquement de rendre la Task Sequence plus compréhensible en identifiant directement le groupe d'applications concerné.

## 2. Problème rencontré

Après avoir renommé l'étape `Install Application`, l'environnement MDT ne parvenait plus à retrouver correctement l'application associée à cette étape lors de l'exécution de la Task Sequence.

Pourtant, l'application était toujours présente dans le Deployment Share, dans la partie dédiée aux applications.

Le problème ne venait donc pas de la présence de l'application dans MDT.

Le constat était plutôt lié à la manière dont l'étape de la Task Sequence était interprétée lors de son exécution.

## 3. Vérifications effectuées

J'ai d'abord vérifié que :

* l'application existait toujours dans le Deployment Share ;
* l'application était correctement configurée ;
* l'application pouvait être retrouvée depuis la console MDT ;
* le Deployment Share contenait bien les fichiers nécessaires ;
* la Task Sequence contenait toujours l'étape d'installation.

Malgré cela, l'exécution de la Task Sequence ne permettait pas de retrouver correctement l'application attendue après le renommage de l'étape.

## 4. Constat

La comparaison entre une étape `Install Application` laissée avec son nom par défaut et une étape renommée en `Application_RH` m'a permis d'identifier un comportement particulier dans mon environnement MDT.

Le nom par défaut `Install Application` correspond à une étape standard de la Task Sequence dont la structure et les propriétés sont interprétées par l'environnement MDT.

Le simple changement du nom visible de cette étape a entraîné, dans mes tests, une perte de la correspondance attendue avec les propriétés utilisées lors de l'exécution.

Le problème ne concernait donc pas l'objet **Application** présent dans le Deployment Share, mais la manière dont l'étape de la Task Sequence était définie et interprétée.

## 5. Solution retenue

J'ai donc conservé le nom par défaut :

`Install Application`

plutôt que de le remplacer par un nom personnalisé tel que :

`Application_RH`

Pour différencier les différentes installations d'applications dans la Task Sequence, j'ai choisi de conserver la structure standard de l'étape et d'utiliser les paramètres et l'organisation de la Task Sequence pour identifier leur fonction.

## 6. Constat technique

Cette expérience montre qu'il faut distinguer deux éléments :

```text
Deployment Share
        │
        └── Applications
              └── Application_RH
                    │
                    │
                    ▼
             Task Sequence
                    │
                    └── Install Application
                           │
                           └── Application sélectionnée
```

L'objet **Application** et l'étape **Install Application** sont donc deux éléments différents.

La présence de l'application dans le Deployment Share ne garantit pas, à elle seule, que l'étape de la Task Sequence pourra correctement la retrouver si la structure ou les propriétés attendues par MDT ont été modifiées.

## 7. Enseignement

Cette erreur m'a permis de comprendre qu'une Task Sequence MDT ne doit pas être considérée uniquement comme une succession d'étapes dont les noms peuvent être librement modifiés.

Certaines étapes reposent sur une structure et des propriétés attendues par l'environnement MDT.

Avant de personnaliser une étape standard, il est donc nécessaire de vérifier si le changement concerne uniquement son affichage ou s'il modifie également les éléments utilisés par MDT lors de l'exécution.
