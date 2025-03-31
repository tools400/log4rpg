# Logger_isDebugEnabled - Checks, whether log level DEBUG is enabled

Checks, whether or not log level DEBUG has been enabled.

## Syntax

**Logger_isDebugEnabled**(***i_hLogger***)

The syntax of **Logger_isDebugEnabled**-procedure uses the following parameters:

| Parameter            | Description                                                   |
|:---------------------|:--------------------------------------------------------------|
| ***i_hLogger***      | Required. Handle of the logger of type **LOG4RPG_hLogger_t**. |

## Return Value

| Name                 | Description                                                      |
|:---------------------|------------------------------------------------------------------|
| ***isEnabled***      | Returns `*ON` if log level `DEBUG` is enabled, otherwise `*OFF`. |

## Comments

none

## Module

LOG4RPG01

***
© 2000-2025, Thomas Raddatz
