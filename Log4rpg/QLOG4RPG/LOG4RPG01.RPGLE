      *=====================================================================*
      *  SrvPgm: LOG4RPG - Logger                                           *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  13.06.2006                                              *
      *  E-mail  :  thomas.raddatz@tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  17.10.2006  Th.Raddatz    Fixed that Logger_addAppender() failed   *
      *                            when attempting to add an appender to    *
      *                            the appender list.                       *
      *                                                                     *
      *  25.10.2006  Th.Raddatz    Replaced data structure logEvent with    *
      *                            object LogEvent.                         *
      *                                                                     *
      *  27.10.2006  Th.Raddatz    Added feature to completely enable/      *
      *                            disable Log4rpg. Logger_setLogging().    *
      *                                                                     *
      *  15.11.2006  Th.Raddatz    Added procedures:                        *
      *                            Logger_getInternalDebugMode()            *
      *                            Logger_getInternalDebugOutput()          *
      *                                                                     *
      *  11.12.2007  Th.Raddatz    Fixed RNX0100 (Length or start position  *
      *                            is out of range) error in                *
      *                            logLoggingEvent() when the message       *
      *                            description could be retrieved.          *
      *                                                                     *
      *  18.04.2008  Th.Raddatz    Added support to reload the configuration*
      *                            data every n minutes:                    *
      *                            Configurator_checkAndReload...()         *
      *                                                                     *
      *  13.06.2008  Th.Raddatz    Changed Log4rpg to log empty messages.   *
      *                            Enhanced the Log4rpg stub module         *
      *                            to optionally load the Log4rpg service   *
      *                            program and forward procedure calls      *
      *                            to it. Added setStubOfs() to let the     *
      *                            stub module set an offset to let         *
      *                            f_caller() skip the stub module.         *
      *                                                                     *
      *  20.06.2008  Th.Raddatz    Added procedure Logger_resetLevel().     *
      *                                                                     *
      *  15.09.2008  Th.Raddatz    Changed parameter i_appName of procedure *
      *                            Logger_addAppender() to i_pAppender.     *
      *                                                                     *
      *  20.05.2011  Th.Raddatz    Fixed problem that the following         *
      *                            procedures did not return a return value *
      *                            if logging was disabled:                 *
      *                               Logger_getInternalDebugMode()         *
      *                               LogLog_getInternalDebugOutput()       *
      *                                                                     *
      *  29.06.2011  Th.Raddatz    Added procedures:                        *
      *                               Logger_isDebugEnabled()               *
      *                               Logger_isInfoEnabled()                *
      *                               Logger_isWarnEnabled()                *
      *                               Logger_isErrorEnabled()               *
      *                               Logger_isFatalEnabled()               *
      *                                                                     *
      *  15.07.2011  Th.Raddatz    Changed the logging procedures to use    *
      *                            the Logger_is*Enabled() procedures       *
      *                            rather than checking all the stuff by    *
      *                            themselves.                              *
      *                                                                     *
      *  15.07.2011  Th.Raddatz    Added call of Repository_dumpHierarchy().*
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< TGTRLS(V5R3M0  );                                    *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /COPY QLOG4RPG,H_SPEC
      /COPY QLOG4RPG,COPYRIGHT
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG                      Public interface & type definitions
      /COPY QLOG4RPG,PLOG4RPG01                    Logger
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PTYPES                        Private type definitions
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      /COPY QLOG4RPG,PLOG4RPG04                    AppenderList
      /COPY QLOG4RPG,PLOG4RPG08                    Configurator
      /COPY QLOG4RPG,PLOG4RPG09                    Level
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
      /COPY QLOG4RPG,PLOG4RPG13                    Repository
      /COPY QLOG4RPG,PLOG4RPG16                    LogEvent
      /COPY QLOG4RPG,PLOG4RPG99                    Helpers
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Deletes a logger.
     D deleteLogger...
     D                 PR
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
      *
      *  Returns cTrue if logging is enabled.
     D isLoggingEnabled...
     D                 PR              N
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Returns the logging priority from the logger hierarchy.
     D getPriorityFromHierarchy...
     D                 PR                         like(LOG4RPG_priority_t  )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
      *
      *  Logs the logging event.
     D logLoggingEvent...
     D                 PR
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
     D  i_priority                         const  like(LOG4RPG_priority_t  )
     D  i_text                             const  like(LOG4RPG_text_t      )
     D                                            options(*varsize)
     D  i_caller                           const  likeds(LOG4RPG_caller_t  )
     D  i_errMsg                           const  likeds(msg_t             )
     D                                            options(*nopass)
      *
      *  Returns the appender list from the logger hierarchy.
     D getAppenderListFromHierarchy...
     D                 PR                         like(LOG4RPG_pAppenderList_t )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t       )
      *
      *  Initializes a given logger handle.
     D initializeLoggerHandle...
     D                 PR
     D  io_logger                                 likeds(LOG4RPG_logger_t  )
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      *
      *  Initializes a given provision node handle.
     D initializeProvisionNodeHandle...
     D                 PR
     D  io_provNode                               likeds(LOG4RPG_logger_t  )
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      *
      *  Clears a given logger handle.
     D clearHandleData...
     D                 PR
     D  io_logger                                 likeds(LOG4RPG_logger_t)
      *
      *  Checks, if the Log4rpg stub module is present and returns an offset
      *  for the f_caller() procdure to skip the stub module.
     D getStubOfs...
     D                 PR             3I 0
      *
      *  Initializes this module.
     D initializeModule...
     D                 PR
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cLOG4RPG_LEVEL_NONE...
     D                 C                   const(-2)
     D cLOG4RPG_LEVEL_PARENT...
     D                 C                   const(-1)
      *
     D cLOG4RPG_NODE_LOGGER...
     D                 C                   const(1)
     D cLOG4RPG_NODE_PROVISION...
     D                 C                   const(2)
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
     D g_isLogging     S               N   inz(cTrue)
     D g_isInit        S               N   inz(cFalse)
     D g_warnRootNoAppender...
     D                 S               N   inz(cFalse)
     D g_stubOfs       S              3I 0 inz(0)
      *
      * -----------------------------------------
      *  Program status data structure
      * -----------------------------------------
      /DEFINE SDS_EXTENDED
      /COPY QLOG4RPG,SDS
      /UNDEFINE SDS_EXTENDED
      *
      *=========================================================================
      *  Enables / Disables LOG4RPG.
      *=========================================================================
      *  Parameters:
      *   i_isLogging   - Specifies whether LOG4RPG is active or not.
      *                   *OFF completely disables LOG4RPG.
      *
      *  Returns:
      *   currentState  - Returns the current state of LOG4RPG.
      *                   1 = ON, 0 = OFF.
      *=========================================================================
     P Logger_setLogging...
     P                 B                   export
      *
     D Logger_setLogging...
     D                 PI              N
     D  i_isLogging                    N   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if i_isLogging;
            g_isLogging = cTrue;
            LogLog_verbose('LOG4RPG is enabled now.');
         else;
            g_isLogging = cFalse;
            LogLog_verbose('LOG4RPG is disabled now.');
         endif;
 
         return g_isLogging;
 
      /END-FREE
      *
     P Logger_setLogging...
     P                 E
      *
      *=========================================================================
      *  Returns whether logging is enabled or not.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   isLogging     - Returns TRUE if logging is enabled, else FALSE.
      *=========================================================================
     P Logger_isLogging...
     P                 B                   export
      *
     D Logger_isLogging...
     D                 PI              N
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if g_isLogging;
            return cTrue;
         else;
            return cFalse;
         endif;
 
      /END-FREE
      *
     P Logger_isLogging...
     P                 E
      *
      *=========================================================================
      *  Returns the root logger.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   hLogger       - Handle of the root logger on success, else
      *                   a NULL handle.
      *=========================================================================
     P Logger_getRootLogger...
     P                 B                   export
      *
     D Logger_getRootLogger...
     D                 PI                         like(LOG4RPG_hLogger_t )
      *
      *  Return value
     D hLogger         S                   like(LOG4RPG_hLogger_t  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return Logger_getLogger(cROOT_LOGGER);
 
      /END-FREE
      *
     P Logger_getRootLogger...
     P                 E
      *
      *=========================================================================
      *  Returns a new logger named as the specified name.
      *=========================================================================
      *  Parameters:
      *   i_logName     - Name of the logger.
      *
      *  Returns:
      *   hLogger       - Handle of the logger on success, else
      *                   a NULL handle.
      *=========================================================================
     P Logger_getLogger...
     P                 B                   export
      *
     D Logger_getLogger...
     D                 PI                         like(LOG4RPG_hLogger_t   )
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      *
      *  Return value
     D hLogger         S                   like(LOG4RPG_hLogger_t  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if not Logger_isLogging();
            return Logger_null();
         endif;
 
         initializeModule();
 
         Configurator_checkAndReloadPropertiesConfiguration();
 
         hLogger = Repository_getLogger(translateLoggerName(i_logName));
 
         return hLogger;
 
      /END-FREE
      *
     P Logger_getLogger...
     P                 E
      *
      *=========================================================================
      *  Logs a DEBUG statement.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_text        - Statement text, that is written to the log.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_debug...
     P                 B                   export
      *
     D Logger_debug...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  Caller
     D caller          DS                  likeds(LOG4RPG_caller_t) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if (not Logger_isDebugEnabled(i_hLogger));
            return;
         endif;
 
         caller.procedure = f_caller(caller.module.name
                                     : caller.pgm.name
                                     : caller.stmtID
                                     : g_stubOfs);
         logLoggingEvent(i_hLogger: cLOG4RPG_PRIORITY_DEBUG
                         : i_text
                         : caller);
 
         return;
 
      /END-FREE
      *
     P Logger_debug...
     P                 E
      *
      *=========================================================================
      *  Logs a DEBUG message.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_msg         - Message, that is written to the log.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_debugMsg...
     P                 B                   export
      *
     D Logger_debugMsg...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      *
      *  Caller
     D caller          DS                  likeds(LOG4RPG_caller_t) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      *
      *  Error message
     D errMsg          DS                  likeds(msg_t   ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if (not Logger_isDebugEnabled(i_hLogger));
            return;
         endif;
 
         caller.procedure = f_caller(caller.module.name
                                     : caller.pgm.name
                                     : caller.stmtID
                                     : g_stubOfs);
         logLoggingEvent(i_hLogger: cLOG4RPG_PRIORITY_DEBUG
                         : %trimR(f_rtvMsgText(i_msg: errMsg))
                         : caller
                         : errMsg);
 
         return;
 
      /END-FREE
      *
     P Logger_debugMsg...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if 'DEBUG' log events are logged.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *
      *  Returns:
      *   isEnabled     - cTrue if 'DEBUG' log events are logged, else cFalse.
      *=========================================================================
     P Logger_isDebugEnabled...
     P                 B                   export
      *
     D Logger_isDebugEnabled...
     D                 PI              N
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Return value
     D isEnabled       S               N   inz(cFalse)
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if (not isLoggingEnabled(i_hLogger));
            return cFalse;
         endif;
 
         isEnabled =
 B01        cLOG4RPG_PRIORITY_DEBUG >= getPriorityFromHierarchy(i_hLogger);
 
         return isEnabled;
 
      /END-FREE
      *
     P Logger_isDebugEnabled...
     P                 E
      *
      *=========================================================================
      *  Logs an INFO statement.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_text        - Statement text, that is written to the log.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_info...
     P                 B                   export
      *
     D Logger_info...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  Caller
     D caller          DS                  likeds(LOG4RPG_caller_t) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if (not Logger_isInfoEnabled(i_hLogger));
            return;
         endif;
 
         caller.procedure = f_caller(caller.module.name
                                     : caller.pgm.name
                                     : caller.stmtID
                                     : g_stubOfs);
         logLoggingEvent(i_hLogger: cLOG4RPG_PRIORITY_INFO
                         : i_text
                         : caller);
 
         return;
 
      /END-FREE
      *
     P Logger_info...
     P                 E
      *
      *=========================================================================
      *  Logs an INFO message.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_msg         - Message, that is written to the log.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_infoMsg...
     P                 B                   export
      *
     D Logger_infoMsg...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      *
      *  Caller
     D caller          DS                  likeds(LOG4RPG_caller_t) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      *
      *  Error message
     D errMsg          DS                  likeds(msg_t   ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if (not Logger_isInfoEnabled(i_hLogger));
            return;
         endif;
 
         caller.procedure = f_caller(caller.module.name
                                     : caller.pgm.name
                                     : caller.stmtID
                                     : g_stubOfs);
         logLoggingEvent(i_hLogger: cLOG4RPG_PRIORITY_INFO
                         : %trimR(f_rtvMsgText(i_msg: *omit))
                         : caller
                         : errMsg);
 
         return;
 
      /END-FREE
      *
     P Logger_infoMsg...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if 'INFO' log events are logged.
      *  (Including DEBUG log events)
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *
      *  Returns:
      *   isEnabled     - cTrue if 'INFO' log events are logged, else cFalse.
      *=========================================================================
     P Logger_isInfoEnabled...
     P                 B                   export
      *
     D Logger_isInfoEnabled...
     D                 PI              N
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Return value
     D isEnabled       S               N   inz(cFalse)
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if (not isLoggingEnabled(i_hLogger));
            return cFalse;
         endif;
 
         isEnabled =
 B01        cLOG4RPG_PRIORITY_INFO >= getPriorityFromHierarchy(i_hLogger);
 
         return isEnabled;
 
      /END-FREE
      *
     P Logger_isInfoEnabled...
     P                 E
      *
      *=========================================================================
      *  Logs a WARN statement.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_text        - Statement text, that is written to the log.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_warn...
     P                 B                   export
      *
     D Logger_warn...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  Caller
     D caller          DS                  likeds(LOG4RPG_caller_t) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if (not Logger_isWarnEnabled(i_hLogger));
            return;
         endif;
 
         caller.procedure = f_caller(caller.module.name
                                     : caller.pgm.name
                                     : caller.stmtID
                                     : g_stubOfs);
         logLoggingEvent(i_hLogger: cLOG4RPG_PRIORITY_WARN
                         : i_text
                         : caller);
 
         return;
 
      /END-FREE
      *
     P Logger_warn...
     P                 E
      *
      *=========================================================================
      *  Logs a WARN message.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_msg         - Message, that is written to the log.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_warnMsg...
     P                 B                   export
      *
     D Logger_warnMsg...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      *
      *  Caller
     D caller          DS                  likeds(LOG4RPG_caller_t) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      *
      *  Error message
     D errMsg          DS                  likeds(msg_t   ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if (not Logger_isWarnEnabled(i_hLogger));
            return;
         endif;
 
         caller.procedure = f_caller(caller.module.name
                                     : caller.pgm.name
                                     : caller.stmtID
                                     : g_stubOfs);
         logLoggingEvent(i_hLogger: cLOG4RPG_PRIORITY_WARN
                         : %trimR(f_rtvMsgText(i_msg: *omit))
                         : caller
                         : errMsg);
 
         return;
 
      /END-FREE
      *
     P Logger_warnMsg...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if 'WARN' log events are logged.
      *  (Including INFO and DEBUG log events)
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *
      *  Returns:
      *   isEnabled     - cTrue if 'WARN' log events are logged, else cFalse.
      *=========================================================================
     P Logger_isWarnEnabled...
     P                 B                   export
      *
     D Logger_isWarnEnabled...
     D                 PI              N
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Return value
     D isEnabled       S               N   inz(cFalse)
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if (not isLoggingEnabled(i_hLogger));
            return cFalse;
         endif;
 
         isEnabled =
 B01        cLOG4RPG_PRIORITY_WARN >= getPriorityFromHierarchy(i_hLogger);
 
         return isEnabled;
 
      /END-FREE
      *
     P Logger_isWarnEnabled...
     P                 E
      *
      *=========================================================================
      *  Logs an ERROR statement.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_text        - Statement text, that is written to the log.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_error...
     P                 B                   export
      *
     D Logger_error...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  Caller
     D caller          DS                  likeds(LOG4RPG_caller_t) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if (not Logger_isErrorEnabled(i_hLogger));
            return;
         endif;
 
         caller.procedure = f_caller(caller.module.name
                                     : caller.pgm.name
                                     : caller.stmtID
                                     : g_stubOfs);
         logLoggingEvent(i_hLogger: cLOG4RPG_PRIORITY_ERROR
                         : i_text
                         : caller);
 
         return;
 
      /END-FREE
      *
     P Logger_error...
     P                 E
      *
      *=========================================================================
      *  Logs an ERROR message.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_msg         - Message, that is written to the log.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_errorMsg...
     P                 B                   export
      *
     D Logger_errorMsg...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      *
      *  Caller
     D caller          DS                  likeds(LOG4RPG_caller_t) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      *
      *  Error message
     D errMsg          DS                  likeds(msg_t   ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if (not Logger_isErrorEnabled(i_hLogger));
            return;
         endif;
 
         caller.procedure = f_caller(caller.module.name
                                     : caller.pgm.name
                                     : caller.stmtID
                                     : g_stubOfs);
         logLoggingEvent(i_hLogger: cLOG4RPG_PRIORITY_ERROR
                         : %trimR(f_rtvMsgText(i_msg: *omit))
                         : caller
                         : errMsg);
 
         return;
 
      /END-FREE
      *
     P Logger_errorMsg...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if 'ERROR' log events are logged.
      *  (Including WARN, INFO and DEBUG log events)
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *
      *  Returns:
      *   isEnabled     - cTrue if 'ERROR' log events are logged, else cFalse.
      *=========================================================================
     P Logger_isErrorEnabled...
     P                 B                   export
      *
     D Logger_isErrorEnabled...
     D                 PI              N
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Return value
     D isEnabled       S               N   inz(cFalse)
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if (not isLoggingEnabled(i_hLogger));
            return cFalse;
         endif;
 
         isEnabled =
 B01        cLOG4RPG_PRIORITY_ERROR >= getPriorityFromHierarchy(i_hLogger);
 
         return isEnabled;
 
      /END-FREE
      *
     P Logger_isErrorEnabled...
     P                 E
      *
      *=========================================================================
      *  Logs a FATAL error statement.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_text        - Statement text, that is written to the log.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_fatal...
     P                 B                   export
      *
     D Logger_fatal...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  Caller
     D caller          DS                  likeds(LOG4RPG_caller_t) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if (not Logger_isFatalEnabled(i_hLogger));
            return;
         endif;
 
         caller.procedure = f_caller(caller.module.name
                                     : caller.pgm.name
                                     : caller.stmtID
                                     : g_stubOfs);
         logLoggingEvent(i_hLogger: cLOG4RPG_PRIORITY_FATAL
                         : i_text
                         : caller);
 
         return;
 
      /END-FREE
      *
     P Logger_fatal...
     P                 E
      *
      *=========================================================================
      *  Logs a FATAL error message.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_msg         - Message, that is written to the log.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_fatalMsg...
     P                 B                   export
      *
     D Logger_fatalMsg...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      *
      *  Caller
     D caller          DS                  likeds(LOG4RPG_caller_t) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      *
      *  Error message
     D errMsg          DS                  likeds(msg_t   ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if (not Logger_isFatalEnabled(i_hLogger));
            return;
         endif;
 
         caller.procedure = f_caller(caller.module.name
                                     : caller.pgm.name
                                     : caller.stmtID
                                     : g_stubOfs);
         logLoggingEvent(i_hLogger: cLOG4RPG_PRIORITY_FATAL
                         : %trimR(f_rtvMsgText(i_msg: *omit))
                         : caller
                         : errMsg);
 
         return;
 
      /END-FREE
      *
     P Logger_fatalMsg...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if 'FATAL' log events are logged.
      *  (Including ERROR, WARN, INFO and DEBUG log events)
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *
      *  Returns:
      *   isEnabled     - cTrue if 'FATAL' log events are logged, else cFalse.
      *=========================================================================
     P Logger_isFatalEnabled...
     P                 B                   export
      *
     D Logger_isFatalEnabled...
     D                 PI              N
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Return value
     D isEnabled       S               N   inz(cFalse)
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if (not isLoggingEnabled(i_hLogger));
            return cFalse;
         endif;
 
         isEnabled =
 B01        cLOG4RPG_PRIORITY_FATAL >= getPriorityFromHierarchy(i_hLogger);
 
         return isEnabled;
 
      /END-FREE
      *
     P Logger_isFatalEnabled...
     P                 E
      *
      *=========================================================================
      *  Logs the specified statement without further checking.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_text        - Statement text, that is written to the log.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_forcedLog...
     P                 B                   export
      *
     D Logger_forcedLog...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_level                            const  like(LOG4RPG_level_t   )
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  Caller
     D caller          DS                  likeds(LOG4RPG_caller_t) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if not Logger_isLogging();
            return;
         endif;
 
         // Return to caller if logger is NULL
         if Logger_isNull(i_hLogger);
            return;
         endif;
 
         // Reload properties (if reloading has been enabled)
         Configurator_checkAndReloadPropertiesConfiguration();
 
         // Return to caller if logger does not exist
         if not Repository_existLogger(logger.name);
            return;
         endif;
 
         caller.procedure = f_caller(caller.module.name
                                     : caller.pgm.name
                                     : caller.stmtID
                                     : g_stubOfs);
         logLoggingEvent(i_hLogger: Level_toInt(i_level)
                         : i_text
                         : caller);
 
         return;
 
      /END-FREE
      *
     P Logger_forcedLog...
     P                 E
      *
      *=========================================================================
      *  Logs the specified message without further checking.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_msg         - Message, that is written to the log.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_forcedLogMsg...
     P                 B                   export
      *
     D Logger_forcedLogMsg...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_level                            const  like(LOG4RPG_level_t   )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      *
      *  Caller
     D caller          DS                  likeds(LOG4RPG_caller_t) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      *
      *  Error message
     D errMsg          DS                  likeds(msg_t   ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if not Logger_isLogging();
            return;
         endif;
 
         // Return to caller if logger is NULL
         if Logger_isNull(i_hLogger);
            return;
         endif;
 
         Configurator_checkAndReloadPropertiesConfiguration();
 
         if not Repository_existLogger(logger.name);
            return;
         endif;
 
         caller.procedure = f_caller(caller.module.name
                                     : caller.pgm.name
                                     : caller.stmtID
                                     : g_stubOfs);
         logLoggingEvent(i_hLogger: Level_toInt(i_level)
                         : %trimR(f_rtvMsgText(i_msg: *omit))
                            : caller                                                        //RADDAT
                            : errMsg);
 
         return;
 
      /END-FREE
      *
     P Logger_forcedLogMsg...
     P                 E
      *
      *=========================================================================
      *  Returns the name of the specified logger.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *
      *  Returns:
      *   logName       - Returns the name of the logger on success, else ''.
      *=========================================================================
     P Logger_getName...
     P                 B                   export
      *
     D Logger_getName...
     D                 PI                         like(LOG4RPG_loggerName_t)
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if not Logger_isLogging();
            return '';
         endif;
 
         return Node_getName(i_hLogger);
 
      /END-FREE
      *
     P Logger_getName...
     P                 E
      *
      *=========================================================================
      *  Adds an appender to the specified logger.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_appName     - The name of the appender.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_addAppender...
     P                 B                   export
      *
     D Logger_addAppender...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t       )
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
      *
      *  Helper fields
     D appName         S                   like(LOG4RPG_appenderName_t  ) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if not Logger_isLogging();
            return;
         endif;
 
         // Return to caller if logger is NULL
         if Logger_isNull(i_hLogger);
            return;
         endif;
 
         if Appender_isNull(i_pAppender);
            LogLog_warning('Appender is NULL. Please check call from [' +
                           f_caller() + '] to [' + f_this() + '].');
            return;
         endif;
 
         appName = Appender_getName(i_pAppender);
 
         if AppenderList_isNull(logger.pAppenderList);
            logger.pAppenderList = AppenderList_new();
         endif;
 
         if Appender_isNull(i_pAppender);
            LogLog_warning('Appender [' + appName +
                           '] does not exist in repository.');
            return;
         endif;
 
         if AppenderList_put(logger.pAppenderList: i_pAppender) = 0;
            LogLog_debug('Appender [' + appName +
                         '] added to logger [' + logger.name + '].');
         else;
            LogLog_error('Failed to add appender [' + appName +
                         '] to logger [' + logger.name + '].');
         endif;
 
         return;
 
      /END-FREE
      *
     P Logger_addAppender...
     P                 E
      *
      *=========================================================================
      *  Removes the specified appender from a given logger.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_appName     - Name of the appender that is removed from the logger.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_removeAppender...
     P                 B                   export
      *
     D Logger_removeAppender...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t       )
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if not Logger_isLogging();
            if not Repository_isShutdown();
               return;
            endif;
         endif;
 
         // Return to caller if logger is NULL
         if Logger_isNull(i_hLogger);
            return;
         endif;
 
         if AppenderList_isNull(logger.pAppenderList);
            return;
         endif;
 
         AppenderList_remove(logger.pAppenderList: i_appName);
 
         LogLog_verbose('Appender [' + i_appName +
                        '] removed from logger [' + logger.name + '].');
 
         return;
 
      /END-FREE
      *
     P Logger_removeAppender...
     P                 E
      *
      *=========================================================================
      *  Removes all appenders from the specified logger.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_removeAllAppenders...
     P                 B                   export
      *
     D Logger_removeAllAppenders...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
      *
      *  Helper fields
     D appIter         DS                  likeds(LOG4RPG_Appender...
     D                                                    ListIterator_t   ) inz
     D pAppender       S                   like(LOG4RPG_pAppender_t        ) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if not Logger_isLogging();
            return;
         endif;
 
         // Return to caller if logger is NULL
         if Logger_isNull(i_hLogger);
            return;
         endif;
 
         if AppenderList_isNull(logger.pAppenderList);
            return;
         endif;
 
         appIter = AppenderList_getIterator(logger.pAppenderList);
 
         dow AppenderList_getNumE(logger.pAppenderList) > 0;
            pAppender = AppenderList_getFirst(appIter);
            Logger_removeAppender(i_hLogger: Appender_getName(pAppender));
         enddo;
 
         return;
 
      /END-FREE
      *
     P Logger_removeAllAppenders...
     P                 E
      *
      *=========================================================================
      *  Tests the specified logger handle for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *
      *  Returns:
      *   isNull        - Returns TRUE if the logger handle is NULL, else TRUE.
      *=========================================================================
     P Logger_isNull...
     P                 B                   export
     D                 PI              N
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         p_assert(i_hLogger = *NULL or
                  logger.node = cLOG4RPG_NODE_LOGGER
                  : 'Expected a logger node');
 
         return Node_isNull(i_hLogger);
 
      /END-FREE
     P                 E
      *
      *=========================================================================
      *  Returns a logger NULL handle.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   hLogger       - Returns a NULL handle.
      *=========================================================================
     P Logger_null...
     P                 B                   export
     D                 PI                         like(LOG4RPG_hLogger_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return *NULL;
 
      /END-FREE
     P                 E
      *
      *=========================================================================
      *  Sets the logging level of the specified logger.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_level       - Logging level. Can be one of these value:
      *                      cLOG4RPG_LEVEL_DEBUG
      *                      cLOG4RPG_LEVEL_INFO
      *                      cLOG4RPG_LEVEL_WARN
      *                      cLOG4RPG_LEVEL_ERROR
      *                      cLOG4RPG_LEVEL_FATAL
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_setLevel...
     P                 B                   export
      *
     D Logger_setLevel...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_level                            const  like(LOG4RPG_level_t   )
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if not Logger_isLogging();
            return;
         endif;
 
         // Return to caller if logger is NULL
         if Logger_isNull(i_hLogger);
            return;
         endif;
 
         logger.priority = Level_toInt(f_ucase(i_level));
 
         return;
 
      /END-FREE
      *
     P Logger_setLevel...
     P                 E
      *
      *=========================================================================
      *  Resets the logging level of the specified logger to use the
      *  log level of the parent logger.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_resetLevel...
     P                 B                   export
      *
     D Logger_resetLevel...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if not Logger_isLogging();
            return;
         endif;
 
         // Return to caller if logger is NULL
         if Logger_isNull(i_hLogger);
            return;
         endif;
 
         logger.priority = cLOG4RPG_LEVEL_PARENT;
 
         return;
 
      /END-FREE
      *
     P Logger_resetLevel...
     P                 E
      *
      *=========================================================================
      *  Allows to enable/disable log4rpg internal logging.
      *=========================================================================
      *  Parameters:
      *   i_debugMode   - Specifies the debug mode for the log4rpg
      *                   internal logging.
      *   i_output      - Specifies the output target for the log events.
      *
      *  Returns:
      *   void
      *
      *  Remark:          This setting affects the complete LOG4RPG system.
      *=========================================================================
     P Logger_setInternalDebugging...
     P                 B                   export
      *
     D Logger_setInternalDebugging...
     D                 PI
     D  i_debugMode                        const  like(LOG4RPG_debugMode_t  )
     D  i_output                           const  like(LOG4RPG_debugOutput_t)
     D                                            options(*nopass)
      *
      *  Parameter positions
     D p_output        C                   const(2)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if not Logger_isLogging();
            return;
         endif;
 
         if %parms() >= p_output;
            LogLog_setInternalDebugging(i_debugMode: i_output);
         else;
            LogLog_setInternalDebugging(i_debugMode);
         endif;
 
         return;
 
      /END-FREE
      *
     P Logger_setInternalDebugging...
     P                 E
      *
      *=========================================================================
      *  Returns the internal debug mode.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   debugMode     - Mode of the internal logging.
      *=========================================================================
     P Logger_getInternalDebugMode...
     P                 B                   export
      *
     D Logger_getInternalDebugMode...
     D                 PI                         like(LOG4RPG_debugMode_t  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if not Logger_isLogging();
            return '';
         endif;
 
         return LogLog_getInternalDebugMode();
 
      /END-FREE
      *
     P Logger_getInternalDebugMode...
     P                 E
      *
      *=========================================================================
      *  Returns the target for internal log events.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   output        - Output target for internal log events.
      *=========================================================================
     P Logger_getInternalDebugOutput...
     P                 B                   export
      *
     D Logger_getInternalDebugOutput...
     D                 PI                         like(LOG4RPG_debugOutput_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if not Logger_isLogging();
            return '';
         endif;
 
         return LogLog_getInternalDebugOutput();
 
      /END-FREE
      *
     P Logger_getInternalDebugOutput...
     P                 E
      *
      *=========================================================================
    R *  ***PRIVATE ***   (exported for internal use only)
      *  Creates a new logger instance.
      *=========================================================================
      *  Parameters:
      *   i_logName     - Name of the logger.
      *
      *  Returns:
      *   hLogger       - Handle of the logger on success, else
      *                   a NULL handle.
      *=========================================================================
     P Logger_new...
     P                 B                   export
      *
     D Logger_new...
     D                 PI                         like(LOG4RPG_hLogger_t   )
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      *
      *  Return value
     D hLogger         S                   like(LOG4RPG_hLogger_t ) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_debug('Creating logger [' + i_logName + '] ...');
 
         hLogger = %alloc(%size(LOG4RPG_logger_t));
 
         initializeLoggerHandle(logger: i_logName);
 
         LogLog_verbose('+ Allocated memory for logger [' + logger.name + ']');
 
         return hLogger;
 
      /END-FREE
      *
     P Logger_new...
     P                 E
      *
      *=========================================================================
    R *  ***PRIVATE ***   (exported for internal use only)
      *  Deletes the specified logger.
      *=========================================================================
      *  Parameters:
      *   io_hLogger    - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_delete...
     P                 B                   export
      *
     D Logger_delete...
     D                 PI
     D  io_hLogger                                like(LOG4RPG_hLogger_t )
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(io_hLogger)
      *
      *  Helper fields
     D name            S                   like(logger.name        ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if not Repository_existLogger(logger.name);
            io_hLogger = Logger_null();
            return;
         endif;
 
         LogLog_verbose('Deleting logger [' + logger.name + '] ...');
 
         name = logger.name;
 
         deleteLogger(io_hLogger);
 
         dealloc(N) io_hLogger;
         io_hLogger = Logger_null();
 
         LogLog_verbose('- Freed memory of logger [' + name + ']');
 
         return;
 
      /END-FREE
      *
     P Logger_delete...
     P                 E
      *
      *=======================================================================
      *  ***PRIVATE ***   (exported for internal use only)
      *  Adds a child node to the specified logger node.
      *  (logger nodes only)
      *=======================================================================
      *  Parameters:
      *   i_hLoggerNode - Handle of the logger node as it was returned by
      *                   Logger_getLogger().
      *   i_hChild      - Handle of the child node.
      *
      *  Returns:
      *   numChildren   - Returns the index of the child node on success,
      *                   else -1.
      *=======================================================================
     P Logger_addChild...
     P                 B                   export
     D                 PI            10I 0
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
     D  i_hChild                           const  like(LOG4RPG_hLogger_t   )
      *
      *  Return value
     D index           S             10I 0 inz(-1)
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         hLogger = i_hLogger;
 
         p_assert(logger.node = cLOG4RPG_NODE_LOGGER
                  : 'Expected a logger node');
 
         index = Node_addChild(i_hLogger: i_hChild);
 
         return index;
 
      /END-FREE
     P                 E
      *
      *=========================================================================
    R *  ***PRIVATE ***   (exported for internal use only)
      *  Sets the parent logger of the specified logger.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *   i_hParent     - Handle of the parent logger.
      *
      *  Returns:
      *   void
      *=========================================================================
     P Logger_setParent...
     P                 B                   export
      *
     D Logger_setParent...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_hParent                          const  like(LOG4RPG_hLogger_t )
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hLogger)
     D parent          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hParent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         p_assert(logger.node = cLOG4RPG_NODE_LOGGER
                  : 'Expected a logger node');
 
         Node_setParent(i_hLogger: i_hParent);
 
         if not Logger_isNull(i_hParent);
            LogLog_verbose('Set parent of logger [' + logger.name + '] to ' +
                                                '[' + parent.name + ']');
         else;
            LogLog_verbose('Set parent of logger [' + logger.name + '] to ' +
                                                '[' + '*NULL'     + ']');
         endif;
 
      /END-FREE
      *
     P Logger_setParent...
     P                 E
      *
      *=========================================================================
    R *  ***PRIVATE ***   (exported for internal use only)
      *  Returns the parent of the specified logger.
      *=========================================================================
      *  Parameters:
      *   i_hLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *
      *  Returns:
      *   hParent       - Handle of the parent logger.
      *=========================================================================
     P Logger_getParent...
     P                 B                   export
      *
     D Logger_getParent...
     D                 PI                         like(LOG4RPG_hLogger_t )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return Node_getParent(i_hLogger);
 
      /END-FREE
      *
     P Logger_getParent...
     P                 E
      *
      *=======================================================================
      *  ***PRIVATE ***   (exported for internal use only)
      *  Returns the name of a given node.
      *=======================================================================
      *  Parameters:
      *   i_hNode       - Handle of the node.
      *
      *  Returns:
      *   name          - Returns the name of the node.
      *=======================================================================
     P Node_getName...
     P                 B                   export
     D                 PI                         like(LOG4RPG_loggerName_t)
     D  i_hNode                            const  like(LOG4RPG_hLogger_t )
      *
      *  Logger handle
     D node            DS                  likeds(LOG4RPG_logger_t )
     D                                     based(hNode)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logger is NULL
         if Node_isNull(i_hNode);
            return '';
         endif;
 
         hNode = i_hNode;
 
         return node.name;
 
      /END-FREE
     P                 E
      *
      *=========================================================================
    R *  ***PRIVATE ***   (exported for internal use only)
      *  Tests the specified node handle for a provision node.
      *=========================================================================
      *  Parameters:
      *   i_hNode       - Handle of the node as it was returned by
      *                   Logger_getLogger(), Logger_getRootLogger() or
      *                   ProvisionNode_makeProvisionNode().
      *
      *  Returns:
      *   isProvNode    - Returns TRUE if the handle is a provision node
      *                   handle, else FALSE.
      *=========================================================================
     P Node_isProvisionNode...
     P                 B                   export
      *
     D Node_isProvisionNode...
     D                 PI              N
     D  i_hNode                            const  like(LOG4RPG_hLogger_t )
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hNode)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logger is NULL
         if Node_isNull(i_hNode);
            return cFalse;
         else;
            if logger.node <> cLOG4RPG_NODE_PROVISION;
               return cFalse;
            endif;
         endif;
 
         return cTrue;
 
      /END-FREE
      *
     P Node_isProvisionNode...
     P                 E
      *
      *=========================================================================
    R *  ***PRIVATE ***   (exported for internal use only)
      *  Tests the specified node handle for a logger node.
      *=========================================================================
      *  Parameters:
      *   i_hNode       - Handle of the node as it was returned by
      *                   Logger_getLogger(), Logger_getRootLogger() or
      *                   ProvisionNode_makeProvisionNode().
      *
      *  Returns:
      *   isLoggerNode  - Returns TRUE if the handle is a logger node
      *                   handle, else FALSE.
      *=========================================================================
     P Node_isLoggerNode...
     P                 B                   export
      *
     D Node_isLoggerNode...
     D                 PI              N
     D  i_hNode                            const  like(LOG4RPG_hLogger_t )
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hNode)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logger is NULL
         if Node_isNull(i_hNode);
            return cFalse;
         else;
            if logger.node <> cLOG4RPG_NODE_LOGGER;
               return cFalse;
            endif;
         endif;
 
         return cTrue;
 
      /END-FREE
      *
     P Node_isLoggerNode...
     P                 E
      *
      *=======================================================================
      *  ***PRIVATE ***   (exported for internal use only)
      *  Returns the number of children of the specified node.
      *  (all nodes)
      *=======================================================================
      *  Parameters:
      *   i_hProvNode   - Handle of the node.
      *
      *  Returns:
      *   numChildren   - Returns the number of children of a
      *                   node on success, else -1.
      *=======================================================================
     P Node_getNumChildren...
     P                 B                   export
     D                 PI            10I 0
     D  i_hNode                            const  like(LOG4RPG_hLogger_t)
      *
      *  Return value
     D numChildren     S             10I 0 inz(-1)
      *
      *  Logger handle
     D node            DS                  likeds(LOG4RPG_logger_t )
     D                                     based(pNode)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pNode = i_hNode;
 
         p_assert(node.node = cLOG4RPG_NODE_PROVISION or
                  node.node = cLOG4RPG_NODE_LOGGER
                  : 'Expected a provision or logger node');
 
         if BasicList_isNull(node.pChildren);
            numChildren = 0;
         else;
            numChildren = BasicList_getNumE(node.pChildren);
         endif;
 
         return numChildren;
 
      /END-FREE
     P                 E
      *
      *=======================================================================
      *  ***PRIVATE ***   (exported for internal use only)
      *  Returns a reference to a child of the specified node.
      *=======================================================================
      *  Parameters:
      *   i_hNode       - Handle of the node.
      *
      *  Returns:
      *   hChild        - Returns the handle of the child node on success,
      *                   else *NULL.
      *=======================================================================
     P Node_getChild...
     P                 B                   export
      *
     D Node_getChild...
     D                 PI                         like(LOG4RPG_hLogger_t   )
     D  i_hNode                            const  like(LOG4RPG_hLogger_t   )
     D  i_index                      10I 0 const
      *
      *  Return value
     D hChild          S                   like(LOG4RPG_hLogger_t   ) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(pLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pLogger = i_hNode;
 
         p_assert(logger.node = cLOG4RPG_NODE_PROVISION or
                  logger.node = cLOG4RPG_NODE_LOGGER
                  : 'Expected a provision or logger node');
 
         hChild = BasicList_getPointer(logger.pChildren: i_index);
 
         return hChild;
 
      /END-FREE
     P                 E
      *
      *=======================================================================
      *  ***PRIVATE ***   (exported for internal use only)
      *  Adds a child node to the specified node.
      *=======================================================================
      *  Parameters:
      *   i_hNode       - Handle of the node.
      *   i_hChild      - Handle of the child node.
      *
      *  Returns:
      *   numChildren   - Returns the index of the child node on success,
      *                   else -1.
      *=======================================================================
     P Node_addChild...
     P                 B                   export
     D                 PI            10I 0
     D  i_hNode                            const  like(LOG4RPG_hLogger_t   )
     D  i_hChild                           const  like(LOG4RPG_hLogger_t   )
      *
      *  Return value
     D index           S             10I 0 inz(-1)
      *
      *  Logger handle
     D node            DS                  likeds(LOG4RPG_logger_t )
     D                                     based(pNode)
     D child           DS                  likeds(LOG4RPG_logger_t )
     D                                     based(pChild)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pNode = i_hNode;
         pChild = i_hChild;
 
         index = BasicList_addPointer(node.pChildren: i_hChild);
         Node_setParent(i_hChild: i_hNode);
 
         return index;
 
      /END-FREE
     P                 E
      *
      *=======================================================================
      *  ***PRIVATE ***   (exported for internal use only)
      *  Sets the parent logger of the specified node.
      *=======================================================================
      *  Parameters:
      *   i_hNode       - Handle of the node.
      *   i_hParent     - Handle of the parent logger.
      *
      *  Returns:
      *   void
      *=======================================================================
     P Node_setParent...
     P                 B                   export
     D                 PI
     D  i_hNode                            const  like(LOG4RPG_hLogger_t )
     D  i_hParent                          const  like(LOG4RPG_hLogger_t )
      *
      *  Logger handle
     D node            DS                  likeds(LOG4RPG_logger_t )
     D                                     based(pNode)
     D parent          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(pParent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pNode = i_hNode;
         pParent = i_hParent;
 
         node.pParent = i_hParent;
 
      /END-FREE
     P                 E
      *
      *=======================================================================
      *  ***PRIVATE ***   (exported for internal use only)
      *  Returns the parent of a given node.
      *=======================================================================
      *  Parameters:
      *   i_hNode       - Handle of the node
      *
      *  Returns:
      *   hParent       - Handle of the parent node.
      *=======================================================================
     P Node_getParent...
     P                 B                   export
     D                 PI                         like(LOG4RPG_hLogger_t )
     D  i_hNode                            const  like(LOG4RPG_hLogger_t )
      *
      *  Logger handle
     D node            DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hNode)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return node.pParent;
 
      /END-FREE
     P                 E
      *
      *=======================================================================
      *  ***PRIVATE ***   (exported for internal use only)
      *  Removes a child from the list of children of the specified node.
      *=======================================================================
      *  Parameters:
      *   i_hNode       - Handle of the node.
      *   index         - Position of the child in the list of children.
      *
      *  Returns:
      *   rc            - Returns 0 un success, else -1.
      *=======================================================================
     P Node_removeChild...
     P                 B                   export
     D                 PI            10I 0
     D  i_hNode                            const  like(LOG4RPG_hLogger_t   )
     D  i_index                      10I 0 const
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Logger handle
     D node            DS                  likeds(LOG4RPG_logger_t )
     D                                     based(hNode)
     D child           DS                  likeds(LOG4RPG_logger_t )
     D                                     based(hChild)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         hNode = i_hNode;
 
         p_assert(node.node = cLOG4RPG_NODE_PROVISION or
                  node.node = cLOG4RPG_NODE_LOGGER
                  : 'Expected provision or logger nodes');
 
         hChild = BasicList_getPointer(node.pChildren: i_index);
 
         if (BasicList_remove(node.pChildren: i_index) = 0);
            Node_setParent(hChild: Logger_null());
            rc = 0;
         endif;
 
         return rc;
 
      /END-FREE
      *
     P                 E
      *
      *=======================================================================
      *  ***PRIVATE ***   (exported for internal use only)
      *  Searches the children of a given node for a given child.
      *=======================================================================
      *  Parameters:
      *   i_hNode       - Handle of the node.
      *   i_hChild      - Handle of the child node.
      *
      *  Returns:
      *   index         - Index of the child on success, else -1.
      *=======================================================================
     P Node_findChild...
     P                 B                   export
     D                 PI            10I 0
     D  i_hNode                            const  like(LOG4RPG_hLogger_t )
     D  i_hChild                           const  like(LOG4RPG_hLogger_t )
      *
      *  Helper fields
     D numChildren     S             10I 0 inz
     D x               S             10I 0 inz
      *
      *  Logger handle
     D node            DS                  likeds(LOG4RPG_logger_t )
     D                                     based(hNode)
     D child           DS                  likeds(LOG4RPG_logger_t )
     D                                     based(hChild)
     D curChild        DS                  likeds(LOG4RPG_logger_t )
     D                                     based(hCurChild)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         hNode = i_hNode;
         hChild = i_hChild;
 
         p_assert(node.node = cLOG4RPG_NODE_PROVISION or
                  node.node = cLOG4RPG_NODE_LOGGER
                  : 'Expected a provision or logger node');
 
         numChildren = BasicList_getNumE(node.pChildren);
 
         for x = 1 to numChildren;
            hCurChild = BasicList_getPointer(node.pChildren: x);
            if (hCurChild = i_hChild);
               return x;
            endif;
         endfor;
 
         return -1;
 
      /END-FREE
      *
     P                 E
      *
      *=========================================================================
      *  Tests the specified node handle for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_hNode       - Handle of the node.
      *
      *  Returns:
      *   isNull        - Returns TRUE if the node handle is NULL, else TRUE.
      *=========================================================================
     P Node_isNull...
     P                 B                   export
     D                 PI              N
     D  i_hNode                            const  like(LOG4RPG_hLogger_t )
      *
      *  Logger handle
     D node            DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hNode)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if i_hNode = Node_null();
            return cTrue;
         endif;
 
         return cFalse;
 
      /END-FREE
     P                 E
      *
      *=========================================================================
      *  Returns a node NULL handle.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   hNode         - Returns a NULL handle.
      *=========================================================================
     P Node_null...
     P                 B                   export
     D                 PI                         like(LOG4RPG_hLogger_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return *NULL;
 
      /END-FREE
     P                 E
      *
      *=========================================================================
      *  Returns a brief description of the node.
      *=========================================================================
      *  Parameters:
      *   i_hNode       - Handle of the node.
      *
      *  Returns:
      *   desc          - Brief description of the node.
      *=========================================================================
     P Node_toString...
     P                 B                   export
     D                 PI           117A          varying
     D  i_hNode                            const  like(LOG4RPG_hLogger_t   )
      *
      *  Return value
     D desc            S            117A   varying inz
     D appenders       S            117A   varying inz
      *
      *  Helper fields
     D priority        S                   like(node.priority)
     D pAppenderList   S                   like(LOG4RPG_pAppenderList_t) inz
     D appIter         DS                  likeds(LOG4RPG_Appender...
     D                                            ListIterator_t) inz
     D pAppender       S                   like(LOG4RPG_pAppender_t) inz
      *
      *  Logger handle
     D node            DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hNode)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         select;
         when Node_isLoggerNode(i_hNode);
            priority = getPriorityFromHierarchy(i_hNode);
            desc = 'Logger:' + Node_getName(i_hNode);
         when Node_isProvisionNode(i_hNode);
            priority = getPriorityFromHierarchy(i_hNode);
            desc = 'ProvNode:' + Node_getName(i_hNode);
         other;
            priority = -1;
            desc = '*** Unknown node type ***';
         endsl;
 
         if (priority = -1);
            return desc;
         endif;
 
         desc += ' [' + Level_toString(priority) + ']';
 
         pAppenderList = getAppenderListFromHierarchy(i_hNode);
         if AppenderList_isNull(pAppenderList);
            return desc;
         endif;
 
         appIter = AppenderList_getIterator(pAppenderList);
         pAppender = AppenderList_getFirst(appIter);
 
         dow (not Appender_isNull(pAppender));
            if (appenders = '');
               appenders = '; ';
            else;
               appenders += ',';
            endif;
            appenders += Appender_getName(pAppender);
            pAppender = AppenderList_getNext(appIter);
         enddo;
 
         desc += appenders;
 
         return desc;
 
      /END-FREE
     P                 E
      *
      *=========================================================================
    R *  ***PRIVATE ***   (exported for internal use only)
      *  Returns the number of children of the specified provision node.
      *  (provision nodes only)
      *=========================================================================
      *  Parameters:
      *   i_hProvNode   - Handle of the provision node as it was returned by
      *                   ProvisionNode_makeProvisionNode().
      *
      *  Returns:
      *   numChildren   - Returns the number of children of a provision
      *                   node on success, else -1.
      *=========================================================================
     P ProvisionNode_getNumChildren...
     P                 B                   export
      *
     D ProvisionNode_getNumChildren...
     D                 PI            10I 0
     D  i_hProvNode                        const  like(LOG4RPG_hLogger_t   )
      *
      *  Return value
     D numChildren     S             10I 0 inz(-1)
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hProvNode)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         p_assert(logger.node = cLOG4RPG_NODE_PROVISION
                  : 'Expected a provision node');
 
         numChildren = Node_getNumChildren(i_hProvNode);
 
         return numChildren;
 
      /END-FREE
      *
     P ProvisionNode_getNumChildren...
     P                 E
      *
      *=========================================================================
    R *  ***PRIVATE ***   (exported for internal use only)
      *  Adds a child node to the specified provision node.
      *  (provision nodes only)
      *=========================================================================
      *  Parameters:
      *   i_hProvNode   - Handle of the provision node as it was returned by
      *                   ProvisionNode_makeProvisionNode().
      *   i_hChild      - Handle of the child node.
      *
      *  Returns:
      *   numChildren   - Returns the index of the child node on success,
      *                   else -1.
      *=========================================================================
     P ProvisionNode_addChild...
     P                 B                   export
      *
     D ProvisionNode_addChild...
     D                 PI            10I 0
     D  i_hProvNode                        const  like(LOG4RPG_hLogger_t   )
     D  i_hChild                           const  like(LOG4RPG_hLogger_t   )
      *
      *  Return value
     D index           S             10I 0 inz(-1)
      *
      *  Helper fields
     D hChild          S                   like(i_hChild)
      *
      *  Logger handle
     D provNode        DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hProvNode)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         p_assert(provNode.node = cLOG4RPG_NODE_PROVISION
                  : 'Expected a provision node');
 
         index = Node_addChild(i_hProvNode: i_hChild);
 
         return index;
 
      /END-FREE
      *
     P ProvisionNode_addChild...
     P                 E
      *
      *=========================================================================
    R *  ***PRIVATE ***   (exported for internal use only)
      *  Returns a reference to a child of the specified provision node.
      *  (provision nodes only)
      *=========================================================================
      *  Parameters:
      *   i_hProvNode   - Handle of the provision node as it was returned by
      *                   ProvisionNode_makeProvisionNode().
      *
      *  Returns:
      *   hChild        - Returns the handle of the child node on success,
      *                   else *NULL.
      *=========================================================================
     P ProvisionNode_getChild...
     P                 B                   export
      *
     D ProvisionNode_getChild...
     D                 PI                         like(LOG4RPG_hLogger_t   )
     D  i_hProvNode                        const  like(LOG4RPG_hLogger_t   )
     D  i_index                      10I 0 const
      *
      *  Return value
     D hChild          S                   like(LOG4RPG_hLogger_t   ) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hProvNode)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         p_assert(logger.node = cLOG4RPG_NODE_PROVISION
                  : 'Expected a provision node');
 
         hChild = Node_getChild(i_hProvNode: i_index);
 
         return hChild;
 
      /END-FREE
      *
     P ProvisionNode_getChild...
     P                 E
      *
      *=========================================================================
    R *  ***PRIVATE ***   (exported for internal use only)
      *  Removes a child from the list of children of the specified provision node.
      *  (provision nodes only)
      *=========================================================================
      *  Parameters:
      *   i_hProvNode   - Handle of the provision node as it was returned by
      *                   ProvisionNode_makeProvisionNode().
      *   index         - Position of the child in the list of children.
      *
      *  Returns:
      *   rc            - Returns 0 un success, else -1.
      *=========================================================================
     P ProvisionNode_removeChild...
     P                 B                   export
      *
     D ProvisionNode_removeChild...
     D                 PI            10I 0
     D  i_hProvNode                        const  like(LOG4RPG_hLogger_t   )
     D  i_index                      10I 0 const
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hProvNode)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         p_assert(logger.node = cLOG4RPG_NODE_PROVISION
                  : 'Expected provision node only');
 
         rc = Node_removeChild(i_hProvNode: i_index);
 
         return rc;
 
      /END-FREE
      *
     P ProvisionNode_removeChild...
     P                 E
      *
      *=======================================================================
      *  ***PRIVATE ***   (exported for internal use only)
      *  Sets the parent logger of the specified logger.
      *=======================================================================
      *  Parameters:
      *   i_hProvNode   - Handle of the provision node.
      *   i_hParent     - Handle of the parent node.
      *
      *  Returns:
      *   void
      *=======================================================================
     P ProvisionNode_setParent...
     P                 B                   export
     D                 PI
     D  i_hProvNode                        const  like(LOG4RPG_hLogger_t )
     D  i_hParent                          const  like(LOG4RPG_hLogger_t )
      *
      *  Logger handle
     D provNode        DS                  likeds(LOG4RPG_logger_t )
     D                                     based(hProvNode)
     D parent          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(hParent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         hProvNode = i_hProvNode;
         hParent = i_hParent;
 
         p_assert(provNode.node = cLOG4RPG_NODE_PROVISION
                  : 'Expected a provision node');
 
         Node_setParent(i_hProvNode: i_hParent);
 
         if not Logger_isNull(i_hParent);
            LogLog_verbose('Set parent of provision node [' +
                                                    provNode.name + '] to ' +
                                              '[' + parent.name   + ']');
         else;
            LogLog_verbose('Set parent of provision node [' +
                                                    provNode.name + '] to ' +
                                                '[' + '*NULL'     + ']');
         endif;
 
      /END-FREE
     P                 E
      *
      *=======================================================================
      *  ***PRIVATE ***   (exported for internal use only)
      *  Returns the parent of the specified provision node.
      *=======================================================================
      *  Parameters:
      *   i_hProvNode   - Handle of the provision node.
      *
      *  Returns:
      *   hParent       - Handle of the parent logger.
      *=======================================================================
     P ProvisionNode_getParent...
     P                 B                   export
     D                 PI                         like(LOG4RPG_hLogger_t )
     D  i_hProvNode                        const  like(LOG4RPG_hLogger_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return Node_getParent(i_hProvNode);
 
      /END-FREE
     P                 E
      *
      *=========================================================================
    R *  ***PRIVATE ***   (exported for internal use only)
      *  Factory: Produces a provision node and adds a child to it.
      *=========================================================================
      *  Parameters:
      *   i_logName     - Name of the logger.
      *   i_hChild      - Handle of the child node.
      *
      *  Returns:
      *   hProvNode     - Handle of the provision node on success, else
      *                   a NULL handle.
      *=========================================================================
     P ProvisionNode_makeProvisionNode...
     P                 B                   export
      *
     D ProvisionNode_makeProvisionNode...
     D                 PI                         like(LOG4RPG_hLogger_t   )
     D  i_nodeName                         const  like(LOG4RPG_loggerName_t)
     D  i_hChild                           const  like(LOG4RPG_hLogger_t   )
      *
      *  Return value
     D provNode        DS                  likeds(LOG4RPG_logger_t )
     D                                     based(hProvNode)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_verbose('Creating provision node [' + i_nodeName + '] ...');
 
         hProvNode = Logger_null();
 
         hProvNode = %alloc(%size(LOG4RPG_logger_t));
 
         clearHandleData(provNode);
 
         initializeProvisionNodeHandle(provNode: i_nodeName);
 
         ProvisionNode_addChild(hProvNode: i_hChild);
 
         LogLog_verbose('+ Allocated memory for provision node [' +
                         i_nodeName + ']');
 
         return hProvNode;
 
      /END-FREE
      *
     P ProvisionNode_makeProvisionNode...
     P                 E
      *
      *=========================================================================
    R *  ***PRIVATE ***   (exported for internal use only)
      *  Frees a provision node.
      *=========================================================================
      *  Parameters:
      *   io_hProvNode  - Handle of the provision node as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *
      *  Returns:
      *   void
      *=========================================================================
     P ProvisionNode_free...
     P                 B                   export
      *
     D ProvisionNode_free...
     D                 PI
     D  io_hProvNode                              like(LOG4RPG_hLogger_t )
      *
      *  Helper fields
     D nodeName        S                   like(LOG4RPG_loggerName_t) inz
      *
      *  Node handle
     D provNode        DS                  likeds(LOG4RPG_logger_t)
     D                                     based(io_hProvNode)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if not Node_isProvisionNode(io_hProvNode);
            LogLog_error('Illegal node type passed to ' + f_this() +
                         ': [' + provNode.name + '('
                               + %char(provNode.node) + ')] ...');
         endif;
 
         LogLog_verbose('Deleting provision node [' +
                         provNode.name + '] ...');
 
         nodeName = provNode.name;
 
         p_assert(provNode.pAppenderList = AppenderList_null()
                  : 'Did not expect appender list on logger [' +
                     nodeName + ']');
 
         BasicList_delete(provNode.pChildren);
 
         clearHandleData(provNode);
 
         dealloc(N) io_hProvNode;
         io_hProvNode = Logger_null();
 
         LogLog_verbose('- Free memory of provision node [' + nodeName + ']');
 
         return;
 
      /END-FREE
      *
     P ProvisionNode_free...
     P                 E
      *
      *=======================================================================
      *  ***PRIVATE ***   (exported for internal use only)
      *  Moves the children to a given logger node.
      *=======================================================================
      *  Parameters:
      *   i_hProvNode   - Handle of the provision node.
      *   i_hLogger     - Handle of a logger that receices the children.
      *
      *  Returns:
      *   void
 
      *=======================================================================
     P ProvisionNode_moveChildren...
     P                 B                   export
     D                 PI
     D  i_hProvNode                               like(LOG4RPG_hLogger_t )
     D  i_hLogger                                 like(LOG4RPG_hLogger_t )
      *
      *  Return value
     D clone           DS                  likeds(LOG4RPG_logger_t)
     D                                     based(hClone)
      *
      *  Hellper fields
     D x               S             10I 0 inz
     D numChildren     S             10I 0 inz
      *
      *  Logger handle
     D provNode        DS                  likeds(LOG4RPG_logger_t)
     D                                     based(hProvNode)
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(hLogger)
     D child           DS                  likeds(LOG4RPG_logger_t)
     D                                     based(hChild)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         hProvNode = i_hProvNode;
         hLogger = i_hLogger;
 
 
         p_assert(provNode.node = cLOG4RPG_NODE_PROVISION
                  : 'Expected a provision node');
         p_assert(logger.node = cLOG4RPG_NODE_LOGGER
                  : 'Expected a logger node');
         p_assert(BasicList_getNumE(logger.pChildren) = 0:
                  'Logger must not yet have any hildren');
 
         numChildren = BasicList_getNumE(provNode.pChildren);
         for x = numChildren downto 1;
            hChild = BasicList_getPointer(provNode.pChildren: x);
            ProvisionNode_removeChild(i_hProvNode: x);
            Logger_addChild(i_hLogger: hChild);
         endfor;
 
         p_assert(BasicList_getNumE(provNode.pChildren) = 0:
                  'Provision node must not have any hildren');
         p_assert(BasicList_getNumE(logger.pChildren) = numChildren:
                  'Logger must have ' + %char(numChildren) + ' any children');
 
      /END-FREE
     P                 E
      *
      *=========================================================================
      *  Tests the specified provision node handle for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_hProvNode   - Handle of the provision node.
      *
      *  Returns:
      *   isNull        - Returns TRUE if the handle is NULL, else TRUE.
      *=========================================================================
     P ProvisionNode_isNull...
     P                 B                   export
     D                 PI              N
     D  i_hProvNode                        const  like(LOG4RPG_hLogger_t )
      *
      *  Logger handle
     D provNode        DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hProvNode)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         p_assert(i_hProvNode = *NULL or
                  provNode.node = cLOG4RPG_NODE_PROVISION
                  : 'Expected a provision node');
 
         return Node_isNull(i_hProvNode);
 
      /END-FREE
     P                 E
      *
      *=========================================================================
      *  Returns a provision node NULL handle.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   hProvNode     - Returns a NULL handle.
      *=========================================================================
     P ProvisionNode_null...
     P                 B                   export
     D                 PI                         like(LOG4RPG_hLogger_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return Node_null();
 
      /END-FREE
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Clears a given logger handle.
      *=========================================================================
     P clearHandleData...
     P                 B
      *
     D clearHandleData...
     D                 PI
     D  io_logger                                 likeds(LOG4RPG_logger_t)
      *
      *  Return value
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clear io_logger;
 
         return;
 
      /END-FREE
      *
     P clearHandleData...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Deletes a logger.
      *=========================================================================
     P deleteLogger...
     P                 B
      *
     D deleteLogger...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
      *
      *  Helper fields
     D logName         S                   like(LOG4RPG_loggerName_t    ) inz
     D appIter         DS                  likeds(LOG4RPG_Appender...
     D                                            ListIterator_t        ) inz
     D pAppender       S                   like(LOG4RPG_pAppender_t     ) inz
     D logger          DS                  likeds(LOG4RPG_logger_t      )
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         logName = logger.name;
 
         if logger.pAppenderList <> AppenderList_null();
            appIter = AppenderList_getIterator(logger.pAppenderList);
 
            dow AppenderList_getNumE(logger.pAppenderList) > 0;
               pAppender = AppenderList_getFirst(appIter);
               Logger_removeAppender(i_hLogger: Appender_getName(pAppender));
            enddo;
 
            AppenderList_delete(logger.pAppenderList);
         endif;
 
         clearHandleData(logger);
 
         return;
 
      /END-FREE
      *
     P deleteLogger...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Returns cTrue if logging is enabled.
      *=========================================================================
     P isLoggingEnabled...
     P                 B
      *
     D isLoggingEnabled...
     D                 PI              N
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(i_hLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return to caller if logging is disabled.
         if not Logger_isLogging();
            return cFalse;
         endif;
 
         // Return to caller if logger is NULL
         if Logger_isNull(i_hLogger);
            return cFalse;
         endif;
 
         // Reload properties (if reloading has been enabled)
         Configurator_checkAndReloadPropertiesConfiguration();
 
         // Return to caller if logger does not exist
         if not Repository_existLogger(logger.name);
            return cFalse;
         endif;
 
         return cTrue;
 
      /END-FREE
      *
     P isLoggingEnabled...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Returns the logging priority from the logger hierarchy.
      *=========================================================================
     P getPriorityFromHierarchy...
     P                 B
      *
     D getPriorityFromHierarchy...
     D                 PI                         like(LOG4RPG_priority_t  )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
      *
      *  Helper fields
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(pLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pLogger = i_hLogger;
 
         dow logger.priority = cLOG4RPG_LEVEL_PARENT;
            if logger.pParent = Logger_null();
               return cLOG4RPG_PRIORITY_NONE;
               leave;
            endif;
            pLogger = logger.pParent;
         enddo;
 
         return logger.priority;
 
      /END-FREE
      *
     P getPriorityFromHierarchy...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Logs the logging event.
      *=========================================================================
     P logLoggingEvent...
     P                 B
      *
     D logLoggingEvent...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
     D  i_priority                         const  like(LOG4RPG_priority_t  )
     D  i_text                             const  like(LOG4RPG_text_t      )
     D                                            options(*varsize)
     D  i_caller                           const  likeds(LOG4RPG_caller_t  )
     D  i_errMsg                           const  likeds(msg_t             )
     D                                            options(*nopass)
      *
      *  Parameter positions
     D p_errMsg        C                   5
      *
      *  Helper fields
     D isMsgRtvErr     S               N   inz(cFalse)
     D msgRtvErrText   S            128A   inz
      *
     D x               S             10I 0 inz
     D pPropList       S                   like(LOG4RPG_pPropertyList_t ) inz
     D pAppenderList   S                   like(LOG4RPG_pAppenderList_t ) inz
     D pAppender       S                   like(LOG4RPG_pAppender_t     ) inz
     D pLogEvent       S                   like(LOG4RPG_pLogEvent_t     ) inz
      *
     D appIter         DS                  likeds(LOG4RPG_Appender...
     D                                            ListIterator_t        ) inz
      *
      *  Logger handle
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(i_hLogger)
      *
      *  Structure for message data of CPF2419
     D CPF2419         DS                  qualified
     D  msgID                         7A
     D  msgF                         10A
     D  msgFLib                      10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pAppenderList = getAppenderListFromHierarchy(i_hLogger);
         if AppenderList_isNull(pAppenderList);
            if (logger.name = cROOT_LOGGER) and not g_warnRootNoAppender;
               LogLog_warning('No appenders could be found for logger [root]');
               LogLog_warning('Please initialize the log4rpg system properly.');
               g_warnRootNoAppender = cTrue;
            endif;
            return;
         endif;
 
         appIter = AppenderList_getIterator(pAppenderList);
         pAppender = AppenderList_getFirst(appIter);
 
         pLogEvent = LogEvent_new(logger.name
                                  : i_priority
                                  : ''
                                  : i_caller);
 
         if (%parms() >= p_errMsg);
            if (i_errMsg.ID = 'CPF2419');
               CPF2419 = i_errMsg.data;
               msgRtvErrText = 'Unable to retrieve message description of +
                                message ' + CPF2419.msgID +
                                ' from message file ' +
                                %trim(CPF2419.msgFLib) + '/' +
                                %trim(CPF2419.msgF);
               LogLog_error(msgRtvErrText);
               isMsgRtvErr = cTrue;
            endif;
         endif;
 
         dow not Appender_isNull(pAppender);
 
            if (isMsgRtvErr);
               LogEvent_setText(pLogEvent: msgRtvErrText);
            else;
               LogEvent_setText(pLogEvent: i_text);
            endif;
 
            Appender_doAppend(pAppender: pLogEvent);
            pAppender = AppenderList_getNext(appIter);
 
            pPropList = LogEvent_getPropertyList(pLogEvent);
            if not PropertyList_isNull(pPropList);
               PropertyList_clear(pPropList);
               LogLog_verbose('> Cleared property list of log event');
            endif;
 
         enddo;
 
         LogEvent_delete(pLogEvent);
 
         return;
 
      /END-FREE
      *
     P logLoggingEvent...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Returns the appender list from the logger hierarchy.
      *=========================================================================
     P getAppenderListFromHierarchy...
     P                 B
      *
     D getAppenderListFromHierarchy...
     D                 PI                         like(LOG4RPG_pAppenderList_t )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t       )
      *
      *  Helper fields
     D logger          DS                  likeds(LOG4RPG_logger_t )
     D                                     based(pLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pLogger = i_hLogger;
 
         dow logger.pAppenderList = AppenderList_null();
            if logger.pParent = Logger_null();
               return AppenderList_null();
               leave;
            endif;
            pLogger = logger.pParent;
         enddo;
 
         return logger.pAppenderList;
 
      /END-FREE
      *
     P getAppenderListFromHierarchy...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Initializes a given logger handle.
      *=========================================================================
      *  Parameters:
      *   i_logger      - Logger handle.
      *
      *  Returns:
      *   void
      *=========================================================================
     P initializeLoggerHandle...
     P                 B
      *
     D initializeLoggerHandle...
     D                 PI
     D  io_logger                                 likeds(LOG4RPG_logger_t  )
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clearHandleData(io_logger);
 
         io_logger.node         = cLOG4RPG_NODE_LOGGER;  // Logger node
         io_logger.pParent      = Logger_null();         // Parent logger
         io_logger.name         = i_logName;             // Logger name
         io_logger.priority     = cLOG4RPG_LEVEL_PARENT; // Use log level of parent logger
         io_logger.pAppenderList= AppenderList_null();   // Appender list
         io_logger.pChildren    = BasicList_new('*CHILDREN');// Children of logger node
 
         if i_logName = cROOT_LOGGER;
            io_logger.priority = Level_toInt(cLOG4RPG_LEVEL_DEBUG);
         endif;
 
         return;
 
      /END-FREE
      *
     P initializeLoggerHandle...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Initializes a given provision node handle.
      *=========================================================================
     P initializeProvisionNodeHandle...
     P                 B
      *
     D initializeProvisionNodeHandle...
     D                 PI
     D  io_provNode                               likeds(LOG4RPG_logger_t  )
     D  i_nodeName                         const  like(LOG4RPG_loggerName_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clearHandleData(io_provNode);
 
         io_provNode.node         = cLOG4RPG_NODE_PROVISION; // Provision node
         io_provNode.pParent      = Logger_null();           // No parent logger
         io_provNode.name         = i_nodeName;              // Node name
         io_provNode.priority     = cLOG4RPG_LEVEL_PARENT;   // Use log level of parent logg
         io_provNode.pAppenderList= AppenderList_null();     // No Appender list
         io_provNode.pChildren    = BasicList_new('*CHILDREN');// Children of provision node
 
         return;
 
      /END-FREE
      *
     P initializeProvisionNodeHandle...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Sets an offset to let f_caller() skip the Log4rpg stub module
      *  if present.
      *=========================================================================
     P setStubOfs...
     P                 B                   export
      *
     D setStubOfs...
     D                 PI
     D  i_stubOfs                     3I 0 const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         g_stubOfs = i_stubOfs;
 
         return;
 
      /END-FREE
      *
     P setStubOfs...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Initializes this module.
      *=========================================================================
     P initializeModule...
     P                 B
      *
     D initializeModule...
     D                 PI
      *
      *  Return value
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if g_isInit;
            return;
         endif;
 
         Loglog_verbose('Initializing module ' + sds.modContProc + '...');
 
         Repository_initialize();
 
         if not Repository_existLogger(cROOT_LOGGER);
            // Configurator_loadDefaultConfiguration();
         endif;
 
         g_isInit = cTrue;
 
         return;
 
      /END-FREE
      *
     P initializeModule...
     P                 E
      *
