# DailyRollingFileAppender

**Service program:** built-in\
**Procedure:** DailyRollingFileAppender

| Property     | Value                       | Comments                                                                                                                                                                                                   |
|:-------------|:----------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| path         | path-name                   | Name of the IFS file                                                                                                                                                                                       |
| ccsid        | ccsid-value                 | CCSID used to create new the log files.<br> Default: 850                                                                                                                                                   |
| share        | true \| false<br>or 1  \| 0 | Specifies whether to share the log file for writing with other jobs or not.<br>Default: false                                                                                                              |
| syncObj      | library/objName             | Specifies a data area that is used to synchronize changing the log file. This properties is used only if `share` is set to `true`.<br>Default: `QGPL/LOG4RPG50`                                            |
| syncLogMode  | true \| false<br>or 1 \| 0  | Specifies whether the data area is updated with the name of the job holding the synchronisation lock. This properties is used only if `share` is set to `true`.<br>Default: false                          |
| syncText     | object-description          | Object description of the data area that is used as the synchronisation object. This properties is used only if `share` is set to `true`.                                                                  |
| datePattern  | date-pattern                | Pattern used to test, if a new file has to be started:<br>dd - Days<br>MM - Months<br>yyyy - Years<br>mm - Minutes<br>HH - Hours<br>. - Insert position                                                    |
| layout       | layout-name                 | Name of the layout used to format the log events: `LIB/SRVPGM(ProcedurePrefix)`.<br>The built-in layouts can be specified by the following short cuts:<br>- PatternLayout<br>- SimpleLayout<br>- XMLLayout |
| writeHeader  | true \| false<br>or 1 \| 0  | Specifies whether layout header data is appended or not.                                                                                                                                                   |
| writeFooter  | true \| false<br>or 1 \| 0  | Specifies whether layout footer data is appended or not.                                                                                                                                                   |

## Example date-patterns

`-yyyy-MM-dd.`

An new file is started at midnight. The current value of the date pattern is inserted before the dot of the file name. If the current outfile is named `foobar.log`, then it will be renamed to `foobar-2006-07-11.log` at midnight 11.07.2006. The log is continued in a new file `foobar.log`.

`.yyyy-MM-dd-HH`

Changes the log file every hour. At 11.07.2006 at 8:00Uhr `foobar.log` is renamed to `foobar.log.2006-07-11-07`.

***
© 2000-2025, Thomas Raddatz
