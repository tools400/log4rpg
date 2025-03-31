# PatternLayout

**Service program:** built-in
**Procedure:** PatternLayout

| Property          | Value   | Comments                                                                                                                                                                    |
|:------------------|:--------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| conversionPattern | pattern | Pattern specifying the layout:<br>%p - priority<br>%t - time<br>%d - date<br>%z - timestamp<br>%l - logger name<br>%m - log message<br>%n - new line<br>%P - program name<br>%L - library name (slow!)<br>%M - module name<br>%F - procedure name<br>%S - statement number<br>%j - qualified job name<br>%u - user name<br>%U - current user name |
| timestampPattern  | pattern | Pattern specifying the layout:<br>%Y - 4-digit year<br>%d - month<br>%d - day of week<br>%H - Hour in 24-hour format [00-23]<br>%I - Hour in 12-hour format [01-12]<br>%M - Minute<br>%S - Second<br>%ms - microseconds<br>The complete list of possible patterns can be found in the documentation of the `strftime()` function. |

`%L` is slow, because of the Retrieve Call Stack (QWVRCSTK) API beeing slow. All other information can be gathered by sending and retrieving a message to the call stack entry that issued the log statement.

`%ms` the default is a 6-digit microsecond value. The number of digits (1-6) can be appended to `%ms`. For example: `%ms3` produces a 3-digit microsecond value.

## Output

![Image](assets/output-pattern-layout.png)

***
© 2000-2025, Thomas Raddatz
