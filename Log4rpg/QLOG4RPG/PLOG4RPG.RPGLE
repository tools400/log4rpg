      /IF NOT DEFINED(PLOG4RPG)
      /DEFINE PLOG4RPG
      *
      /IF NOT DEFINED(LOGGER_STUB)
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,FDMSG
      *
      * -----------------------------------------
      *  Type Definitions
      * -----------------------------------------
     D LOG4RPG_text_t...
     D                 S           2048A   varying             based(pDummy)
      *
     D LOG4RPG_msg_t...
     D                 DS                  likeds(msg_t    )   based(pDummy)
      *
     D LOG4RPG_header_t...
     D                 S           4096A   varying             based(pDummy)
      *
     D LOG4RPG_footer_t...
     D                 S                   like(LOG4RPG_header_t)
     D                                                         based(pDummy)
      *
     D LOG4RPG_formattedText_t...
     D                 S           4096A   varying             based(pDummy)
      *
     D cLOG4RPG_MAX_TEXT_LENGTH...
     D                 C                   const(4096)
      *
     D LOG4RPG_level_t...
     D                 S             10A   varying             based(pDummy)
     D LOG4RPG_priority_t...
     D                 S             10I 0                     based(pDummy)
     D LOG4RPG_hLogger_t...
     D                 S               *                       based(pDummy)
     D LOG4RPG_loggerName_t...
     D                 S            128A   varying             based(pDummy)
     D LOG4RPG_debugMode_t...
     D                 S             10A   varying             based(pDummy)
     D LOG4RPG_debugOutput_t...
     D                 S             10A   varying             based(pDummy)
     D LOG4RPG_path_t...
     D                 S            256A   varying             based(pDummy)
     D LOG4RPG_implClass_t...
     D                 S            128A   varying             based(pDummy)
      *
     D LOG4RPG_pAppender_t...
     D                 S               *                           based(pDummy)
     D LOG4RPG_appenderName_t...
     D                 S             32A   varying             based(pDummy)
     D LOG4RPG_pFilter_t...
     D                 S               *                           based(pDummy)
     D LOG4RPG_filterName_t...
     D                 S             32A   varying                 based(pDummy)
     D LOG4RPG_pLayout_t...
     D                 S               *                           based(pDummy)
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      *  Special value *SEARCH for the library name when loading properties from
      *  a physical file member. When *SEARCH is specified as the library name,
      *  all files in the library list that matches the specified file name are
      *  searched for the member. The first member that is found is used to load
      *  the configuration data.
     D cLOG4RPG_LIB_SEARCH...
     D                 C                   const('*SEARCH')
      *
      *  Default time to wait (in minutes) to check the properties file for changes.
     D cLOG4RPG_CONFIGURATION_DEFAULT_RELOAD_DELAY...
     D                 C                   const(1)
     D cLOG4RPG_CONFIGURATION_DEFAULT_RELOAD_DELAY_UNIT...
     D                 C                   const('*MINUTES')
      *
      *  Debug Level:                 log4rpg.loggerName=
     D cLOG4RPG_LEVEL_DEBUG...
     D                 C                   const('DEBUG')
     D cLOG4RPG_LEVEL_INFO...
     D                 C                   const('INFO')
     D cLOG4RPG_LEVEL_WARN...
     D                 C                   const('WARN')
     D cLOG4RPG_LEVEL_ERROR...
     D                 C                   const('ERROR')
     D cLOG4RPG_LEVEL_FATAL...
     D                 C                   const('FATAL')
      *
      *  Debug mode:                 log4rpg.debug=
     D cLOG4RPG_DEBUG_QUIET...
     D                 C                   const('quiet')
     D cLOG4RPG_DEBUG_OFF...
     D                 C                   const('off')
     D cLOG4RPG_DEBUG_ON...
     D                 C                   const('on')
     D cLOG4RPG_DEBUG_VERBOSE...
     D                 C                   const('verbose')
      *
      *  Debug output:               log4rpg.debug=
     D cLOG4RPG_DEBUG_OUTPUT_PRINTER...
     D                 C                   const('printer')
     D cLOG4RPG_DEBUG_OUTPUT_STDOUT...
     D                 C                   const('stdout')
      *
      *  Boolean values
      /IF NOT DEFINED(cTrue)
      /DEFINE cTrue
     D cTrue           C                   const(*on )
      /ENDIF
      *
      /IF NOT DEFINED(cFalse)
      /DEFINE cFalse
     D cFalse          C                   const(*off)
      /ENDIF
      *
      /ENDIF
      *
      * -----------------------------------------
      *  Logger:
      * -----------------------------------------
      *
      *  Enables / Disables LOG4RPG.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_setLogging...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_setLogging+
     D                                     ')
      /ELSE
     D Impl_Logger_setLogging...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.setLogging
     D                                     )
      /ENDIF
     D  i_isLogging                    N   const
      *
      *  Returns whether logging is enabled or not.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_isLogging...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_isLogging+
     D                                     ')
      /ELSE
     D Impl_Logger_isLogging...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.isLogging
     D                                     )
      /ENDIF
      *
      *  Returns the root logger.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_getRootLogger...
     D                 PR                         like(LOG4RPG_hLogger_t )
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_getRootLogger+
     D                                     ')
      /ELSE
     D Impl_Logger_getRootLogger...
     D                 PR                         like(LOG4RPG_hLogger_t )
     D                                     extproc(
     D                                     g_procptr.getRootLogger
     D                                     )
      /ENDIF
      *
      *  Returns a new logger named as the specified name.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_getLogger...
     D                 PR                         like(LOG4RPG_hLogger_t )
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_getLogger+
     D                                     ')
      /ELSE
     D Impl_Logger_getLogger...
     D                 PR                         like(LOG4RPG_hLogger_t )
     D                                     extproc(
     D                                     g_procptr.getLogger
     D                                     )
      /ENDIF
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      *
      *  Logs a DEBUG statement.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_debug...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_debug+
     D                                     ')
      /ELSE
     D Impl_Logger_debug...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.debug
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  Logs a DEBUG message.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_debugMsg...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_debugMsg+
     D                                     ')
      /ELSE
     D Impl_Logger_debugMsg...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.debugMsg
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      *
      *  Logs an INFO statement.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_info...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_info+
     D                                     ')
      /ELSE
     D Impl_Logger_info...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.info
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  Logs an INFO message.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_infoMsg...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_infoMsg+
     D                                     ')
      /ELSE
     D Impl_Logger_infoMsg...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.infoMsg
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      *
      *  Logs a WARN statement.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_warn...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_warn+
     D                                     ')
      /ELSE
     D Impl_Logger_warn...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.warn
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  Logs a WARN message.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_warnMsg...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_warnMsg+
     D                                     ')
      /ELSE
     D Impl_Logger_warnMsg...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.warnMsg
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      *
      *  Logs an ERROR statement.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_error...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_error+
     D                                     ')
      /ELSE
     D Impl_Logger_error...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.error
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  Logs an ERROR message.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_errorMsg...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_errorMsg+
     D                                     ')
      /ELSE
     D Impl_Logger_errorMsg...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.errorMsg
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      *
      *  Logs a FATAL error statement.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_fatal...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_fatal+
     D                                     ')
      /ELSE
     D Impl_Logger_fatal...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.fatal
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  Logs a FATAL error message.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_fatalMsg...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_fatalMsg+
     D                                     ')
      /ELSE
     D Impl_Logger_fatalMsg...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.fatalMsg
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      *
      *  Logs the specified statement without further checking.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_forcedLog...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_forcedLog+
     D                                     ')
      /ELSE
     D Impl_Logger_forcedLog...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.forcedLog
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_level                            const  like(LOG4RPG_level_t   )
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  Logs the specified message without further checking.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_forcedLogMsg...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_forcedLogMsg+
     D                                     ')
      /ELSE
     D Impl_Logger_forcedLogMsg...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.forcedLogMsg
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_level                            const  like(LOG4RPG_level_t   )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      *
      *  Returns cTrue if 'DEBUG' log events are logged.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_isDebugEnabled...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_isDebugEnabled+
     D                                     ')
      /ELSE
     D Impl_Logger_isDebugEnabled...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.isDebugEnabled
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Returns cTrue if 'INFO' log events are logged.
      *  (Including DEBUG log events)
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_isInfoEnabled...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_isInfoEnabled+
     D                                     ')
      /ELSE
     D Impl_Logger_isInfoEnabled...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.isInfoEnabled
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Returns cTrue if 'WARN' log events are logged.
      *  (Including INFO and DEBUG log events)
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_isWarnEnabled...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_isWarnEnabled+
     D                                     ')
      /ELSE
     D Impl_Logger_isWarnEnabled...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.isWarnEnabled
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Returns cTrue if 'ERROR' log events are logged.
      *  (Including WARN, INFO and DEBUG log events)
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_isErrorEnabled...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_isErrorEnabled+
     D                                     ')
      /ELSE
     D Impl_Logger_isErrorEnabled...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.isErrorEnabled
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Returns cTrue if 'FATAL' log events are logged.
      *  (Including ERROR, WARN, INFO and DEBUG log events)
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_isFatalEnabled...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_isFatalEnabled+
     D                                     ')
      /ELSE
     D Impl_Logger_isFatalEnabled...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.isFatalEnabled
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Returns the name of the specified logger.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_getName...
     D                 PR                         like(LOG4RPG_loggerName_t)
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_getName+
     D                                     ')
      /ELSE
     D Impl_Logger_getName...
     D                 PR                         like(LOG4RPG_loggerName_t)
     D                                     extproc(
     D                                     g_procptr.getName
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
      *
      *  Test the specified logger handle for a NULL value.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_isNull...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_isNull+
     D                                     ')
      /ELSE
     D Impl_Logger_isNull...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.isNull
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Returns a NULL handle.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_null...
     D                 PR                         like(LOG4RPG_hLogger_t )
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_null+
     D                                     ')
      /ELSE
     D Impl_Logger_null...
     D                 PR                         like(LOG4RPG_hLogger_t )
     D                                     extproc(
     D                                     g_procptr.null
     D                                     )
      /ENDIF
      *
      *  Sets the logging level of the specified logger.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_setLevel...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_setLevel+
     D                                     ')
      /ELSE
     D Impl_Logger_setLevel...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.setLevel
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_level                            const  like(LOG4RPG_level_t   )
      *
      *  Allows to enable/disable log4rpg internal logging.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_setInternalDebugging...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_setInternalDebugging+
     D                                     ')
      /ELSE
     D Impl_Logger_setInternalDebugging...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.setInternalDebugging
     D                                     )
      /ENDIF
     D  i_debugMode                        const  like(LOG4RPG_debugMode_t  )
     D  i_output                           const  like(LOG4RPG_debugOutput_t)
     D                                            options(*nopass)
      *
      *  Returns the internal debug mode.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_getInternalDebugMode...
     D                 PR                         like(LOG4RPG_debugMode_t  )
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_getInternalDebugMode+
     D                                     ')
      /ELSE
     D Impl_Logger_getInternalDebugMode...
     D                 PR                         like(LOG4RPG_debugMode_t  )
     D                                     extproc(
     D                                     g_procptr.getInternalDebugMode
     D                                     )
      /ENDIF
      *
      *  Returns the target for internal log events.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_getInternalDebugOutput...
     D                 PR                         like(LOG4RPG_debugOutput_t)
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_getInternalDebugOutput+
     D                                     ')
      /ELSE
     D Impl_Logger_getInternalDebugOutput...
     D                 PR                         like(LOG4RPG_debugOutput_t)
     D                                     extproc(
     D                                     g_procptr.getInternalDebugOutput
     D                                     )
      /ENDIF
      *
      * -----------------------------------------
      *  Prototypes of 'Configurator'
      *  (copied from PLOG4RPG08)
      * -----------------------------------------
      *
      *  Loads a default configuration.
      /IF NOT DEFINED(LOGGER_STUB)
     D Configurator_loadDefaultConfiguration...
     D                 PR              N
     D                                     extproc('LOG4RPG08+
     D                                     _Configurator_+
     D                                     loadDefaultConfiguration+
     D                                     ')
      /ELSE
     D Impl_Configurator_loadDefaultConfiguration...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.load...
     D                                     DefaultConfiguration)
      /ENDIF
      *
      *  Configures LOG4RPG from a properties file.
      /IF NOT DEFINED(LOGGER_STUB)
     D Configurator_loadPropertiesConfiguration...
     D                 PR              N
     D                                     extproc('LOG4RPG08+
     D                                     _Configurator_+
     D                                     loadPropertiesConfiguration+
     D                                     ')
      /ELSE
     D Impl_Configurator_loadPropertiesConfiguration...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.load...
     D                                     PropertiesConfiguration)
      /ENDIF
     D  i_path                             const  like(LOG4RPG_path_t   )
      *
      *  Configures LOG4RPG from a properties file. Watches the properties
      *  file for changes and reloads the configuration on changes.
      /IF NOT DEFINED(LOGGER_STUB)
     D Configurator_loadAndWatchPropertiesConfiguration...
     D                 PR              N
     D                                     extproc('LOG4RPG08+
     D                                     _Configurator_+
     D                                     loadAndWatchPropertiesConfiguration+
     D                                     ')
      /ELSE
     D Impl_Configurator_loadAndWatchPropertiesConfiguration...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.loadAndWatch...
     D                                     PropertiesConfiguration
     D                                     )
      /ENDIF
     D  i_path                             const  like(LOG4RPG_path_t   )
     D  i_waitMinutes                10I 0 const  options(*nopass)
     D  i_unit                       10A   const  options(*nopass)
      *
      *  Clears all configuration data.
      /IF NOT DEFINED(LOGGER_STUB)
     D Configurator_clearConfiguration...
     D                 PR
     D                                     extproc('LOG4RPG08+
     D                                     _Configurator_clearConfiguration+
     D                                     ')
      /ELSE
     D Impl_Configurator_clearConfiguration...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.clearConfiguration
     D                                     )
      /ENDIF
      *
      *  Creates a new layout.
      /IF NOT DEFINED(LOGGER_STUB)
     D Layout_new...
     D                 PR                         like(LOG4RPG_pLayout_t      )
     D                                     extproc('LOG4RPG11+
     D                                     _Layout_new+
     D                                     ')
      /ELSE
     D Impl_Layout_new...
     D                 PR                         like(LOG4RPG_pLayout_t      )
     D                                     extproc(
     D                                     g_procptr.Layout_new
     D                                     )
      /ENDIF
     D  i_layoutImpl                       const  like(LOG4RPG_implClass_t     )
     D  i_pPropString                  *   const  options(*nopass:
     D                                                    *omit  : *string)
      *
      *  Returns a NULL layout.
      /IF NOT DEFINED(LOGGER_STUB)
     D Layout_null...
     D                 PR                         like(LOG4RPG_pLayout_t      )
     D                                     extproc('LOG4RPG11+
     D                                     _Layout_null+
     D                                     ')
      /ELSE
     D Impl_Layout_null...
     D                 PR                         like(LOG4RPG_pLayout_t      )
     D                                     extproc(
     D                                     g_procptr.Layout_null
     D                                     )
      /ENDIF
      *
      *  Creates a new appender.
      /IF NOT DEFINED(LOGGER_STUB)
     D Appender_new...
     D                 PR                         like(LOG4RPG_pAppender_t    )
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_new+
     D                                     ')
      /ELSE
     D Impl_Appender_new...
     D                 PR                         like(LOG4RPG_pAppender_t    )
     D                                     extproc(
     D                                     g_procptr.Appender_New
     D                                     )
      /ENDIF
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
     D  i_appImpl                          const  like(LOG4RPG_implClass_t     )
     D  i_pPropString                  *   const  options(*nopass:
     D                                                    *omit  : *string)
      *
      *  Returns a NULL appender.
      /IF NOT DEFINED(LOGGER_STUB)
     D Appender_null...
     D                 PR                         like(LOG4RPG_pAppender_t    )
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_null+
     D                                     ')
      /ELSE
     D Impl_Appender_null...
     D                 PR                         like(LOG4RPG_pAppender_t    )
     D                                     extproc(
     D                                     g_procptr.Appender_null
     D                                     )
      /ENDIF
      *
      *  Sets the layout for the specified appender.
      /IF NOT DEFINED(LOGGER_STUB)
     D Appender_setLayout...
     D                 PR              N
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_setLayout+
     D                                     ')
      /ELSE
     D Impl_Appender_setLayout...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.Appender_setLayout
     D                                     )
      /ENDIF
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
     D  i_pLayout                          const  like(LOG4RPG_pLayout_t       )
      *
      *  Sets the filter for the specified appender.
      /IF NOT DEFINED(LOGGER_STUB)
     D Appender_setFilter...
     D                 PR              N
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_setFilter+
     D                                     ')
      /ELSE
     D Impl_Appender_setFilter...
     D                 PR              N
     D                                     extproc(
     D                                     g_procptr.Appender_setFilter
     D                                     )
      /ENDIF
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t       )
      *
      *  Adds an appender to the specified logger.
      /IF NOT DEFINED(LOGGER_STUB)
     D Logger_addAppender...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_addAppender+
     D                                     ')
      /ELSE
     D Impl_Logger_addAppender...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.Logger_addAppender
     D                                     )
      /ENDIF
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t       )
     D  i_hAppender                        const  like(LOG4RPG_pAppender_t     )
      *
      *  Creates a new filter.
      /IF NOT DEFINED(LOGGER_STUB)
     D Filter_new...
     D                 PR                         like(LOG4RPG_pFilter_t       )
     D                                     extproc('LOG4RPG17+
     D                                     _Filter_new+
     D                                     ')
      /ELSE
     D Impl_Filter_new...
     D                 PR                         like(LOG4RPG_pFilter_t       )
     D                                     extproc(
     D                                     g_procptr.Filter_new
     D                                     )
      /ENDIF
     D  i_fltName                          const  like(LOG4RPG_filterName_t    )
     D  i_fltImpl                          const  like(LOG4RPG_implClass_t     )
     D  i_pPropString                  *   const  options(*nopass:
     D                                                    *omit  : *string)
      *
      *  Returns a NULL filter.
      /IF NOT DEFINED(LOGGER_STUB)
     D Filter_null...
     D                 PR                         like(LOG4RPG_pFilter_t       )
     D                                     extproc('LOG4RPG17+
     D                                     _Filter_null+
     D                                     ')
      /ELSE
     D Impl_Filter_null...
     D                 PR                         like(LOG4RPG_pFilter_t       )
     D                                     extproc(
     D                                     g_procptr.Filter_null
     D                                     )
      /ENDIF
      *
      *  Sets the next filter of the filter chain.
      /IF NOT DEFINED(LOGGER_STUB)
     D Filter_setNext...
     D                 PR
     D                                     extproc('LOG4RPG17+
     D                                     _Filter_setNext+
     D                                     ')
      /ELSE
     D Impl_Filter_setNext...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.Filter_setNext
     D                                     )
      /ENDIF
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t     )
     D  i_pNextFilter                      const  like(LOG4RPG_pFilter_t     )
      *
      /ENDIF
