# Configuration - RollingFileAppender

This is an example configuration of a [RollingFileAppender](appender/Appender___RollingFileAppender.md). The appender uses a [PatternLayout](layout/Layout___PatternLayout.md) for renedering the log events. The name of the log file is `log4rpg.log`. It is placed into the current directory. Usually this is the home directory, as specified in the user profile, parameter `HOMEDIR`.

## Configuration Data

```properties
log4rpg.debug=off, printer

log4rpg.rootLogger=DEBUG, file
log4rpg.logger.de.tools400=INFO

log4rpg.appender.file=*LIBL/LOG4RLFAPP(RollingFileAppender)
log4rpg.appender.file.path=log4rpg.log
log4rpg.appender.file.maxFileSize=128
log4rpg.appender.file.maxBackupIndex=10
log4rpg.appender.file.layout=PatternLayout
log4rpg.appender.file.layout.conversionPattern=%z \[%-5p\] %L/%P(%M).%F (%S) %m%n
```

## Log Rotation

A maximum of 10 backup files are created.

***
© 2000-2025, Thomas Raddatz
