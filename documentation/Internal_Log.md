# Internal Log

*Log4rpg* has a built-in log that can be used to learn more about the internals of *Log4rpg* or to debug it.

The internal log is controlled by the `log4rpg.debug` property:

```prioperties
log4rpg.debug=on, printer
```

The first parameter specifies the log level, hence how detailed the log is. The valid values are:

- quiet - absolutely no log events are written to the log

- off - only warnings or error messages are written to the log

- on - the program flow is written to the log

- verbose - each and evrything is written to the log

The second parameter specifies the output target. The valid values are:

- printer - log events are written to a spool file

- stdout - log events are written to STDOUT

It is also possible to enable/disable the internal log by calling procedure [Logger_setInternalDebugging](reference/Logger_setInternalDebugging___Enable_Disable_internal_log.md).

***
© 2000-2025, Thomas Raddatz
