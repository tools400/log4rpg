# Filter_new - Create filter

Produces a new filter and returns a value of type **LOG4RPG_pFilter_t**.

## Syntax

**Filter_new**(***i_fltName***, ***i_fltImpl***, {­***i_pPropString***)

The syntax of **Filter_new**-procedure uses the following parameters:

| Parameter            | Description                                                                                                                                      |
|:---------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------|
| ***i_fltName***      | Required. Name of the appender of type **LOG4RPG_filterName_t**.                                                                                 |
| ***i_fltImpl***      | Required. Qualified name of the class that implements the filter of type **LOG4RPG_implClass_t**.<br>Example: `*LIBL/LOG4PROFLT(PropertyFilter)` |
| ***i_pPropString***  | Optional or omissible. Semicolon separated liest of configuration properties of type **STRING**.                                                 |

## Return Value

| Name                 | Description                                               |
|:---------------------|-----------------------------------------------------------|
| ***pFilter***        | Handle of the filter of type **LOG4RPG_pFilter_t**.       |

## Comments

none

## Module

LOG4RPG17

***
© 2000-2025, Thomas Raddatz
