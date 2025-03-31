# XMLSocketHubAppender

**Service program:** LOG4SCKAPP\
**Procedure:** XMLSocketHubAppender

| Property | Value       | Comments                                                                                                                                                                                                    |
|:---------|:------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| port     | port        | Listener port number. Must be unique on the *IBM i*.                                                                                                                                                        |
| ccsid    | ccsid-value | CCSID used to create new the log files. Default: 850                                                                                                                                                        |
| layout   | layout-name | Name of the layout used to format the log events: `LIB/SRVPGM(ProcedurePrefix)`.<br>The built-in layouts can be specified by the following short cuts:<br>- PatternLayout<br> - SimpleLayout<br>- XMLLayout |

The XMLSocketAppender can be used to send the log events to [Chainsaw](Chainsaw___Overview.md>). In contrast to the [XMLSocketAppender](<appender/Appender___XMLSocketAppender.md) the `XMLSocketHubAppender` connects to *Chainsaw* on a PC as soon as it is startet. That makes it possible to connect *Chainsaw* to running processes on the *IBM i*. The `XMLSocketHubAppender` can manage up to 32 clients at the same time.

The `XMLSocketHubAppender` consists of service program `LOG4SHBAPP` and program `LOG4SHBAPC`. `LOG4SHBAPC` is startet as a thread for managing a client connection. It listens for incoming connections and forwards the log events to the clients. `LOG4SHBAPC` must reside in the same library as service program `LOG4SHBAPP`.

## Event Flow

`Event producer` --> `XMLSocketHubAppender (LOG4SHBAPP)` --> `XMLSocketHubAppender (LOG4SHBAPC)` -> *Chainsaw* application running on a PC

## Additional Information

The `XMLSockerHubAppender` acts as a server and hence each `XMLSockerHubAppender` must have its own listener port.

***
© 2000-2025, Thomas Raddatz
