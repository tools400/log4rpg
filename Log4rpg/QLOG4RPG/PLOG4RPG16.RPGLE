**free
/if NOT defined(PLOG4RPG16)
/define PLOG4RPG16

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PSHARE Type defs appenders, layouts, filters

dcl-s LOG4RPG_pLogEvent_t pointer based(pDummy);

// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------

//  Produces a new log event.
dcl-pr LogEvent_new like(LOG4RPG_pLogEvent_t) extproc('LOG4RPG16_LogEvent_new');
  i_logName  like(LOG4RPG_loggerName_t) const;
  i_priority like(LOG4RPG_priority_t) const;
  i_text     like(LOG4RPG_formattedText_t) options(*varsize) const;
  i_caller   likeds(LOG4RPG_caller_t) const;
end-pr;

//  Returns the property list of the log event.
dcl-pr LogEvent_getPropertyList like(LOG4RPG_pPropertyList_t)
  extproc('LOG4RPG16_LogEvent_getPropertyList');
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Sets the text of the log event
dcl-pr LogEvent_setText extproc('LOG4RPG16_LogEvent_setText');
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  i_text      like(LOG4RPG_formattedText_t) options(*varsize) const;
end-pr;

//  Appends the text of the log event
dcl-pr LogEvent_appendText extproc('LOG4RPG16_LogEvent_appendText');
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  i_text      like(LOG4RPG_formattedText_t) options(*varsize) const;
end-pr;

//  Returns the name of the logger that produced the specified log event.
dcl-pr LogEvent_getLoggerName like(LOG4RPG_loggerName_t) extproc('LOG4RPG16_LogEvent_getLoggerName')
  ;
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Returns the priority of the log event.
dcl-pr LogEvent_getPriority like(LOG4RPG_priority_t) extproc('LOG4RPG16_LogEvent_getPriority');
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Returns the level of the log event.
dcl-pr LogEvent_getLevel like(LOG4RPG_level_t) extproc('LOG4RPG16_LogEvent_getLevel');
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Returns the time at which the log event was produced.
dcl-pr LogEvent_getTime timestamp extproc('LOG4RPG16_LogEvent_getTime');
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Returns the qualified name of the procedure that called the logger.
dcl-pr LogEvent_getCaller likeds(LOG4RPG_caller_t) extproc('LOG4RPG16_LogEvent_getCaller');
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Resolves the name of the library of the program that called Log4rpg.
dcl-pr LogEvent_resolveCallerPgmLibrary char(10)
  extproc('LOG4RPG16_LogEvent_resolveCallerPgmLibrary');
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Returns the log event text.
dcl-pr LogEvent_getText like(LOG4RPG_formattedText_t) extproc('LOG4RPG16_LogEvent_getText');
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Returns a pointer to the log event text.
dcl-pr LogEvent_getTextPointer pointer extproc('LOG4RPG16_LogEvent_getTextPointer');
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Returns the length of the log event text.
dcl-pr LogEvent_textLength int(10) extproc('LOG4RPG16_LogEvent_textLength');
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Returns the first line of text.
dcl-pr LogEvent_getFirstLineOfText like(LOG4RPG_formattedText_t)
  extproc('LOG4RPG16_LogEvent_getFirstLineOfText');
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  o_isText    ind;
  i_width     uns(10) options(*nopass) const;
end-pr;

//  Returns the next line of text.
dcl-pr LogEvent_getNextLineOfText like(LOG4RPG_formattedText_t)
  extproc('LOG4RPG16_LogEvent_getNextLineOfText');
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  o_isText    ind;
  i_width     uns(10) options(*nopass) const;
end-pr;

//  Deletes a given log event.
dcl-pr LogEvent_delete extproc('LOG4RPG16_LogEvent_delete');
  io_pLogEvent like(LOG4RPG_pLogEvent_t);
end-pr;

//  Tests a given log event for a NULL value.
dcl-pr LogEvent_isNull ind extproc('LOG4RPG16_LogEvent_isNull');
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Returns a NULL log event.
dcl-pr LogEvent_null like(LOG4RPG_pLogEvent_t) extproc('LOG4RPG16_LogEvent_null');
end-pr;

/endif