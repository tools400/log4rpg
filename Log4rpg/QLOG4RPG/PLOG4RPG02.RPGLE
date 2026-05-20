**FREE
/IF NOT DEFINED(PLOG4RPG02)
/DEFINE PLOG4RPG02
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/COPY QLOG4RPG,PLOG4RPG01                    Logger
//
dcl-s LOG4RPG_pLoggerList_t
      pointer based(pDummy);
//
dcl-ds LOG4RPG_LoggerListIterator_t
       qualified               based(pDummy);
  pLogList        like(LOG4RPG_pLoggerList_t );
  lastLog         int(10);
end-ds;
//
// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
//
//  Creates a new logger list.
dcl-pr LoggerList_new
       like(LOG4RPG_pLoggerList_t )
       extproc('LOG4RPG02+
       _LoggerList_new+
       ');
end-pr;
//
//  Returns the number of entries in a given logger list.
dcl-pr LoggerList_getNumE
       int(10)
       extproc('LOG4RPG02+
       _LoggerList_NumE+
       ');
  i_pLogList      const  like(LOG4RPG_pLoggerList_t );
end-pr;
//
//  Adds a logger to a given logger list.
dcl-pr LoggerList_put
       int(10)
       extproc('LOG4RPG02+
       _LoggerList_put+
       ');
  i_pLogList      const  like(LOG4RPG_pLoggerList_t );
  i_pLogger       const  like(LOG4RPG_hLogger_t     );
end-pr;
//
//  Removes the specified logger from the given logger list.
dcl-pr LoggerList_remove
       int(10)
       extproc('LOG4RPG02+
       _LoggerList_remove+
       ');
  i_pLogList      const  like(LOG4RPG_pLoggerList_t );
  i_logName       const  like(LOG4RPG_loggerName_t  );
end-pr;
//
//  Returns the logger that matches the specified name.
dcl-pr LoggerList_get
       like(LOG4RPG_hLogger_t       )
       extproc('LOG4RPG02+
       _LoggerList_get+
       ');
  i_pLogList      const  like(LOG4RPG_pLoggerList_t );
  i_logName       const  like(LOG4RPG_loggerName_t  );
end-pr;
//
//  Tests, if the logger list contains the specified logger.
dcl-pr LoggerList_exist
       ind
       extproc('LOG4RPG02+
       _LoggerList_exist+
       ');
  i_pLogList      const  like(LOG4RPG_pLoggerList_t );
  i_logName       const  like(LOG4RPG_loggerName_t  );
end-pr;
//
//  Returns an iterator for the specified logger list.
dcl-ds LoggerList_getIterator...
       PR                  likeds(LOG4RPG_Logger
ListIterator_t   )
extproc('LOG4RPG02+
_LoggerList_getIterator+
');
i_pLogList      const  like(LOG4RPG_pLoggerList_t );
end-ds;
//
//  Returns the first logger of the specified logger list.
dcl-pr LoggerList_getFirst
       like(LOG4RPG_hLogger_t       )
       extproc('LOG4RPG02+
       _LoggerList_getFirst+
       ');
  io_logIter      likeds(LOG4RPG_Logger...
ListIterator_t);
end-pr;
//
//  Returns the next logger of the specified logger list.
dcl-pr LoggerList_getNext
       like(LOG4RPG_hLogger_t       )
       extproc('LOG4RPG02+
       _LoggerList_getNext+
       ');
  io_logIter      likeds(LOG4RPG_Logger...
ListIterator_t);
end-pr;
//
//  Deletes a given logger list.
dcl-pr LoggerList_delete
       ind
       extproc('LOG4RPG02+
       _LoggerList_delete+
       ');
  io_pLogList     like(LOG4RPG_pLoggerList_t );
end-pr;
//
//  Test the specified logger list object for a NULL value.
dcl-pr LoggerList_isNull
       ind
       extproc('LOG4RPG02+
       _LoggerList_isNull+
       ');
  i_pLogList      const  like(LOG4RPG_pLoggerList_t );
end-pr;
//
//  Returns a NULL logger list.
dcl-pr LoggerList_null
       like(LOG4RPG_pLoggerList_t )
       extproc('LOG4RPG02+
       _LoggerList_null+
       ');
end-pr;
//
/ENDIF
