# 01 — Hyperviseur

## Introduction

La virtualisation constitue la base de l'infrastructure mise en place dans le cadre de ce projet. Elle permet de reproduire une infrastructure d'entreprise complète sur une seule machine physique en exécutant plusieurs systèmes d'exploitation et serveurs sous forme de machines virtuelles.

Pour mettre en place cet environnement, la solution de virtualisation retenue est **VMware Workstation Pro 26H1**, version **26.0.0.25388281**.

Cette solution est utilisée pour créer, configurer, connecter et administrer les différentes machines virtuelles constituant l'infrastructure du projet.

## 1. Présentation de VMware Workstation Pro

VMware Workstation Pro est un hyperviseur de type 2 destiné aux environnements Windows et Linux. Il permet d'exécuter plusieurs machines virtuelles simultanément sur une machine physique hôte.

Chaque machine virtuelle dispose de ses propres ressources virtuelles et peut exécuter un système d'exploitation indépendamment des autres machines.

Dans le cadre de ce projet, VMware Workstation Pro constitue la couche de virtualisation sur laquelle sont hébergés :

* les serveurs Windows de l'infrastructure ;
* le serveur Ubuntu utilisé pour Wazuh ;
* le poste client Windows ;
* les différents composants nécessaires à la réalisation et aux tests de l'environnement.

L'utilisation d'un hyperviseur de bureau permet ainsi de construire un environnement d'entreprise isolé et reproductible sans nécessiter plusieurs machines physiques.

## 2. Version utilisée

La solution utilisée dans le projet est :

| Élément                    | Information                                    |
| -------------------------- | ---------------------------------------------- |
| Produit                    | VMware® Workstation Pro                        |
| Version                    | 26H1                                           |
| Version logicielle         | 26.0.0.25388281                                |
| Type                       | Hyperviseur de bureau                          |
| Système hôte               | Windows                                        |
| Utilisation dans le projet | Hébergement et gestion des machines virtuelles |

VMware Workstation Pro 26H1 est une version officiellement prise en charge par Broadcom, notamment sur les systèmes hôtes Windows et Linux compatibles.

## 3. Création d'une machine virtuelle

L'une des fonctionnalités principales utilisées dans le projet est **Create a New Virtual Machine**.

Cette fonctionnalité permet de créer une nouvelle machine virtuelle et de définir les caractéristiques matérielles qui lui seront attribuées.

Lors de la création d'une machine virtuelle, VMware Workstation permet notamment de définir :

* le système d'exploitation invité ;
* le nombre de processeurs virtuels ;
* le nombre de cœurs attribués ;
* la quantité de mémoire vive ;
* les interfaces réseau virtuelles ;
* les contrôleurs et périphériques de stockage ;
* les disques virtuels ;
* les lecteurs CD/DVD virtuels ;
* certains paramètres liés au firmware de la machine virtuelle.

Cette étape permet donc d'adapter les ressources attribuées à chaque machine en fonction de son rôle dans l'infrastructure.

Par exemple, un serveur destiné à assurer plusieurs services d'infrastructure peut recevoir davantage de mémoire et de ressources processeur qu'un poste client utilisé principalement pour les tests.

## 4. Gestion des ressources virtuelles

Une machine virtuelle fonctionne avec des ressources matérielles virtuelles fournies par la machine physique.

### 4.1 Processeur

VMware Workstation permet de définir le nombre de processeurs virtuels et de cœurs virtuels attribués à une machine.

Ces ressources sont présentées au système d'exploitation invité comme des processeurs disponibles pour son fonctionnement.

Cette configuration permet d'adapter les performances de chaque machine virtuelle aux besoins du service qu'elle héberge.

### 4.2 Mémoire vive

La mémoire RAM de la machine physique peut être répartie entre les différentes machines virtuelles.

La quantité de mémoire attribuée à chaque VM doit être adaptée au système d'exploitation et aux services exécutés.

Dans le cadre du projet, cette configuration permet notamment de réserver suffisamment de ressources aux serveurs exécutant plusieurs rôles et services simultanément.

### 4.3 Stockage virtuel

VMware Workstation utilise des disques virtuels stockés sous forme de fichiers sur le système de fichiers de la machine hôte.

Un disque virtuel constitue le stockage principal d'une machine virtuelle et contient notamment son système d'exploitation, ses applications et ses données.

Workstation permet de créer et de configurer les disques virtuels lors de la création de la machine ou ultérieurement à partir des paramètres matériels de la VM.

Cette approche facilite également le déplacement, la copie et la sauvegarde des environnements virtuels, puisque les composants d'une machine virtuelle sont regroupés sous forme de fichiers.

### 4.4 CD/DVD virtuel

Une machine virtuelle peut disposer d'un lecteur CD/DVD virtuel permettant notamment de connecter une image ISO.

Cette fonctionnalité est utilisée lors de l'installation des systèmes d'exploitation et permet de monter directement les supports d'installation nécessaires aux différentes machines virtuelles.

## 5. Configuration matérielle d'une machine virtuelle

Après sa création, VMware Workstation permet de modifier la configuration matérielle de la machine virtuelle à partir de ses paramètres.

La section **Virtual Machine Settings** permet notamment de gérer :

* la mémoire ;
* les processeurs ;
* les disques durs virtuels ;
* les lecteurs CD/DVD ;
* les cartes réseau ;
* les contrôleurs ;
* les périphériques USB ;
* certains paramètres du firmware ;
* différents périphériques virtuels.

Cette possibilité est particulièrement importante dans le projet car les besoins d'une machine peuvent évoluer au fur et à mesure de la mise en place de l'infrastructure.

## 6. Réseau virtuel VMware

La virtualisation du réseau constitue un élément essentiel du projet.

Chaque machine virtuelle peut disposer d'une ou plusieurs interfaces réseau virtuelles. Ces interfaces permettent de connecter les machines entre elles, au réseau physique ou à des réseaux virtuels isolés.

VMware Workstation fournit plusieurs modes de connexion réseau permettant d'adapter le comportement de chaque interface virtuelle.

Les principaux modes utilisés et étudiés dans le cadre du projet sont :

* Bridged ;
* NAT ;
* Host-only.

## 7. Mode Bridged

Le mode **Bridged** permet de connecter directement l'interface réseau virtuelle au réseau physique auquel est connecté l'hôte.

La machine virtuelle apparaît alors sur le réseau comme une machine distincte et peut obtenir sa propre adresse IP.

Ce mode est utile lorsque la machine virtuelle doit communiquer directement avec le réseau physique ou accéder aux ressources présentes sur celui-ci.

Dans le projet, ce type de connexion peut notamment être utilisé lorsqu'un serveur virtuel doit être accessible depuis le réseau physique de la machine hôte.

## 8. Mode NAT

Le mode **NAT (Network Address Translation)** permet aux machines virtuelles d'accéder à un réseau externe en utilisant la connexion réseau de la machine hôte.

La machine virtuelle se trouve derrière le mécanisme NAT fourni par VMware.

Ce fonctionnement permet notamment à une VM d'accéder à Internet sans nécessairement être directement exposée au réseau physique.

Le mode NAT est donc particulièrement adapté lorsqu'une machine virtuelle doit disposer d'un accès externe tout en restant intégrée à un réseau virtuel géré par VMware.

## 9. Mode Host-only

Le mode **Host-only** permet de créer un réseau virtuel isolé entre la machine hôte et les machines virtuelles connectées à ce réseau.

Les machines connectées au même réseau Host-only peuvent communiquer entre elles sans être directement exposées au réseau physique.

Ce mode est particulièrement intéressant dans un environnement de laboratoire car il permet de créer un réseau interne dédié aux machines virtuelles.

Dans le cadre du projet, ce principe permet notamment de construire un réseau interne dans lequel les serveurs et les clients peuvent communiquer pour les besoins de l'infrastructure, du déploiement et des tests.

## 10. Virtual Network Editor

La fonctionnalité **Virtual Network Editor** permet de gérer les réseaux virtuels créés par VMware Workstation.

Elle permet notamment de configurer les réseaux virtuels et de définir leur comportement.

Cette fonctionnalité est particulièrement importante pour ce projet car l'infrastructure nécessite plusieurs types de communications :

* communication entre les machines virtuelles ;
* communication entre les machines virtuelles et l'hôte ;
* communication avec le réseau physique ;
* accès externe lorsque nécessaire ;
* séparation de certains flux dans des réseaux virtuels dédiés.

Le Virtual Network Editor permet ainsi d'adapter les réseaux VMware aux besoins de l'architecture du laboratoire.

## 11. Interfaces réseau virtuelles

Une machine virtuelle peut disposer de plusieurs cartes réseau virtuelles.

Chaque interface peut être connectée à un réseau VMware différent.

Cette possibilité est particulièrement utile pour les serveurs ayant plusieurs fonctions réseau.

Par exemple, une machine virtuelle peut disposer :

* d'une interface connectée à un réseau externe ;
* d'une seconde interface connectée à un réseau interne isolé.

Cette séparation permet de reproduire plus fidèlement une architecture réseau d'entreprise et de contrôler les communications entre les différents composants de l'infrastructure.

## 12. Gestion des snapshots

VMware Workstation Pro permet également de créer des **snapshots** d'une machine virtuelle.

Un snapshot capture l'état d'une machine virtuelle à un moment donné et permet de revenir à cet état ultérieurement.

Dans un environnement de laboratoire, cette fonctionnalité peut être utilisée avant une modification importante de configuration, une installation ou un test susceptible de modifier l'état du système.

Elle facilite ainsi les opérations de test et de restauration pendant les différentes phases du projet.

Il convient cependant de gérer les snapshots avec précaution, notamment parce qu'ils peuvent consommer de l'espace disque et nécessiter des opérations de consolidation.

## 13. Clonage des machines virtuelles

Workstation Pro permet également de créer des clones de machines virtuelles.

Le clonage permet de reproduire une machine virtuelle existante afin de créer rapidement un nouvel environnement à partir d'une configuration déjà préparée.

Cette fonctionnalité peut être utile dans un laboratoire lorsque plusieurs machines doivent partager une configuration de base similaire.

Elle permet notamment de réduire le temps nécessaire à la préparation de nouvelles machines virtuelles.

## 14. Gestion et administration des machines virtuelles

VMware Workstation Pro fournit une interface permettant de gérer plusieurs machines virtuelles depuis un même environnement.

L'administrateur peut notamment :

* démarrer ou arrêter une VM ;
* suspendre une VM ;
* redémarrer une VM ;
* modifier ses ressources ;
* modifier sa configuration réseau ;
* connecter ou déconnecter des périphériques virtuels ;
* gérer ses snapshots ;
* créer des clones ;
* accéder à la console du système invité.

Cette gestion centralisée facilite l'administration de l'ensemble de l'environnement de laboratoire.

## 15. Fonctionnalités exploitées dans le projet

Parmi les nombreuses fonctionnalités proposées par VMware Workstation Pro, celles qui sont particulièrement importantes pour ce projet sont :

| Fonctionnalité               | Utilisation dans le projet                         |
| ---------------------------- | -------------------------------------------------- |
| Create a New Virtual Machine | Création des serveurs et du client                 |
| Virtual Machine Settings     | Configuration des ressources de chaque VM          |
| CPU virtuel                  | Attribution des ressources processeur              |
| RAM virtuelle                | Allocation de mémoire aux VM                       |
| Disques virtuels             | Installation des systèmes et stockage des données  |
| Lecteur CD/DVD virtuel       | Installation depuis des images ISO                 |
| Network Adapter              | Configuration des interfaces réseau virtuelles     |
| Virtual Network Editor       | Création et configuration des réseaux virtuels     |
| Bridged                      | Connexion au réseau physique lorsque nécessaire    |
| NAT                          | Accès externe via le réseau de l'hôte              |
| Host-only                    | Création de réseaux internes isolés                |
| Snapshots                    | Retour à un état précédent lors des phases de test |
| Clones                       | Reproduction rapide d'environnements virtuels      |
| Console VM                   | Administration des systèmes invités                |

## 16. Choix de VMware Workstation Pro

Le choix de VMware Workstation Pro est lié aux besoins du projet.

L'objectif est de construire une infrastructure composée de plusieurs serveurs et postes clients nécessitant des ressources différentes, plusieurs interfaces réseau et plusieurs réseaux virtuels.

Workstation Pro fournit directement les fonctionnalités nécessaires à cette mise en œuvre : création des machines virtuelles, allocation des ressources, gestion des disques virtuels, configuration des interfaces réseau, gestion des réseaux virtuels, snapshots et clonage. Broadcom décrit également Workstation Pro comme une solution destinée notamment aux professionnels de l'informatique et aux développeurs, avec des fonctions de mise en réseau virtuel, de clonage et de gestion de plusieurs machines virtuelles.

### Comparaison avec VirtualBox

Une autre solution possible pour réaliser ce laboratoire aurait été **Oracle VirtualBox**.

Le choix entre les deux solutions dépend notamment des fonctionnalités recherchées, de l'environnement de travail et des habitudes d'administration.

Dans ce projet, VMware Workstation Pro a été retenu principalement pour disposer d'un environnement de virtualisation permettant de gérer facilement plusieurs machines virtuelles, leurs ressources matérielles et surtout leurs différentes interfaces et configurations réseau depuis une même plateforme.

Le choix est donc lié aux besoins techniques du laboratoire plutôt qu'à l'utilisation d'un hyperviseur comme solution universelle supérieure à une autre.

## 17. Rôle de VMware Workstation dans l'architecture

VMware Workstation constitue la couche de virtualisation située sous les différents composants de l'infrastructure.

Son rôle peut être représenté de manière simplifiée comme suit :

```text
                    MACHINE PHYSIQUE
                           │
                           │
                 VMware Workstation Pro
                           │
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
   Primary Server    Storage Server    Ubuntu Wazuh
   Windows Server    Windows Server      Ubuntu
          │                │                │
          └────────────────┼────────────────┘
                           │
                           ▼
                    Client Windows
```

Les machines virtuelles constituent ensuite les différents composants de l'infrastructure et communiquent entre elles à travers les réseaux virtuels configurés dans VMware Workstation.

## Conclusion

VMware Workstation Pro 26H1 constitue la plateforme de virtualisation utilisée pour construire l'environnement du projet.

La solution permet de disposer sur une même machine physique de plusieurs systèmes indépendants, tout en contrôlant leurs ressources matérielles, leurs périphériques virtuels, leurs interfaces réseau et leurs connexions aux différents réseaux.

Les fonctionnalités de création de machines virtuelles, de configuration des ressources, de gestion des disques, de configuration réseau avec le Virtual Network Editor, ainsi que les mécanismes de snapshots et de clonage constituent les principaux éléments exploités pour construire et maintenir l'environnement de laboratoire.
