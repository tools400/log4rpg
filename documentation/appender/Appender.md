# Appender

## Description

Appender are used to append the log event to an arbitrary output target. Usually log events are written to a file. However it is also possible to send log events over the Internet using e-mail or a socket connection.

*Log4rpg* is shipped with three ready-to-go appenders:

- [DailyRollingFileAppender](Appender___DailyRollingFileAppender.md)
- [DailyRollingPrintAppender](Appender___DailyRollingPrintAppender.md)
- [NullAppender](Appender___NullAppender.md)
- [RollingFileAppender](Appender___RollingFileAppender.md)
- [XmlSocketAppender](Appender___XmlSocketAppender.md)
- [XmlSocketHubAppender](Appender___XmlSocketHubAppender.md)

Based on the shipped appenders and with the help of your phantasy you can write appenders for whatever target you want.

Please refer to member `PAPPENDER` to get additinal information about writing appenders.

## Configuration

Appenders are defined in the *Log4rpg* properties file. They are independant objects that can be assigned to loggers. An appender entry starts with `log4rpg.appender.` followed by an arbitrary name of the appender. The service program implementing the appender follows right after the equal sign. Example:

```properties
log4rpg.appender.file=*LIBL/LOG4RPG(DailyRollingFileAppender)
```

The appender properties are added like this:

```properties
log4rpg.appender.file.path=log4_x1p1.log
log4rpg.appender.file.layout=PatternLayout
```

## API Reference

- [Appender_new()](reference/Appender_new___Create_appender.md)
- [Appender_setFilter()](reference/Appender_setFilter___Set_filter_for_appender.md)
- [Appender_setLayout()](reference/Appender_setLayout___Set_layout_for_appender.md)

***
© 2000-2025, Thomas Raddatz
