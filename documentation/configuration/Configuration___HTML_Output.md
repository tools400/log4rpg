# Configuration - HTML Output

This example shows how to configure a [DailyRollingFileAppender](<appender/Appender___DailyRollingFileAppender.md) which uses a [HTMLLayout](layout/Layout___HTMLLayout.md) producing HTML log output. The name of the file is `log4rpg.html`. It is placed into the current directory. Usually this is the home directory, as specified in the user profile, parameter `HOMEDIR`.

## Configuration Data

```properties
log4rpg.debug=off, printer

log4rpg.rootLogger=DEBUG, html
log4rpg.logger.de.tools400=INFO

log4rpg.appender.html=DailyRollingFileAppender
log4rpg.appender.html.path=log4rpg.html
log4rpg.appender.html.layout=*LIBL/LOG4HTMLAY(HTMLLayout)
```

***
© 2000-2025, Thomas Raddatz
