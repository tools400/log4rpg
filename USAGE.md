# Using Log4rpg

Basically Log4rpg works the same way as Log4j. It does not have all features of Log4j, but if you are familiar with that, you should have no problems using Log4rpg.

## Configuration Objects

### Logger

A logger logs messages of different types. Loggers are defined by names and are organized in a tree structure. The root logger is accessed by `Logger_getRootLogger()`. Child loggers inherit the properties of the root logger. Handles of child loggers are retrieved with `Logger_getLogger(logger_name)`.

### Appender

An appender is used for appending message to the log. It is the glue between the logger and the logging target. The logging target can be each and everything that can store messages. Common targets are files and printers.

You can develop your own appender if you have special requirements.

Included appenders:

- RollingFileAppender
- DailyRollingFileAppender
- NullAppender
- XMLSocketAppender
- XMLSocketHubAppender

### Layout

A layout is used by an appender for formatting the message. Hence different appenders may require different layouts.

You can develop your own layout if you have special requirements.

Included appenders:

- HTMLLayout
- PatternLayout
- SimpleLayout
- XMLLayout

### Filter

A filter is used by an appender for deciding what to do with the log event or changing the log event. For example, the included `PropertyFilter` is used for adding properties to the log event. It is a *neutral* filter, which does not block events or other filters.

You can develop your own filter if you have special requirements.

Included appenders:

- PropertyFilter

## Configuration Files

Log4rpg is configured using properties files or members.

### Simple Configuration

This is a simple configuration using the `PatternLayout`:

```properties
log4rpg.debug=off, printer

log4rpg.rootLogger=DEBUG, file
log4rpg.logger.de.tools400=INFO

log4rpg.appender.file=*LIBL/LOG4RPG(DailyRollingFileAppender)
log4rpg.appender.file.path=log4_x1p1.log
log4rpg.appender.file.layout=PatternLayout
log4rpg.appender.file.layout.conversionPattern=%z [%-5p] %L/%P(%M).%F (%S) %m%n
```

### Chainsaw Configuration

THis is a configuration for the [Apache Chainsaw](https://logging.apache.org/chainsaw/2.x/) utility:

```properties
log4rpg.debug=off, printer

log4rpg.rootLogger=DEBUG, chainsaw
log4rpg.logger.de.tools400=INFO

log4rpg.appender.chainsaw=*LIBL/LOG4SCKAPP(XMLSocketAppender)
log4rpg.appender.chainsaw.remoteHost=xxx.xxx.xxx.xxx
log4rpg.appender.chainsaw.port=4448
log4rpg.appender.chainsaw.layout=XMLLayout
log4rpg.appender.chainsaw.filter=appName

log4rpg.filter.appName=*LIBL/LOG4PROFLT(PropertyFilter)
log4rpg.filter.appName.property.application=myApplication
```

Included configurations:

- LOG4_X1P1 (Configures a DailyRollingFileAppender)
- LOG4_X1P2 (Configures a DailyRollingPrintAppender)
- LOG4_X1P3 (Configures a DailyRollingFileAppender + HTMLLayout)
- LOG4_X1P4 (Configures a XMLSocketAppender for Chainsaw)
- LOG4_X1P5 (Configures a DailyRollingFileAppender + XMLLayout)
- LOG4_X1P6 (Configures a XMLSocketHubAppender for Chainsaw)
- LOG4_X1P7 (Configures a RollingFileAppender)
