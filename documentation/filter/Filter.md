# Filter

## Description

Filters are used to further analyse the log event in order to determine, whether the log event has to be logged or not. The result of a filter decision equals one of the following values:

- cFILTER_ACCEPT

- cFILTER_DENY

- cFILTER_NEUTRAL

Filter can be used to change the log event. For example the [PropertyFilter](Filter___PropertyFilter.md) is used to add properties to a log event.

*Log4rpg* is shipped with one ready-to-go filter:

- [PropertyFilter](Filter___PropertyFilter.md)

Based on the shipped filter and with the help of your phantasy you can write filters for whatever purpose you need.

Please refer to member `PFILTER` to get additinal information about writing filters.

## Configuration

Filters are defined in the *Log4rpg* properties file. They are independant objects that can be added to appenders. A filter entry starts with `log4rpg.filter.` followed by an arbitrary name of the filter. The service program implementing the filter follows right after the equal sign. Example:

```properties
log4rpg.filter.appName=*LIBL/LOG4PROFLT(PropertyFilter)
```

The filter properties are added like this:

```properties
log4rpg.filter.appName.property.application=myApplication
```

## API Reference

- [Filter_new()](reference/Filter_new___Create_filter.md)
- [Filter_setNext()](reference/Filter_setNext___Set_follow_up_filter.md)

***
© 2000-2025, Thomas Raddatz
