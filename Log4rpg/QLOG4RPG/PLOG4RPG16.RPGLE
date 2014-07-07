      /IF NOT DEFINED(PLOG4RPG16)
      /DEFINE PLOG4RPG16
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PSHARE                        Type defs appenders, layouts, filters
      *
     D LOG4RPG_pLogEvent_t...
     D                 S               *                       based(pDummy)
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Produces a new log event.
     D LogEvent_new...
     D                 PR                         like(LOG4RPG_pLogEvent_t)
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_new+
     D                                     ')
     D  i_logName                          const  like(LOG4RPG_loggerName_t    )
     D  i_priority                         const  like(LOG4RPG_priority_t      )
     D  i_text                             const  like(LOG4RPG_formattedText_t )
     D                                            options(*varsize)
     D  i_caller                           const  likeds(LOG4RPG_caller_t      )
      *
      *  Returns the property list of the log event.
     D LogEvent_getPropertyList...
     D                 PR                         like(LOG4RPG_pPropertyList_t)
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_getPropertyList+
     D                                     ')
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t    )
      *
      *  Sets the text of the log event
     D LogEvent_setText...
     D                 PR
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_setText+
     D                                     ')
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
     D  i_text                             const  like(LOG4RPG_formattedText_t )
     D                                             options(*varsize)
      *
      *  Appends the text of the log event
     D LogEvent_appendText...
     D                 PR
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_appendText+
     D                                     ')
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
     D  i_text                             const  like(LOG4RPG_formattedText_t )
     D                                             options(*varsize)
      *
      *  Returns the name of the logger that produced the specified log event.
     D LogEvent_getLoggerName...
     D                 PR                         like(LOG4RPG_loggerName_t    )
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_getLoggerName+
     D                                     ')
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Returns the priority of the log event.
     D LogEvent_getPriority...
     D                 PR                         like(LOG4RPG_priority_t      )
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_getPriority+
     D                                     ')
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Returns the level of the log event.
     D LogEvent_getLevel...
     D                 PR                         like(LOG4RPG_level_t         )
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_getLevel+
     D                                     ')
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Returns the time at which the log event was produced.
     D LogEvent_getTime...
     D                 PR              Z
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_getTime+
     D                                     ')
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Returns the qualified name of the procedure that called the logger.
     D LogEvent_getCaller...
     D                 PR                         likeds(LOG4RPG_caller_t      )
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_getCaller+
     D                                     ')
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Resolves the name of the library of the program that called Log4rpg.
     D LogEvent_resolveCallerPgmLibrary...
     D                 PR            10A
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_resolveCallerPgmLibrary+
     D                                     ')
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Returns the log event text.
     D LogEvent_getText...
     D                 PR                         like(LOG4RPG_formattedText_t )
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_getText+
     D                                     ')
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Returns a pointer to the log event text.
     D LogEvent_getTextPointer...
     D                 PR              *
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_getTextPointer+
     D                                     ')
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Returns the length of the log event text.
     D LogEvent_textLength...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_textLength+
     D                                     ')
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Returns the first line of text.
     D LogEvent_getFirstLineOfText...
     D                 PR                         like(LOG4RPG_formattedText_t )
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_getFirstLineOfText+
     D                                     ')
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
     D  o_isText                       N
     D  i_width                      10U 0 const  options(*nopass)
      *
      *  Returns the next line of text.
     D LogEvent_getNextLineOfText...
     D                 PR                         like(LOG4RPG_formattedText_t )
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_getNextLineOfText+
     D                                     ')
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
     D  o_isText                       N
     D  i_width                      10U 0 const  options(*nopass)
      *
      *  Deletes a given log event.
     D LogEvent_delete...
     D                 PR
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_delete+
     D                                     ')
     D  io_pLogEvent                              like(LOG4RPG_pLogEvent_t     )
      *
      *  Tests a given log event for a NULL value.
     D LogEvent_isNull...
     D                 PR              N
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_isNull+
     D                                     ')
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Returns a NULL log event.
     D LogEvent_null...
     D                 PR                         like(LOG4RPG_pLogEvent_t     )
     D                                     extproc('LOG4RPG16+
     D                                     _LogEvent_null+
     D                                     ')
      *
      /ENDIF
