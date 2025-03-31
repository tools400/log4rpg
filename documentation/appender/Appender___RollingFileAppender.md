# RollingFileAppender

**Service program:** LOG4RLFAPP\
**Procedure:** RollingFileAppender

| Property       | Wert                       | Bemerkung                                                                                                                                                                                                  |
|:---------------|:---------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| path           | path-name                  | Name of the IFS file                                                                                                                                                                                       |
| ccsid          | ccsid-value                | CCSID used to create new the log files.<br>Default: 850                                                                                                                                                    |
| share          | true \| false<br>or 1 \| 0 | Specifies whether to share the log file for writing with other jobs or not.<br>Default: `false`                                                                                                            |
| syncObj        | library/objName            | Specifies a data area that is used to synchronize changing the log file. This properties is used only if `share` is set to 'true'.<>Default: `QGPL/LOG4RLFAPP`                                             |
| syncLogMode    | true \| false<br>or 1 \| 0 | Specifies whether the data area is updated with the name of the job holding the synchronisation lock. This properties is used only if `share` is set to 'true'.<br>Default: `false`                        |
| syncText       | object-description         | Object description of the data area that is used as the synchronisation object. This properties is used only if 'share' is set to `true`.                                                                  |
| maxFileSize    | file-size                  | Specifies the maximum size of the log file. When the log file reaches the maximum size it is rolled over to the backup files.<br>Default: 10 MB                                                            |
| maxBackupIndex | index-value                | Specifies the number of backup files. If the number of backup files is equal to 0, no backup files are created and the log file gets truncated.<br>Default: 1                                              |
| filter         | filter-name                | Name of the filter to use.                                                                                                                                                                                 |
| layout         | layout-name                | Name of the layout used to format the log events: `LIB/SRVPGM(ProcedurePrefix)`.<br>The built-in layouts can be specified by the following short cuts:<br>- PatternLayout<br> -SimpleLayout<br>- XMLLayout |
| writeHeader    | true \| false<br>or 1 \| 0 | Specifies whether layout header data is appended or not.                                                                                                                                                   |
| writeFooter    | true \| false<br>or 1 \| 0 | Specifies whether layout footer data is appended or not.                                                                                                                                                   |

**Logik der Backup Dateien:**

Backup files get the name 'file.index' where 'file' is the name of the log file. When file reaches the maximum size, the following actions take place:

If 'file.maxBackupIndex' exists it is deleted.

All backup files from 'file.maxBackupIndex-1' to file.1' are renamed to index + 1.

The current log file is renamed to 'file.1'.

A new log file is started.

Example:

log4rpg.log (current log file)

Backup files:

log4rpg.log.1

log4rpg.log.2

log4rpg.log.3

...

log4rpg.log.maxBackupIndex

## Additional Information

The RollingFileAppender calls `Layout_getHeader()` and `Layout_getFooter()`.

***
© 2000-2025, Thomas Raddatz
