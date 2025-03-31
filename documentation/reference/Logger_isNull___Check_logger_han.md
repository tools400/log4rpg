# Logger_isNull - Check logger handle for NULL value

Test a logger handle for a NULL value and returns a value of type **BOOL**.

## Syntax

**Logger_isNull**(***i_hLogger***, {­***i_char***)

The syntax of **Logger_isNull**-procedure uses the following parameters:

| Parameter            | Description                                                  |
|:---------------------|:-------------------------------------------------------------|
| ***i_hLogger***      | Required. Handle of the logger of type **LOG4RPG_handle_t**. |

## Return Value

| Name                 | Description                                                      |
|:---------------------|------------------------------------------------------------------|
| ***isNull***         | Returns `*ON`, when the logger handle is NULL, otherwise `*OFF`. |

## Comments

Do not test a logger handle for a null value with the RPG special value \*NULL. Whenever you have to know whether a logger handle is NULL or not, use the **Logger_isNull**-procedure.

## Module

LOG4RPG01

***
© 2000-2025, Thomas Raddatz
