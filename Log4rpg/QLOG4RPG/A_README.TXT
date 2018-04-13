LOG4RPG - A Tools/400 Service Program
-------------------------------------

LOG4RPG is service program providing logging services similar to Log4j.
In fact, the utility was inspired by Log4j.

Dependencies: BASICS1, IFS

Compile members with the following PDM option:                                                     
                                                                          
   STRPREPRC USESRCFILE(&L/&F) USESRCMBR(&N) OPTION(*EVENTF) CHGOBJD(*NO) 
     LIB(&O) OBJ(&N) SRCLIB(&L) SRCFILE(&F) SRCMBR(&N) USER0(&X)          
     USER1(*LIST) USER2(*FULL)                                            

Members of type MAKPGM or BND are used for linking programs (MAKPGM) 
and service programs (BND).

2018, Thomas Raddatz

-----------------------
      History
-----------------------
 
 
Version 1.12
------------
 
Fixed:   Changed *_doAppend() to better handle unexpected errors
         when renaming the log file. (RollingFileAppender and
         DailyRollingFileAppender)
 
 
Version 1.11
------------
 
Fixed:   Fixed problem that the hierachy of the loggers was broken
         when a logger of a higher level had been defined after a
         a loger of a lower level.
New:     Now the logger hierachy is dumped to the debug log, when
         the Log4rpg debug log is set to VERBOSE.
         Setting: log4rpg.debug=verbose
 
 
Version 1.10.1
--------------
 
Fixed:   Fixed problem that some special charcaters were not properly
         translated to job CCSID when producing the XML message.
 
 
Version 1.10
------------
 
Changed: Changed the logging procedures to use the Logger_is*Enabled()
         procedures rather than checking all the stuff by themselves.
 
Added:   Exported procedures:
            Logger_isDebugEnabled()
            Logger_isInfoEnabled()
            Logger_isWarnEnabled()
            Logger_isErrorEnabled()
            Logger_isFatalEnabled()
 
 
Version 1.9.5
-------------
 
Fixed:   Fixed problem that the following procedures did not return a
         return value if logging was disabled:
            Logger_getInternalDebugMode()
            LogLog_getInternalDebugOutput()
 
 
Version 1.9.4
-------------
 
New:     RollingFileAppender: Added parameter 'ccsid' to enable the user
         to specify the ccsid of the log file.
New:     DailyRollingFileAppender: Added parameter 'ccsid' to enable the
         user to specify the ccsid of the log file.
 
 
Version 1.9.3
-------------
 
Fixed:   Introduced special host name 'localclient' that resolves to the
         TCP/IP address of the 5250 client of the current job.
         'localclient' can be used to configure the XMLSocketAppender to
         connect to a server running of the 5250 client of the current job.
 
 
Version 1.9.2
-------------
 
Fixed:   Updated CEELIB, CLIB and CLIB2 to latest version.
 
 
Version 1.9.1
-------------
 
Fixed:   Changed passing mode of parameter i_followLnk of prototype Qp0lGetAttr
         from 'const' to 'value'.
 
 
Version 1.9
-----------
 
Changed: Removed dependency to BASICS1 from logger stub service program LOG4RPGS.
 
 
Version 1.8
-----------
 
Fixed:   Fixed synchronisation problems, when sharing the log file with another job.
Added:   Exported procedures:
            getObject()
            getProcedure()
            getSrvPgm()
Added:   Added property 'syncObj' to DailyRollingFileAppender and RollingFileAppender.
         Default values are:   DailyRollingFileAppender - QGPL/LOG4RPG50
                               RollingFileAppender      - QGPL/LOG4RLFAPP
Added:   Added property 'syncMode' to DailyRollingFileAppender and RollingFileAppender.
         Default value for both appenders is: 'false' = do not log sync lock holder.
Added:   Added property 'syncText' to DailyRollingFileAppender and RollingFileAppender.
         Default values are:
               DailyRollingFileAppender - Log4rpg Daily RollingFileAppender Sync. Object
               RollingFileAppender      - Log4rpg RollingFileAppender Sync. Object
 
 
Version 1.7.1
-------------
 
Fixed:   Now LOG4_X1PGM (LOG4_X1) compiles without erroes.
 
 
Version 1.7
-----------
 
Fixed:   Fixed problem when the same log file is used by multiple jobs. This fix
         requires IFS V1.7.
Changed: New requisites:   Service program IFS V1.7
Changed: Changed parameter 'i_filterName' of Appender_setFilter() to 'i_pFilter'.
Changed: Changed parameter 'i_appName' of Logger_addAppender() to 'i_pAppender'.
Changed: DailyRollingFileAppender, RollingFileAppender and DailyRollingPrintAppender:
         Improved performance when calling f_writeLineIfsFile() / Rwrite().
Changed: Added optional parameter i_width to LogEvent_getFirstLineOfText() and
         LogEvent_getNextLineOfText() procedures.
Changed: New exported procedures to configure a logger within a program.
Added:   Added new procedures to Log4rpg stub module:
            Layout_new()         Appender_new()
            Layout_null()        Appender_null()
            Filter_new()         Appender_setLayout()
            Filter_null()        Appender_setFilter()
            Filter_setNext()     Logger_addAppender()
 
 
Version 1.6.1
-------------
 
Fixed:   Fixed problem in "RollingFileAppender" plugin. Now correctly passing a file name to
         f_renameIfsFile().
 
 
Version 1.6
-----------
 
Fixed:   Fixed problem that appenders, layouts and filters were not (re)configured
         when reloading configuration data. Only the log level was properly configured.
Fixed:   Fixed potential memory leak in PropertyList object. Handle may not have been
         correctly freed in PropertyList_delete().
Added:   Special value *SEARCH for the library name when loading properties from
         a physical file member. When *SEARCH is specified as the library name,
         all files in the library list that matches the specified file name are
         searched for the member. The first member that is found is used to load
         the configuration data.
Changed: New requisites:   Service program BASICS1: V1.9
Changed: Changed Log4rpg to log empty messages. You may considers that as a bug fix.
Changed: Enhanced the Log4rpg stub module to optionally load the Log4rpg service
         program and forward procedure calls to it. Added setStubOfs() to let the
         stub module set an offset to let f_caller() skip the stub module.
 
 
Version 1.5
-----------
 
Added:   Added pluggable appender: RollingFileAppender
Added:   Added feature to periodically reload the configuration data.
Added:   Added procedure Configurator_loadAndWatchPropertiesConfiguration().
Changed: New requisites:   Service program IFS    : V1.5
                           Service program BASICS1: V1.7.2
Changed: Changed all Appender to use the new OptionConverter to convert
         properties.
Fixed:   Fixed problem that loadPropertiesFromMbr crashed with RNX0100
         if the record length of a non-source member exceeded 512.
Fixed:   Fixed typo in PLOG4RPG11. Renamed 'Layouder_isNull' to 'Layout_isNull'.
 
 
Version 1.4.5
-------------
 
Added:   Added stub module 'LOG4RPG00' to distribution package.
Changed: Moved URL object to BASICS1.
Changed: Change size of 'logger name' from 32A to 128A.
 
 
Version 1.4.4
-------------
 
Fixed:   Fixed RNX0100 (Length or start position is out of range) error
         in logLoggingEvent() when the message description could be
         retrieved.
 
 
Version 1.4.3
-------------
 
Added:   Fixed problem that the log file could not be renamed because
         'getArchivePath' returned a path instead of a file name.
 
 
Version 1.4.2
-------------
 
Added:   Added property 'share' to DailyRollingFileAppender. Default
         value is 'false' = do not share log file with other jobs.
 
 
Version 1.4.1
-------------
 
Added:   Fixed problem that the log event was not correctly produced
         when i_text contained ']]>'. Now it is replaced with ']]&gt'.
 
 
Version 1.4
-----------
 
Added:   Added property 'connectTimeout' to XMLSocketAppender. Default
         connect timeout is 5.000 milliseconds = 5 seconds.
 
 
Version 1.3.1
-------------
 
Fixed:   Fixed problem that LOG4RPG50 crashed, when the appender could
         not be opened. (error on 'f_left(i_handle.dateValue: 1)' due to
         missing dateValue)
Added:   Added property 'reconnectionDelay' to XMLSocketAppender. Default
         reconnection delay is 30.000 milliseconds = 30 seconds.
 
 
Version 1.3
-----------
 
Fixed:   Fixed probem that parameter 'ccsid' was not properly handled.
         Changed XMLSocketAppender_setProperties() to correctly call
         initIconv().
Fixed:   Changed call to f_getProcPtrByName() to omit message parameter
         to avoid program crash on error.
Fixed:   Fixed problem that appender 'defaultFile' was not found when
         the default configuration was used.
Changed: Now using LogLog_verbose() to log errors when Layout_getHeader()
         or Layout_getFooter() could not be resolved.
Added:   Added procedures: Logger_getInternalDebugMode()
                           Logger_getInternalDebugOutput()
Added:   Added properties 'writeHeader' and 'writeFooter' to the
         DailyRollingFileAppender that control whether a header
         or footer is appended to the log.
Added:   Added pluggable appender: XMLSocketHubAppender (used to connect to Chainsaw)
 
 
Version 1.2.1
-------------
 
Fixed:   Added missing </title> tag to HTMLLayout.
 
 
Version 1.2
-----------
 
Changed: Replaced data structure logEvent with object LogEvent.
Changed: Moved wordWrap processing to Appender implementation objects.
Changed: Now changing property key to lower case, when adding a property.
Changed: Removed return value from procedure: Layout_format().
Changed: Added parameter i_level to Logger_forcedLog() and Logger_forcedLogMsg().
Changed: Added parameter i_pAppender to appender implementation objects.
Changed: Added parameter i_pLayout to layout implementation objects.
Fixed:   Fixed problem that properties were not found because auf case mismatch.
Added:   Added feature to completely enable/disable Log4rpg. Logger_setLogging().
Added:   Introduced Filter to Log4rpg.
Added:   Added procedure Appender_knowsProperty().
Added:   Added procedure Layout_knowsProperty().
Added:   Added procedure Layout_newLine() which returns the new-line character.
Added:   Added pluggable layout: HTMLLayout
Added:   Added pluggable filter: PropertyFilter
Added:   Added pluggable appender: XMLSocketAppender (used to connect to Chainsaw)
 
 
Version 1.1
-----------
 
Fixed:   Released Version 0.9 instead of 1.0.
Fixed:   Fix bug in PropertyList_loadFromUrl(). Now returning cFalse
         on unknown URL protocol.
Fixed:   Logger_addAppender() failed when attempting to add an appender
         to the appender list.
Changed: Added the following export to the Log4rpg service program:
            - LOG4RPG07_PropertyList_getFirst
            - LOG4RPG07_PropertyList_getIterator
            - LOG4RPG07_PropertyList_getNext
            - LOG4RPG07_PropertyList_isNull
 
 
Version 1.0
-----------
 
Relased: 10.10.2006
 
