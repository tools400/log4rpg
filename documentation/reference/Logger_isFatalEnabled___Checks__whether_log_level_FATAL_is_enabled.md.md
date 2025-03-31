# Logger_isFatalEnabled - Checks, whether log level FATAL is enabled

Checks, whether or not log level FATAL has been enabled.

## Syntax

**Logger_isFatalEnabled**(***i_hLogger***)

The syntax of **Logger_isFatalEnabled**-procedure uses the following parameters:

| Parameter            | Description                                                   |
|:---------------------|:--------------------------------------------------------------|
| ***i_hLogger***      | Required. Handle of the logger of type **LOG4RPG_hLogger_t**. |

## Return Value

| Name                 | Description                                                      |
|:---------------------|------------------------------------------------------------------|
| ***isEnabled***      | Returns `*ON` if log level `FATAL` is enabled, otherwise `*OFF`. |

## Comments

non

## Module

LOG4RPG01

***
© 2000-2025, Thomas Raddatz
