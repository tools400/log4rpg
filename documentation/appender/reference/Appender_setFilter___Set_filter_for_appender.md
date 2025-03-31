# Appender_setFilter - Set filter for appender

Assigns a filter to a given appender and returns a value of type **BOOL**.

## Syntax

**Appender_setFilter**(***i_pAppender***, ***i_pFilter***)

The syntax of **Appender_setFilter**-procedure uses the following parameters:

| Parameter           | Description                                                       |
|:--------------------|:------------------------------------------------------------------|
| ***i_pAppender***   | Required. Handle of the appender of type **LOG4RPG_pAppender_t**. |
| ***i_pFilter***     | Required. Handle of the filter of type **LOG4RPG_pFilter_t**.     |

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
