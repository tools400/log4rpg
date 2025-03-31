# Logger_forcedLog - Log statement

Appends a statement to the log regardless of the log level.

## Syntax

**Logger_forcedLog**(***i_hLogger***, ***i_level***, ***i_text***)

The syntax of **Logger_forcedLog**-procedure uses the following parameters:

| Parameter            | Description                                                                       |
|:---------------------|:----------------------------------------------------------------------------------|
| ***i_hLogger***      | Required. Handle of the logger of type **LOG4RPG_hLogger_t**.                     |
| ***i_level***        | Required. **Log-Level**, associated to the Log Event of type **LOG4RPG_level_t**. |
| ***i_text***         | Required. Statement to log of type **LOG4RPG_text_t**.                            |

## Return Value

| Name                 | Description                                               |
|:---------------------|-----------------------------------------------------------|
| none                 |                                                           |

## Comments

none

## Module

LOG4RPG01

***
© 2000-2025, Thomas Raddatz
