# Échec de l'enregistrement du poste dans Active Directory

## 1. Contexte

Lors d'un déploiement MDT, le poste doit rejoindre le domaine Active Directory afin d'être enregistré comme ordinateur dans le domaine.

Dans mon infrastructure, deux serveurs assurent les services Active Directory et la réplication des données de domaine :

* `SERVERORCHESTRER1`
* `SERVERSTOCKAGE`

Le déploiement du poste pouvait correctement atteindre l'infrastructure du domaine et résoudre le nom du domaine, mais l'enregistrement du nouvel ordinateur dans Active Directory ne se déroulait pas correctement.

## 2. Problème rencontré

Le poste parvenait à trouver le domaine et à effectuer sa résolution DNS.

Cependant, lors de la tentative de jonction au domaine, l'ordinateur rencontrait des difficultés à être correctement enregistré comme objet **Computer** dans Active Directory.

Le comportement était donc particulier :

```text
Résolution du domaine
        ↓
       OK
        ↓
Connexion au domaine
        ↓
      Échec / comportement anormal
        ↓
Objet Computer non enregistré correctement
```

## 3. Première analyse

La résolution DNS étant fonctionnelle, j'ai dans un premier temps vérifié que le problème ne provenait pas simplement de l'absence de résolution du domaine.

Les vérifications ont montré que le poste pouvait bien retrouver les services du domaine.

J'ai ensuite vérifié l'état des contrôleurs de domaine et de leur réplication.

## 4. Cause identifiée

L'analyse a permis de constater que le serveur de stockage n'avait pas reçu les dernières mises à jour provenant de l'autre contrôleur de domaine depuis plusieurs jours.

Il existait donc un décalage entre les informations Active Directory présentes sur les deux serveurs.

La résolution du domaine pouvait fonctionner, tout en ayant des informations Active Directory qui n'étaient pas encore synchronisées entre les contrôleurs.

## 5. Résolution

J'ai forcé la réplication Active Directory afin de synchroniser les contrôleurs de domaine.

La commande utilisée était :

```powershell
repadmin /syncall /AdeP
```

L'état de la réplication a ensuite été vérifié avec :

```powershell
repadmin /replsummary
```

et :

```powershell
repadmin /showrepl
```

## 6. Validation

Après la synchronisation, j'ai vérifié que les informations Active Directory étaient bien disponibles sur le serveur de stockage.

Le fonctionnement du domaine a ensuite été retesté avec le déploiement du poste.

Cette vérification a permis de distinguer deux éléments qui peuvent facilement être confondus :

* la capacité à **résoudre le domaine** ;
* la capacité à **effectuer correctement les opérations Active Directory nécessaires à l'enregistrement d'un ordinateur**.

## 7. Constat

Cette erreur m'a permis de constater qu'une résolution DNS fonctionnelle ne signifie pas nécessairement que l'ensemble des opérations Active Directory fonctionnera correctement.

Dans une infrastructure comportant plusieurs contrôleurs de domaine, l'état de la réplication doit également être pris en compte lors du diagnostic d'un problème de jonction ou d'enregistrement d'un poste.

Le problème ne provenait donc pas directement de la MDT Database : il se situait en amont, au niveau de la synchronisation des services Active Directory.
