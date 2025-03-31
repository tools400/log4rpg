# Layout_new - Create layout

Produces a new layout and returns a value of type **LOG4RPG_pLayout_t** zurück.

## Syntax

**Layout_new**(***i_layoutImpl***, {­***i_pPropString***)

The syntax of **Layout_new**-procedure uses the following parameters:

| Parameter            | Description                                                                                                                                  |
|:---------------------|:---------------------------------------------------------------------------------------------------------------------------------------------|
| ***i_layoutImpl***   | Required. Qualified name of the class that implements the layout of type **LOG4RPG_implClass_t**.<br>Example: `*LIBL/LOG4HTMLAY(HTMLLayout)` |
| ***i_pPropString***  | Optional or omissible. Semicolon separated liest of configuration properties of type **STRING**.                                             |

## Return Value

| Name                 | Description                                               |
|:---------------------|-----------------------------------------------------------|
| ***pLayout***        | Handle of the layout of type **LOG4RPG_pLayout_t**.       |

## Comments

none

## Module

LOG4RPG11

***
© 2000-2025, Thomas Raddatz
