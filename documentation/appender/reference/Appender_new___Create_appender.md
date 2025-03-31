# Appender_new - Create appender

Produces a new Appender and returns a value of type **LOG4RPG_pAppender_t**.

## Syntax

**Appender_new**(***i_appName***, ***i_appImpl***, {­***i_pPropString***)

The syntax of **Appender_new**-procedure uses the following parameters:

| Parameter           | Description                                                                                                                                             |
|:--------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------|
| ***i_appName***     | Required. Name of the appender of type **LOG4RPG_appenderName_t**.                                                                                      |
| ***i_appImpl***     | Required. Qualified name of the class that implements the appender of type **LOG4RPG_implClass_t**.<br>Example: `*LIBL/LOG4RLFAPP(RollingFileAppender)` |
| ***i_pPropString*** | Optional or omissible. Semicolon separated liest of configuration properties of type **STRING**.                                                        |

## Return Value

| Name                 | Description                                               |
|:---------------------|-----------------------------------------------------------|
| ***pAppender***      | Handle of the appender of type **LOG4RPG_pAppender_t**.   |

## Comments

none

## Module

LOG3RPG03

***
© 2000-2025, Thomas Raddatz
