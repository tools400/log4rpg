# Quickstart

Log4rpg comes as a service program that other programs can bind to. The programs that want to utilize *Log4rpg* must bind to service program `LOG4RPG`. The appropriate creation command looks like this:

```text
CRTPGM PGM(yourLibName/yourPgmName) **BNDSRVPGM(LOG4RPG)**
```

A modules that must call a *Log4rpg* procedures, such as [Logger_getLogger()](reference/Logger_getLogger___Get_logger_handle.md), must include copy book `PLOG4RPG`. Please look at the included example programs:

- LOG4_EXP1 - Example 1 - Properties From Stream File
- LOG4_EXP2 - Example 2 - Properties From Member
- LOG4_EXP3 - Example 3 - Programmatically Log4rpg Configuration
- LOG4_EXP4 - Example 4 - Speed Test

You can call these example with the following configuration members:

- LOG4_X1P1 - Configures a DailyRollingFileAppender
- LOG4_X1P2 - Configures a DailyRollingPrintAppender
- LOG4_X1P3 - Configures a DailyRollingFileAppender + HTMLLayout
- LOG4_X1P4 - Configures a XMLSocketAppender for Chainsaw
- LOG4_X1P5 - Configures a DailyRollingFileAppender + XMLLayout
- LOG4_X1P6 - Configures a XMLSocketHubAppender for Chainsaw
- LOG4_X1P7 - Configures a RollingFileAppender
- LOG4_X1P8 - Configures a DailyRollingFileAppender + SimpleLayout

For example:

```text
CALL PGM(LOG4_EXP2) PARM('mbr:qlog4rpg.log4_x1p4')
```

The first step towards a working logger is to properly configure *Log4rpg*. The easiest way to accomplish that is to call:

- [Configurator_loadDefaultConfiguration()](reference/Configurator_loadDefaultConfiguration.md)

That configures *Log4rpg* using the [DailyRollingFileAppender](appender/Appender___DailyRollingFileAppender.md) with a [PatternLayout](layout/Layout___PatternLayout.md). The log level is set to `DEBUG` and the output goes to file `log4rpg.log` in the current directory of the user.

The next step is getting a logger handle. Call one of following procedures to get one:

- [Logger_getRootLogger()](reference/Logger_getRootLogger___Get_root_logger.md)

- [Logger_getLogger()](reference/Logger_getLogger___Get_logger_handle.md)

The handle identifies a logger. It is used whenever a log statement must be logged. This time you should call [Logger_getRootLogger()](reference/Logger_getRootLogger___Get_root_logger.md) to keep it simple.

The log level can be changed calling:

- [Logger_setLevel()](reference/Logger_setLevel___Set_log_Level.md)

Now that Log4rpg is properly configured, log events can be logged with the following procedures:

- [Logger_debug()](reference/Logger_debug___Log_DEBUG_statement.md)

- [Logger_info()](reference/Logger_info___Log_INFO_statement.md)

- [Logger_warn()](reference/Logger_warn___Log_WARN_statement.md)

- [Logger_error()](reference/Logger_error___Log_ERROR_statement.md)

- [Logger_fatal()](reference/Logger_fatal___Log_FATAL_statement.md)

The first thing all these procedure do is to checking the log level in order to determine whether the log event has to be logged or not. The following procedure can used in case that a log event must be logged regardless of the log level:

- [Logger_forcedLog()](reference/Logger_forcedLog___Log_statement.md)

All *Log4rpg* settings stay active until the activation group that hosts the `LOG4RPG` service program is reclaimed.

***
© 2000-2025, Thomas Raddatz
