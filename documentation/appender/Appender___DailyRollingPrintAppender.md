# DailyRollingPrintAppender

**Service program:** built-in\
**Procedure:** DailyRollingPrintAppender

| Property    | Value                 | Comments                                                                                                                                                                                                   |
|:------------|:----------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| outQ        | output-queue-name     | Name of the output queue.                                                                                                                                                                                  |
| splfName    | spool-file-name       | Name of the printer file.                                                                                                                                                                                  |
| usrdta      | user-data             | User data of the printer file.                                                                                                                                                                             |
| length      | page-length           | Page length measured in lines.                                                                                                                                                                             |
| width       | page-widht            | Page width measured in characters.                                                                                                                                                                         |
| lpi         | &#54;, 8              | Lines per inch.                                                                                                                                                                                            |
| cpi         | &#49;0, 12            | Charcters per inch.                                                                                                                                                                                        |
| ovrflw      | overflow-line-number  | Page overflow line.                                                                                                                                                                                        |
| leftMargin  | left-margin           | Left margin measured in characters.                                                                                                                                                                        |
| rightMargin | right-margin          | Right margin measured in characters.                                                                                                                                                                       |
| datePattern | datePattern           | Pattern used to test, if a new file has to be started:<br>dd - Days<br>MM - Months<br>yyyy - Years<br>mm - Minutes<br>HH - Hours                                                                           |
| layout      | layout-name           | Name of the layout used to format the log events: `LIB/SRVPGM(ProcedurePrefix)`.<br>The built-in layouts can be specified by the following short cuts:<br>- PatternLayout<br>- SimpleLayout<br>- XMLLayout |

***
© 2000-2025, Thomas Raddatz
