# Logger_isWarnEnabled - Checks, whether log level WARN is enabled

Checks, whether or not log level WARN has been enabled.

## Syntax

**Logger_isWarnEnabled**(***i_hLogger***)

The syntax of **Logger_isWarnEnabled**-procedure uses the following parameters:

| Parameter            | Description                                                   |
|:---------------------|:--------------------------------------------------------------|
| ***i_hLogger***      | Required. Handle of the logger of type **LOG4RPG_hLogger_t**. |

## Return Value

| Name                 | Description                                                     |
|:---------------------|-----------------------------------------------------------------|
| ***isEnabled***      | Returns `*ON` if log level `WARN` is enabled, otherwise `*OFF`. |

## Comments

none

## Module

LOG4RPG01

***
© 2000-2025, Thomas Raddatz
