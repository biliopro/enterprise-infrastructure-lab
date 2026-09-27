# Introduction des dépendances dans un bundle MDT

## 1. Contexte

Dans le cadre de l'automatisation du déploiement avec MDT, j'ai utilisé des **bundles d'applications** afin de regrouper plusieurs applications qui doivent être installées ensemble.

La création initiale du bundle a été réalisée à partir de l'interface graphique de MDT. Cette méthode permet de créer facilement un objet de type *Application Bundle* et de définir ses principales propriétés.

Cependant, lors de cette manipulation, l'ajout des dépendances au bundle n'a pas produit le résultat attendu.

## 2. Problème rencontré

Le bundle a d'abord été créé graphiquement depuis la console MDT.

L'objectif était ensuite de lui associer plusieurs applications existantes en tant que dépendances.

Malgré l'ajout des dépendances, celles-ci n'apparaissaient pas dans les propriétés du bundle.

Le bundle était donc bien créé, mais sa liste de dépendances restait vide.

## 3. Première approche : création graphique

La première approche consistait à reproduire le fonctionnement attendu depuis l'interface graphique de MDT :

1. Création d'une nouvelle application de type **Application Bundle**.
2. Définition du nom et des propriétés du bundle.
3. Sélection des applications devant constituer ses dépendances.
4. Validation de la configuration.
5. Vérification des propriétés du bundle.

Le bundle était correctement créé, mais les dépendances attendues n'étaient pas enregistrées.

## 4. Deuxième approche : PowerShell

Pour comprendre le fonctionnement et contourner cette limitation rencontrée avec l'interface graphique, j'ai reproduit la logique de création à l'aide de PowerShell.

L'approche consistait d'abord à :

1. créer l'objet Application Bundle ;
2. récupérer les GUID des applications existantes ;
3. ajouter ces applications comme dépendances au bundle créé.

Cette méthode n'a cependant pas permis d'obtenir le résultat attendu : le bundle était créé, mais les dépendances n'étaient toujours pas présentes.

## 5. Constat

Cette manipulation m'a permis de constater que, dans le fonctionnement observé lors de mes tests, **la création du bundle et l'ajout des dépendances devaient être réalisés dans la même opération PowerShell**.

Plutôt que de créer d'abord un bundle vide puis de tenter d'ajouter les dépendances dans une seconde opération, le script final construit directement le bundle en lui associant les GUID des applications dépendantes lors de sa création.

La logique retenue est donc :

```text
Applications existantes
        │
        ├── Application A → GUID
        ├── Application B → GUID
        └── Application C → GUID
                │
                ▼
      Création du Application Bundle
                │
                │ + GUID des dépendances
                ▼
       Bundle avec dépendances
```

Cette approche a permis d'obtenir un bundle contenant effectivement les dépendances attendues.

## 6. Solution retenue

La solution finale consiste donc à automatiser la création du bundle directement depuis PowerShell en fournissant les GUID des applications à associer au moment de la création.

Le script permet notamment de :

* identifier les applications nécessaires ;
* récupérer ou utiliser leurs GUID ;
* créer l'objet Application Bundle ;
* associer les dépendances au bundle lors de sa création ;
* vérifier ensuite la liste des dépendances enregistrées.

## 7. Script utilisé

Le script complet utilisé pour automatiser cette opération est présenté ci-dessous :

Après les différents essais, la méthode retenue consiste à créer directement le bundle avec les dépendances définies à l'aide de leurs GUID.

Import-MDTApplication `
    -Path "DS001:\Applications\IT" `
    -Name "ITAPP" `
    -ShortName "ITAPP" `
    -Enable $true `
    -Reboot $false `
    -Hide $false `
    -Version "" `
    -Publisher "" `
    -Language "" `
    -Bundle `
    -Dependency @(
        "{809d08ea-a406-4508-9ab8-30e881aa8083}",
        "{d50353f0-5e39-4062-a9ac-0aa1eaee2f9a}"
    )
Décomposition du script
Chemin du bundle
-Path "DS001:\Applications\IT"

Le bundle est créé dans le dossier IT du Deployment Share DS001.

Nom du bundle
-Name "ITAPP"
-ShortName "ITAPP"

Ces paramètres définissent respectivement le nom et le nom court du bundle.

Activation
-Enable $true

Le bundle est activé et peut donc être utilisé dans le processus de déploiement.

Paramètres de redémarrage et d'affichage
-Reboot $false
-Hide $false

Le bundle n'impose pas de redémarrage et reste visible dans MDT.

Type Bundle
-Bundle

Ce paramètre indique que l'objet créé est un Application Bundle et non une application classique.

Dépendances
-Dependency @(
    "{809d08ea-a406-4508-9ab8-30e881aa8083}",
    "{d50353f0-5e39-4062-a9ac-0aa1eaee2f9a}"
)

Cette partie définit les applications qui seront associées au bundle.

Les valeurs utilisées correspondent aux GUID des applications existantes dans MDT.

Le principe est donc :

Application 1 ── GUID ──┐
                         │
Application 2 ── GUID ──┼──> ITAPP
                         │
                         └──> Application Bundle

Le recours aux GUID permet d'identifier précisément les objets Application auxquels le bundle doit faire référence.

Résultat attendu

Après l'exécution du script, l'objet ITAPP apparaît dans :

DS001:\Applications\IT

avec les deux applications définies comme dépendances.

La configuration peut ensuite être vérifiée depuis les propriétés du bundle dans la console MDT.



## 8. Vérification

Après exécution du script, les propriétés du bundle sont vérifiées afin de confirmer que les dépendances ont bien été enregistrées.

La vérification permet notamment de retrouver :

* le nom du bundle ;
* son GUID ;
* les applications définies comme dépendances.

Cette étape permet de confirmer que la création automatisée produit bien la structure attendue.

## 9. Enseignement

Ce problème m'a permis de mieux comprendre la différence entre la manipulation d'un objet MDT depuis l'interface graphique et son automatisation à travers les cmdlets PowerShell.

La difficulté ne concernait donc pas uniquement la création du bundle, mais également la manière dont ses dépendances étaient associées à l'objet lors de sa création.

Cette observation a conduit à privilégier une création automatisée permettant de définir directement les dépendances à partir de leurs GUID.
