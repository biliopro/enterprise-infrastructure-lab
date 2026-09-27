# 02 — Choix de l'architecture

## Introduction

L'architecture retenue pour ce projet a été conçue afin de disposer d'un environnement cohérent permettant de mettre en œuvre, d'administrer, de déployer et de superviser différents composants d'une infrastructure informatique d'entreprise.

Bien que l'environnement soit réalisé dans un cadre de laboratoire et repose sur des machines virtuelles, les principes d'organisation retenus s'inspirent d'une infrastructure pouvant être mise en œuvre dans un contexte professionnel.

Le choix de l'architecture ne repose donc pas uniquement sur les contraintes du laboratoire. Il prend également en compte la séparation des responsabilités, l'organisation des services, les possibilités d'évolution et la capacité à reproduire des situations rencontrées dans une infrastructure d'entreprise.


## 1. Principes de conception de l'architecture

La conception de l'infrastructure repose principalement sur une organisation structurée des différents rôles.

L'objectif est d'éviter de concentrer l'ensemble des fonctions sur une seule machine et de répartir les responsabilités entre plusieurs systèmes selon leur utilisation.

Cette organisation permet notamment :

* de séparer les différentes fonctions de l'infrastructure ;
* de limiter le regroupement de services indépendants sur une même machine ;
* de faciliter l'administration et la maintenance des différents composants ;
* de reproduire des interactions entre plusieurs systèmes ;
* de faciliter les opérations de test et de validation ;
* de permettre une évolution progressive de l'environnement.

Cette approche permet également de mieux représenter le fonctionnement d'une infrastructure d'entreprise dans laquelle les différents services peuvent être répartis sur plusieurs systèmes physiques ou virtuels.



## 2. Choix d'une architecture multi-serveurs

L'architecture retenue repose sur **trois serveurs et un poste client**.

Le choix d'une architecture multi-serveurs permet de répartir les différentes fonctions de l'environnement plutôt que de les concentrer sur un serveur unique.

Dans le cadre du projet, cette organisation permet de distinguer trois grandes catégories de fonctions :

* l'administration et le déploiement de l'environnement ;
* la gestion du stockage et des ressources partagées ;
* la sécurité et la supervision.

Cette séparation permet de conserver une organisation claire des responsabilités et de faciliter l'étude des interactions entre les différents composants.

À l'inverse, une architecture reposant sur un seul serveur aurait permis de regrouper les services, mais aurait réduit la séparation fonctionnelle recherchée dans le cadre du projet.

Le choix de trois serveurs constitue ainsi un compromis entre une architecture suffisamment représentative d'un environnement d'entreprise et les ressources nécessaires à sa réalisation dans un environnement de laboratoire.


## 3. Répartition des rôles

Les trois serveurs sont organisés selon leurs fonctions principales.

### Serveur d'administration et de déploiement

Le premier serveur regroupe les fonctions nécessaires à l'administration centralisée de l'environnement ainsi qu'au déploiement des postes.

Cette organisation permet de disposer d'un point central pour la gestion du domaine et des mécanismes de déploiement utilisés dans le projet.

Les différents services associés à ce serveur ont été présentés dans la partie **01 — Infrastructure**.

### Serveur de stockage

Le deuxième serveur est dédié aux fonctions de stockage et à la gestion des ressources partagées.

La séparation du stockage des fonctions d'administration permet de distinguer les données et ressources partagées des services assurant la gestion de l'environnement.

Cette organisation facilite également l'étude de la gestion des accès aux ressources dans un environnement comportant plusieurs systèmes.

### Serveur de sécurité et de supervision

Le troisième serveur est dédié aux fonctions liées à la sécurité et à la supervision de l'environnement.

La séparation de ces fonctions permet de disposer d'un système distinct chargé de collecter et d'exploiter les informations provenant des différents composants supervisés.

Cette organisation permet ainsi d'étudier la supervision d'une infrastructure composée de plusieurs systèmes plutôt que de limiter cette fonction à un seul serveur.


## 4. Intégration d'un poste client

La présence d'un poste client constitue un élément essentiel de l'architecture.

Le poste client représente le système utilisé par un utilisateur final et permet de vérifier concrètement le fonctionnement des différents services mis en place sur les serveurs.

Il permet notamment de valider :

* l'intégration au domaine ;
* l'application des configurations centralisées ;
* les mécanismes de déploiement ;
* l'accès aux ressources partagées ;
* la communication avec les services d'infrastructure ;
* la remontée des informations nécessaires à la supervision.

Le client joue ainsi un rôle de point de validation permettant d'observer le fonctionnement de l'infrastructure du point de vue d'un système utilisateur.


## 5. Adaptation au contexte du projet

L'architecture a été dimensionnée en fonction des besoins du projet et des ressources disponibles dans l'environnement de laboratoire.

Le recours à la virtualisation permet de reproduire plusieurs systèmes indépendants sur une même infrastructure matérielle tout en conservant une séparation logique entre leurs différents rôles.

Le nombre de serveurs et de postes a donc été défini afin de disposer d'un environnement suffisamment complet pour mettre en œuvre les différentes fonctionnalités du projet, sans reproduire inutilement une infrastructure de grande taille.

Cette approche permet également de modifier, tester ou reconstruire certains composants de l'environnement sans nécessiter une infrastructure physique dédiée pour chaque rôle.


## 6. Transposition vers un environnement professionnel

L'architecture mise en place dans le cadre de ce projet constitue un environnement de laboratoire, mais les principes utilisés ne sont pas limités à ce contexte.

Une architecture similaire peut être transposée dans un environnement professionnel en adaptant le nombre de systèmes, leurs ressources et leur organisation aux besoins réels de l'entreprise.

Par exemple, une infrastructure disposant d'un nombre important de postes pourrait nécessiter davantage de ressources dédiées au déploiement, au stockage, à l'administration ou à la supervision. La séparation des rôles pourrait également être renforcée selon les contraintes de disponibilité, de sécurité et de performance.

De la même manière, les mécanismes de déploiement étudiés dans le projet peuvent être utilisés dans des environnements professionnels lorsque l'organisation choisit de s'appuyer sur ces technologies. La différence entre l'environnement présenté ici et une infrastructure réelle réside principalement dans l'échelle, les ressources matérielles, les exigences de disponibilité et les contraintes propres à l'organisation.

L'environnement de laboratoire constitue ainsi une représentation réduite permettant de mettre en pratique des principes d'architecture et d'administration pouvant être adaptés à une infrastructure de production.


## Conclusion

Le choix d'une architecture composée de trois serveurs et d'un poste client répond donc à une volonté de conserver une séparation fonctionnelle entre les différents rôles de l'infrastructure tout en disposant d'un environnement réalisable dans le cadre du projet.

Cette organisation permet de mettre en œuvre et de valider les différentes fonctions de l'infrastructure dans un environnement cohérent, tout en conservant des principes d'organisation pouvant être transposés à une infrastructure professionnelle.

La partie suivante présente les objectifs poursuivis à travers la réalisation de cette architecture.
