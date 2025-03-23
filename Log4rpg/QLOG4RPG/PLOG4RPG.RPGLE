      /IF NOT DEFINED(PLOG4RPG)
      /DEFINE PLOG4RPG
      ///
      // -----------------------------------------
      //  Constants
      // -----------------------------------------
      ///

      ///
      //  Special value *SEARCH for the library name when loading properties from
      //  a physical file member. When *SEARCH is specified as the library name,
      //  all files in the library list that matches the specified file name are
      //  searched for the member. The first member that is found is used to load
      //  the configuration data.
      ///
     D cLOG4RPG_LIB_SEARCH...
     D                 C                   '*SEARCH'

      ///
      //  Default time to wait (in minutes) to check
      //  the properties file for changes.
      ///
     D cLOG4RPG_CONFIGURATION_DEFAULT_RELOAD_DELAY...
     D                 C                   1
     D cLOG4RPG_CONFIGURATION_DEFAULT_RELOAD_DELAY_UNIT...
     D                 C                   '*MINUTES'

      ///
      //  Debug Level:
      //  Specifies the possible values of
      //  configuration property: log4rpg.rootLogger=
      ///
     D cLOG4RPG_LEVEL_DEBUG...
     D                 C                   'DEBUG'
     D cLOG4RPG_LEVEL_INFO...
     D                 C                   'INFO'
     D cLOG4RPG_LEVEL_WARN...
     D                 C                   'WARN'
     D cLOG4RPG_LEVEL_ERROR...
     D                 C                   'ERROR'
     D cLOG4RPG_LEVEL_FATAL...
     D                 C                   'FATAL'

      ///
      //  Debug mode:
      //  Specifies the possible values of
      //  configuration property: log4rpg.debug=
      ///
     D cLOG4RPG_DEBUG_QUIET...
     D                 C                   'quiet'
     D cLOG4RPG_DEBUG_OFF...
     D                 C                   'off'
     D cLOG4RPG_DEBUG_ON...
     D                 C                   'on'
     D cLOG4RPG_DEBUG_VERBOSE...
     D                 C                   'verbose'

      ///
      //  Debug output:
      //  Specifies the possible values of
      //  configuration property: log4rpg.debug=
      ///
     D cLOG4RPG_DEBUG_OUTPUT_PRINTER...
     D                 C                   const('printer')
     D cLOG4RPG_DEBUG_OUTPUT_STDOUT...
     D                 C                   const('stdout')

      ///
      //  Specifies the maximum length of a formatted Log4rpg message
      //  that is appebnded to the log. The maximum length of the
      //  input message is defined by template LOG4RPG_text_t.
      ///
     D cLOG4RPG_MAX_TEXT_LENGTH...
     D                 C                   const(4096)

      ///
      // -----------------------------------------
      //  Type definition
      // -----------------------------------------
      ///
     D LOG4RPG_appenderName_t...
     D                 S             32A   varying template

     D LOG4RPG_debugMode_t...
     D                 S             10A   varying template

     D LOG4RPG_debugOutput_t...
     D                 S             10A   varying template

     D LOG4RPG_filterName_t...
     D                 S             32A   varying template

     D LOG4RPG_hLogger_t...
     D                 S               *   template

     D LOG4RPG_implClass_t...
     D                 S            128A   varying template

     D LOG4RPG_level_t...
     D                 S             10A   varying template

     D LOG4RPG_loggerName_t...
     D                 S            128A   varying template

     D LOG4RPG_msg_t...
     D                 DS                  qualified template
     D  id                            7A
     D  data                        512A
     D  type                         10A
     D  file                         10A
     D  lib                          10A

     D LOG4RPG_pAppender_t...
     D                 S               *   template

     D LOG4RPG_path_t...
     D                 S            256A   varying template

     D LOG4RPG_pFilter_t...
     D                 S               *   template

     D LOG4RPG_pLayout_t...
     D                 S               *   template

     D LOG4RPG_text_t...
     D                 S           2048A   varying template

      /IF DEFINED(TYPES_ONLY)
      /EOF
      /ENDIF

      // LOGGER_STUB has been replaced with TYPES_ONLY in v1.13
      /IF DEFINED(LOGGER_STUB)
      /EOF
      /ENDIF

      ///
      // -----------------------------------------
      //  Public API of Log4rpg
      // -----------------------------------------
      ///

      ///
      //  Enables/disables Log4rpg at all.
      //
      //  @param Specifies whether logging is enabled/disabled at all
      //
      //  @return *ON if logging is enabled, otherwise *OFF
      ///
     D Logger_setLogging...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_setLogging+
     D                                     ')
     D  i_isLogging                    N   const

      ///
      //  Returns whether logging is enabled or not.
      //
      //  @return *ON if logging is enabled, otherwise *OFF
      ///
     D Logger_isLogging...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_isLogging+
     D                                     ')

      ///
      //  Returns the root logger.
      //
      //  @return handle of the 'root' logger
      ///
     D Logger_getRootLogger...
     D                 PR
     D                                     like(LOG4RPG_hLogger_t)
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_getRootLogger+
     D                                     ')

      ///
      //  Returns a new logger named as the specified name.
      //
      //  @param Logger name
      //
      //  @return handle of the logger
      ///
     D Logger_getLogger...
     D                 PR
     D                                     like(LOG4RPG_hLogger_t)
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_getLogger+
     D                                     ')
     D  i_logName                          const  like(LOG4RPG_loggerName_t)

      ///
      //  Logs a DEBUG statement.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      //  @param Message text that is appended to the log
      ///
     D Logger_debug...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_debug+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_text                             const  like(LOG4RPG_text_t)

      ///
      //  Logs a DEBUG message.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      //  @param Message that is appended to the log
      ///
     D Logger_debugMsg...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_debugMsg+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_msg                              const  likeds(LOG4RPG_msg_t)

      ///
      //  Logs an INFO statement.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      //  @param Message text that is appended to the log
      ///
     D Logger_info...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_info+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_text                             const  like(LOG4RPG_text_t)

      ///
      //  Logs an INFO message.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      //  @param Message that is appended to the log
      ///
     D Logger_infoMsg...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_infoMsg+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_msg                              const  likeds(LOG4RPG_msg_t)

      ///
      //  Logs a WARN statement.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      //  @param Message text that is appended to the log
      ///
     D Logger_warn...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_warn+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_text                             const  like(LOG4RPG_text_t)

      ///
      //  Logs a WARN message.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      //  @param Message that is appended to the log
      ///
     D Logger_warnMsg...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_warnMsg+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_msg                              const  likeds(LOG4RPG_msg_t)

      ///
      //  Logs an ERROR statement.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      //  @param Message text that is appended to the log
      ///
     D Logger_error...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_error+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_text                             const  like(LOG4RPG_text_t)

      ///
      //  Logs an ERROR message.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      //  @param Message that is appended to the log
      ///
     D Logger_errorMsg...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_errorMsg+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_msg                              const  likeds(LOG4RPG_msg_t)

      ///
      //  Logs a FATAL error statement.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      //  @param Message text that is appended to the log
      ///
     D Logger_fatal...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_fatal+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_text                             const  like(LOG4RPG_text_t)

      ///
      //  Logs a FATAL error message.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      //  @param Message that is appended to the log
      ///
     D Logger_fatalMsg...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_fatalMsg+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_msg                              const  likeds(LOG4RPG_msg_t)

      ///
      //  Logs the specified statement without further checking of
      //  the log level.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      //  @param Debug level
      //  @param Message text that is appended to the log
      ///
     D Logger_forcedLog...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_forcedLog+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_level                            const  like(LOG4RPG_level_t)
     D  i_text                             const  like(LOG4RPG_text_t)

      ///
      //  Logs the specified message without further checking of
      //  the log level.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      //  @param Debug level
      //  @param Message that is appended to the log
      ///
     D Logger_forcedLogMsg...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_forcedLogMsg+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_level                            const  like(LOG4RPG_level_t)
     D  i_msg                              const  likeds(LOG4RPG_msg_t)

      ///
      //  Returns *ON if 'DEBUG' log events are logged by the
      //  specified logger.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      ///
     D Logger_isDebugEnabled...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_isDebugEnabled+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)

      ///
      //  Returns *ON if 'INFO' log events are logged by
      //  specified logger.
      //  (Including DEBUG log events)
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      ///
     D Logger_isInfoEnabled...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_isInfoEnabled+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)

      ///
      //  Returns *ON if 'WARN' log events are logged by
      //  specified logger.
      //  (Including INFO and DEBUG log events)
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      ///
     D Logger_isWarnEnabled...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_isWarnEnabled+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)

      ///
      //  Returns *ON if 'ERROR' log events are logged by
      //  specified logger.
      //  (Including WARN, INFO and DEBUG log events)
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      ///
     D Logger_isErrorEnabled...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_isErrorEnabled+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)

      ///
      //  Returns *ON if 'FATAL' log events are logged by
      //  specified logger.
      //  (Including ERROR, WARN, INFO and DEBUG log events)
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      ///
     D Logger_isFatalEnabled...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_isFatalEnabled+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)

      ///
      //  Returns the name of the specified logger.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      ///
     D Logger_getName...
     D                 PR
     D                                     like(LOG4RPG_loggerName_t)
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_getName+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)

      ///
      //  Tests the specified logger handle for a NULL value.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      //
      //  @return *ON if the logger handle is NULL, otherwise *OFF
      ///
     D Logger_isNull...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_isNull+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)

      ///
      //  Returns a NULL logger handle.
      //
      //  @return Null logger handle
      ///
     D Logger_null...
     D                 PR
     D                                     like(LOG4RPG_hLogger_t)
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_null+
     D                                     ')

      ///
      //  Sets the logging level of the specified logger.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      //  @param Log level assigned to the specified logger.
      //         The Possible values are:
      //         - cLOG4RPG_LEVEL_DEBUG
      //         - cLOG4RPG_LEVEL_INFO
      //         - cLOG4RPG_LEVEL_WARN
      //         - cLOG4RPG_LEVEL_ERROR
      //         - cLOG4RPG_LEVEL_FATAL
      ///
     D Logger_setLevel...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_setLevel+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_level                            const  like(LOG4RPG_level_t)

      ///
      //  Allows to enable/disable the internal logger of Log4rpg.
      //
      //  @param debug mode of the internal logging of Log4rpg.
      //         The Possible values are:
      //         - cLOG4RPG_DEBUG_QUIET
      //         - cLOG4RPG_DEBUG_OFF
      //         - cLOG4RPG_DEBUG_ON
      //         - cLOG4RPG_DEBUG_VERBOSE
      //  @param Output target.
      //         Default value: Printer
      //         The Possible values are:
      //         - cLOG4RPG_DEBUG_OUTPUT_PRINTER
      //         - cLOG4RPG_DEBUG_OUTPUT_STDOUT
      ///
     D Logger_setInternalDebugging...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_setInternalDebugging+
     D                                     ')
     D  i_debugMode                        const  like(LOG4RPG_debugMode_t)
     D  i_output                           const  like(LOG4RPG_debugOutput_t)
     D                                            options(*nopass)

      ///
      //  Returns the mode of the internal logger of Log4rpg.
      //
      //  @return Mode of the internal logger
      ///
     D Logger_getInternalDebugMode...
     D                 PR
     D                                     like(LOG4RPG_debugMode_t)
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_getInternalDebugMode+
     D                                     ')

      ///
      //  Returns the output target for the internal logger
      //  of Log4rpg.
      //
      //  @return Output target of the internal logger
      ///
     D Logger_getInternalDebugOutput...
     D                 PR
     D                                     like(LOG4RPG_debugOutput_t)
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_getInternalDebugOutput+
     D                                     ')

      ///
      // -----------------------------------------
      //  Prototypes of 'Configurator'
      //  (copied from PLOG4RPG08)
      // -----------------------------------------
      ///

      ///
      //  Loads a default configuration.
      //
      //  @return *ON if the configuration was successfully applied,
      //          otherwise *OFF
      ///
     D Configurator_loadDefaultConfiguration...
     D                 PR              N
     D                                     extproc('LOG4RPG08+
     D                                     _Configurator_+
     D                                     loadDefaultConfiguration+
     D                                     ')

      ///
      //  Configures Log4rpg from a given configuration file or member.
      //
      //  Example paths:
      //    'file:/home/raddatz/log4_x1P1.properties'
      //    'mbr:LOG4RPGDVP/QLOG4RPG.LOG4_X1P1'
      //    'mbr:LOG4RPGDVP/QLOG4RPG(LOG4_X1P1)'
      //
      //  @param Path that specifies the configuration file
      //         The possible path types are:
      //         - mbr:
      //         - file:
      //
      //  @return *ON if the configuration was successfully applied,
      //          otherwise *OFF
      ///
     D Configurator_loadPropertiesConfiguration...
     D                 PR              N
     D                                     extproc('LOG4RPG08+
     D                                     _Configurator_+
     D                                     loadPropertiesConfiguration+
     D                                     ')
     D  i_path                             const  like(LOG4RPG_path_t)

      ///
      //  Configures Log4rpg and watches the configuration
      //  file for changes. Reloads the configuration on changes.
      //
      //  @param Path that specifies the configuration file
      //         The possible path types are:
      //         - mbr:
      //         - file:
      //  @param Time interval for checking for configuration changes
      //         Default value: 1
      //  @param Time interval unit.
      //         Default value: Minutes
      //         The possible values are:
      //         - cLOG4RPG_CONFIGURATION_DEFAULT_RELOAD_DELAY
      ///
     D Configurator_loadAndWatchPropertiesConfiguration...
     D                 PR              N
     D                                     extproc('LOG4RPG08+
     D                                     _Configurator_+
     D                                     loadAndWatchPropertiesConfiguration+
     D                                     ')
     D  i_path                             const  like(LOG4RPG_path_t)
     D  i_waitMinutes                10I 0 const  options(*nopass)
     D  i_unit                       10A   const  options(*nopass)

      ///
      //  Clears the configuration data.
      ///
     D Configurator_clearConfiguration...
     D                 PR
     D                                     extproc('LOG4RPG08+
     D                                     _Configurator_clearConfiguration+
     D                                     ')

      ///
      //  Creates a new layout.
      //
      //  @param Module implementing the layout
      //  @param Semicolon separated list of configuration
      //         properties.
      ///
     D Layout_new...
     D                 PR
     D                                     like(LOG4RPG_pLayout_t)
     D                                     extproc('LOG4RPG11+
     D                                     _Layout_new+
     D                                     ')
     D  i_layoutImpl                       const  like(LOG4RPG_implClass_t)
     D  i_pPropString                  *   const  options(*nopass:
     D                                                    *omit: *string)

      ///
      //  Returns a NULL layout.
      ///
     D Layout_null...
     D                 PR
     D                                     like(LOG4RPG_pLayout_t)
     D                                     extproc('LOG4RPG11+
     D                                     _Layout_null+
     D                                     ')

      ///
      //  Creates a new appender.
      //
      //  @param Unique appender name
      //  @param Module implementing the appender
      //  @param Semicolon separated list of configuration
      //         properties.
      ///
     D Appender_new...
     D                 PR
     D                                     like(LOG4RPG_pAppender_t)
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_new+
     D                                     ')
     D  i_appName                          const  like(LOG4RPG_appenderName_t)
     D  i_appImpl                          const  like(LOG4RPG_implClass_t)
     D  i_pPropString                  *   const  options(*nopass:
     D                                                    *omit: *string)

      ///
      //  Returns a NULL appender.
      ///
     D Appender_null...
     D                 PR
     D                                     like(LOG4RPG_pAppender_t)
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_null+
     D                                     ')

      ///
      //  Sets the layout for the specified appender.
      ///
     D Appender_setLayout...
     D                 PR              N
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_setLayout+
     D                                     ')
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t)
     D  i_pLayout                          const  like(LOG4RPG_pLayout_t)

      ///
      //  Sets the filter for the specified appender.
      //
      //  @param Appender handle as returned by Appender_new()
      //  @param Filter handle as returned by Filter_new()
      ///
     D Appender_setFilter...
     D                 PR              N
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_setFilter+
     D                                     ')
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t)
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t)

      ///
      //  Adds an appender to the specified logger.
      //
      //  @param Logger handle as returned by Logger_getRootLogger()
      //         or Logger_getLogger()
      //  @param Appender handle as returned by Appender_new()
      ///
     D Logger_addAppender...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_addAppender+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t)
     D  i_hAppender                        const  like(LOG4RPG_pAppender_t)

      ///
      //  Creates a new filter.
      //
      //  @param Unique filter name
      //  @param Module implementing the filter
      //  @param Semicolon separated list of configuration
      //         properties.
      ///
     D Filter_new...
     D                 PR
     D                                     like(LOG4RPG_pFilter_t)
     D                                     extproc('LOG4RPG17+
     D                                     _Filter_new+
     D                                     ')
     D  i_fltName                          const  like(LOG4RPG_filterName_t)
     D  i_fltImpl                          const  like(LOG4RPG_implClass_t)
     D  i_pPropString                  *   const  options(*nopass:
     D                                                    *omit: *string)

      ///
      //  Returns a NULL filter.
      ///
     D Filter_null...
     D                 PR
     D                                     like(LOG4RPG_pFilter_t)
     D                                     extproc('LOG4RPG17+
     D                                     _Filter_null+
     D                                     ')

      ///
      //  Sets the next filter of the filter chain.
      //
      //  @param Filter handle as returned by Filter_new()
      //  @param Filter handle of the next filter as returned by Filter_new()
      ///
     D Filter_setNext...
     D                 PR
     D                                     extproc('LOG4RPG17+
     D                                     _Filter_setNext+
     D                                     ')
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t)
     D  i_pNextFilter                      const  like(LOG4RPG_pFilter_t)

      /ENDIF
