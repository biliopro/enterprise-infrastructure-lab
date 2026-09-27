 03 — Objectifs

 Introduction

Le projet a été conçu principalement dans le but de comprendre la logique mise en œuvre lors du déploiement automatisé d'un système Windows.

Au-delà de la simple installation d'un système d'exploitation, l'objectif est d'étudier la manière dont un environnement de déploiement peut identifier un poste, récupérer des informations le concernant, prendre des décisions à partir de ces informations et appliquer une installation ainsi qu'une configuration adaptées à ses caractéristiques.

Les différents services et composants intégrés à l'infrastructure permettent ainsi de construire un environnement suffisamment représentatif pour observer et expérimenter cette logique de déploiement.



 1. Objectif principal

L'objectif principal du projet est de **comprendre le fonctionnement et la logique d'un processus de déploiement automatisé de Windows**.

Il ne s'agit donc pas uniquement de parvenir à installer Windows sur un poste sans intervention humaine. L'objectif est de comprendre les mécanismes qui permettent de transformer un processus d'installation générique en un processus capable d'adapter le déploiement au poste cible.

Cette approche permet notamment d'étudier comment un même environnement de déploiement peut être utilisé pour plusieurs postes tout en permettant à chacun d'eux de recevoir une configuration différente selon les informations qui lui sont associées.



 2. Comprendre la chaîne de déploiement

Le projet vise à comprendre les différentes étapes qui interviennent entre le démarrage d'un poste et l'obtention d'un système Windows configuré.

L'étude porte notamment sur la logique suivante :


Démarrage du poste
        ↓
Boot réseau PXE
        ↓
Chargement de l'environnement de démarrage
        ↓
Initialisation de l'environnement de déploiement
        ↓
Collecte des informations du poste
        ↓
Détermination des paramètres applicables
        ↓
Sélection des éléments du déploiement
        ↓
Installation de Windows
        ↓
Configuration du poste
        ↓
Intégration dans l'environnement


Cette chaîne permet de comprendre que le déploiement ne correspond pas uniquement au transfert d'une image Windows vers un poste.

Il constitue un processus composé de plusieurs étapes au cours desquelles différentes informations sont collectées, interprétées et utilisées afin de déterminer la manière dont le poste doit être installé et configuré.



 3. Comprendre le déploiement adapté au poste cible

Un objectif essentiel du projet est de comprendre comment un environnement de déploiement peut produire des configurations différentes à partir d'une même infrastructure de déploiement.

Dans un scénario simple, plusieurs postes pourraient recevoir exactement la même image et la même configuration.

Le projet cherche au contraire à étudier une logique dans laquelle le processus de déploiement peut tenir compte des caractéristiques du poste cible.

Par exemple, un poste associé au département **RH** peut recevoir une configuration et des applications différentes d'un poste associé au département **IT** ou **Comptabilité**.

La logique recherchée peut ainsi être représentée de manière générale :


                Poste cible
                     │
                     ↓
             Identification
                     │
                     ↓
          Récupération des données
                     │
                     ↓
       Détermination du contexte
                     │
          ┌──────────┴──────────┐
          ↓                     ↓
    Département RH        Département IT
          │                     │
          ↓                     ↓
 Configuration RH       Configuration IT


L'objectif est donc de comprendre **comment une infrastructure de déploiement peut prendre des décisions en fonction du contexte du poste**, plutôt que de simplement reproduire une installation identique sur toutes les machines.



 4. Comprendre le rôle des variables et des règles

Le projet vise également à comprendre comment les paramètres du déploiement sont transportés et exploités tout au long du processus.

L'utilisation de fichiers de configuration et de variables permet d'étudier la manière dont le comportement du déploiement peut être contrôlé sans modifier directement les éléments fondamentaux de l'installation.

Dans le cadre du projet, cette logique est notamment étudiée à travers les mécanismes de configuration de MDT, les variables utilisées par l'environnement de déploiement et les règles permettant de déterminer les paramètres applicables au poste.

L'objectif est de comprendre comment ces différents éléments peuvent être combinés afin de produire un processus de déploiement automatisé et contextualisé.



 5. Comprendre l'automatisation du déploiement

Un autre objectif du projet est de comprendre comment réduire progressivement les interventions nécessaires lors du déploiement d'un poste.

L'étude porte notamment sur la possibilité d'automatiser :

* la sélection des paramètres de déploiement ;
* l'identification du poste ;
* l'application des règles correspondantes ;
* la sélection des configurations ;
* l'installation des applications ;
* l'intégration du poste dans l'environnement ;
* certaines opérations de configuration post-installation.

L'objectif est ainsi de comprendre comment passer d'un déploiement nécessitant de nombreuses décisions manuelles à un processus pouvant être exécuté de manière largement automatisée.

La suppression ou la réduction des interventions du wizard constitue donc un moyen d'étudier concrètement le niveau d'automatisation qu'il est possible d'atteindre.



 6. Comprendre le rôle de la base de données dans le déploiement

Le projet vise également à comprendre comment une base de données peut participer à la logique d'un déploiement automatisé.

L'association entre les informations relatives aux postes et les paramètres de déploiement permet d'étudier un modèle dans lequel le système peut déterminer automatiquement les caractéristiques et les configurations à appliquer à un poste donné.

La base de données ne constitue donc pas uniquement un espace de stockage d'informations. Dans le cadre du projet, elle participe à la logique permettant d'associer un poste à son contexte de déploiement et, par conséquent, aux paramètres qui doivent lui être appliqués.



 7. Comprendre la collecte des informations pendant le déploiement

Le projet cherche également à comprendre comment l'environnement de déploiement récupère et exploite les informations nécessaires à son fonctionnement.

Les mécanismes de collecte utilisés par MDT permettent notamment d'étudier comment les variables et les informations disponibles dans l'environnement sont récupérées au cours du processus.

Cette étape permet de mieux comprendre le rôle des différents composants intervenant entre l'environnement de démarrage et l'application effective des paramètres de configuration.



 8. Objectifs secondaires

Bien que la compréhension du déploiement Windows constitue l'objectif central du projet, la mise en œuvre de cet environnement nécessite également l'intégration de plusieurs fonctions complémentaires.

Ces fonctions permettent notamment de construire un environnement cohérent dans lequel le déploiement peut être testé dans des conditions proches d'un contexte d'entreprise.

Les objectifs secondaires concernent notamment :

* la mise en place d'un environnement d'administration centralisé ;
* la gestion des utilisateurs et des postes ;
* l'application de configurations centralisées ;
* la gestion des ressources partagées ;
* l'intégration de mécanismes de sécurité et de supervision ;
* l'automatisation de certaines opérations d'administration ;
* la validation du fonctionnement global de l'infrastructure.

Ces éléments ne constituent toutefois pas la finalité principale du projet. Ils servent principalement à fournir le contexte nécessaire à l'expérimentation et à la validation du processus de déploiement.



 9. Portée de l'étude

Le choix de WDS et MDT permet d'étudier concrètement plusieurs concepts fondamentaux du déploiement Windows, notamment le démarrage réseau par PXE, l'environnement de préinstallation, la collecte d'informations, l'utilisation de variables, les règles de configuration, l'automatisation et l'adaptation du déploiement au poste cible.

D'autres solutions de déploiement et de gestion des postes existent et peuvent proposer des fonctionnalités plus larges ou répondre à des besoins différents.

Cependant, le choix effectué dans le cadre de ce projet répond avant tout à un objectif d'apprentissage et de compréhension des mécanismes fondamentaux du déploiement Windows.

L'intérêt de l'environnement mis en place est donc de permettre d'observer et d'expérimenter ces mécanismes de manière concrète, depuis le démarrage réseau jusqu'à la configuration finale du poste.



 Conclusion

L'objectif principal de ce projet est ainsi de comprendre que le déploiement Windows ne se limite pas à la diffusion d'une image identique sur plusieurs postes.

Il s'agit d'un processus composé de plusieurs mécanismes permettant d'identifier le poste cible, de récupérer et d'interpréter des informations, de déterminer les paramètres applicables et d'automatiser leur mise en œuvre.

La réalisation de cette infrastructure permet ainsi d'étudier concrètement cette logique à travers un environnement intégrant le démarrage PXE, les mécanismes de déploiement, les variables, les règles, la base de données et les processus de collecte d'informations.

Les autres composants de l'infrastructure viennent compléter cet environnement afin de permettre de tester le déploiement dans un contexte cohérent d'administration et de gestion des postes.
