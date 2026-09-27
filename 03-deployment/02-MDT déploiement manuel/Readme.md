# 02 — MDT déploiement manuel

## Introduction

Microsoft Deployment Toolkit (MDT) fournit un environnement de déploiement qui peut être utilisé directement après sa configuration initiale. Cependant, son fonctionnement repose sur différents fichiers, scripts, règles et variables qui peuvent être étudiés et adaptés afin de répondre aux besoins spécifiques d'une infrastructure.

Dans le cadre de ce projet, une phase de configuration manuelle a donc été réalisée afin de comprendre le fonctionnement interne de MDT et d'explorer les possibilités offertes par sa personnalisation.

L'objectif n'était pas de modifier l'ensemble de la solution ni de remplacer les mécanismes natifs de MDT, mais de comprendre suffisamment leur fonctionnement pour pouvoir les manipuler, les compléter et construire progressivement un environnement de déploiement adapté aux besoins de l'entreprise.

Cette démarche permet notamment de comprendre où les informations sont définies, comment elles sont récupérées, comment elles sont transformées en variables MDT et comment ces variables sont ensuite utilisées par les différentes étapes du déploiement.

La page `Computer Details` a constitué le principal exemple de cette étude, car elle a nécessité plusieurs modifications de l'interface et du traitement des données. Elle ne représente cependant qu'une partie du fonctionnement étudié.

La démarche suivie peut être résumée ainsi :

```text
Comprendre MDT
      ↓
Identifier les composants
      ↓
Comprendre les variables
      ↓
Modifier certains fichiers
      ↓
Créer et exploiter ses propres variables
      ↓
Automatiser plusieurs paramètres
      ↓
Réduire progressivement les interventions
      ↓
Faire évoluer l'architecture avec la MDT Database
```

---

## 2.1. Étude des composants du Deployment Wizard

MDT utilise plusieurs fichiers pour construire et exécuter le Deployment Wizard. La première étape a consisté à identifier les composants utiles à la compréhension du fonctionnement du déploiement.

L'étude s'est notamment intéressée à :

| Élément                      | Rôle                                                                                    |
| ---------------------------- | --------------------------------------------------------------------------------------- |
| `CustomSettings.ini`         | Définit des règles et des propriétés utilisées par MDT                                  |
| `DeployWiz_Definition_ENU`   | Définit l'organisation générale du Deployment Wizard et référence ses différentes pages |
| `DeployWiz_ComputerName.xml` | Définit la structure et les éléments affichés dans la page `Computer Details`           |
| `DeployWiz_ComputerName.vbs` | Contient la logique d'initialisation, de traitement et de validation associée à la page |
| Variables MDT                | Transportent les informations utilisées par les différents mécanismes du déploiement    |

L'objectif de cette étude était surtout de comprendre que ces éléments ne fonctionnent pas indépendamment.

Une partie du fonctionnement peut être représentée ainsi :

```text
Fichiers de configuration
        │
        ▼
Deployment Wizard
        │
        ▼
Définition des pages
        │
        ▼
Interface
        │
        ▼
Scripts
        │
        ▼
Variables MDT
        │
        ▼
Task Sequence
```

Cette analyse a permis de comprendre la séparation entre les différents niveaux du système : définition, interface, traitement et exploitation des informations.

Elle a également montré qu'une modification du comportement de MDT doit être réalisée en tenant compte des relations existantes entre ces composants.

---

## 2.2. Fonctionnement des variables MDT

La compréhension du fonctionnement des variables MDT constitue la base de la personnalisation réalisée dans cette partie.

Une variable peut recevoir une valeur depuis différentes sources, puis être utilisée par plusieurs composants du processus de déploiement.

Le principe général peut être représenté comme suit :

```text
Source d'une information
        │
        ▼
Variable MDT
        │
        ├──► Script
        ├──► Wizard
        ├──► Règle
        └──► Task Sequence
```

L'environnement MDT permet ainsi de conserver des informations entre les différentes étapes du déploiement.

L'utilisation de l'objet `oEnvironment` permet notamment à un script de définir ou de modifier une propriété de l'environnement :

```vb
oEnvironment.Item("NomDeVariable") = "Valeur"
```

Cette possibilité est particulièrement importante dans une démarche de personnalisation, car elle signifie qu'une variable peut être introduite pour répondre à un besoin spécifique de l'environnement, puis utilisée par la logique construite autour de cette variable.

L'étude de ce fonctionnement a donc permis de comprendre qu'il n'est pas nécessaire de considérer MDT comme un système fermé dans lequel seules les propriétés prévues initialement peuvent être utilisées.

Il est possible de construire une logique adaptée à l'organisation à condition de définir :

```text
la variable
     ↓
la source de sa valeur
     ↓
le mécanisme qui la traite
     ↓
les composants qui l'exploitent
```

Cette compréhension constitue la base de la phase de personnalisation présentée dans la section suivante.

---

## 2.3. Personnalisation du Deployment Wizard

Après avoir identifié le rôle des différents composants, l'étape suivante a consisté à modifier certains fichiers du Deployment Wizard afin d'adapter son comportement sans remettre en cause son fonctionnement général.

### `DeployWiz_Definition_ENU`

Le fichier de définition générale permet notamment de déclarer les différentes pages du Wizard et de les associer aux fichiers correspondants.

Pour la page `Computer Details`, le principe est le suivant :

```xml
<Pane id="ComputerName"
      reference="DeployWiz_ComputerName.xml">
```

Le Deployment Wizard sait ainsi quelle définition utiliser pour la page correspondante.

### `DeployWiz_ComputerName.xml`

Le fichier XML intervient ensuite dans la construction de l'interface de la page.

Il peut notamment contenir les champs, éléments graphiques et événements utilisés par la page.

Dans le cadre du projet, un élément permettant de sélectionner le département a été ajouté à l'interface.

Exemple simplifié :

```xml
<select id="DepartmentSelect"
        language="vbscript"
        onchange="UpdateDepartmentConfig">

    <option value="">
        -- Sélectionner un département --
    </option>

    <option value="RH">
        Ressources Humaines
    </option>

    <option value="IT">
        Informatique
    </option>

    <option value="Comptabilite">
        Comptabilité
    </option>

</select>
```

Le fichier XML permet donc de définir la partie visible et interactive de la page.

Le script associé est chargé par la page à travers :

```xml
<Global>
    <CustomScript>DeployWiz_ComputerName.vbs</CustomScript>
</Global>
```

Le VBS est ainsi chargé comme script personnalisé de la page. Les fonctions qu'il contient peuvent ensuite être appelées par le mécanisme d'initialisation, de validation ou par les événements associés aux éléments de l'interface.

### `DeployWiz_ComputerName.vbs`

Le fichier VBScript constitue la couche de traitement associée à la page.

Il contient notamment des fonctions d'initialisation et de validation telles que :

```text
InitializeComputerName
ValidateComputerName
InitializeDomainMembership
ValidateDomainMembership
```

Une fonction supplémentaire a été ajoutée pour traiter la sélection du département :

```text
UpdateDepartmentConfig
```

La valeur du contrôle XML peut alors être récupérée par le script :

```vb
SelectedDepartment = document.getElementById("DepartmentSelect").value
```

Le principe de fonctionnement devient :

```text
DeployWiz_Definition_ENU
        ↓
référence de la page
        ↓
DeployWiz_ComputerName.xml
        ↓
construction de l'interface
        ↓
interaction avec l'utilisateur
        ↓
fonction VBScript
        ↓
traitement de l'information
```

Cette organisation permet donc d'adapter l'interface et la logique du Deployment Wizard tout en conservant les fonctions natives de MDT lorsque celles-ci restent nécessaires.

---

## 2.4. Création et exploitation de variables personnalisées

La personnalisation du Deployment Wizard a ensuite permis de mettre en pratique la création et l'exploitation de variables adaptées aux besoins du projet.

Le département constitue ici l'exemple principal.

Lorsqu'une valeur est sélectionnée dans l'interface, le script peut l'enregistrer dans l'environnement MDT :

```vb
oEnvironment.Item("Department") = "RH"
```

Cette variable peut ensuite être utilisée pour définir d'autres paramètres :

```vb
oEnvironment.Item("MachineObjectOU") = _
    "OU=RH,OU=Workstations,OU=Entreprise,DC=bilie,DC=corps"
```

La logique complète est alors :

```text
Sélection dans l'interface
          │
          ▼
Department
          │
          ▼
Variable de l'environnement MDT
          │
          ▼
Logique personnalisée
```

Cette approche permet de créer des variables qui répondent directement aux besoins de l'organisation.

Dans le cas du projet, `Department` n'est pas une simple information affichée dans le Wizard. Il devient une variable de configuration pouvant être réutilisée par d'autres mécanismes.

Ainsi, une information sélectionnée une seule fois peut être exploitée pour déterminer plusieurs éléments du déploiement :

```text
Department
    │
    ├──► configuration du poste
    │
    ├──► applications à installer
    │
    └──► MachineObjectOU
```

Par exemple :

```text
Department = RH
        │
        ├──► applications associées au département RH
        │
        └──► OU RH dans Active Directory
```

Cette expérience montre qu'il est possible de construire son propre environnement de déploiement à partir des mécanismes fournis par MDT.

L'essentiel n'est pas seulement de créer une nouvelle variable, mais de définir l'ensemble de la chaîne nécessaire à son fonctionnement :

```text
Définir la variable
        ↓
Lui fournir une valeur
        ↓
La traiter
        ↓
La rendre disponible dans l'environnement MDT
        ↓
La réutiliser dans le processus
```

Cette possibilité constitue l'un des principaux enseignements de cette phase de configuration manuelle.

---

## 2.5. Automatisation du parcours du Wizard avec les variables `Skip`

L'étude du fonctionnement du Deployment Wizard a également permis d'identifier les variables `Skip`.

Ces variables permettent de contrôler l'affichage de certaines pages du Wizard.

Le principe peut être résumé ainsi :

```text
Variable Skip
      ↓
Condition évaluée par MDT
      ↓
Page affichée ou ignorée
```

Cette fonctionnalité devient particulièrement intéressante dans une démarche d'automatisation, puisqu'elle permet de réduire les interactions avec l'administrateur.

Cependant, cette possibilité introduit un problème logique important.

Une page du Wizard peut être utilisée pour récupérer plusieurs informations nécessaires aux étapes suivantes du déploiement. Si cette page est ignorée, les variables qu'elle devait fournir restent malgré tout nécessaires.

Le raisonnement devient alors :

```text
Page ignorée
      ↓
Quelles informations devait-elle fournir ?
      ↓
Quelles variables sont nécessaires ?
      ↓
Qui va fournir leurs valeurs ?
      ↓
Depuis quelle source ?
```

Cette réflexion permet de comprendre qu'une automatisation ne consiste pas seulement à supprimer des pages.

Pour rendre le processus réellement autonome, il faut également prévoir un mécanisme capable d'alimenter les variables qui étaient auparavant renseignées à travers l'interface.

Cette découverte constitue une transition importante entre la personnalisation manuelle du Wizard et l'utilisation d'une source externe de configuration.

---

## 2.6. Limites de la configuration manuelle et évolution vers la MDT Database

Les modifications réalisées dans cette partie ont permis de compléter l'automatisation existante et de construire une logique de déploiement adaptée aux besoins de l'environnement.

Cependant, plusieurs étapes nécessitaient encore une intervention importante de l'administrateur.

Même lorsque certaines valeurs étaient automatiquement déterminées, le déploiement restait encore dépendant du parcours du Deployment Wizard et de certaines informations fournies au moment du lancement.

La situation pouvait être résumée ainsi :

```text
Configuration manuelle
        ↓
Variables personnalisées
        ↓
Traitement automatique
        ↓
Paramètres partiellement automatisés
        ↓
Intervention encore nécessaire
```

La limite ne concernait donc plus uniquement la page elle-même, mais la source des données nécessaires au déploiement.

L'étude des variables `Skip` a renforcé ce constat : si une page est ignorée, les informations qu'elle devait fournir doivent être obtenues autrement.

La MDT Database a alors été intégrée au projet afin de faire évoluer ce fonctionnement.

La base permet d'associer un ordinateur à une configuration prédéfinie à partir de son identité. Dans le projet, l'adresse MAC a notamment été utilisée comme élément d'identification dans `ComputerIdentity`.

Le principe devient :

```text
Identité du poste
       │
       ▼
MDT Database
       │
       ▼
Configuration associée
       │
       ▼
Variables MDT
       │
       ▼
Déploiement
```

Cette approche permet de récupérer automatiquement certaines informations qui auraient auparavant nécessité une intervention de l'administrateur.

L'utilisation de l'adresse MAC permet également d'associer un poste donné à une configuration déterminée et d'exploiter des possibilités plus avancées de sélection et de préparation du déploiement.

L'évolution du projet peut ainsi être représentée comme suit :

```text
MDT standard
      ↓
Étude des composants
      ↓
Compréhension des variables
      ↓
Personnalisation du Wizard
      ↓
Création de variables personnalisées
      ↓
Automatisation de paramètres
      ↓
Réduction des interventions manuelles
      ↓
Identification des limites
      ↓
MDT Database
      ↓
Alimentation automatique de la configuration
```

Cette progression montre que la MDT Database n'a pas été ajoutée indépendamment du travail réalisé précédemment.

Elle constitue l'évolution logique de la démarche : après avoir compris comment les variables sont créées, alimentées et exploitées, il devient possible de rechercher un mécanisme permettant de leur fournir automatiquement les valeurs nécessaires.

---

## Conclusion

Cette partie a permis d'explorer la capacité de Microsoft Deployment Toolkit à être personnalisé au-delà de sa configuration initiale.

L'objectif était à la fois de comprendre le fonctionnement de la solution et d'apprendre à manipuler ses composants sans perturber les mécanismes natifs de déploiement.

L'étude des fichiers de configuration, du Deployment Wizard, des fichiers XML, des scripts VBScript et des variables MDT a permis de comprendre comment les différentes informations circulent au sein du processus :

```text
Interface
   ↓
Script
   ↓
Variable MDT
   ↓
Traitement
   ↓
Déploiement
```

La personnalisation de `Computer Details` a constitué le principal exemple pratique de cette démarche. Elle a notamment permis de créer une logique autour de la variable `Department`, puis d'utiliser cette information pour déterminer plusieurs paramètres du poste, notamment les applications à installer et l'unité d'organisation Active Directory.

Cette phase a ainsi démontré qu'un administrateur peut étendre MDT en introduisant ses propres variables, en définissant les mécanismes nécessaires pour leur attribuer des valeurs et en déterminant les traitements qui leur seront appliqués.

La découverte des variables `Skip` a ensuite permis d'élargir cette compréhension : réduire l'intervention de l'administrateur ne consiste pas simplement à masquer les pages du Wizard, car les variables que ces pages fournissaient doivent toujours être alimentées.

Cette limite a conduit à l'évolution vers la MDT Database, qui permet d'associer automatiquement une configuration à un ordinateur identifié notamment par son adresse MAC.

La configuration manuelle étudiée dans cette partie constitue donc une étape essentielle du projet : elle a permis non seulement d'automatiser certaines opérations, mais surtout de comprendre comment construire un environnement MDT adapté à une organisation donnée et comment faire évoluer progressivement son niveau d'automatisation.
