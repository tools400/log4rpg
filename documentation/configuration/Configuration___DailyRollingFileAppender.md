# Configuration - DailyRollingFileAppender

This is an example configuration of a [DailyRollingFileAppender](appender/Appender___DailyRollingFileAppender.md). The appender uses a [PatternLayout](layout/Layout___PatternLayout.md) for rendering log events. The name of the log file is `log4rpg.log`. It is placed into the current directory. Usually this is the home directory, as specified in the user profile, parameter `HOMEDIR`.

## Configuration Data

```properties
log4rpg.debug=off, printer

log4rpg.rootLogger=DEBUG, file
log4rpg.logger.de.tools400=INFO

log4rpg.appender.file=DailyRollingFileAppender
log4rpg.appender.file.path=log4rpg.log
log4rpg.appender.file.layout=PatternLayout
log4rpg.appender.file.layout.conversionPattern=%z \[%-5p\] %L/%P(%M).%F (%S) %m%n
```

## Log Rotation

**Attaching new log file evry minute:**

```properties
log4rpg.appender.file.datePattern=-yyyy-MM-dd.HH.mm.
```

**Attaching new log file evry hour:**

```properties
log4rpg.appender.file.datePattern=-yyyy-MM-dd.HH.
```

**Attaching new log file daily:**

```properties
log4rpg.appender.file.datePattern=-yyyy-MM-dd.
```

***
© 2000-2025, Thomas Raddatz
