# Overview

Usually it is a quite time consuming job to debug an application. The time you need to get the error increases the smaller the pieces of the application are. The programmer often has to use the single-step mode of the debugger to get close to the bug. When concentration goes down he often needs several attempts due to his fingers getting faster and faster. Before he realized what happened, he again stepped over the intersting part of the code.

Logging enables the programmer to watch the program flow. That makes it a lot easier to locate the bug. The amount of lines of code the programmer has to analyse is reduced and usually the programmer gets the bug faster. having said that it is clear that I am not talking about a big secret. Moost of the programmers know that but do not want to change and recompile the application just to get logging statements.

What, if you had a logger that could be configured without changing the source code. Would'nt that be nice?

That is the point when Log4rpg comes into play. Log4rpg is a powerful logger that was inspired by the great Java Log4j utility. Similar to Log4j it supports:

- a logger hierarchy

- user defined appender

- user defined layouts

Log4rpg is configured using IFS files or file member. Hence no changes to the source code are required to enable or disable Log4rpg.

The output of Log4rpg can be send to everywhere because it is up to you to use an appropriate appender. It is the appender that determines what to do with the log event. If there is not yet an appender that fits your needs - develop one and make it public.

Log4rpg comes with predefined appenders to make it easier to start. The '*DailyRollingFileAppender*' appends log events to an IFS file. The '*DailyRollingPrintAppender*' write the log events to a printer file. The '*NullAppender*' passes the log events to a NULL device.

While it is up to the appender to send the log events to a target, it is up to the layouts to do the necessary formatting. For example there could be a layout that formats the log event according to the rules of a CSV string. In addition the layout is responsible for gathering and adding additional information to the log event. As with appenders Log4rpg is shipped with three ready-to-go layouts: '*PatternLayout*', '*SimpleLayout*' und '*XMLLayout*'.

If that is not enough: Write your own appenders and layouts.

***
© 2000-2025, Thomas Raddatz
