# Logger_setInternalDebugging - Enable/disable internal log

Specifies the mode and output target of the internal log.

## Syntax

**Logger_setInternalDebugging**(***i_debugMode***, ***i_output***)

The syntax of **Logger_setInternalDebugging**-procedure uses the following parameters:

| Parameter            | Description                                                                                                                                             |
|:---------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------|
| ***i_debugMode***    | Required. Mode of the internal log of type **LOG4RPG_debugMode_t**.<br>cLOG4RPG_DEBUG_QUIET - no logging at all<br>cLOG4RPG_DEBUG_OFF - warnings and errors only<br>cLOG4RPG_DEBUG_ON - logs the program flow<br>cLOG4RPG_DEBUG_VERBOSE - logs each and everything |
| ***i_output***       | Required. Output target of the internal log of type **LOG4RPG_debugOutput_t**.<br>cLOG4RPG_OUTPUT_PRINTER - write log events to a printer file<br>cLOG4RPG_OUTPUT_STDOUT - write log events to STDOUT |

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
