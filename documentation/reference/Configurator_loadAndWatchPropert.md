# Configurator_loadAndWatchPropertiesConfiguration - Load property configuration

Loads the configuration data from a properties file and returns a value of type **BOOL**. Watches the configuration file for changes and reloads configuration on changges.

## Syntax

**Configurator_loadAndWatchPropertiesConfiguration**(***i_URL***, {­***i_waitTime***, {­***i_unit***)

The syntax of **Configurator_loadAndWatchPropertiesConfiguration**-procedure uses the following parameters:

| Parameter            | Description                                                                                                                                             |
|:---------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------|
| ***i_URL***          | Required. URL of the properties file of type **LOG4RPG_path_t**.                                                                                        |
| ***i_waitTime***     | Optional. Time to wait until to check the configuration file for changes of type **INTEGER**.<br>Default: **cLOG4RPG_CONFIGURATION_DEFAULT_RELOAD_DELAY** (1 minute) |
| ***i_unit***         | Optional. [Unit](popup_time_unit.md) of ***i_waitTime*** of type **STRING**.<br>Default: **cLOG4RPG_CONFIGURATION_DEFAULT_RELOAD_DELAY_UNIT** (*MINUTE) |

## Return Value

| Name                 | Description                                 |
|:---------------------|---------------------------------------------|
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
