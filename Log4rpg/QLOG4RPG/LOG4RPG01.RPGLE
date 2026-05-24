**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Logger                                           *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  13.06.2006                                              *
//  E-mail  :  thomas.raddatz@tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  17.10.2006  Th.Raddatz    Fixed that Logger_addAppender() failed   *
//                            when attempting to add an appender to    *
//                            the appender list.                       *
//                                                                     *
//  25.10.2006  Th.Raddatz    Replaced data structure logEvent with    *
//                            object LogEvent.                         *
//                                                                     *
//  27.10.2006  Th.Raddatz    Added feature to completely enable/      *
//                            disable Log4rpg. Logger_setLogging().    *
//                                                                     *
//  15.11.2006  Th.Raddatz    Added procedures:                        *
//                            Logger_getInternalDebugMode()            *
//                            Logger_getInternalDebugOutput()          *
//                                                                     *
//  11.12.2007  Th.Raddatz    Fixed RNX0100 (Length or start position  *
//                            is out of range) error in                *
//                            logLoggingEvent() when the message       *
//                            description could be retrieved.          *
//                                                                     *
//  18.04.2008  Th.Raddatz    Added support to reload the configuration*
//                            data every n minutes:                    *
//                            Configurator_checkAndReload...()         *
//                                                                     *
//  13.06.2008  Th.Raddatz    Changed Log4rpg to log empty messages.   *
//                            Enhanced the Log4rpg stub module         *
//                            to optionally load the Log4rpg service   *
//                            program and forward procedure calls      *
//                            to it. Added setStubOfs() to let the     *
//                            stub module set an offset to let         *
//                            f_caller() skip the stub module.         *
//                                                                     *
//  20.06.2008  Th.Raddatz    Added procedure Logger_resetLevel().     *
//                                                                     *
//  15.09.2008  Th.Raddatz    Changed parameter i_appName of procedure *
//                            Logger_addAppender() to i_pAppender.     *
//                                                                     *
//  20.05.2011  Th.Raddatz    Fixed problem that the following         *
//                            procedures did not return a return value *
//                            if logging was disabled:                 *
//                               Logger_getInternalDebugMode()         *
//                               LogLog_getInternalDebugOutput()       *
//                                                                     *
//  29.06.2011  Th.Raddatz    Added procedures:                        *
//                               Logger_isDebugEnabled()               *
//                               Logger_isInfoEnabled()                *
//                               Logger_isWarnEnabled()                *
//                               Logger_isErrorEnabled()               *
//                               Logger_isFatalEnabled()               *
//                                                                     *
//  15.07.2011  Th.Raddatz    Changed the logging procedures to use    *
//                            the Logger_is*Enabled() procedures       *
//                            rather than checking all the stuff by    *
//                            themselves.                              *
//                                                                     *
//  15.07.2011  Th.Raddatz    Added call of Repository_dumpHierarchy().*
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//                                                                     *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) +                     *
//                              SRCMBR(&SM);                           *
//                                                                     *
//     >>COMPILE<<                                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TGTRLS(V7R3M0  );                                    *
//     >>END-COMPILE<<                                                 *
//                                                                     *
//     >>EXECUTE<<                                                     *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
/copy QLOG4RPG,H_SPEC
/copy QLOG4RPG,COPYRIGHT
//=====================================================================*
//
// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG Public interface & type definitions
/copy QLOG4RPG,PLOG4RPG01 Logger

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PTYPES Private type definitions

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QBASICS1,PBASICS1 Basic RPG Extensions
/copy QLOG4RPG,PLOG4RPG04 AppenderList
/copy QLOG4RPG,PLOG4RPG08 Configurator
/copy QLOG4RPG,PLOG4RPG09 Level
/copy QLOG4RPG,PLOG4RPG10 LogLog
/copy QLOG4RPG,PLOG4RPG13 Repository
/copy QLOG4RPG,PLOG4RPG16 LogEvent
/copy QLOG4RPG,PLOG4RPG99 Helpers

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Deletes a logger.
dcl-pr deleteLogger;
  i_hLogger like(LOG4RPG_hLogger_t) const;
end-pr;

//  Returns *ON if logging is enabled.
dcl-pr isLoggingEnabled ind;
  i_hLogger like(LOG4RPG_hLogger_t) const;
end-pr;

//  Returns the logging priority from the logger hierarchy.
dcl-pr getPriorityFromHierarchy like(LOG4RPG_priority_t);
  i_hLogger like(LOG4RPG_hLogger_t) const;
end-pr;

//  Logs the logging event.
dcl-pr logLoggingEvent;
  i_hLogger  like(LOG4RPG_hLogger_t) const;
  i_priority like(LOG4RPG_priority_t) const;
  i_text     like(LOG4RPG_text_t) options(*varsize) const;
  i_caller   likeds(LOG4RPG_caller_t) const;
  i_errMsg   likeds(msg_t) options(*nopass) const;
end-pr;

//  Returns the appender list from the logger hierarchy.
dcl-pr getAppenderListFromHierarchy like(LOG4RPG_pAppenderList_t);
  i_hLogger like(LOG4RPG_hLogger_t) const;
end-pr;

//  Initializes a given logger handle.
dcl-pr initializeLoggerHandle;
  io_logger likeds(LOG4RPG_logger_t);
  i_logName like(LOG4RPG_loggerName_t) const;
end-pr;

//  Initializes a given provision node handle.
dcl-pr initializeProvisionNodeHandle;
  io_provNode likeds(LOG4RPG_logger_t);
  i_logName   like(LOG4RPG_loggerName_t) const;
end-pr;

//  Clears a given logger handle.
dcl-pr clearHandleData;
  io_logger likeds(LOG4RPG_logger_t);
end-pr;

//  Checks, if the Log4rpg stub module is present and returns an offset
//  for the f_caller() procdure to skip the stub module.
dcl-pr getStubOfs int(3);
end-pr;

//  Initializes this module.
dcl-pr initializeModule;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cLOG4RPG_LEVEL_NONE -2;
dcl-c cLOG4RPG_LEVEL_PARENT -1;

dcl-c cLOG4RPG_NODE_LOGGER 1;
dcl-c cLOG4RPG_NODE_PROVISION 2;

// -----------------------------------------
//  Global fields
// -----------------------------------------
dcl-s g_isLogging ind inz(*on);
dcl-s g_isInit ind inz(*off);
dcl-s g_warnRootNoAppender ind inz(*off);
dcl-s g_stubOfs int(3) inz(0);

// -----------------------------------------
//  Program status data structure
// -----------------------------------------
/define SDS_EXTENDED
/copy QLOG4RPG,SDS
/undefine SDS_EXTENDED

//=========================================================================
//  Enables / Disables LOG4RPG.
//=========================================================================
//  Parameters:
//   i_isLogging   - Specifies whether LOG4RPG is active or not.
//                   *OFF completely disables LOG4RPG.
//
//  Returns:
//   currentState  - Returns the current state of LOG4RPG.
//                   1 = ON, 0 = OFF.
//=========================================================================
dcl-proc Logger_setLogging export;
  dcl-pi *n ind;
    i_isLogging ind const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if i_isLogging;
    g_isLogging = *on;
    LogLog_verbose('LOG4RPG is enabled now.');
  else;
    g_isLogging = *off;
    LogLog_verbose('LOG4RPG is disabled now.');
  endif;

  return g_isLogging;


end-proc;

//=========================================================================
//  Returns whether logging is enabled or not.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   isLogging     - Returns TRUE if logging is enabled, else FALSE.
//=========================================================================
dcl-proc Logger_isLogging export;
  dcl-pi *n ind;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if g_isLogging;
    return *on;
  else;
    return *off;
  endif;


end-proc;

//=========================================================================
//  Returns the root logger.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   hLogger       - Handle of the root logger on success, else
//                   a NULL handle.
//=========================================================================
dcl-proc Logger_getRootLogger export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
  end-pi;

  //  Return value
  dcl-s hLogger like(LOG4RPG_hLogger_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return Logger_getLogger(cROOT_LOGGER);


end-proc;

//=========================================================================
//  Returns a new logger named as the specified name.
//=========================================================================
//  Parameters:
//   i_logName     - Name of the logger.
//
//  Returns:
//   hLogger       - Handle of the logger on success, else
//                   a NULL handle.
//=========================================================================
dcl-proc Logger_getLogger export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
    i_logName like(LOG4RPG_loggerName_t) const;
  end-pi;

  //  Return value
  dcl-s hLogger like(LOG4RPG_hLogger_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Return to caller if logging is disabled.
  if not Logger_isLogging();
    return Logger_null();
  endif;

  initializeModule();

  Configurator_checkAndReloadPropertiesConfiguration();

  hLogger = Repository_getLogger(translateLoggerName(i_logName));

  return hLogger;


end-proc;

//=========================================================================
//  Logs a DEBUG statement.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_text        - Statement text, that is written to the log.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_debug export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_text    like(LOG4RPG_text_t) const;
  end-pi;

  //  Caller
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Logs a DEBUG message.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_msg         - Message, that is written to the log.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_debugMsg export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_msg     likeds(LOG4RPG_msg_t) const;
  end-pi;

  //  Caller
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);

  //  Error message
  dcl-ds errMsg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Returns *ON if 'DEBUG' log events are logged.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//
//  Returns:
//   isEnabled     - *ON if 'DEBUG' log events are logged, else *OFF.
//=========================================================================
dcl-proc Logger_isDebugEnabled export;
  dcl-pi *n ind;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Return value
  dcl-s isEnabled ind inz(*off);

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Return to caller if logging is disabled.
  if (not isLoggingEnabled(i_hLogger));
    return *off;
  endif;

  isEnabled =
     cLOG4RPG_PRIORITY_DEBUG >= getPriorityFromHierarchy(i_hLogger);

  return isEnabled;


end-proc;

//=========================================================================
//  Logs an INFO statement.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_text        - Statement text, that is written to the log.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_info export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_text    like(LOG4RPG_text_t) const;
  end-pi;

  //  Caller
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Logs an INFO message.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_msg         - Message, that is written to the log.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_infoMsg export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_msg     likeds(LOG4RPG_msg_t) const;
  end-pi;

  //  Caller
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);

  //  Error message
  dcl-ds errMsg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Returns *ON if 'INFO' log events are logged.
//  (Including DEBUG log events)
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//
//  Returns:
//   isEnabled     - *ON if 'INFO' log events are logged, else *OFF.
//=========================================================================
dcl-proc Logger_isInfoEnabled export;
  dcl-pi *n ind;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Return value
  dcl-s isEnabled ind inz(*off);

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Return to caller if logging is disabled.
  if (not isLoggingEnabled(i_hLogger));
    return *off;
  endif;

  isEnabled =
     cLOG4RPG_PRIORITY_INFO >= getPriorityFromHierarchy(i_hLogger);

  return isEnabled;


end-proc;

//=========================================================================
//  Logs a WARN statement.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_text        - Statement text, that is written to the log.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_warn export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_text    like(LOG4RPG_text_t) const;
  end-pi;

  //  Caller
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Logs a WARN message.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_msg         - Message, that is written to the log.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_warnMsg export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_msg     likeds(LOG4RPG_msg_t) const;
  end-pi;

  //  Caller
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);

  //  Error message
  dcl-ds errMsg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Returns *ON if 'WARN' log events are logged.
//  (Including INFO and DEBUG log events)
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//
//  Returns:
//   isEnabled     - *ON if 'WARN' log events are logged, else *OFF.
//=========================================================================
dcl-proc Logger_isWarnEnabled export;
  dcl-pi *n ind;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Return value
  dcl-s isEnabled ind inz(*off);

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Return to caller if logging is disabled.
  if (not isLoggingEnabled(i_hLogger));
    return *off;
  endif;

  isEnabled =
     cLOG4RPG_PRIORITY_WARN >= getPriorityFromHierarchy(i_hLogger);

  return isEnabled;


end-proc;

//=========================================================================
//  Logs an ERROR statement.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_text        - Statement text, that is written to the log.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_error export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_text    like(LOG4RPG_text_t) const;
  end-pi;

  //  Caller
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Logs an ERROR message.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_msg         - Message, that is written to the log.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_errorMsg export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_msg     likeds(LOG4RPG_msg_t) const;
  end-pi;

  //  Caller
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);

  //  Error message
  dcl-ds errMsg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Returns *ON if 'ERROR' log events are logged.
//  (Including WARN, INFO and DEBUG log events)
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//
//  Returns:
//   isEnabled     - *ON if 'ERROR' log events are logged, else *OFF.
//=========================================================================
dcl-proc Logger_isErrorEnabled export;
  dcl-pi *n ind;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Return value
  dcl-s isEnabled ind inz(*off);

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Return to caller if logging is disabled.
  if (not isLoggingEnabled(i_hLogger));
    return *off;
  endif;

  isEnabled =
     cLOG4RPG_PRIORITY_ERROR >= getPriorityFromHierarchy(i_hLogger);

  return isEnabled;


end-proc;

//=========================================================================
//  Logs a FATAL error statement.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_text        - Statement text, that is written to the log.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_fatal export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_text    like(LOG4RPG_text_t) const;
  end-pi;

  //  Caller
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Logs a FATAL error message.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_msg         - Message, that is written to the log.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_fatalMsg export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_msg     likeds(LOG4RPG_msg_t) const;
  end-pi;

  //  Caller
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);

  //  Error message
  dcl-ds errMsg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Returns *ON if 'FATAL' log events are logged.
//  (Including ERROR, WARN, INFO and DEBUG log events)
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//
//  Returns:
//   isEnabled     - *ON if 'FATAL' log events are logged, else *OFF.
//=========================================================================
dcl-proc Logger_isFatalEnabled export;
  dcl-pi *n ind;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Return value
  dcl-s isEnabled ind inz(*off);

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Return to caller if logging is disabled.
  if (not isLoggingEnabled(i_hLogger));
    return *off;
  endif;

  isEnabled =
     cLOG4RPG_PRIORITY_FATAL >= getPriorityFromHierarchy(i_hLogger);

  return isEnabled;


end-proc;

//=========================================================================
//  Logs the specified statement without further checking.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_text        - Statement text, that is written to the log.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_forcedLog export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_level   like(LOG4RPG_level_t) const;
    i_text    like(LOG4RPG_text_t) const;
  end-pi;

  //  Caller
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Logs the specified message without further checking.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_msg         - Message, that is written to the log.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_forcedLogMsg export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_level   like(LOG4RPG_level_t) const;
    i_msg     likeds(LOG4RPG_msg_t) const;
  end-pi;

  //  Caller
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);

  //  Error message
  dcl-ds errMsg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
                     : caller
                     : errMsg);

  return;


end-proc;

//=========================================================================
//  Returns the name of the specified logger.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//
//  Returns:
//   logName       - Returns the name of the logger on success, else ''.
//=========================================================================
dcl-proc Logger_getName export;
  dcl-pi *n like(LOG4RPG_loggerName_t);
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Return to caller if logging is disabled.
  if not Logger_isLogging();
    return '';
  endif;

  return Node_getName(i_hLogger);


end-proc;

//=========================================================================
//  Adds an appender to the specified logger.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_appName     - The name of the appender.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_addAppender export;
  dcl-pi *n;
    i_hLogger   like(LOG4RPG_hLogger_t) const;
    i_pAppender like(LOG4RPG_pAppender_t) const;
  end-pi;

  //  Helper fields
  dcl-s appName like(LOG4RPG_appenderName_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Removes the specified appender from a given logger.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_appName     - Name of the appender that is removed from the logger.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_removeAppender export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_appName like(LOG4RPG_appenderName_t) const;
  end-pi;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Removes all appenders from the specified logger.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_removeAllAppenders export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Helper fields
  dcl-ds appIter likeds(LOG4RPG_PropertyListIterator_t) inz;
  dcl-s pAppender like(LOG4RPG_pAppender_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Tests the specified logger handle for a NULL value.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//
//  Returns:
//   isNull        - Returns TRUE if the logger handle is NULL, else TRUE.
//=========================================================================
dcl-proc Logger_isNull export;
  dcl-pi *n ind;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  p_assert(i_hLogger = *NULL or
           logger.node = cLOG4RPG_NODE_LOGGER
           : 'Expected a logger node');

  return Node_isNull(i_hLogger);

end-proc;

//=========================================================================
//  Returns a logger NULL handle.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   hLogger       - Returns a NULL handle.
//=========================================================================
dcl-proc Logger_null export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return *NULL;

end-proc;

//=========================================================================
//  Sets the logging level of the specified logger.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_level       - Logging level. Can be one of these value:
//                      cLOG4RPG_LEVEL_DEBUG
//                      cLOG4RPG_LEVEL_INFO
//                      cLOG4RPG_LEVEL_WARN
//                      cLOG4RPG_LEVEL_ERROR
//                      cLOG4RPG_LEVEL_FATAL
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_setLevel export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_level   like(LOG4RPG_level_t) const;
  end-pi;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Resets the logging level of the specified logger to use the
//  log level of the parent logger.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_resetLevel export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Allows to enable/disable log4rpg internal logging.
//=========================================================================
//  Parameters:
//   i_debugMode   - Specifies the debug mode for the log4rpg
//                   internal logging.
//   i_output      - Specifies the output target for the log events.
//
//  Returns:
//   void
//
//  Remark:          This setting affects the complete LOG4RPG system.
//=========================================================================
dcl-proc Logger_setInternalDebugging export;
  dcl-pi *n;
    i_debugMode like(LOG4RPG_debugMode_t) const;
    i_output    like(LOG4RPG_debugOutput_t) options(*nopass) const;
  end-pi;

  //  Parameter positions
  dcl-c p_output 2;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Returns the internal debug mode.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   debugMode     - Mode of the internal logging.
//=========================================================================
dcl-proc Logger_getInternalDebugMode export;
  dcl-pi *n like(LOG4RPG_debugMode_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Return to caller if logging is disabled.
  if not Logger_isLogging();
    return '';
  endif;

  return LogLog_getInternalDebugMode();


end-proc;

//=========================================================================
//  Returns the target for internal log events.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   output        - Output target for internal log events.
//=========================================================================
dcl-proc Logger_getInternalDebugOutput export;
  dcl-pi *n like(LOG4RPG_debugOutput_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Return to caller if logging is disabled.
  if not Logger_isLogging();
    return '';
  endif;

  return LogLog_getInternalDebugOutput();


end-proc;

//=========================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Creates a new logger instance.
//=========================================================================
//  Parameters:
//   i_logName     - Name of the logger.
//
//  Returns:
//   hLogger       - Handle of the logger on success, else
//                   a NULL handle.
//=========================================================================
dcl-proc Logger_new export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
    i_logName like(LOG4RPG_loggerName_t) const;
  end-pi;

  //  Return value
  dcl-s hLogger like(LOG4RPG_hLogger_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LogLog_debug('Creating logger [' + i_logName + '] ...');

  hLogger = %alloc(%size(LOG4RPG_logger_t));

  initializeLoggerHandle(logger: i_logName);

  LogLog_verbose('+ Allocated memory for logger [' + logger.name + ']');

  return hLogger;


end-proc;

//=========================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Deletes the specified logger.
//=========================================================================
//  Parameters:
//   io_hLogger    - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_delete export;
  dcl-pi *n;
    io_hLogger like(LOG4RPG_hLogger_t);
  end-pi;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(io_hLogger);

  //  Helper fields
  dcl-s name like(logger.name) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=======================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Adds a child node to the specified logger node.
//  (logger nodes only)
//=======================================================================
//  Parameters:
//   i_hLoggerNode - Handle of the logger node as it was returned by
//                   Logger_getLogger().
//   i_hChild      - Handle of the child node.
//
//  Returns:
//   numChildren   - Returns the index of the child node on success,
//                   else -1.
//=======================================================================
dcl-proc Logger_addChild export;
  dcl-pi *n int(10);
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_hChild  like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Return value
  dcl-s index int(10) inz(-1);

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  hLogger = i_hLogger;

  p_assert(logger.node = cLOG4RPG_NODE_LOGGER
           : 'Expected a logger node');

  index = Node_addChild(i_hLogger: i_hChild);

  return index;

end-proc;

//=========================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Sets the parent logger of the specified logger.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//   i_hParent     - Handle of the parent logger.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Logger_setParent export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_hParent like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  dcl-ds parent likeds(LOG4RPG_logger_t) based(i_hParent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Returns the parent of the specified logger.
//=========================================================================
//  Parameters:
//   i_hLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//
//  Returns:
//   hParent       - Handle of the parent logger.
//=========================================================================
dcl-proc Logger_getParent export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return Node_getParent(i_hLogger);


end-proc;

//=======================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Returns the name of a given node.
//=======================================================================
//  Parameters:
//   i_hNode       - Handle of the node.
//
//  Returns:
//   name          - Returns the name of the node.
//=======================================================================
dcl-proc Node_getName export;
  dcl-pi *n like(LOG4RPG_loggerName_t);
    i_hNode like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Logger handle
  dcl-ds node likeds(LOG4RPG_logger_t) based(hNode);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Return to caller if logger is NULL
  if Node_isNull(i_hNode);
    return '';
  endif;

  hNode = i_hNode;

  return node.name;

end-proc;

//=========================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Tests the specified node handle for a provision node.
//=========================================================================
//  Parameters:
//   i_hNode       - Handle of the node as it was returned by
//                   Logger_getLogger(), Logger_getRootLogger() or
//                   ProvisionNode_makeProvisionNode().
//
//  Returns:
//   isProvNode    - Returns TRUE if the handle is a provision node
//                   handle, else FALSE.
//=========================================================================
dcl-proc Node_isProvisionNode export;
  dcl-pi *n ind;
    i_hNode like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hNode);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Return to caller if logger is NULL
  if Node_isNull(i_hNode);
    return *off;
  else;
    if logger.node <> cLOG4RPG_NODE_PROVISION;
      return *off;
    endif;
  endif;

  return *on;


end-proc;

//=========================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Tests the specified node handle for a logger node.
//=========================================================================
//  Parameters:
//   i_hNode       - Handle of the node as it was returned by
//                   Logger_getLogger(), Logger_getRootLogger() or
//                   ProvisionNode_makeProvisionNode().
//
//  Returns:
//   isLoggerNode  - Returns TRUE if the handle is a logger node
//                   handle, else FALSE.
//=========================================================================
dcl-proc Node_isLoggerNode export;
  dcl-pi *n ind;
    i_hNode like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hNode);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Return to caller if logger is NULL
  if Node_isNull(i_hNode);
    return *off;
  else;
    if logger.node <> cLOG4RPG_NODE_LOGGER;
      return *off;
    endif;
  endif;

  return *on;


end-proc;

//=======================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Returns the number of children of the specified node.
//  (all nodes)
//=======================================================================
//  Parameters:
//   i_hProvNode   - Handle of the node.
//
//  Returns:
//   numChildren   - Returns the number of children of a
//                   node on success, else -1.
//=======================================================================
dcl-proc Node_getNumChildren export;
  dcl-pi *n int(10);
    i_hNode like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Return value
  dcl-s numChildren int(10) inz(-1);

  //  Logger handle
  dcl-ds node likeds(LOG4RPG_logger_t) based(pNode);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

end-proc;

//=======================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Returns a reference to a child of the specified node.
//=======================================================================
//  Parameters:
//   i_hNode       - Handle of the node.
//
//  Returns:
//   hChild        - Returns the handle of the child node on success,
//                   else *NULL.
//=======================================================================
dcl-proc Node_getChild export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
    i_hNode like(LOG4RPG_hLogger_t) const;
    i_index int(10) const;
  end-pi;

  //  Return value
  dcl-s hChild like(LOG4RPG_hLogger_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(pLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pLogger = i_hNode;

  p_assert(logger.node = cLOG4RPG_NODE_PROVISION or
           logger.node = cLOG4RPG_NODE_LOGGER
           : 'Expected a provision or logger node');

  hChild = BasicList_getPointer(logger.pChildren: i_index);

  return hChild;

end-proc;

//=======================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Adds a child node to the specified node.
//=======================================================================
//  Parameters:
//   i_hNode       - Handle of the node.
//   i_hChild      - Handle of the child node.
//
//  Returns:
//   numChildren   - Returns the index of the child node on success,
//                   else -1.
//=======================================================================
dcl-proc Node_addChild export;
  dcl-pi *n int(10);
    i_hNode  like(LOG4RPG_hLogger_t) const;
    i_hChild like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Return value
  dcl-s index int(10) inz(-1);

  //  Logger handle
  dcl-ds node likeds(LOG4RPG_logger_t) based(pNode);
  dcl-ds child likeds(LOG4RPG_logger_t) based(pChild);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pNode = i_hNode;
  pChild = i_hChild;

  index = BasicList_addPointer(node.pChildren: i_hChild);
  Node_setParent(i_hChild: i_hNode);

  return index;

end-proc;

//=======================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Sets the parent logger of the specified node.
//=======================================================================
//  Parameters:
//   i_hNode       - Handle of the node.
//   i_hParent     - Handle of the parent logger.
//
//  Returns:
//   void
//=======================================================================
dcl-proc Node_setParent export;
  dcl-pi *n;
    i_hNode   like(LOG4RPG_hLogger_t) const;
    i_hParent like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Logger handle
  dcl-ds node likeds(LOG4RPG_logger_t) based(pNode);
  dcl-ds parent likeds(LOG4RPG_logger_t) based(pParent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pNode = i_hNode;
  pParent = i_hParent;

  node.pParent = i_hParent;

end-proc;

//=======================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Returns the parent of a given node.
//=======================================================================
//  Parameters:
//   i_hNode       - Handle of the node
//
//  Returns:
//   hParent       - Handle of the parent node.
//=======================================================================
dcl-proc Node_getParent export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
    i_hNode like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Logger handle
  dcl-ds node likeds(LOG4RPG_logger_t) based(i_hNode);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return node.pParent;

end-proc;

//=======================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Removes a child from the list of children of the specified node.
//=======================================================================
//  Parameters:
//   i_hNode       - Handle of the node.
//   index         - Position of the child in the list of children.
//
//  Returns:
//   rc            - Returns 0 un success, else -1.
//=======================================================================
dcl-proc Node_removeChild export;
  dcl-pi *n int(10);
    i_hNode like(LOG4RPG_hLogger_t) const;
    i_index int(10) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Logger handle
  dcl-ds node likeds(LOG4RPG_logger_t) based(hNode);
  dcl-ds child likeds(LOG4RPG_logger_t) based(hChild);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=======================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Searches the children of a given node for a given child.
//=======================================================================
//  Parameters:
//   i_hNode       - Handle of the node.
//   i_hChild      - Handle of the child node.
//
//  Returns:
//   index         - Index of the child on success, else -1.
//=======================================================================
dcl-proc Node_findChild export;
  dcl-pi *n int(10);
    i_hNode  like(LOG4RPG_hLogger_t) const;
    i_hChild like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Helper fields
  dcl-s numChildren int(10) inz;
  dcl-s x int(10) inz;

  //  Logger handle
  dcl-ds node likeds(LOG4RPG_logger_t) based(hNode);
  dcl-ds child likeds(LOG4RPG_logger_t) based(hChild);
  dcl-ds curChild likeds(LOG4RPG_logger_t) based(hCurChild);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Tests the specified node handle for a NULL value.
//=========================================================================
//  Parameters:
//   i_hNode       - Handle of the node.
//
//  Returns:
//   isNull        - Returns TRUE if the node handle is NULL, else TRUE.
//=========================================================================
dcl-proc Node_isNull export;
  dcl-pi *n ind;
    i_hNode like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Logger handle
  dcl-ds node likeds(LOG4RPG_logger_t) based(i_hNode);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if i_hNode = Node_null();
    return *on;
  endif;

  return *off;

end-proc;

//=========================================================================
//  Returns a node NULL handle.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   hNode         - Returns a NULL handle.
//=========================================================================
dcl-proc Node_null export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return *NULL;

end-proc;

//=========================================================================
//  Returns a brief description of the node.
//=========================================================================
//  Parameters:
//   i_hNode       - Handle of the node.
//
//  Returns:
//   desc          - Brief description of the node.
//=========================================================================
dcl-proc Node_toString export;
  dcl-pi *n varchar(117);
    i_hNode like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Return value
  dcl-s desc varchar(117) inz;
  dcl-s appenders varchar(117) inz;

  //  Helper fields
  dcl-s priority like(node.priority);
  dcl-s pAppenderList like(LOG4RPG_pAppenderList_t) inz;
  dcl-ds appIter likeds(LOG4RPG_PropertyListIterator_t) inz;
  dcl-s pAppender like(LOG4RPG_pAppender_t) inz;

  //  Logger handle
  dcl-ds node likeds(LOG4RPG_logger_t) based(i_hNode);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

end-proc;

//=========================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Returns the number of children of the specified provision node.
//  (provision nodes only)
//=========================================================================
//  Parameters:
//   i_hProvNode   - Handle of the provision node as it was returned by
//                   ProvisionNode_makeProvisionNode().
//
//  Returns:
//   numChildren   - Returns the number of children of a provision
//                   node on success, else -1.
//=========================================================================
dcl-proc ProvisionNode_getNumChildren export;
  dcl-pi *n int(10);
    i_hProvNode like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Return value
  dcl-s numChildren int(10) inz(-1);

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hProvNode);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  p_assert(logger.node = cLOG4RPG_NODE_PROVISION
           : 'Expected a provision node');

  numChildren = Node_getNumChildren(i_hProvNode);

  return numChildren;


end-proc;

//=========================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Adds a child node to the specified provision node.
//  (provision nodes only)
//=========================================================================
//  Parameters:
//   i_hProvNode   - Handle of the provision node as it was returned by
//                   ProvisionNode_makeProvisionNode().
//   i_hChild      - Handle of the child node.
//
//  Returns:
//   numChildren   - Returns the index of the child node on success,
//                   else -1.
//=========================================================================
dcl-proc ProvisionNode_addChild export;
  dcl-pi *n int(10);
    i_hProvNode like(LOG4RPG_hLogger_t) const;
    i_hChild    like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Return value
  dcl-s index int(10) inz(-1);

  //  Helper fields
  dcl-s hChild like(i_hChild);

  //  Logger handle
  dcl-ds provNode likeds(LOG4RPG_logger_t) based(i_hProvNode);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  p_assert(provNode.node = cLOG4RPG_NODE_PROVISION
           : 'Expected a provision node');

  index = Node_addChild(i_hProvNode: i_hChild);

  return index;


end-proc;

//=========================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Returns a reference to a child of the specified provision node.
//  (provision nodes only)
//=========================================================================
//  Parameters:
//   i_hProvNode   - Handle of the provision node as it was returned by
//                   ProvisionNode_makeProvisionNode().
//
//  Returns:
//   hChild        - Returns the handle of the child node on success,
//                   else *NULL.
//=========================================================================
dcl-proc ProvisionNode_getChild export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
    i_hProvNode like(LOG4RPG_hLogger_t) const;
    i_index     int(10) const;
  end-pi;

  //  Return value
  dcl-s hChild like(LOG4RPG_hLogger_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hProvNode);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  p_assert(logger.node = cLOG4RPG_NODE_PROVISION
           : 'Expected a provision node');

  hChild = Node_getChild(i_hProvNode: i_index);

  return hChild;


end-proc;

//=========================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Removes a child from the list of children of the specified provision node.
//  (provision nodes only)
//=========================================================================
//  Parameters:
//   i_hProvNode   - Handle of the provision node as it was returned by
//                   ProvisionNode_makeProvisionNode().
//   index         - Position of the child in the list of children.
//
//  Returns:
//   rc            - Returns 0 un success, else -1.
//=========================================================================
dcl-proc ProvisionNode_removeChild export;
  dcl-pi *n int(10);
    i_hProvNode like(LOG4RPG_hLogger_t) const;
    i_index     int(10) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hProvNode);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  p_assert(logger.node = cLOG4RPG_NODE_PROVISION
           : 'Expected provision node only');

  rc = Node_removeChild(i_hProvNode: i_index);

  return rc;


end-proc;

//=======================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Sets the parent logger of the specified logger.
//=======================================================================
//  Parameters:
//   i_hProvNode   - Handle of the provision node.
//   i_hParent     - Handle of the parent node.
//
//  Returns:
//   void
//=======================================================================
dcl-proc ProvisionNode_setParent export;
  dcl-pi *n;
    i_hProvNode like(LOG4RPG_hLogger_t) const;
    i_hParent   like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Logger handle
  dcl-ds provNode likeds(LOG4RPG_logger_t) based(hProvNode);
  dcl-ds parent likeds(LOG4RPG_logger_t) based(hParent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

end-proc;

//=======================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Returns the parent of the specified provision node.
//=======================================================================
//  Parameters:
//   i_hProvNode   - Handle of the provision node.
//
//  Returns:
//   hParent       - Handle of the parent logger.
//=======================================================================
dcl-proc ProvisionNode_getParent export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
    i_hProvNode like(LOG4RPG_hLogger_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return Node_getParent(i_hProvNode);

end-proc;

//=========================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Factory: Produces a provision node and adds a child to it.
//=========================================================================
//  Parameters:
//   i_logName     - Name of the logger.
//   i_hChild      - Handle of the child node.
//
//  Returns:
//   hProvNode     - Handle of the provision node on success, else
//                   a NULL handle.
//=========================================================================
dcl-proc ProvisionNode_makeProvisionNode export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
    i_nodeName like(LOG4RPG_loggerName_t) const;
    i_hChild   like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Return value
  dcl-ds provNode likeds(LOG4RPG_logger_t) based(hProvNode);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LogLog_verbose('Creating provision node [' + i_nodeName + '] ...');

  hProvNode = Logger_null();

  hProvNode = %alloc(%size(LOG4RPG_logger_t));

  clearHandleData(provNode);

  initializeProvisionNodeHandle(provNode: i_nodeName);

  ProvisionNode_addChild(hProvNode: i_hChild);

  LogLog_verbose('+ Allocated memory for provision node [' +
                  i_nodeName + ']');

  return hProvNode;


end-proc;

//=========================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Frees a provision node.
//=========================================================================
//  Parameters:
//   io_hProvNode  - Handle of the provision node as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//
//  Returns:
//   void
//=========================================================================
dcl-proc ProvisionNode_free export;
  dcl-pi *n;
    io_hProvNode like(LOG4RPG_hLogger_t);
  end-pi;

  //  Helper fields
  dcl-s nodeName like(LOG4RPG_loggerName_t) inz;

  //  Node handle
  dcl-ds provNode likeds(LOG4RPG_logger_t) based(io_hProvNode);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=======================================================================
//  ***PRIVATE ***   (exported for internal use only)
//  Moves the children to a given logger node.
//=======================================================================
//  Parameters:
//   i_hProvNode   - Handle of the provision node.
//   i_hLogger     - Handle of a logger that receices the children.

//  Returns:
//   void

//=======================================================================
dcl-proc ProvisionNode_moveChildren export;
  dcl-pi *n;
    i_hProvNode like(LOG4RPG_hLogger_t);
    i_hLogger   like(LOG4RPG_hLogger_t);
  end-pi;

  //  Return value
  dcl-ds clone likeds(LOG4RPG_logger_t) based(hClone);

  //  Hellper fields
  dcl-s x int(10) inz;
  dcl-s numChildren int(10) inz;

  //  Logger handle
  dcl-ds provNode likeds(LOG4RPG_logger_t) based(hProvNode);
  dcl-ds logger likeds(LOG4RPG_logger_t) based(hLogger);
  dcl-ds child likeds(LOG4RPG_logger_t) based(hChild);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

end-proc;

//=========================================================================
//  Tests the specified provision node handle for a NULL value.
//=========================================================================
//  Parameters:
//   i_hProvNode   - Handle of the provision node.
//
//  Returns:
//   isNull        - Returns TRUE if the handle is NULL, else TRUE.
//=========================================================================
dcl-proc ProvisionNode_isNull export;
  dcl-pi *n ind;
    i_hProvNode like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Logger handle
  dcl-ds provNode likeds(LOG4RPG_logger_t) based(i_hProvNode);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  p_assert(i_hProvNode = *NULL or
           provNode.node = cLOG4RPG_NODE_PROVISION
           : 'Expected a provision node');

  return Node_isNull(i_hProvNode);

end-proc;

//=========================================================================
//  Returns a provision node NULL handle.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   hProvNode     - Returns a NULL handle.
//=========================================================================
dcl-proc ProvisionNode_null export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return Node_null();

end-proc;

//=========================================================================
//  *** Private ***
//  Clears a given logger handle.
//=========================================================================
dcl-proc clearHandleData;
  dcl-pi *n;
    io_logger likeds(LOG4RPG_logger_t);
  end-pi;

  //  Return value
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear io_logger;

  return;


end-proc;

//=========================================================================
//  *** Private ***
//  Deletes a logger.
//=========================================================================
dcl-proc deleteLogger;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Helper fields
  dcl-s logName like(LOG4RPG_loggerName_t) inz;
  dcl-ds appIter likeds(LOG4RPG_PropertyListIterator_t) inz;
  dcl-s pAppender like(LOG4RPG_pAppender_t) inz;
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  *** Private ***
//  Returns *ON if logging is enabled.
//=========================================================================
dcl-proc isLoggingEnabled;
  dcl-pi *n ind;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Return to caller if logging is disabled.
  if not Logger_isLogging();
    return *off;
  endif;

  // Return to caller if logger is NULL
  if Logger_isNull(i_hLogger);
    return *off;
  endif;

  // Reload properties (if reloading has been enabled)
  Configurator_checkAndReloadPropertiesConfiguration();

  // Return to caller if logger does not exist
  if not Repository_existLogger(logger.name);
    return *off;
  endif;

  return *on;


end-proc;

//=========================================================================
//  *** Private ***
//  Returns the logging priority from the logger hierarchy.
//=========================================================================
dcl-proc getPriorityFromHierarchy;
  dcl-pi *n like(LOG4RPG_priority_t);
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Helper fields
  dcl-ds logger likeds(LOG4RPG_logger_t) based(pLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pLogger = i_hLogger;

  dow logger.priority = cLOG4RPG_LEVEL_PARENT;
    if logger.pParent = Logger_null();
      return cLOG4RPG_PRIORITY_NONE;
      leave;
    endif;
    pLogger = logger.pParent;
  enddo;

  return logger.priority;


end-proc;

//=========================================================================
//  *** Private ***
//  Logs the logging event.
//=========================================================================
dcl-proc logLoggingEvent;
  dcl-pi *n;
    i_hLogger  like(LOG4RPG_hLogger_t) const;
    i_priority like(LOG4RPG_priority_t) const;
    i_text     like(LOG4RPG_text_t) options(*varsize) const;
    i_caller   likeds(LOG4RPG_caller_t) const;
    i_errMsg   likeds(msg_t) options(*nopass) const;
  end-pi;

  //  Parameter positions
  dcl-c p_errMsg 5;

  //  Helper fields
  dcl-s isMsgRtvErr ind inz(*off);
  dcl-s msgRtvErrText char(128) inz;

  dcl-s x int(10) inz;
  dcl-s pPropList like(LOG4RPG_pPropertyList_t) inz;
  dcl-s pAppenderList like(LOG4RPG_pAppenderList_t) inz;
  dcl-s pAppender like(LOG4RPG_pAppender_t) inz;
  dcl-s pLogEvent like(LOG4RPG_pLogEvent_t) inz;

  dcl-ds appIter likeds(LOG4RPG_PropertyListIterator_t) inz;

  //  Logger handle
  dcl-ds logger likeds(LOG4RPG_logger_t) based(i_hLogger);

  //  Structure for message data of CPF2419
  dcl-ds CPF2419 qualified;
    msgID   char(7);
    msgF    char(10);
    msgFLib char(10);
  end-ds;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pAppenderList = getAppenderListFromHierarchy(i_hLogger);
  if AppenderList_isNull(pAppenderList);
    if (logger.name = cROOT_LOGGER) and not g_warnRootNoAppender;
      LogLog_warning('No appenders could be found for logger [root]');
      LogLog_warning('Please initialize the log4rpg system properly.');
      g_warnRootNoAppender = *on;
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
      isMsgRtvErr = *on;
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


end-proc;

//=========================================================================
//  *** Private ***
//  Returns the appender list from the logger hierarchy.
//=========================================================================
dcl-proc getAppenderListFromHierarchy;
  dcl-pi *n like(LOG4RPG_pAppenderList_t);
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;

  //  Helper fields
  dcl-ds logger likeds(LOG4RPG_logger_t) based(pLogger);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pLogger = i_hLogger;

  dow logger.pAppenderList = AppenderList_null();
    if logger.pParent = Logger_null();
      return AppenderList_null();
      leave;
    endif;
    pLogger = logger.pParent;
  enddo;

  return logger.pAppenderList;


end-proc;

//=========================================================================
//  *** private ***
//  Initializes a given logger handle.
//=========================================================================
//  Parameters:
//   i_logger      - Logger handle.
//
//  Returns:
//   void
//=========================================================================
dcl-proc initializeLoggerHandle;
  dcl-pi *n;
    io_logger likeds(LOG4RPG_logger_t);
    i_logName like(LOG4RPG_loggerName_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  *** private ***
//  Initializes a given provision node handle.
//=========================================================================
dcl-proc initializeProvisionNodeHandle;
  dcl-pi *n;
    io_provNode likeds(LOG4RPG_logger_t);
    i_nodeName  like(LOG4RPG_loggerName_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clearHandleData(io_provNode);

  io_provNode.node         = cLOG4RPG_NODE_PROVISION; // Provision node
  io_provNode.pParent      = Logger_null();           // No parent logger
  io_provNode.name         = i_nodeName;              // Node name
  io_provNode.priority     = cLOG4RPG_LEVEL_PARENT;   // Use log level of parent logg
  io_provNode.pAppenderList= AppenderList_null();     // No Appender list
  io_provNode.pChildren    = BasicList_new('*CHILDREN');// Children of provision node

  return;


end-proc;

//=========================================================================
//  *** private ***
//  Sets an offset to let f_caller() skip the Log4rpg stub module
//  if present.
//=========================================================================
dcl-proc setStubOfs export;
  dcl-pi *n;
    i_stubOfs int(3) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_stubOfs = i_stubOfs;

  return;


end-proc;

//=========================================================================
//  *** private ***
//  Initializes this module.
//=========================================================================
dcl-proc initializeModule;
  dcl-pi *n;
  end-pi;

  //  Return value
  //
  //  Helper fields
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if g_isInit;
    return;
  endif;

  Loglog_verbose('Initializing module ' + sds.modContProc + '...');

  Repository_initialize();

  if not Repository_existLogger(cROOT_LOGGER);
  // Configurator_loadDefaultConfiguration();
  endif;

  g_isInit = *on;

  return;


end-proc;
