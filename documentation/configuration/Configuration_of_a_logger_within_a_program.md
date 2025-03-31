# Programmatic Logger Configuration

Usually Log4rpg is configured by a properties file, because it is the easiest and most flexible option. In rare circumstances it may be required to configure one or more loggers within a program. The following example configures a XMLSocketAppender for Chainsaw:

## Configuration Statements

```c
dcl-s hLogger like(LOG4RPG_hLogger_t);
dcl-s hLayout like(LOG4RPG_pLayout_t);
dcl-s hAppender like(LOG4RPG_pAppender_t);
dcl-s hFilter like(LOG4RPG_pFilter_t);

Configurator_clearConfiguration();

hLogger = Logger_getLogger(i_logger);
Logger_setLevel(g_hLogger: cLOG4RPG_LEVEL_DEBUG);

hLayout = Layout_new('*LIBL/LOG4RPG(XMLLayout)');

hFilter = Filter_new('appName'
                    : '*LIBL/LOG4PROFLT(PropertyFilter)'
                    : 'property.application=myApplication');

hAppender = Appender_new('chainsaw'
                        : '*LIBL/LOG4SCKAPP(XMLSocketAppender)'
                        : 'remoteHost=xxx.xxx.xxx.xxx; port=4448;');

Appender_setLayout(hAppender: hLayout);
Appender_setFilter(hAppender: hFilter);
```

***
© 2000-2025, Thomas Raddatz
