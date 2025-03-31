# Filter_setNext - Set follow-up filter for filter

Assigns a follow-up filter to a given filter and returns a value of type **BOOL**.

## Syntax

**Filter_setNext**(***i_pFilter***, ***i_pNextFilter***)

The syntax of **Filter_setNext**-procedure uses the following parameters:

| Parameter            | Description                                                   |
|:---------------------|:--------------------------------------------------------------|
| ***i_pFilter***      | Required. Handle of the filter of type **LOG4RPG_pFilter_t**. |
| ***i_pNextFilter***  | Required. Handle of the filter of type **LOG4RPG_pFilter_t**. |

## Return Value

| Name                 | Description                                               |
|:---------------------|-----------------------------------------------------------|
| ***isSet***          | Returns `*ON` on success, else `*OFF`.                    |

## Comments

You can use this procedure to create a chain of filters. The filter are called one after another before the appender appends the log event to the target.

## Module

LOG4RPG17

***
© 2000-2025, Thomas Raddatz
