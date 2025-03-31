# Configuration - DailyRollingPrintAppender

This is a example configuration of a [**DailyRollingPrintAppender**](appender/Appender___DailyRollingPrintAppender.md>). The appender uses a [**PatternLayout**](<layout/Layout___PatternLayout.md) to render the log events. The name of the spooled file is 'LOG4RPGLOG'. It is placed into the output queue of the user.

## Configuration Data

```properties
log4rpg.debug=off, printer

log4rpg.rootLogger=DEBUG, print
log4rpg.logger.de.tools400=INFO

log4rpg.appender.print=DailyRollingPrintAppender
log4rpg.appender.print.splfName=LOG4RPGLOG
log4rpg.appender.print.length=49
log4rpg.appender.print.width=132
log4rpg.appender.print.lpi=6
log4rpg.appender.print.cpi=10
log4rpg.appender.print.ovrflw=42
log4rpg.appender.print.leftMargin=10
log4rpg.appender.print.rightMargin=10
log4rpg.appender.print.layout=PatternLayout log4rpg.appender.print.layout.conversionPattern=%z \[%-5p\] %P(%M).%F (%S) %m%n
```

## Log Rotation

**Attaching new log spooled file every minute:**

```properties
log4rpg.appender.print.datePattern=yyyy-MM-dd.HH.mm
```

**Attaching new log spooled file every hour:**

```properties
log4rpg.appender.print.datePattern=yyyy-MM-dd.HH
```

**Attaching new log spooled fileevery day:**

```properties
log4rpg.appender.print.datePattern=yyyy-MM-dd
```

***
© 2000-2025, Thomas Raddatz
