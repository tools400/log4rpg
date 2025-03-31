# Appender_setLayout - Set layout for appender

Assigns a layout to a given appender and returns a value of type **BOOL**.

## Syntax

**Appender_setLayout**(***i_pAppender***, ***i_pLayout***)

The syntax of **Appender_setLayout**-procedure uses the following parameters:

| Parameter            | Description                                                        |
|:---------------------|:-------------------------------------------------------------------|
| ***i_pAppender***    | Required. Handle of the appender of type **LOG4RPG_pAppender _t**. |
| ***i_pLayout***      | Required. Handle of the layout of type **LOG4RPG_pLayout_t**.      |

## Return Value

| Name                 | Description                                               |
|:---------------------|-----------------------------------------------------------|
| ***isSet***          | Returns `*ON` on success, else `*OFF`.                    |

## Comments

none

## Module

LOG4RPG03

***
© 2000-2025, Thomas Raddatz
