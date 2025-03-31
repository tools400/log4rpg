# XMLSocketAppender

**Service program:** LOG4SCKAPP
**Procedure:** XMLSocketAppender

| Property          | Value        | Comments                                                                                                                                                                                                   |
|:------------------|:-------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| remoteHost        | host-address | Host name or IP-Address. Special value `localclient` that resolves to the TCP/IP address of the 5250 client of the current job.                                                                            |
| port              | port         | Number of the port to connect to.                                                                                                                                                                          |
| ccsid             | ccsid-value  | The CCSID that is used to send the log events to the destination address.                                                                                                                                  |
| filter            | filter-name  | Name of the filter to use.                                                                                                                                                                                 |
| layout            | layout-name  | Name of the layout used to format the log events: `LIB/SRVPGM(ProcedurePrefix)`.<br>The built-in layouts can be specified by the following short cuts:<br>- PatternLayout<br> -SimpleLayout<br>- XMLLayout |
| reconnectionDelay | wait-msecs   | Reconnection delay time measured in milliseconds.<br>Default: 30.000 msecs.                                                                                                                                |
| connectTimeout    | wait_msecs   | Timeout for establishing a new connection in milliseconds.<br>Default: 5.000 msecs.                                                                                                                        |

The XMLSocketAppender can be used to send the log events to [Chainsaw](Chainsaw___Overview.md).

## Additional Information

The `XMLSocketAppender` does not call the optional layout procedures `Layout_getHeader()` und `Layout_getFooter().

***
© 2000-2025, Thomas Raddatz
