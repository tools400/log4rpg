# What's new

Version 1.10.1 dated from 03.04.2012

| Fixed | Fixed problem that some special charcaters were not properly translated to the CCSID of the current job when producing the XML message. |
| --- | --- |

Version 1.10 dated from 17.07.2011

| Added | Procedures Logger_is\*Enabled() tu check, whther or not a certain log level has been enabled. |
| --- | --- |

Version 1.9.5 dated from 20.05.2011

| Fixed | Fixed missing return values of the following procedures: Logger_getInternalDebugMode() and Logger_getInternalDebugOutput(). |
| --- | --- |

Version 1.9.4 dated from 20.11.2010

| Added | Added parameter 'ccsid' to the configuration values of the RollingFileAppender and the DailyRollingFileAppender. The CCSID value is used to specify the CCSID for new log files. |
| --- | --- |

Version 1.9.3 dated from 13.10.2010

| Added | Introduced new special host name 'localclient' that resolves to the TCP/IP address of the 5250 client of the current job. 'localclient' can be used to configure the XMLSocketAppender to connect to a server running on the 5250 client of the current job. |
| --- | --- |

Version 1.9.2 dated from 18.05.2010

| Changed | Updated CEELIB, CLIB and CLIB2 to the latest version. |
| --- | --- |

Version 1.9.1 dated from 22.09.2009

| Fixed | Changed passing mode of parameter i_followLnk of prototype Qp0lGetAttr from 'const' to 'value'. |
| --- | --- |

Version 1.9 dated from 24.03.2009

| Changed | Removed dependency between Log4rpg stub service program (LOG4RPGS) and BASICS1. |
| --- | --- |

Version 1.8 dated from 10.11.2008

| Fixed | Fixed synchronisation problems, when sharing the log file with another job. (DailyRollingFileAppender and RollingFileAppender) |
| --- | --- |
| Added | Exported additional helper procedures: getObject(), getProcedure(), getSrvPgm() and isValidObjectName(). |
| Added | Added property 'syncObj' to DailyRollingFileAppender and RollingFileAppender. Default values are: DailyRollingFileAppender - QGPL/LOG4RPG50, RollingFileAppender - QGPL/LOG4RLFAPP |
| Added | Added property 'syncLogMode' to DailyRollingFileAppender and RollingFileAppender. Default value for both appenders is: 'false' = do not log sync lock holder. |
| Added | Added property 'syncText' to DailyRollingFileAppender and RollingFileAppender. |

Version 1.7.1 dated from 19.09.2008

| Fixed | Fixed compile issues with member LOG4_X1 (programm LOG4_X1PGM). |
| --- | --- |
| Added | Added DOS batch program upload_Log4rpg.bat to ease the uploading procedure. |

Version 1.7 dated from 15.09.2008

| Changed | Changed prerequisite to: IFS V1.7. |
| --- | --- |
| Changed | Improved performance of the following appender: DailyRollingFileAppender, RollingFileAppender, DailyRollingPrintAppender |
| Changed | New exported procedures to configure a logger within a program. |
| Fixed | Fixed problem when a log file is shared with multiple jobs. This fix requires IFS V1.7. |

Version 1.6.1 dated from 31.08.2008

| Fixed | Now the 'RollingFileAppender' correctly passes a file name to the f_renameIfsFile() procedure. |
| --- | --- |

Version 1.6 dated from 20.06.2008

| Added | Added special value \*SEARCH for the library name, when loading the configuration data from a file member. \*SEARCH searches all libraries of the library list for the specified file and member. |
| --- | --- |
| Changed | Changed prerequisite to: BASICS1 V1.9. |
| Changed | Enabled logging of empty messages. You may consider that as a bug fix. |
| Changed | Changed the Log4rpg stub module to optionally forward procedure calls to the Log4rpg service program. |
| Fixed | Fixed potential "Memory Leak" in PropertyList object. |
| Fixed | Now appenders, layouts and filters are correctly configured, when reloading configuration data. In the past only the log level was properly configured. |

Version 1.5 dated from 22.04.2008

| Added | Pluggable Appender **RollingFileAppender**. |
| --- | --- |
| Added | Added option to reload the configuration periodically. See **Configurator_loadAndWatchPropertiesConfiguration**-procedure. |
| Changed | Changed prerequisites to: IFS V1.5 und BASICS1 V1.7.2. |
| Changed | Now all appender use the new OptionConverter object to convert properties. |
| Fixed | Fixed error RNX0100 that occured when reading properties from a member with a record lenght greater than 512 byte. |
| Fixed | Fixed typo in PLOG4RPG11 korrigiert. Renamed Layouder_isNull() to Layout_isNull(). |

Version 1.4.5 dated from 08.02.2008

| Added | Added stub module 'LOG4RPG00' to distribution package. The module is needed for WSDL2RPG. |
| --- | --- |
| Changed | Moved URL object to BASICS1. |
| Changed | Change size of 'logger name' from 32A to 128A. |

Version 1.4.4 dated from 11.12.2007

| Fixed | Fixed RNX0100 (Length or start position is out of range) error in logLoggingEvent() when the message description could be retrieved. |
| --- | --- |

Version 1.4.3 dated from 05.06.2007

| Fixed | Fixed problem that the log file could not be renamed because 'getArchivePath' returned a path instead of a file name. |
| --- | --- |

Version 1.4.2 dated from 16.05.2007

| Added | Added property 'share' to DailyRollingFileAppender. Default value is 'false' to not share log file. |
| --- | --- |

Version 1.4.1 dated from 25.04.2007

| Fixed | Fixed problem that the log event was not correctly produced, when i_text contained '\]\]\>'. Now '\]\]\>' is replaced with '\]\]\&gt'. |
| --- | --- |

Version 1.4 dated from 07.03.2007

| Added | Added property 'connectTimeout' to XMLSocketAppender. Default wait time for a new connection is 5.000 milliseconds = 5 seconds. |
| --- | --- |

Version 1.3.1 dated from 08.01.2007

| Fixed | Fixed problem that LOG4RPG50 crashed, when the appender could not be opened. |
| --- | --- |
| Added | Added property 'reconnectionDelay' to XMLSocketAppender. Default reconnection delay is 30.000 milliseconds = 30 seconds. |

Version 1.3 dated from 18.11.2006

| Fixed | Fixed problem that parameter 'ccsid' was not properly handled. Changed XMLSocketAppender_setProperties() to correctly call initIconv(). |
| --- | --- |
| Fixed | Changed call to f_getProcPtrByName() to omit message parameter to prevent program crash. |
| Fixed | Fixed problem that Appender 'defaultFile' was not found when using Configurator_loadDefaultConfiguration(). |
| Changed | Now using LogLog_verbose() to log errors when `Layout_getHeader()` and/or `Layout_getFooter()` could not be resolved. |
| Added | `Logger_getInternalDebugMode()` and `Logger_getInternalDebugOutput()`. |
| Added | Added properties `writeHeader` and writeFooter` to `DailyRollingFileAppender` to control whether header and/or footer data is appended to the log. |
| Added | Pluggable appender **XMLSocketHubAppender**. |

Version 1.2.1 dated from 07.11.2006

| Fixed | Added missing \</title\> tag to HTMLLayout. |
| --- | --- |

Version 1.2 dated from 06.11.2006

| Changed | Replaced structure logEvent with object LogEvent. |
| --- | --- |
| Changed | Moved word-wrap into Appender implementation objects. |
| Changed | Converting property key to lower-case. |
| Changed | Removed return value from procedure **Layout_format**. |
| Changed | Inserted parameter "level" into parameter list of **Logger_forcedLog** and **Logger_forcedLogMsg**. |
| Changed | Inserted parameter **i_pAppender** into parameter list of \*_new-procedures of Appender implementation objects. |
| Changed | Inserted parameter **i_pLayout** into parameter list of \*_new-procedures of Layout implementation objects. |
| Fixed | Fixed problem that properties were not found because of case mismatch. |
| New | Added feature to completely enable/disable: **Logger_setLogging**. |
| New | Adopted filter concept of Log4j. |
| New | Procedure: Appender_knowsProperty. |
| New | Procedure: Layout-knowsProperty. |
| New | Procedure: Layout_newLine. Returns the new-line character. |
| New | Pluggable layout **HTMLLayout**. |
| New | Pluggable filter **PropertyFilter**. |
| New | Pluggable appender **XMLSocketAppender**. |

Version 1.1 dated from 17.10.2006

| Fixed | Fixed problem that I released Log4rpg 0.9 instead of 1.0. |
| --- | --- |
| Fixed | Fixed problem in PropertyList_loadFromUrl(). Now returning `*OFF` on unknown URL protocol. |
| Fixed | Logger_addAppender() failed when attempting to add an appender to the appender list. This was because Log4rpg V0.9 does definitely not work with BASICS1 V1.6+. |
| Changed | Added addiitonal exports to the Log4rpg service program. |

Version 1.0 dated from 10.10.2006

| New | Released Version 1.0 of Log4rpg. |
| --- | --- |

***
© 2000-2025, Thomas Raddatz
