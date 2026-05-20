**FREE
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
dcl-c cLOG4RPG_LIB_SEARCH
      '*SEARCH';

///
//  Default time to wait (in minutes) to check
//  the properties file for changes.
///
dcl-c cLOG4RPG_CONFIGURATION_DEFAULT_RELOAD_DELAY
      1;
dcl-c cLOG4RPG_CONFIGURATION_DEFAULT_RELOAD_DELAY_UNIT
      '*MINUTES';

///
//  Debug Level:
//  Specifies the possible values of
//  configuration property: log4rpg.rootLogger=
///
dcl-c cLOG4RPG_LEVEL_DEBUG
      'DEBUG';
dcl-c cLOG4RPG_LEVEL_INFO
      'INFO';
dcl-c cLOG4RPG_LEVEL_WARN
      'WARN';
dcl-c cLOG4RPG_LEVEL_ERROR
      'ERROR';
dcl-c cLOG4RPG_LEVEL_FATAL
      'FATAL';

///
//  Debug mode:
//  Specifies the possible values of
//  configuration property: log4rpg.debug=
///
dcl-c cLOG4RPG_DEBUG_QUIET
      'quiet';
dcl-c cLOG4RPG_DEBUG_OFF
      'off';
dcl-c cLOG4RPG_DEBUG_ON
      'on';
dcl-c cLOG4RPG_DEBUG_VERBOSE
      'verbose';

///
//  Debug output:
//  Specifies the possible values of
//  configuration property: log4rpg.debug=
///
dcl-c cLOG4RPG_DEBUG_OUTPUT_PRINTER
      const('printer');
dcl-c cLOG4RPG_DEBUG_OUTPUT_STDOUT
      const('stdout');

///
//  Specifies the maximum length of a formatted Log4rpg message
//  that is appebnded to the log. The maximum length of the
//  input message is defined by template LOG4RPG_text_t.
///
dcl-c cLOG4RPG_MAX_TEXT_LENGTH
      const(4096);

///
// -----------------------------------------
//  Type definition
// -----------------------------------------
///
dcl-s LOG4RPG_appenderName_t
      varchar(32) template;

dcl-s LOG4RPG_debugMode_t
      varchar(10) template;

dcl-s LOG4RPG_debugOutput_t
      varchar(10) template;

dcl-s LOG4RPG_filterName_t
      varchar(32) template;

dcl-s LOG4RPG_hLogger_t
      pointer template;

dcl-s LOG4RPG_implClass_t
      varchar(128) template;

dcl-s LOG4RPG_level_t
      varchar(10) template;

dcl-s LOG4RPG_loggerName_t
      varchar(128) template;

dcl-ds LOG4RPG_msg_t
       qualified template;
  id              char(7);
  data            char(512);
  type            char(10);
  file            char(10);
  lib             char(10);
end-ds;

dcl-s LOG4RPG_pAppender_t
      pointer template;

dcl-s LOG4RPG_path_t
      varchar(256) template;

dcl-s LOG4RPG_pFilter_t
      pointer template;

dcl-s LOG4RPG_pLayout_t
      pointer template;

dcl-s LOG4RPG_text_t
      varchar(2048) template;

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
dcl-pr Logger_setLogging
       ind
       extproc('LOG4RPG01+
       _Logger_setLogging+
       ');
  i_isLogging     ind const;
end-pr;

///
//  Returns whether logging is enabled or not.
//
//  @return *ON if logging is enabled, otherwise *OFF
///
dcl-pr Logger_isLogging
       ind
       extproc('LOG4RPG01+
       _Logger_isLogging+
       ');
end-pr;

///
//  Returns the root logger.
//
//  @return handle of the 'root' logger
///
dcl-pr Logger_getRootLogger
       like(LOG4RPG_hLogger_t)
       extproc('LOG4RPG01+
       _Logger_getRootLogger+
       ');
end-pr;

///
//  Returns a new logger named as the specified name.
//
//  @param Logger name
//
//  @return handle of the logger
///
dcl-pr Logger_getLogger
       like(LOG4RPG_hLogger_t)
       extproc('LOG4RPG01+
       _Logger_getLogger+
       ');
  i_logName       const  like(LOG4RPG_loggerName_t);
end-pr;

///
//  Logs a DEBUG statement.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
//  @param Message text that is appended to the log
///
dcl-pr Logger_debug
       extproc('LOG4RPG01+
       _Logger_debug+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_text          const  like(LOG4RPG_text_t);
end-pr;

///
//  Logs a DEBUG message.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
//  @param Message that is appended to the log
///
dcl-pr Logger_debugMsg
       extproc('LOG4RPG01+
       _Logger_debugMsg+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_msg           const  likeds(LOG4RPG_msg_t);
end-pr;

///
//  Logs an INFO statement.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
//  @param Message text that is appended to the log
///
dcl-pr Logger_info
       extproc('LOG4RPG01+
       _Logger_info+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_text          const  like(LOG4RPG_text_t);
end-pr;

///
//  Logs an INFO message.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
//  @param Message that is appended to the log
///
dcl-pr Logger_infoMsg
       extproc('LOG4RPG01+
       _Logger_infoMsg+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_msg           const  likeds(LOG4RPG_msg_t);
end-pr;

///
//  Logs a WARN statement.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
//  @param Message text that is appended to the log
///
dcl-pr Logger_warn
       extproc('LOG4RPG01+
       _Logger_warn+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_text          const  like(LOG4RPG_text_t);
end-pr;

///
//  Logs a WARN message.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
//  @param Message that is appended to the log
///
dcl-pr Logger_warnMsg
       extproc('LOG4RPG01+
       _Logger_warnMsg+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_msg           const  likeds(LOG4RPG_msg_t);
end-pr;

///
//  Logs an ERROR statement.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
//  @param Message text that is appended to the log
///
dcl-pr Logger_error
       extproc('LOG4RPG01+
       _Logger_error+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_text          const  like(LOG4RPG_text_t);
end-pr;

///
//  Logs an ERROR message.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
//  @param Message that is appended to the log
///
dcl-pr Logger_errorMsg
       extproc('LOG4RPG01+
       _Logger_errorMsg+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_msg           const  likeds(LOG4RPG_msg_t);
end-pr;

///
//  Logs a FATAL error statement.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
//  @param Message text that is appended to the log
///
dcl-pr Logger_fatal
       extproc('LOG4RPG01+
       _Logger_fatal+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_text          const  like(LOG4RPG_text_t);
end-pr;

///
//  Logs a FATAL error message.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
//  @param Message that is appended to the log
///
dcl-pr Logger_fatalMsg
       extproc('LOG4RPG01+
       _Logger_fatalMsg+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_msg           const  likeds(LOG4RPG_msg_t);
end-pr;

///
//  Logs the specified statement without further checking of
//  the log level.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
//  @param Debug level
//  @param Message text that is appended to the log
///
dcl-pr Logger_forcedLog
       extproc('LOG4RPG01+
       _Logger_forcedLog+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_level         const  like(LOG4RPG_level_t);
  i_text          const  like(LOG4RPG_text_t);
end-pr;

///
//  Logs the specified message without further checking of
//  the log level.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
//  @param Debug level
//  @param Message that is appended to the log
///
dcl-pr Logger_forcedLogMsg
       extproc('LOG4RPG01+
       _Logger_forcedLogMsg+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_level         const  like(LOG4RPG_level_t);
  i_msg           const  likeds(LOG4RPG_msg_t);
end-pr;

///
//  Returns *ON if 'DEBUG' log events are logged by the
//  specified logger.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
///
dcl-pr Logger_isDebugEnabled
       ind
       extproc('LOG4RPG01+
       _Logger_isDebugEnabled+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
end-pr;

///
//  Returns *ON if 'INFO' log events are logged by
//  specified logger.
//  (Including DEBUG log events)
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
///
dcl-pr Logger_isInfoEnabled
       ind
       extproc('LOG4RPG01+
       _Logger_isInfoEnabled+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
end-pr;

///
//  Returns *ON if 'WARN' log events are logged by
//  specified logger.
//  (Including INFO and DEBUG log events)
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
///
dcl-pr Logger_isWarnEnabled
       ind
       extproc('LOG4RPG01+
       _Logger_isWarnEnabled+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
end-pr;

///
//  Returns *ON if 'ERROR' log events are logged by
//  specified logger.
//  (Including WARN, INFO and DEBUG log events)
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
///
dcl-pr Logger_isErrorEnabled
       ind
       extproc('LOG4RPG01+
       _Logger_isErrorEnabled+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
end-pr;

///
//  Returns *ON if 'FATAL' log events are logged by
//  specified logger.
//  (Including ERROR, WARN, INFO and DEBUG log events)
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
///
dcl-pr Logger_isFatalEnabled
       ind
       extproc('LOG4RPG01+
       _Logger_isFatalEnabled+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
end-pr;

///
//  Returns the name of the specified logger.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
///
dcl-pr Logger_getName
       like(LOG4RPG_loggerName_t)
       extproc('LOG4RPG01+
       _Logger_getName+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
end-pr;

///
//  Tests the specified logger handle for a NULL value.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
//
//  @return *ON if the logger handle is NULL, otherwise *OFF
///
dcl-pr Logger_isNull
       ind
       extproc('LOG4RPG01+
       _Logger_isNull+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
end-pr;

///
//  Returns a NULL logger handle.
//
//  @return Null logger handle
///
dcl-pr Logger_null
       like(LOG4RPG_hLogger_t)
       extproc('LOG4RPG01+
       _Logger_null+
       ');
end-pr;

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
dcl-pr Logger_setLevel
       extproc('LOG4RPG01+
       _Logger_setLevel+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_level         const  like(LOG4RPG_level_t);
end-pr;

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
dcl-pr Logger_setInternalDebugging
       extproc('LOG4RPG01+
       _Logger_setInternalDebugging+
       ');
  i_debugMode     const  like(LOG4RPG_debugMode_t);
  i_output        const  like(LOG4RPG_debugOutput_t)
       options(*nopass);
end-pr;

///
//  Returns the mode of the internal logger of Log4rpg.
//
//  @return Mode of the internal logger
///
dcl-pr Logger_getInternalDebugMode
       like(LOG4RPG_debugMode_t)
       extproc('LOG4RPG01+
       _Logger_getInternalDebugMode+
       ');
end-pr;

///
//  Returns the output target for the internal logger
//  of Log4rpg.
//
//  @return Output target of the internal logger
///
dcl-pr Logger_getInternalDebugOutput
       like(LOG4RPG_debugOutput_t)
       extproc('LOG4RPG01+
       _Logger_getInternalDebugOutput+
       ');
end-pr;

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
dcl-pr Configurator_loadDefaultConfiguration
       ind
       extproc('LOG4RPG08+
       _Configurator_+
       loadDefaultConfiguration+
       ');
end-pr;

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
dcl-pr Configurator_loadPropertiesConfiguration
       ind
       extproc('LOG4RPG08+
       _Configurator_+
       loadPropertiesConfiguration+
       ');
  i_path          const  like(LOG4RPG_path_t);
end-pr;

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
dcl-pr Configurator_loadAndWatchPropertiesConfiguration
       ind
       extproc('LOG4RPG08+
       _Configurator_+
       loadAndWatchPropertiesConfiguration+
       ');
  i_path          const  like(LOG4RPG_path_t);
  i_waitMinutes   int(10) const  options(*nopass);
  i_unit          char(10) const  options(*nopass);
end-pr;

///
//  Clears the configuration data.
///
dcl-pr Configurator_clearConfiguration
       extproc('LOG4RPG08+
       _Configurator_clearConfiguration+
       ');
end-pr;

///
//  Creates a new layout.
//
//  @param Module implementing the layout
//  @param Semicolon separated list of configuration
//         properties.
///
dcl-pr Layout_new
       like(LOG4RPG_pLayout_t)
       extproc('LOG4RPG11+
       _Layout_new+
       ');
  i_layoutImpl    const  like(LOG4RPG_implClass_t);
  i_pPropString   pointer const  options(*nopass:
       *omit: *string);
end-pr;

///
//  Returns a NULL layout.
///
dcl-pr Layout_null
       like(LOG4RPG_pLayout_t)
       extproc('LOG4RPG11+
       _Layout_null+
       ');
end-pr;

///
//  Creates a new appender.
//
//  @param Unique appender name
//  @param Module implementing the appender
//  @param Semicolon separated list of configuration
//         properties.
///
dcl-pr Appender_new
       like(LOG4RPG_pAppender_t)
       extproc('LOG4RPG03+
       _Appender_new+
       ');
  i_appName       const  like(LOG4RPG_appenderName_t);
  i_appImpl       const  like(LOG4RPG_implClass_t);
  i_pPropString   pointer const  options(*nopass:
       *omit: *string);
end-pr;

///
//  Returns a NULL appender.
///
dcl-pr Appender_null
       like(LOG4RPG_pAppender_t)
       extproc('LOG4RPG03+
       _Appender_null+
       ');
end-pr;

///
//  Sets the layout for the specified appender.
///
dcl-pr Appender_setLayout
       ind
       extproc('LOG4RPG03+
       _Appender_setLayout+
       ');
  i_pAppender     const  like(LOG4RPG_pAppender_t);
  i_pLayout       const  like(LOG4RPG_pLayout_t);
end-pr;

///
//  Sets the filter for the specified appender.
//
//  @param Appender handle as returned by Appender_new()
//  @param Filter handle as returned by Filter_new()
///
dcl-pr Appender_setFilter
       ind
       extproc('LOG4RPG03+
       _Appender_setFilter+
       ');
  i_pAppender     const  like(LOG4RPG_pAppender_t);
  i_pFilter       const  like(LOG4RPG_pFilter_t);
end-pr;

///
//  Adds an appender to the specified logger.
//
//  @param Logger handle as returned by Logger_getRootLogger()
//         or Logger_getLogger()
//  @param Appender handle as returned by Appender_new()
///
dcl-pr Logger_addAppender
       extproc('LOG4RPG01+
       _Logger_addAppender+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t);
  i_hAppender     const  like(LOG4RPG_pAppender_t);
end-pr;

///
//  Creates a new filter.
//
//  @param Unique filter name
//  @param Module implementing the filter
//  @param Semicolon separated list of configuration
//         properties.
///
dcl-pr Filter_new
       like(LOG4RPG_pFilter_t)
       extproc('LOG4RPG17+
       _Filter_new+
       ');
  i_fltName       const  like(LOG4RPG_filterName_t);
  i_fltImpl       const  like(LOG4RPG_implClass_t);
  i_pPropString   pointer const  options(*nopass:
       *omit: *string);
end-pr;

///
//  Returns a NULL filter.
///
dcl-pr Filter_null
       like(LOG4RPG_pFilter_t)
       extproc('LOG4RPG17+
       _Filter_null+
       ');
end-pr;

///
//  Sets the next filter of the filter chain.
//
//  @param Filter handle as returned by Filter_new()
//  @param Filter handle of the next filter as returned by Filter_new()
///
dcl-pr Filter_setNext
       extproc('LOG4RPG17+
       _Filter_setNext+
       ');
  i_pFilter       const  like(LOG4RPG_pFilter_t);
  i_pNextFilter   const  like(LOG4RPG_pFilter_t);
end-pr;

/ENDIF
