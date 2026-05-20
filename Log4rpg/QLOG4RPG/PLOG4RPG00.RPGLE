**FREE
/IF NOT DEFINED(PLOG4RPG00)
/DEFINE PLOG4RPG00
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
//
//  Loads the LOG4RPG service program and forwards all requests to it.
dcl-pr LoggerStub_loadSrvPgm
       extproc('LOG4RPG00+
       _LoggerStub_loadSrvPgm+
       ');
end-pr;
//
// -----------------------------------------
//  Logger:
// -----------------------------------------
//
//  Enables / Disables LOG4RPG.
dcl-pr Impl_Logger_setLogging
       ind
       extproc(
       g_procptr.setLogging
       );
  i_isLogging     ind const;
end-pr;
//
//  Returns whether logging is enabled or not.
dcl-pr Impl_Logger_isLogging
       ind
       extproc(
       g_procptr.isLogging
       );
end-pr;
//
//  Returns the root logger.
dcl-pr Impl_Logger_getRootLogger
       like(LOG4RPG_hLogger_t)
       extproc(
       g_procptr.getRootLogger
       );
end-pr;
//
//  Returns a new logger named as the specified name.
dcl-pr Impl_Logger_getLogger
       like(LOG4RPG_hLogger_t)
       extproc(
       g_procptr.getLogger
       );
  i_logName       const  like(LOG4RPG_loggerName_t);
end-pr;
//
//  Logs a DEBUG statement.
dcl-pr Impl_Logger_debug
       extproc(
       g_procptr.debug
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_text          const  like(LOG4RPG_text_t);
end-pr;
//
//  Logs a DEBUG message.
dcl-pr Impl_Logger_debugMsg
       extproc(
       g_procptr.debugMsg
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_msg           const  likeds(LOG4RPG_msg_t);
end-pr;
//
//  Logs an INFO statement.
dcl-pr Impl_Logger_info
       extproc(
       g_procptr.info
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_text          const  like(LOG4RPG_text_t);
end-pr;
//
//  Logs an INFO message.
dcl-pr Impl_Logger_infoMsg
       extproc(
       g_procptr.infoMsg
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_msg           const  likeds(LOG4RPG_msg_t);
end-pr;
//
//  Logs a WARN statement.
dcl-pr Impl_Logger_warn
       extproc(
       g_procptr.warn
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_text          const  like(LOG4RPG_text_t);
end-pr;
//
//  Logs a WARN message.
dcl-pr Impl_Logger_warnMsg
       extproc(
       g_procptr.warnMsg
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_msg           const  likeds(LOG4RPG_msg_t);
end-pr;
//
//  Logs an ERROR statement.
dcl-pr Impl_Logger_error
       extproc(
       g_procptr.error
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_text          const  like(LOG4RPG_text_t);
end-pr;
//
//  Logs an ERROR message.
dcl-pr Impl_Logger_errorMsg
       extproc(
       g_procptr.errorMsg
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_msg           const  likeds(LOG4RPG_msg_t);
end-pr;
//
//  Logs a FATAL error statement.
dcl-pr Impl_Logger_fatal
       extproc(
       g_procptr.fatal
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_text          const  like(LOG4RPG_text_t);
end-pr;
//
//  Logs a FATAL error message.
dcl-pr Impl_Logger_fatalMsg
       extproc(
       g_procptr.fatalMsg
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_msg           const  likeds(LOG4RPG_msg_t);
end-pr;
//
//  Logs the specified statement without further checking.
dcl-pr Impl_Logger_forcedLog
       extproc(
       g_procptr.forcedLog
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_level         const  like(LOG4RPG_level_t);
  i_text          const  like(LOG4RPG_text_t);
end-pr;
//
//  Logs the specified message without further checking.
dcl-pr Impl_Logger_forcedLogMsg
       extproc(
       g_procptr.forcedLogMsg
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_level         const  like(LOG4RPG_level_t);
  i_msg           const  likeds(LOG4RPG_msg_t);
end-pr;
//
//  Returns *ON if 'DEBUG' log events are logged.
dcl-pr Impl_Logger_isDebugEnabled
       ind
       extproc(
       g_procptr.isDebugEnabled
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
end-pr;
//
//  Returns *ON if 'INFO' log events are logged.
//  (Including DEBUG log events)
dcl-pr Impl_Logger_isInfoEnabled
       ind
       extproc(
       g_procptr.isInfoEnabled
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
end-pr;
//
//  Returns *ON if 'WARN' log events are logged.
//  (Including INFO and DEBUG log events)
dcl-pr Impl_Logger_isWarnEnabled
       ind
       extproc(
       g_procptr.isWarnEnabled
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
end-pr;
//
//  Returns *ON if 'ERROR' log events are logged.
//  (Including WARN, INFO and DEBUG log events)
dcl-pr Impl_Logger_isErrorEnabled
       ind
       extproc(
       g_procptr.isErrorEnabled
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
end-pr;
//
//  Returns *ON if 'FATAL' log events are logged.
//  (Including ERROR, WARN, INFO and DEBUG log events)
dcl-pr Impl_Logger_isFatalEnabled
       ind
       extproc(
       g_procptr.isFatalEnabled
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
end-pr;
//
//  Returns the name of the specified logger.
dcl-pr Impl_Logger_getName
       like(LOG4RPG_loggerName_t)
       extproc(
       g_procptr.getName
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
end-pr;
//
//  Test the specified logger handle for a NULL value.
dcl-pr Impl_Logger_isNull
       ind
       extproc(
       g_procptr.isNull
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
end-pr;
//
//  Returns a NULL handle.
dcl-pr Impl_Logger_null
       like(LOG4RPG_hLogger_t)
       extproc(
       g_procptr.null
       );
end-pr;
//
//  Sets the logging level of the specified logger.
dcl-pr Impl_Logger_setLevel
       extproc(
       g_procptr.setLevel
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_level         const  like(LOG4RPG_level_t);
end-pr;
//
//  Allows to enable/disable log4rpg internal logging.
dcl-pr Impl_Logger_setInternalDebugging
       extproc(
       g_procptr.setInternalDebugging
       );
  i_debugMode     const  like(LOG4RPG_debugMode_t);
  i_output        const  like(LOG4RPG_debugOutput_t)
       options(*nopass);
end-pr;
//
//  Returns the internal debug mode.
dcl-pr Impl_Logger_getInternalDebugMode
       like(LOG4RPG_debugMode_t)
       extproc(
       g_procptr.getInternalDebugMode
       );
end-pr;
//
//  Returns the target for internal log events.
dcl-pr Impl_Logger_getInternalDebugOutput
       like(LOG4RPG_debugOutput_t)
       extproc(
       g_procptr.getInternalDebugOutput
       );
end-pr;
//
// -----------------------------------------
//  Prototypes of 'Configurator'
//  (copied from PLOG4RPG08)
// -----------------------------------------
//
//  Loads a default configuration.
dcl-pr Impl_Configurator_loadDefaultConfiguration
       ind
       extproc(
       g_procptr.load...
       DefaultConfiguration);
end-pr;
//
//  Configures LOG4RPG from a properties file.
dcl-pr Impl_Configurator_loadPropertiesConfiguration
       ind
       extproc(
       g_procptr.load...
       PropertiesConfiguration);
  i_path          const  like(LOG4RPG_path_t);
end-pr;
//
//  Configures LOG4RPG from a properties file. Watches the properties
//  file for changes and reloads the configuration on changes.
dcl-pr Impl_Configurator_loadAndWatchPropertiesConfiguration
       ind
       extproc(
       g_procptr.loadAndWatch...
       PropertiesConfiguration
       );
  i_path          const  like(LOG4RPG_path_t);
  i_waitMinutes   int(10) const  options(*nopass);
  i_unit          char(10) const  options(*nopass);
end-pr;
//
//  Clears all configuration data.
dcl-pr Impl_Configurator_clearConfiguration
       extproc(
       g_procptr.clearConfiguration
       );
end-pr;
//
//  Creates a new layout.
dcl-pr Impl_Layout_new
       like(LOG4RPG_pLayout_t)
       extproc(
       g_procptr.Layout_new
       );
  i_layoutImpl    const  like(LOG4RPG_implClass_t);
  i_pPropString   pointer const  options(*nopass:
       *omit: *string);
end-pr;
//
//  Returns a NULL layout.
dcl-pr Impl_Layout_null
       like(LOG4RPG_pLayout_t)
       extproc(
       g_procptr.Layout_null
       );
end-pr;
//
//  Creates a new appender.
dcl-pr Impl_Appender_new
       like(LOG4RPG_pAppender_t)
       extproc(
       g_procptr.Appender_New
       );
  i_appName       const  like(LOG4RPG_appenderName_t);
  i_appImpl       const  like(LOG4RPG_implClass_t);
  i_pPropString   pointer const  options(*nopass:
       *omit: *string);
end-pr;
//
//  Returns a NULL appender.
dcl-pr Impl_Appender_null
       like(LOG4RPG_pAppender_t)
       extproc(
       g_procptr.Appender_null
       );
end-pr;
//
//  Sets the layout for the specified appender.
dcl-pr Impl_Appender_setLayout
       ind
       extproc(
       g_procptr.Appender_setLayout
       );
  i_pAppender     const  like(LOG4RPG_pAppender_t);
  i_pLayout       const  like(LOG4RPG_pLayout_t);
end-pr;
//
//  Sets the filter for the specified appender.
dcl-pr Impl_Appender_setFilter
       ind
       extproc(
       g_procptr.Appender_setFilter
       );
  i_pAppender     const  like(LOG4RPG_pAppender_t);
  i_pFilter       const  like(LOG4RPG_pFilter_t);
end-pr;
//
//  Adds an appender to the specified logger.
dcl-pr Impl_Logger_addAppender
       extproc(
       g_procptr.Logger_addAppender
       );
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_hAppender     const  like(LOG4RPG_pAppender_t);
end-pr;
//
//  Creates a new filter.
dcl-pr Impl_Filter_new
       like(LOG4RPG_pFilter_t)
       extproc(
       g_procptr.Filter_new
       );
  i_fltName       const  like(LOG4RPG_filterName_t);
  i_fltImpl       const  like(LOG4RPG_implClass_t);
  i_pPropString   pointer const  options(*nopass:
       *omit: *string);
end-pr;
//
//  Returns a NULL filter.
dcl-pr Impl_Filter_null
       like(LOG4RPG_pFilter_t)
       extproc(
       g_procptr.Filter_null
       );
end-pr;
//
//  Sets the next filter of the filter chain.
dcl-pr Impl_Filter_setNext
       extproc(
       g_procptr.Filter_setNext
       );
  i_pFilter       const  like(LOG4RPG_pFilter_t);
  i_pNextFilter   const  like(LOG4RPG_pFilter_t);
end-pr;
//
/ENDIF
