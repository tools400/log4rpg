# Logger_getLogger - Get logger handle

Retrieves a handle for a named logger and returns a value of type **LOG4RPG_hLogger_t**.

## Syntax

**Logger_getLogger**(***i_logName***)

The syntax of **Logger_getLogger**-procedure uses the following parameters:

| Parameter            | Description                                                    |
|:---------------------|:---------------------------------------------------------------|
| ***i_logName***      | Required. Name of the logger of type **LOG4RPG_loggerName_t**. |

## Return Value

| Name                 | Description                                               |
|:---------------------|-----------------------------------------------------------|
| ***hLogger***        | Handle of the logger of type **LOG4RPG_hLogger_t**.       |

## Comments

Wenn der Logger, dessen handle ermittelt werden soll, nicht existiert, wird er angelegt und einem entsprechenden Eltern Logger zugewiesen.

## Module

LOG4RPG01

***
© 2000-2025, Thomas Raddatz
