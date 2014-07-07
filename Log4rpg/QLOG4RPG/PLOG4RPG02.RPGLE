      /IF NOT DEFINED(PLOG4RPG02)
      /DEFINE PLOG4RPG02
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG01                    Logger
      *
     D LOG4RPG_pLoggerList_t...
     D                 S               *                           based(pDummy)
      *
     D LOG4RPG_LoggerListIterator_t...
     D                 DS                  qualified               based(pDummy)
     D  pLogList                           like(LOG4RPG_pLoggerList_t )
     D  lastLog                      10I 0
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Creates a new logger list.
     D LoggerList_new...
     D                 PR                         like(LOG4RPG_pLoggerList_t )
     D                                     extproc('LOG4RPG02+
     D                                     _LoggerList_new+
     D                                     ')
      *
      *  Returns the number of entries in a given logger list.
     D LoggerList_getNumE...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG02+
     D                                     _LoggerList_NumE+
     D                                     ')
     D  i_pLogList                         const  like(LOG4RPG_pLoggerList_t )
      *
      *  Adds a logger to a given logger list.
     D LoggerList_put...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG02+
     D                                     _LoggerList_put+
     D                                     ')
     D  i_pLogList                         const  like(LOG4RPG_pLoggerList_t )
     D  i_pLogger                          const  like(LOG4RPG_hLogger_t     )
      *
      *  Removes the specified logger from the given logger list.
     D LoggerList_remove...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG02+
     D                                     _LoggerList_remove+
     D                                     ')
     D  i_pLogList                         const  like(LOG4RPG_pLoggerList_t )
     D  i_logName                          const  like(LOG4RPG_loggerName_t  )
      *
      *  Returns the logger that matches the specified name.
     D LoggerList_get...
     D                 PR                  like(LOG4RPG_hLogger_t       )
     D                                     extproc('LOG4RPG02+
     D                                     _LoggerList_get+
     D                                     ')
     D  i_pLogList                         const  like(LOG4RPG_pLoggerList_t )
     D  i_logName                          const  like(LOG4RPG_loggerName_t  )
      *
      *  Tests, if the logger list contains the specified logger.
     D LoggerList_exist...
     D                 PR              N
     D                                     extproc('LOG4RPG02+
     D                                     _LoggerList_exist+
     D                                     ')
     D  i_pLogList                         const  like(LOG4RPG_pLoggerList_t )
     D  i_logName                          const  like(LOG4RPG_loggerName_t  )
      *
      *  Returns an iterator for the specified logger list.
     D LoggerList_getIterator...
     D                 PR                  likeds(LOG4RPG_Logger...
     D                                                    ListIterator_t   )
     D                                     extproc('LOG4RPG02+
     D                                     _LoggerList_getIterator+
     D                                     ')
     D  i_pLogList                         const  like(LOG4RPG_pLoggerList_t )
      *
      *  Returns the first logger of the specified logger list.
     D LoggerList_getFirst...
     D                 PR                  like(LOG4RPG_hLogger_t       )
     D                                     extproc('LOG4RPG02+
     D                                     _LoggerList_getFirst+
     D                                     ')
     D  io_logIter                                likeds(LOG4RPG_Logger...
     D                                                           ListIterator_t)
      *
      *  Returns the next logger of the specified logger list.
     D LoggerList_getNext...
     D                 PR                  like(LOG4RPG_hLogger_t       )
     D                                     extproc('LOG4RPG02+
     D                                     _LoggerList_getNext+
     D                                     ')
     D  io_logIter                                likeds(LOG4RPG_Logger...
     D                                                           ListIterator_t)
      *
      *  Deletes a given logger list.
     D LoggerList_delete...
     D                 PR              N
     D                                     extproc('LOG4RPG02+
     D                                     _LoggerList_delete+
     D                                     ')
     D  io_pLogList                               like(LOG4RPG_pLoggerList_t )
      *
      *  Test the specified logger list object for a NULL value.
     D LoggerList_isNull...
     D                 PR              N
     D                                     extproc('LOG4RPG02+
     D                                     _LoggerList_isNull+
     D                                     ')
     D  i_pLogList                         const  like(LOG4RPG_pLoggerList_t )
      *
      *  Returns a NULL logger list.
     D LoggerList_null...
     D                 PR                         like(LOG4RPG_pLoggerList_t )
     D                                     extproc('LOG4RPG02+
     D                                     _LoggerList_null+
     D                                     ')
      *
      /ENDIF
