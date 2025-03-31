# Logger Hierarchy

Log4rpg implements a logger hierachy similar to the one of Log4j. The logger hierarchy makes it easy to switch on or off a whole bunch of loggers at once. The logger hierarchy is build from the names of the logger. Hence the programmer can define a hierarchy that satisfies his needs.

**Rule 1**: A logger is the parent of another logger in case that its name followed by a dot is the prefix of the name of the child logger.

**Rule 2**: The root logger is at the top of the logger hierarchy. It does not have any parents. Each logger that has no parent according to the first rule is a child of the root logger.

The following properties are taken from the parent logger if not yet set for the child logger:

- Log-Level

- Appender List

One option to stablish a logger hierarchy is to use logical names. Given that an application has a module '*CustomerOrder*' that consists of '*Order*' and '*Invoice*', '*Invoice*' could consist of '*Create*' and '*Print*'. Based on this assumptions the logger hierarchy may look like this:

- root

- CustomerOrder

- CustomerOrder.Order

- CustomerOrder.Invoice

- CustomerOrder.Invoice.Create

- CustomerOrder.Invoice.Print

Now the log level of '*CustomerOrder*' can be set to '*FATAL*' with appender '*file*':

```properties
log4rpg.logger.customerOrder=FATAL, file
```

But the log level of '*CustomerOrder.Invoice.Create*' can independently changed to '*DEBUG*':

```properties
log4rpg.logger.customerOrder.invoice.create=DEBUG
```

That means that a basic log is produced for '*CustomerOrder*' and that a detailed log is written for '*CustomerOrder.Invoice.Create*'.

That is what how the configuration file might look like:

```properties
log4rpg.debug=on, printer

log4rpg.logger.customerOrder=FATAL, file
log4rpg.logger.customerOrder.invoice.create=DEBUG
log4rpg.logger.customerOrder.invoice.create.whatEverElse=WARN

log4rpg.appender.file=DailyRollingFileAppender
log4rpg.appender.file.path=log4rpg.log
log4rpg.appender.file.datePattern=_YYYY-MM-dd-HH.mm.
log4rpg.appender.filelayout=PatternLayout
log4rpg.appender.file.conversionPattern=%z \[%-5p\] %P(%M).%F (%S) %m%n
```

All children of '*CustomerOrder*' inherit the '*file*' appender of '*CustomerOrder*' because there are no appenders defined for the children. In addition the '*CustomerOrder.Order*' logger inherits log level '*FATAL*'.

Last but not least the internal debug log of Log4rpg is enabled. It looks like this:

```text
log4rpg:WARN Could not find root logger information. Is this OK?
log4rpg:WARN No appenders could be found for logger \[root\]
log4rpg:WARN Please initialize the log4rpg system properly.
```

The Log4rpg debug log complains about that Log4rpg is not properly configured because the configuration file does not specify **root logger** properties.

The root logger should always be configured, because it is the parent for all loggers without an ancestor.

***
(c) 2025, Thomas Raddatz