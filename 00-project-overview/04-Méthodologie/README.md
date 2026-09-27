# 04 — Méthodologie

## Introduction

La réalisation du projet a été menée selon une démarche progressive permettant de construire, configurer, expérimenter et valider l'infrastructure étape par étape.

Cette approche a été retenue afin de comprendre progressivement les différents mécanismes intervenant dans le fonctionnement de l'environnement, avec une attention particulière portée à la logique de déploiement automatisé de Windows.

La méthodologie suivie ne consiste donc pas uniquement à installer les différents composants de l'infrastructure. Elle repose sur une succession d'étapes permettant de passer de la conception de l'environnement à sa mise en œuvre, puis à son automatisation et à sa validation.

## 1. Analyse des besoins

La première étape consiste à identifier les besoins du projet et les fonctionnalités nécessaires à la réalisation de l'environnement.

Cette analyse permet notamment de déterminer :

* les différents systèmes nécessaires ;
* les fonctions devant être assurées par les serveurs ;
* les besoins liés à l'administration ;
* les besoins liés au déploiement des postes ;
* les besoins liés au stockage ;
* les besoins liés à la sécurité et à la supervision ;
* les mécanismes devant être automatisés ;
* les éléments devant être vérifiés lors de la phase de validation.

Cette étape permet de définir le périmètre du projet avant de commencer la mise en œuvre technique.

## 2. Conception de l'architecture

Une fois les besoins identifiés, l'architecture globale de l'environnement est définie.

Cette étape consiste à déterminer la répartition des différents rôles entre les machines ainsi que leur organisation au sein de l'environnement virtualisé.

La conception prend notamment en compte :

* la séparation des rôles ;
* les interactions entre les différents systèmes ;
* l'organisation des réseaux nécessaires au fonctionnement de l'environnement ;
* les ressources disponibles ;
* les besoins liés aux tests et à la validation ;
* les possibilités d'évolution de l'architecture.

Cette phase permet d'obtenir une organisation cohérente avant de procéder à la création et à la configuration des différentes machines.

## 3. Mise en place de l'environnement

Après la conception, l'environnement de virtualisation est préparé afin d'accueillir les différents systèmes nécessaires au projet.

Les machines virtuelles sont ensuite créées et configurées selon les caractéristiques définies dans l'architecture.

Cette étape comprend notamment :

* la création des machines virtuelles ;
* l'installation des systèmes d'exploitation ;
* la configuration des ressources matérielles virtuelles ;
* la configuration des interfaces réseau ;
* la mise en place des différents réseaux virtuels ;
* la préparation des systèmes avant l'installation des services.

L'objectif de cette phase est de disposer d'une base stable permettant de commencer la configuration de l'infrastructure.

## 4. Configuration des services

Une fois les systèmes opérationnels, les différents services nécessaires au projet sont installés et configurés.

La configuration est réalisée progressivement afin de pouvoir vérifier le fonctionnement de chaque composant avant de poursuivre la mise en œuvre.

Cette phase concerne notamment :

* les services d'administration ;
* les services nécessaires au déploiement ;
* les services de stockage ;
* les mécanismes de gestion des postes ;
* les composants de sécurité et de supervision.

Les configurations sont ensuite vérifiées afin de s'assurer que les différents services peuvent fonctionner ensemble conformément à l'architecture définie.

## 5. Mise en œuvre du déploiement

Une attention particulière est portée à la mise en œuvre du processus de déploiement Windows.

Cette étape permet d'étudier le fonctionnement de la chaîne de déploiement depuis le démarrage du poste jusqu'à l'obtention d'un système configuré.

Le processus est mis en œuvre progressivement afin de comprendre notamment :

* le démarrage réseau ;
* le chargement de l'environnement de préinstallation ;
* la récupération des informations nécessaires au déploiement ;
* l'application des règles et paramètres ;
* l'installation du système ;
* la configuration du poste ;
* son intégration dans l'environnement.

Cette phase constitue le cœur expérimental du projet puisqu'elle permet d'observer concrètement la logique utilisée pour adapter le déploiement au poste cible.

## 6. Automatisation

Une fois le processus de déploiement fonctionnel, les différentes étapes nécessitant une intervention manuelle sont progressivement automatisées.

L'objectif est de comprendre comment les informations disponibles dans l'environnement peuvent être utilisées pour déterminer automatiquement les paramètres applicables à chaque poste.

L'automatisation porte notamment sur :

* la récupération des informations relatives au poste ;
* l'application des règles de déploiement ;
* la sélection des paramètres appropriés ;
* l'installation des éléments nécessaires ;
* certaines opérations de configuration ;
* les opérations complémentaires réalisées après l'installation.

Cette phase permet également d'expérimenter l'utilisation de variables, de règles et de données provenant de différentes sources afin de construire un processus de déploiement adapté au contexte du poste.

## 7. Sécurisation et supervision

Une fois les principaux mécanismes opérationnels, des fonctions de sécurité et de supervision sont intégrées à l'environnement.

Cette étape permet de suivre l'activité des systèmes et d'observer certains événements produits pendant leur fonctionnement.

Elle permet également d'intégrer la sécurité au fonctionnement global de l'infrastructure plutôt que de la considérer comme une fonction indépendante du reste du projet.

Les mécanismes mis en place sont ensuite vérifiés afin de s'assurer qu'ils peuvent communiquer avec les différents systèmes concernés et fournir les informations attendues.

## 8. Tests et validation

Chaque étape importante de la réalisation fait l'objet de tests afin de vérifier son fonctionnement avant de poursuivre.

Les tests permettent notamment de vérifier :

* la communication entre les systèmes ;
* le fonctionnement des services ;
* l'intégration des postes ;
* l'application des configurations ;
* le fonctionnement du déploiement ;
* l'automatisation des différentes étapes ;
* la remontée des informations de supervision.

Les tests sont réalisés progressivement afin de faciliter l'identification des erreurs et de limiter leur impact sur les autres composants de l'environnement.

Une validation globale est ensuite effectuée afin de vérifier que les différents composants fonctionnent ensemble conformément aux objectifs définis.

## 9. Documentation et capitalisation

Les différentes étapes de réalisation, les configurations importantes, les résultats des tests et les problèmes rencontrés sont documentés au fur et à mesure de l'avancement du projet.

Cette documentation permet de conserver une trace des choix effectués et des mécanismes mis en œuvre.

Elle permet également de faciliter la reproduction de l'environnement et de disposer d'une référence pour les opérations de maintenance, d'évolution ou de modification du projet.

Les captures d'écran, fichiers de configuration, scripts et autres éléments utiles sont organisés dans les différentes parties du dépôt afin de conserver une documentation structurée.

## 10. Approche progressive et expérimentale

La méthodologie repose sur une approche progressive et expérimentale.

Plutôt que de mettre en place l'ensemble des composants simultanément, les différentes fonctions sont construites et vérifiées progressivement.

Cette approche permet notamment :

* d'identifier plus facilement l'origine d'un problème ;
* de vérifier chaque étape avant de dépendre d'elle pour la suivante ;
* de comprendre les interactions entre les différents composants ;
* d'expérimenter les mécanismes de déploiement ;
* d'améliorer progressivement le niveau d'automatisation ;
* de valider les résultats obtenus.

Cette démarche est particulièrement importante dans le cadre de l'étude du déploiement Windows, car elle permet de comprendre les différentes étapes du processus et pas uniquement son résultat final.

## Conclusion

La méthodologie adoptée repose donc sur une progression allant de l'analyse des besoins jusqu'à la validation de l'environnement.

Le projet est réalisé selon une succession logique :

text
Analyse des besoins
        ↓
Conception de l'architecture
        ↓
Mise en place de l'environnement
        ↓
Configuration des services
        ↓
Mise en œuvre du déploiement
        ↓
Automatisation
        ↓
Sécurisation et supervision
        ↓
Tests et validation
        ↓
Documentation


Cette démarche permet de construire progressivement une infrastructure cohérente tout en conservant une approche expérimentale centrée sur la compréhension des mécanismes de déploiement Windows.

Elle permet également de distinguer la construction de l'environnement, l'expérimentation des mécanismes, leur automatisation et la validation des résultats obtenus.
