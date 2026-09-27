# 01 — Présentation du projet

## Introduction

Ce projet consiste à concevoir et mettre en place une infrastructure informatique d'entreprise virtualisée, intégrant les principaux services nécessaires à l'administration, au déploiement, au stockage, à la gestion des postes et à la supervision de l'environnement.

L'objectif est de reproduire, dans un environnement de laboratoire, une infrastructure structurée permettant de mettre en œuvre différents composants d'un système d'information et d'étudier leur fonctionnement de manière cohérente.

Le projet s'appuie sur un environnement de virtualisation permettant d'héberger plusieurs machines virtuelles représentant les différents composants de l'infrastructure.

## Périmètre du projet

L'environnement mis en place comprend plusieurs catégories de composants :

* un environnement de virtualisation permettant d'héberger les machines virtuelles ;
* des serveurs assurant les différents rôles et services de l'infrastructure ;
* un serveur de stockage destiné à la gestion des ressources partagées ;
* un environnement Linux dédié à la supervision et à la sécurité ;
* un poste client Windows utilisé pour les tests, le déploiement et la validation.

L'infrastructure intègre notamment des services liés à la gestion des identités, à la résolution de noms, à l'attribution de configuration réseau, au déploiement des systèmes, à la gestion centralisée des postes, au stockage et à la supervision de la sécurité.

## Environnement du projet

L'ensemble de l'infrastructure est déployé dans un environnement virtualisé. Cette approche permet de disposer de plusieurs systèmes indépendants tout en conservant une architecture représentative d'un environnement d'entreprise.

Les différentes machines virtuelles sont organisées selon leurs fonctions et communiquent à travers plusieurs réseaux virtuels adaptés aux besoins de l'environnement.

Cette organisation permet notamment de séparer les différents usages réseau et de reproduire certaines contraintes rencontrées dans une infrastructure réelle.

## Réalisation du projet

Le projet est réalisé de manière progressive, en partant de la conception de l'environnement jusqu'à son administration, son automatisation et sa validation.

La démarche comprend notamment :

1. la conception de l'architecture ;
2. la mise en place de l'environnement de virtualisation ;
3. le déploiement des serveurs et du poste client ;
4. l'installation et la configuration des services ;
5. l'administration centralisée de l'environnement ;
6. l'automatisation de certaines opérations ;
7. la mise en place de mécanismes de supervision et de sécurité ;
8. les tests et la validation du fonctionnement de l'ensemble.

## Organisation de la documentation

La documentation du projet suit la même logique que sa réalisation.

01 — Infrastructure présente les composants physiques et virtuels de l'environnement ainsi que leurs rôles.

02 — Administration présente ensuite la configuration et l'administration des différents services et composants.

03 — Deployment

Cette partie présente les mécanismes utilisés pour le déploiement des systèmes, des postes et des différentes configurations nécessaires à leur intégration dans l'environnement.

04 — Security & Monitoring

Cette partie présente les mécanismes et les composants mis en place pour assurer la sécurité de l'infrastructure et des systèmes, ainsi que les solutions utilisées pour la supervision et le suivi de l'environnement.

05 — Validation & Results

Cette partie présente les tests réalisés afin de vérifier le bon fonctionnement des services, des configurations, des mécanismes de sécurité et de l'infrastructure dans son ensemble, ainsi que les résultats obtenus.

Ressources complémentaires

Les dossiers screenshots/ et documentation/ regroupent respectivement les captures d'écran et les ressources documentaires complémentaires utilisées dans le cadre du projet.

L'ensemble de ces parties forme une documentation progressive, allant de la présentation générale du projet jusqu'à la mise en œuvre, l'administration, le déploiement, la sécurisation, la supervision et la validation de l'environnement.

## Synthèse

Ce projet constitue ainsi un environnement de laboratoire permettant de mettre en œuvre et d'étudier une infrastructure informatique d'entreprise composée de plusieurs systèmes, services et fonctions interdépendants.

L'approche retenue vise à conserver une organisation structurée, dans laquelle chaque composant possède un rôle défini tout en participant au fonctionnement global de l'infrastructure.
