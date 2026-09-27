# 03 — Client

## Introduction

Le poste client constitue la machine utilisée pour représenter un poste de travail au sein de l'infrastructure.

Il est principalement utilisé pour tester et valider les différents services mis en place sur les serveurs. Il intervient notamment dans les opérations de déploiement automatisé, l'intégration au domaine, l'application des stratégies de groupe, l'installation des applications et la supervision de la sécurité.

Le client permet ainsi de vérifier le fonctionnement de l'infrastructure depuis le point de vue d'un poste utilisateur.

---

# 01 — Présentation du client

## 1.1 Système d'exploitation

Le poste client fonctionne sous **Windows 11**.

Il constitue le système de référence utilisé pour tester les mécanismes de déploiement et d'administration des postes Windows dans l'environnement.

## 1.2 Caractéristiques de la machine virtuelle

Le poste client est hébergé sous VMware Workstation avec les ressources suivantes :

| Caractéristique        | Configuration      |
| ---------------------- | ------------------ |
| Système d'exploitation | Windows 11 x64     |
| Mémoire vive           | 4 GB               |
| Processeurs virtuels   | 2                  |
| Stockage               | 64 GB              |
| Nombre de disques      | 1                  |
| Réseau                 | Custom (VMnet1)    |
| Hyperviseur            | VMware Workstation |

Ces ressources permettent au poste de fonctionner comme une machine cliente représentative dans l'environnement de laboratoire.

---

# 02 — Configuration réseau

## 2.1 Type de réseau

Le poste client utilise un **réseau virtuel Custom (VMnet1)**.

Ce réseau permet au client de communiquer avec les différentes machines virtuelles participant à l'environnement de test.

La configuration réseau est également adaptée aux opérations de déploiement et aux communications avec les services d'infrastructure.

## 2.2 Utilisation du réseau

La connectivité réseau du client est nécessaire notamment pour :

* communiquer avec les services du domaine ;
* obtenir sa configuration réseau ;
* accéder aux ressources partagées ;
* participer aux opérations de déploiement ;
* communiquer avec les services de supervision ;
* recevoir les configurations appliquées par l'infrastructure.

---

# 03 — Rôle du client

Le poste client joue principalement un rôle de **machine de test, de déploiement et de validation**.

Il permet de reproduire les principales opérations qui seraient réalisées sur un poste de travail d'une entreprise.

Ses principales fonctions sont :

* participer au processus de déploiement Windows ;
* rejoindre le domaine ;
* recevoir les stratégies de groupe ;
* recevoir les applications prévues par l'infrastructure ;
* communiquer avec les différents services réseau ;
* être supervisé par la solution de sécurité ;
* permettre la validation du fonctionnement global de l'infrastructure.

Le client constitue donc le point de contrôle permettant de vérifier que les services configurés sur les serveurs fonctionnent correctement depuis un poste utilisateur.

---

# 04 — Déploiement du système

## 4.1 Déploiement avec WDS et MDT

Le poste client est utilisé dans le processus de déploiement automatisé mis en place avec **WDS** et **MDT**.

Le processus permet notamment de :

* démarrer le poste à travers le réseau ;
* charger l'environnement de déploiement ;
* installer Windows ;
* appliquer les paramètres définis pour le poste ;
* installer les applications nécessaires ;
* effectuer l'intégration au domaine ;
* appliquer les configurations prévues par l'infrastructure.

Le client permet ainsi de valider le fonctionnement de la chaîne de déploiement automatisée.

## 4.2 Applications

Les applications nécessaires au poste peuvent être installées automatiquement pendant le processus de déploiement.

Les composants prévus dans l'environnement comprennent notamment :

* **7-Zip** ;
* **Firefox ESR** ;
* **Wazuh Agent** ;
* les composants regroupés dans le socle logiciel de l'entreprise.

L'utilisation de MDT permet de standardiser l'installation de ces composants.

---

# 05 — Intégration au domaine

Après son déploiement, le poste client est intégré à l'environnement Active Directory.

Cette intégration permet notamment :

* l'authentification des utilisateurs avec les comptes du domaine ;
* la gestion centralisée du poste ;
* l'application des stratégies de groupe ;
* l'accès aux ressources du domaine ;
* l'administration du poste depuis l'infrastructure Windows.

Le client devient ainsi un ordinateur géré au sein du domaine de l'entreprise.

---

# 06 — Gestion par les stratégies de groupe

Une fois intégré au domaine, le poste client peut recevoir les **Group Policy Objects (GPO)** définies sur le serveur principal.

Les GPO permettent notamment d'appliquer automatiquement des paramètres concernant :

* la sécurité du système ;
* la configuration de Windows ;
* les restrictions utilisateur ;
* les paramètres d'administration ;
* les configurations propres à l'organisation.

Le poste client permet donc de vérifier que les stratégies définies dans Active Directory sont correctement appliquées.

---

# 07 — Supervision et sécurité

## 7.1 Wazuh Agent

Le poste client est également intégré à la plateforme de supervision **Wazuh**.

Pour cela, l'agent Wazuh est installé sur la machine.

L'agent permet de transmettre au serveur Wazuh les informations nécessaires à la supervision de la machine.

## 7.2 Fonctions de supervision

La supervision permet notamment de collecter et d'analyser :

* les événements du système ;
* certaines informations de sécurité ;
* les activités surveillées par Wazuh ;
* les alertes générées par les mécanismes de sécurité.

Les données collectées sont ensuite traitées par les composants Wazuh présents sur le serveur Ubuntu.

---

# 08 — Validation de l'infrastructure

Le poste client constitue également un élément essentiel pour les tests et la validation.

Il permet de vérifier successivement le fonctionnement des différents services :


                     INFRASTRUCTURE
                           │
                           ▼
                  ┌─────────────────┐
                  │      Client     │
                  │   Windows 11    │
                  └────────┬────────┘
                           │
             ┌─────────────┼─────────────┐
             │             │             │
             ▼             ▼             ▼
          Réseau         Domaine       Sécurité
             │             │             │
             ▼             ▼             ▼
           DHCP          AD DS         Wazuh
             │             │             │
             └─────────────┼─────────────┘
                           │
                           ▼
                     Déploiement
                       WDS / MDT
```

Le client permet notamment de valider :

* la connectivité réseau ;
* l'attribution de la configuration réseau ;
* l'intégration au domaine ;
* l'application des GPO ;
* le déploiement des applications ;
* le fonctionnement de l'agent Wazuh ;
* la communication avec les différents serveurs.

---

# 09 — Composants utilisés

| Composant            | Utilisation sur le client                            |
| -------------------- | ---------------------------------------------------- |
| **Windows 11 x64**   | Système d'exploitation du poste                      |
| **WDS**              | Démarrage réseau lors du déploiement                 |
| **MDT**              | Automatisation du déploiement et de la configuration |
| **Active Directory** | Intégration et gestion du poste dans le domaine      |
| **GPO**              | Application des configurations et politiques         |
| **7-Zip**            | Outil de compression/décompression                   |
| **Firefox ESR**      | Navigateur Web                                       |
| **Wazuh Agent**      | Supervision et collecte des événements de sécurité   |

---

# 10 — Synthèse

Le client Windows 11 représente le **poste de travail de référence** de l'environnement.

Il permet de mettre en œuvre et de vérifier l'ensemble de la chaîne d'administration :

**Déploiement → Intégration au domaine → Configuration → Applications → Supervision**

Son rôle ne se limite donc pas à celui d'un simple poste utilisateur. Il constitue également une machine de validation permettant de vérifier que les différents services de l'infrastructure fonctionnent correctement lorsqu'ils sont utilisés depuis un poste client.
