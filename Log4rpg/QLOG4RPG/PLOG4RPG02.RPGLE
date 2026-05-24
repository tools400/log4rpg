**free
/if NOT defined(PLOG4RPG02)
/define PLOG4RPG02

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG01 Logger

dcl-s LOG4RPG_pLoggerList_t pointer based(pDummy);

dcl-ds LOG4RPG_LoggerListIterator_t qualified based(pDummy);
  pLogList like(LOG4RPG_pLoggerList_t);
  lastLog  int(10);
end-ds;

// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------

//  Creates a new logger list.
dcl-pr LoggerList_new like(LOG4RPG_pLoggerList_t) extproc('LOG4RPG02_LoggerList_new');
end-pr;

//  Returns the number of entries in a given logger list.
dcl-pr LoggerList_getNumE int(10) extproc('LOG4RPG02_LoggerList_NumE');
  i_pLogList like(LOG4RPG_pLoggerList_t) const;
end-pr;

//  Adds a logger to a given logger list.
dcl-pr LoggerList_put int(10) extproc('LOG4RPG02_LoggerList_put');
  i_pLogList like(LOG4RPG_pLoggerList_t) const;
  i_pLogger  like(LOG4RPG_hLogger_t) const;
end-pr;

//  Removes the specified logger from the given logger list.
dcl-pr LoggerList_remove int(10) extproc('LOG4RPG02_LoggerList_remove');
  i_pLogList like(LOG4RPG_pLoggerList_t) const;
  i_logName  like(LOG4RPG_loggerName_t) const;
end-pr;

//  Returns the logger that matches the specified name.
dcl-pr LoggerList_get like(LOG4RPG_hLogger_t) extproc('LOG4RPG02_LoggerList_get');
  i_pLogList like(LOG4RPG_pLoggerList_t) const;
  i_logName  like(LOG4RPG_loggerName_t) const;
end-pr;

//  Tests, if the logger list contains the specified logger.
dcl-pr LoggerList_exist ind extproc('LOG4RPG02_LoggerList_exist');
  i_pLogList like(LOG4RPG_pLoggerList_t) const;
  i_logName  like(LOG4RPG_loggerName_t) const;
end-pr;

//  Returns an iterator for the specified logger list.
dcl-pr LoggerList_getIterator likeds(LOG4RPG_LoggerListIterator_t)
  extproc('LOG4RPG02_LoggerList_getIterator');
  i_pLogList like(LOG4RPG_pLoggerList_t) const;
end-pr;

//  Returns the first logger of the specified logger list.
dcl-pr LoggerList_getFirst like(LOG4RPG_hLogger_t) extproc('LOG4RPG02_LoggerList_getFirst');
  io_logIter likeds(LOG4RPG_LoggerListIterator_t);
end-pr;

//  Returns the next logger of the specified logger list.
dcl-pr LoggerList_getNext like(LOG4RPG_hLogger_t) extproc('LOG4RPG02_LoggerList_getNext');
  io_logIter likeds(LOG4RPG_LoggerListIterator_t);
end-pr;

//  Deletes a given logger list.
dcl-pr LoggerList_delete ind extproc('LOG4RPG02_LoggerList_delete');
  io_pLogList like(LOG4RPG_pLoggerList_t);
end-pr;

//  Test the specified logger list object for a NULL value.
dcl-pr LoggerList_isNull ind extproc('LOG4RPG02_LoggerList_isNull');
  i_pLogList like(LOG4RPG_pLoggerList_t) const;
end-pr;

//  Returns a NULL logger list.
dcl-pr LoggerList_null like(LOG4RPG_pLoggerList_t) extproc('LOG4RPG02_LoggerList_null');
end-pr;

/endif