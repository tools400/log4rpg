      /IF NOT DEFINED(PLOG4RPG04)
      /DEFINE PLOG4RPG04
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG03                    Appender
      *
     D LOG4RPG_pAppenderList_t...
     D                 S               *                           based(pDummy)
      *
     D LOG4RPG_AppenderListIterator_t...
     D                 DS                  qualified               based(pDummy)
     D  pAppList                           like(LOG4RPG_pAppenderList_t )
     D  lastApp                      10I 0
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Creates a new appender list.
     D AppenderList_new...
     D                 PR                         like(LOG4RPG_pAppenderList_t )
     D                                     extproc('LOG4RPG04+
     D                                     _AppenderList_new+
     D                                     ')
      *
      *  Returns the number of entries in a given appender list.
     D AppenderList_getNumE...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG04+
     D                                     _AppenderList_NumE+
     D                                     ')
     D  i_pAppList                         const  like(LOG4RPG_pAppenderList_t )
      *
      *  Adds an appender to a given appender list.
     D AppenderList_put...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG04+
     D                                     _AppenderList_put+
     D                                     ')
     D  i_pAppList                         const  like(LOG4RPG_pAppenderList_t )
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
      *
      *  Removes the specified appender from the given appender list.
     D AppenderList_remove...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG04+
     D                                     _AppenderList_remove+
     D                                     ')
     D  i_pAppList                         const  like(LOG4RPG_pAppenderList_t )
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
      *
      *  Returns the appender that matches the specified name.
     D AppenderList_get...
     D                 PR                  like(LOG4RPG_pAppender_t     )
     D                                     extproc('LOG4RPG04+
     D                                     _AppenderList_get+
     D                                     ')
     D  i_pAppList                         const  like(LOG4RPG_pAppenderList_t )
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
      *
      *  Tests, if the appender list contains the specified appender.
     D AppenderList_exist...
     D                 PR              N
     D                                     extproc('LOG4RPG04+
     D                                     _AppenderList_exist+
     D                                     ')
     D  i_pAppList                         const  like(LOG4RPG_pAppenderList_t )
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
      *
      *  Returns an iterator for the specified appender list.
     D AppenderList_getIterator...
     D                 PR                  likeds(LOG4RPG_Appender...
     D                                                    ListIterator_t   )
     D                                     extproc('LOG4RPG04+
     D                                     _AppenderList_getIterator+
     D                                     ')
     D  i_pAppList                         const  like(LOG4RPG_pAppenderList_t )
      *
      *  Returns the first appender of the specified appender list.
     D AppenderList_getFirst...
     D                 PR                  like(LOG4RPG_pAppender_t     )
     D                                     extproc('LOG4RPG04+
     D                                     _AppenderList_getFirst+
     D                                     ')
     D  io_appIter                                likeds(LOG4RPG_Appender...
     D                                                           ListIterator_t)
      *
      *  Returns the next appender of the specified appender list.
     D AppenderList_getNext...
     D                 PR                  like(LOG4RPG_pAppender_t     )
     D                                     extproc('LOG4RPG04+
     D                                     _AppenderList_getNext+
     D                                     ')
     D  io_appIter                                likeds(LOG4RPG_Appender...
     D                                                           ListIterator_t)
      *
      *  Deletes a given appender list.
     D AppenderList_delete...
     D                 PR              N
     D                                     extproc('LOG4RPG04+
     D                                     _AppenderList_delete+
     D                                     ')
     D  io_pAppList                               like(LOG4RPG_pAppenderList_t )
      *
      *  Test the specified appender list object for a NULL value.
     D AppenderList_isNull...
     D                 PR              N
     D                                     extproc('LOG4RPG04+
     D                                     _AppenderList_isNull+
     D                                     ')
     D  i_pAppList                         const  like(LOG4RPG_pAppenderList_t )
      *
      *  Returns a NULL appender list.
     D AppenderList_null...
     D                 PR                         like(LOG4RPG_pAppenderList_t )
     D                                     extproc('LOG4RPG04+
     D                                     _AppenderList_null+
     D                                     ')
      *
      /ENDIF
