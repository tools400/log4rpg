# Layout

Appender work hand in hand with layouts. While the task of an appender is to append the log event to a logging target, layouts format the log event.

Of course it is not required that an appender uses a layout. It that case it appends the raw text to the logging target.

*Log4rpg* is shipped with the following ready-to-go layouts:

- [HTMLLayout](./Layout___HTMLLayout.md)

- [PatternLayout](./Layout___PatternLayout.md)

- [SimpleLayout](./Layout___SimpleLayout.md)

- [XMLLayout](./Layout___XMLLayout.md)

Based on the shipped layouts and with the help of your phantasy you can write layouts for whatever purpose you need.

Please refer to member `PLAYOUT` to get additinal information about writing layouts.

## Configuration

Layouts are defined in the *Log4rpg* properties file. They are part of an appender. A layout entry starts with `log4rpg.appender.[appender_name].layout.` followed by an arbitrary name of the layout. The service program implementing the layout follows right after the equal sign. Example:

```properties
log4rpg.appender.file.layout=PatternLayout
```

The layout properties are added like this:

```properties
log4rpg.appender.file.layout.conversionPattern=%z [%-5p] %L/%P(%M).%F (%S) %m%n
```

## API Reference

- [Layout_new()](reference/Layout_new___Create_layout.md)

***
© 2000-2025, Thomas Raddatz
