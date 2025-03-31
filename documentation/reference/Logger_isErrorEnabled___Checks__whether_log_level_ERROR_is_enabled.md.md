# Logger_isErrorEnabled - Checks, whether log level ERROR is enabled

Checks, whether or not log level ERROR has been enabled.

## Syntax

**Logger_isErrorEnabled**(***i_hLogger***)

The syntax of **Logger_isErrorEnabled**-procedure uses the following parameters:

| Parameter            | Description                                                   |
|:---------------------|:--------------------------------------------------------------|
| ***i_hLogger***      | Required. Handle of the logger of type **LOG4RPG_hLogger_t**. |

## Return Value

| Name                 | Description                                                      |
|:---------------------|------------------------------------------------------------------|
| ***isEnabled***      | Returns `*ON` if log level `ERROR` is enabled, otherwise `*OFF`. |

## Comments

none

## Module

LOG4RPG01

***
© 2000-2025, Thomas Raddatz
