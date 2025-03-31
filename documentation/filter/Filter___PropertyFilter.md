# PropertyFilter

Service program:&nbsp; &nbsp; LOG4PROFLT\
Procedure:&nbsp; &nbsp; PropertyFilter

| **Property** | **Value** | ## Comments |
|:---------|:------|:---------|
| property | value | Defines an arbitrary property for the log event. A property is nothing more than a key/value pair. |

PropertyFilter are used to add the "application" property to log events if the log events are send to [**Chainsaw**](Chainsaw___Overview.md). Chainsaw uses the "application" property together with the host name to determine which tab to use to present the log events.

**Chainsaw example:**

log4rpg.filter.appName=\*LIBL/LOG4PROFLT(PropertyFilter)

log4rpg.filter.appName.property.application=myApplication

***
© 2000-2025, Thomas Raddatz
