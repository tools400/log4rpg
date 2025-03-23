      /IF NOT DEFINED(PLOG4RPG00)
      /DEFINE PLOG4RPG00
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      *
      *  Loads the LOG4RPG service program and forwards all requests to it.
     D LoggerStub_loadSrvPgm...
     D                 PR
     D                                     extproc('LOG4RPG00+
     D                                     _LoggerStub_loadSrvPgm+
     D                                     ')
      *
      * -----------------------------------------
      *  Logger:
      * -----------------------------------------
      *
      *  Enables / Disables LOG4RPG.
     D Impl_Logger_setLogging...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.setLogging
     D                                     )
     D  i_isLogging                    N   const
      *
      *  Returns whether logging is enabled or not.
     D Impl_Logger_isLogging...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.isLogging
     D                                     )
      *
      *  Returns the root logger.
     D Impl_Logger_getRootLogger...
     D                 PR
     D                                     like(LOG4RPG_hLogger_t)
     D                                     extproc(
     D                                     g_procptr.getRootLogger
     D                                     )
      *
      *  Returns a new logger named as the specified name.
     D Impl_Logger_getLogger...
     D                 PR
     D                                     like(LOG4RPG_hLogger_t)
     D                                     extproc(
     D                                     g_procptr.getLogger
     D                                     )
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      *
      *  Logs a DEBUG statement.
     D Impl_Logger_debug...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.debug
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_text                             const  like(LOG4RPG_text_t)
      *
      *  Logs a DEBUG message.
     D Impl_Logger_debugMsg...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.debugMsg
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_msg                              const  likeds(LOG4RPG_msg_t)
      *
      *  Logs an INFO statement.
     D Impl_Logger_info...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.info
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_text                             const  like(LOG4RPG_text_t)
      *
      *  Logs an INFO message.
     D Impl_Logger_infoMsg...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.infoMsg
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_msg                              const  likeds(LOG4RPG_msg_t)
      *
      *  Logs a WARN statement.
     D Impl_Logger_warn...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.warn
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_text                             const  like(LOG4RPG_text_t)
      *
      *  Logs a WARN message.
     D Impl_Logger_warnMsg...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.warnMsg
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_msg                              const  likeds(LOG4RPG_msg_t)
      *
      *  Logs an ERROR statement.
     D Impl_Logger_error...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.error
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_text                             const  like(LOG4RPG_text_t)
      *
      *  Logs an ERROR message.
     D Impl_Logger_errorMsg...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.errorMsg
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_msg                              const  likeds(LOG4RPG_msg_t)
      *
      *  Logs a FATAL error statement.
     D Impl_Logger_fatal...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.fatal
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_text                             const  like(LOG4RPG_text_t)
      *
      *  Logs a FATAL error message.
     D Impl_Logger_fatalMsg...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.fatalMsg
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_msg                              const  likeds(LOG4RPG_msg_t)
      *
      *  Logs the specified statement without further checking.
     D Impl_Logger_forcedLog...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.forcedLog
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_level                            const  like(LOG4RPG_level_t)
     D  i_text                             const  like(LOG4RPG_text_t)
      *
      *  Logs the specified message without further checking.
     D Impl_Logger_forcedLogMsg...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.forcedLogMsg
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_level                            const  like(LOG4RPG_level_t)
     D  i_msg                              const  likeds(LOG4RPG_msg_t)
      *
      *  Returns *ON if 'DEBUG' log events are logged.
     D Impl_Logger_isDebugEnabled...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.isDebugEnabled
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
      *
      *  Returns *ON if 'INFO' log events are logged.
      *  (Including DEBUG log events)
     D Impl_Logger_isInfoEnabled...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.isInfoEnabled
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
      *
      *  Returns *ON if 'WARN' log events are logged.
      *  (Including INFO and DEBUG log events)
     D Impl_Logger_isWarnEnabled...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.isWarnEnabled
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
      *
      *  Returns *ON if 'ERROR' log events are logged.
      *  (Including WARN, INFO and DEBUG log events)
     D Impl_Logger_isErrorEnabled...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.isErrorEnabled
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
      *
      *  Returns *ON if 'FATAL' log events are logged.
      *  (Including ERROR, WARN, INFO and DEBUG log events)
     D Impl_Logger_isFatalEnabled...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.isFatalEnabled
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
      *
      *  Returns the name of the specified logger.
     D Impl_Logger_getName...
     D                 PR                         like(LOG4RPG_loggerName_t)
     D                                     extproc(
     D                                     g_procptr.getName
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
      *
      *  Test the specified logger handle for a NULL value.
     D Impl_Logger_isNull...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.isNull
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
      *
      *  Returns a NULL handle.
     D Impl_Logger_null...
     D                 PR
     D                                     like(LOG4RPG_hLogger_t)
     D                                     extproc(
     D                                     g_procptr.null
     D                                     )
      *
      *  Sets the logging level of the specified logger.
     D Impl_Logger_setLevel...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.setLevel
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_level                            const  like(LOG4RPG_level_t)
      *
      *  Allows to enable/disable log4rpg internal logging.
     D Impl_Logger_setInternalDebugging...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.setInternalDebugging
     D                                     )
     D  i_debugMode                        const  like(LOG4RPG_debugMode_t)
     D  i_output                           const  like(LOG4RPG_debugOutput_t)
     D                                            options(*nopass)
      *
      *  Returns the internal debug mode.
     D Impl_Logger_getInternalDebugMode...
     D                 PR
     D                                     like(LOG4RPG_debugMode_t)
     D                                     extproc(
     D                                     g_procptr.getInternalDebugMode
     D                                     )
      *
      *  Returns the target for internal log events.
     D Impl_Logger_getInternalDebugOutput...
     D                 PR
     D                                     like(LOG4RPG_debugOutput_t)
     D                                     extproc(
     D                                     g_procptr.getInternalDebugOutput
     D                                     )
      *
      * -----------------------------------------
      *  Prototypes of 'Configurator'
      *  (copied from PLOG4RPG08)
      * -----------------------------------------
      *
      *  Loads a default configuration.
     D Impl_Configurator_loadDefaultConfiguration...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.load...
     D                                     DefaultConfiguration)
      *
      *  Configures LOG4RPG from a properties file.
     D Impl_Configurator_loadPropertiesConfiguration...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.load...
     D                                     PropertiesConfiguration)
     D  i_path                             const  like(LOG4RPG_path_t)
      *
      *  Configures LOG4RPG from a properties file. Watches the properties
      *  file for changes and reloads the configuration on changes.
     D Impl_Configurator_loadAndWatchPropertiesConfiguration...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.loadAndWatch...
     D                                     PropertiesConfiguration
     D                                     )
     D  i_path                             const  like(LOG4RPG_path_t)
     D  i_waitMinutes                10I 0 const  options(*nopass)
     D  i_unit                       10A   const  options(*nopass)
      *
      *  Clears all configuration data.
     D Impl_Configurator_clearConfiguration...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.clearConfiguration
     D                                     )
      *
      *  Creates a new layout.
     D Impl_Layout_new...
     D                 PR
     D                                     like(LOG4RPG_pLayout_t)
     D                                     extproc(
     D                                     g_procptr.Layout_new
     D                                     )
     D  i_layoutImpl                       const  like(LOG4RPG_implClass_t)
     D  i_pPropString                  *   const  options(*nopass:
     D                                                    *omit: *string)
      *
      *  Returns a NULL layout.
     D Impl_Layout_null...
     D                 PR
     D                                     like(LOG4RPG_pLayout_t)
     D                                     extproc(
     D                                     g_procptr.Layout_null
     D                                     )
      *
      *  Creates a new appender.
     D Impl_Appender_new...
     D                 PR
     D                                     like(LOG4RPG_pAppender_t)
     D                                     extproc(
     D                                     g_procptr.Appender_New
     D                                     )
     D  i_appName                          const  like(LOG4RPG_appenderName_t)
     D  i_appImpl                          const  like(LOG4RPG_implClass_t)
     D  i_pPropString                  *   const  options(*nopass:
     D                                                    *omit: *string)
      *
      *  Returns a NULL appender.
     D Impl_Appender_null...
     D                 PR
     D                                     like(LOG4RPG_pAppender_t)
     D                                     extproc(
     D                                     g_procptr.Appender_null
     D                                     )
      *
      *  Sets the layout for the specified appender.
     D Impl_Appender_setLayout...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.Appender_setLayout
     D                                     )
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t)
     D  i_pLayout                          const  like(LOG4RPG_pLayout_t)
      *
      *  Sets the filter for the specified appender.
     D Impl_Appender_setFilter...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.Appender_setFilter
     D                                     )
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t)
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t)
      *
      *  Adds an appender to the specified logger.
     D Impl_Logger_addAppender...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.Logger_addAppender
     D                                     )
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_hAppender                        const  like(LOG4RPG_pAppender_t)
      *
      *  Creates a new filter.
     D Impl_Filter_new...
     D                 PR
     D                                     like(LOG4RPG_pFilter_t)
     D                                     extproc(
     D                                     g_procptr.Filter_new
     D                                     )
     D  i_fltName                          const  like(LOG4RPG_filterName_t)
     D  i_fltImpl                          const  like(LOG4RPG_implClass_t)
     D  i_pPropString                  *   const  options(*nopass:
     D                                                    *omit: *string)
      *
      *  Returns a NULL filter.
     D Impl_Filter_null...
     D                 PR
     D                                     like(LOG4RPG_pFilter_t)
     D                                     extproc(
     D                                     g_procptr.Filter_null
     D                                     )
      *
      *  Sets the next filter of the filter chain.
     D Impl_Filter_setNext...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.Filter_setNext
     D                                     )
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t)
     D  i_pNextFilter                      const  like(LOG4RPG_pFilter_t)
      *
      /ENDIF
