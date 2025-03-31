# Logger_setLogging - Enables-/disables Log4rpg

Siehe auch&nbsp; &nbsp; Example&nbsp; &nbsp; Info

Enables/disables Log4rpg completely and returns a value of type **BOOL**.

## Syntax

**Logger_setLogging**(***i_isEnabled***)

The syntax of **Logger_setLogging**-procedure uses the following parameters:

| Parameter            | Description                                                                                                                                             |
|:---------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------|
|                      |                                                                                                                                                         |
|                      |                                                                                                                                                         |
|                      |                                                                                                                                                         |

***i_isEnabled***&nbsp; &nbsp; Required. Specifies whether to enable or disable Log4rpg of type **BOOL**.

## Return Value

| Name                 | Description                                               |
|:---------------------|-----------------------------------------------------------|
|                      |                                                           |


***isEnabled***&nbsp; &nbsp; Current operating mode of Log4rpg of type **BOOL**.

## Comments

*Log4rpg* ignores all function calls excepted [**Logger_null**](Logger_null___Produce_NULL_Handle.md>) and [**Logger_isNull**](<Logger_null___Produce_NULL_Handle.md) if it is disabled.

## Module

LOG4RPG01

***
© 2000-2025, Thomas Raddatz
