# Log4rpg

## Table of contents

### Getting Started

- [Overview](Overview.md)
- [Quickstart](Quickstart.md)
- [Log-Level](Log_Level.md)
- [Logger Hierarchy](Logger_Hierarchy.md)
- [Internal Log](Internal_Log.md)

### Configuration Objects

- [Appender](appender/Appender.md)
- [Layout](layout/Layout.md)
- [Filters](filter/Filter.md)

### API Reference

#### Global Configuration

- [Logger_isLogging - Returns operating mode of Log4rpg](reference/Logger_isLogging___Returns_operating_mode_of_Log4rpg.md)
- [Logger_setLogging - Enables-/disables Log4rpg](reference/Logger_setLogging___Enables__disables_Log4rpg.md)

#### Internal Debug Log

- [Logger_getInternalDebugMode - Returns the mode of the internal debug log](reference/Logger_getInternalDebugMode___Returns_the_mode_of_the_internal_debug_log.md)
- [Logger_getInternalDebugOutput - Returns the output target of the internal debug log](reference/Logger_getInternalDebugOutput___Returns_the_output_target_of_the_internal_debug_log.md)
- [Logger_setInternalDebugging - Enable/disable internal log](reference/Logger_setInternalDebugging___Enable_Disable_internal_log.md)

#### Logger Configuration

- [Configurator_loadDefaultConfiguration - Load default configuration](reference/Configurator_loadDefaultConfiguration.md)
- [Configurator_loadPropertiesConfiguration - Load property configuration](reference/Configurator_loadPropertiesConfiguration.md)
- [Configurator_loadAndWatchPropertiesConfiguration - Load property configuration](reference/Configurator_loadAndWatchPropert.md)
- [Configurator_clearConfiguration - Clear Config Data](reference/Configurator_clearConfiguration_.md)

- [Logger_getRootLogger - Get root logger handle](reference/Logger_getRootLogger___Get_root_logger.md)
- [Logger_getLogger - Get logger handle](reference/Logger_getLogger___Get_logger_handle.md)
- [Logger_getName - Get logger name](reference/Logger_getName___Get_logger_Name.md)
- [Logger_setLevel - Set log level](reference/Logger_setLevel___Set_log_Level.md)

- [Logger_addAppender - Add appender (experimental)](reference/Logger_addAppender___Add_appender.md)
- [Logger_removeAppender - Remove appender (experimental)](reference/Logger_removeAppender___Remove_appender.md)
- [Logger_removeAllAppenders - Remove all appenders (experimental)](reference/Logger_removeAllAppenders___Remove_all_appender.md)

- [Logger_isDebugEnabled - Checks, whether log level DEBUG is enabled](reference/Logger_isDebugEnabled___Checks__whether_log_level_DEBUG_is_enabled.md)
- [Logger_isInfoEnabled - Checks, whether log level INFO is enabled](reference/Logger_isInfoEnabled___Checks__whether_log_level_INFO_is_enabled.md)
- [Logger_isWarnEnabled - Checks, whether log level WARN is enabled](reference/Logger_isWarnEnabled___Checks__whether_log_level_WARN_is_enabled.md)
- [Logger_isErrorEnabled - Checks, whether log level ERROR is enabled](reference/Logger_isErrorEnabled___Checks__whether_log_level_ERROR_is_enabled.md)
- [Logger_isFatalEnabled - Checks, whether log level FATAL is enabled](reference/Logger_isFatalEnabled___Checks__whether_log_level_FATAL_is_enabled.md)

- [Logger_isNull - Check logger handle for NULL value](reference/Logger_isNull___Check_logger_han.md)
- [Logger_null - Produce NULL Handle](reference/Logger_null___Produce_NULL_Handle.md)

#### Appending Log Events

- [Logger_debug - Log DEBUG statement](reference/Logger_debug___Log_DEBUG_statement.md)
- [Logger_debugMsg - Log DEBUG message](reference/Logger_debugMsg___Log_DEBUG_message.md)
- [Logger_info - Log INFO statement](reference/Logger_info___Log_INFO_statement.md)
- [Logger_infoMsg - Log INFO message](reference/Logger_infoMsg___Log_INFO_message.md)
- [Logger_warn - Log WARN statement](reference/Logger_warn___Log_WARN_statementent.md)
- [Logger_warnMsg - Log WARN message](reference/Logger_warnMsg___Log_WARN_message.md)
- [Logger_error - Log ERROR statement](reference/Logger_error___Log_ERROR_statement.md)
- [Logger_errorMsg - Log ERROR message](reference/Logger_errorMsg___Log_ERROR_message.md)
- [Logger_fatal - Log FATAL statement](reference/Logger_fatal___Log_FATAL_statement.md)
- [Logger_fatalMsg - Log FATAL message](reference/Logger_fatalMsg___Log_FATAL_message.md)
- [Logger_forcedLog - Log statement](reference/Logger_forcedLog___Log_statement.md)
- [Logger_forcedLogMsg - Log message](reference/Logger_forcedLogMsg___Log_message.md)

### Chainsaw

- [Overview](chainsaw/Chainsaw___Overview.md)
- [Installation](chainsaw/Chainsaw___Installation.md)
- [Settings Files](chainsaw/Chainsaw___Settings_files.md)

### Others

- [What's new](What_s_new.md)

- [Properties - HTMLLayout](layout/Layout___HTMLLayout.md)
- [Properties - PropertyFilter](Properties___PropertyFilter.md)
- [Properties - XMLSocketAppender](appender/Appender___XMLSocketAppender.md)
- [Configuration - DailyRollingFileAppender](Configuration___DailyRollingFileAppender.md)
- [Configuration - DailyRollingPrintAppender](Configuration___DailyRollingPrintAppender.md)
- [Configuration - HTML Output](Configuration___HTML_Output.md>)
- [Configuration - XML Output to Chainsaw](Configuration___XML_Output_to_Chainsaw.md)
- [Configuration - XML Output to Chainsaw (Hub)](Configuration___XML_Output_to_Chainsaw_Hub.md)
- [Properties - XMLSocketHubAppender](appender/Appender___XMLSocketHubAppender.md)
- [Properties - RollingFileAppender](appender/Appender___RollingFileAppender.md)
- [Configuration - RollingFileAppender](Configuration___RollingFileAppender.md)
- [Appender_new - Create appender](Appender_new___Create_appender.md)
- [Appender_setFilter - Set filter for appender](Appender_setFilter___Set_filter_for_appender.md)
- [Appender_setLayout - Set layout for appender](Appender_setLayout___Set_layout_for_appender.md)
- [Filter_new - Create filter](Filter_new___Create_filter.md)
- [Filter_setNext - Set follow-up filter for filter](Filter_setNext___Set_follow_up_filter.md)
- [Programmatic Logger Configuration](Programmatic_Logger_Configuration.md)
- [Layout_new - Create layout](Layout_new___Create_layout.md)
