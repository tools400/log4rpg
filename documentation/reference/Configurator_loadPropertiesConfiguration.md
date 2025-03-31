# Configurator_loadPropertiesConfiguration - Load property configuration

Loads the configuration data from a properties file and returns a value of type **BOOL**.

## Syntax

**Configurator_loadPropertiesConfiguration**(***i_URL***)

The syntax of **Configurator_loadPropertiesConfiguration**-procedure uses the following parameters:

| Parameter            | Description                                                                                                                                             |
|:---------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------|
| ***i_URL***          | Required. URL of the properties file of type **LOG4RPG_path_t**.                                                                                        |
|                      |                                                                                                                                                         |
|                      |                                                                                                                                                         |

## Return Value

| Name                 | Description                                               |
|:---------------------|-----------------------------------------------------------|
| ***isConfigured***   | Returns `*ON` on success, otherwise `*OFF`. |

## Comments

Valid URLs are:

- file: - URL of an IFS file.

- mbr: - URL of a file member.

Examples:

```text
file:log4rpg.properties

file:/home/qsysopr/log4rpg.properties

mbr:QLOG4RPG.PROPS1

mbr:*LIBL/QLOG4RPG.PROPS1

mbr:*SEARCH/QLOG4RPG.PROPS1
```

`*SEARCH` searches all libraries of the library list for the specified file and member.

## Module

LOG4RPG01

***
© 2000-2025, Thomas Raddatz
