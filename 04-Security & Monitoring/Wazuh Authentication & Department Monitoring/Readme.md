# Wazuh Authentication & Department Monitoring

## Introduction

Une fois la plateforme Wazuh mise en place, une organisation des agents a été définie afin de les administrer selon leur département.

L’objectif est de permettre à chaque poste d’être identifié par Wazuh, authentifié auprès du Manager et associé au groupe correspondant à son environnement de travail.

```text
Poste
  ↓
Enrôlement
  ↓
Authentification
  ↓
Groupe départemental
  ↓
Configuration de supervision
```

## 1. Organisation des agents par département

Wazuh permet de regrouper les agents afin de leur appliquer une configuration centralisée propre à chaque groupe. Un agent peut appartenir à plusieurs groupes, avec une priorité définie entre ceux-ci. 
Dans le projet, les groupes correspondent à l’organisation de l’entreprise :

```text
RH
IT
Comptabilite
```

Les groupes sont créés avec l’outil `agent_groups` :

```bash
/var/ossec/bin/agent_groups -a -g RH -q
/var/ossec/bin/agent_groups -a -g IT -q
/var/ossec/bin/agent_groups -a -g Comptabilite -q
```

La liste des groupes peut être vérifiée avec :

```bash
/var/ossec/bin/agent_groups -l
```

Un agent peut ensuite être affecté à un groupe avec :

```bash
/var/ossec/bin/agent_groups -a -i 002 -g IT
```

et son appartenance peut être vérifiée avec :

```bash
/var/ossec/bin/agent_groups -s -i 002
```

Ces mécanismes permettent de conserver une correspondance entre les postes de l’entreprise et leur groupe Wazuh. 

## 2. Enrôlement et authentification des agents

L’enrôlement permet d’enregistrer un nouvel agent auprès du Wazuh Manager.

Le programme `agent-auth` est utilisé pour demander au Manager une clé d’authentification. Le groupe et le nom de l’agent peuvent être transmis directement lors de cette opération avec les paramètres prévus par l’outil.

Dans le projet, le principe est :

```text
Agent Windows
     │
     │ agent-auth
     ▼
Wazuh Manager
     │
     ├── identité de l'agent
     ├── clé d'authentification
     └── groupe
```

La clé reçue est ensuite enregistrée dans le fichier `client.keys` de l’agent. Elle permet à celui-ci d’établir sa communication authentifiée avec le Manager. 

Dans l’environnement réalisé, le poste `PC-IT-001` a obtenu l’identifiant :

```text
002 PC-IT-001
```

et a été associé au groupe :

```text
IT
```

## 3. Attribution automatique du groupe

L’affectation au groupe est intégrée au processus de déploiement.

Les informations déjà déterminées pour le poste permettent au mécanisme d’enrôlement de transmettre le groupe correspondant au Manager.

Le principe est donc :

```text
Département du poste
        ↓
WazuhGroup
        ↓
Enrôlement
        ↓
Groupe Wazuh
```

Ainsi, deux postes appartenant à des départements différents peuvent être enregistrés dans des groupes distincts sans nécessiter une gestion manuelle individuelle.

## 4. Configuration de supervision par groupe

Chaque groupe possède un répertoire partagé pouvant contenir son fichier `agent.conf` :

```text
/var/ossec/etc/shared/RH/agent.conf
/var/ossec/etc/shared/IT/agent.conf
/var/ossec/etc/shared/Comptabilite/agent.conf
```

Le Manager transmet ensuite la configuration du groupe aux agents qui lui sont associés. 

Cette configuration centralisée peut notamment définir les éléments à superviser :

```text
File Integrity Monitoring
Collecte de journaux
SCA
Syscollector
Rootcheck
```

Les paramètres réellement appliqués dépendent du contenu de chaque `agent.conf`. 

L’organisation devient alors :

```text
Groupe RH
   ↓
Configuration RH
   ↓
Agents RH

Groupe IT
   ↓
Configuration IT
   ↓
Agents IT
```

Cette approche évite de reproduire la même configuration individuellement sur chaque poste.

## 5. Vérification de l’état des agents

L’état d’un agent peut être vérifié depuis le Manager avec :

```bash
/var/ossec/bin/agent_control -l
```

Pour un agent particulier :

```bash
/var/ossec/bin/agent_control -i 002
```

Enfin, la synchronisation de la configuration centralisée peut être contrôlée avec :

```bash
/var/ossec/bin/agent_groups -S -i 002
```

Wazuh fournit ces outils pour vérifier respectivement l’état de l’agent, ses groupes et la synchronisation de sa configuration.

## Conclusion

L’organisation retenue repose sur une séparation claire entre **identification**, **authentification** et **supervision** :

```text
Identification
      ↓
Enrôlement
      ↓
Clé d'authentification
      ↓
Groupe départemental
      ↓
Configuration centralisée
      ↓
Monitoring
```

Le regroupement des agents par département permet ainsi d’adapter la supervision à l’organisation de l’entreprise tout en conservant une administration centralisée dans Wazuh.
