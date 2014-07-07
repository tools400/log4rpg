      /IF NOT DEFINED(PLOG4RPG03)
      /DEFINE PLOG4RPG03
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PSHARE                        Type defs appenders, layouts, filters
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Creates a new appender.
      *  ==> PLOG4RPG
      *
      *  Appends a message to the specified appender.
     D Appender_doAppend...
     D                 PR              N
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_doAppend+
     D                                     ')
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Returns the name of the specified appender.
     D Appender_getName...
     D                 PR                         like(LOG4RPG_appenderName_t  )
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_getName+
     D                                     ')
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
      *
      *  Returns the layout of the specified appender.
     D Appender_getLayout...
     D                 PR                         like(LOG4RPG_pLayout_t       )
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_getLayout+
     D                                     ')
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
      *
      *  Sets the properties of the specified appender.
     D Appender_setProperties...
     D                 PR
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_setProperties+
     D                                     ')
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Deletes a given appender.
     D Appender_delete...
     D                 PR              N
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_delete+
     D                                     ')
     D  io_pAppender                              like(LOG4RPG_pAppender_t     )
      *
      *  Tests a given appender for a NULL value.
     D Appender_isNull...
     D                 PR              N
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_isNull+
     D                                     ')
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
      *
      *  Returns TRUE if the appender requires a layout.
     D Appender_requiresLayout...
     D                 PR              N
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_requiresLayout+
     D                                     ')
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
      *
      *  Sets the layout for the specified appender.
      *  ==> PLOG4RPG
      *
      *  Sets the filter for the specified appender.
      *  ==> PLOG4RPG
      *
      *  Returns the filter attached to the appender.
     D Appender_getFilter...
     D                 PR                         like(LOG4RPG_pFilter_t       )
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_getFilter+
     D                                     ')
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
      *
      *  Tests, whether the specified property is known by the
      *  super Appender.
     D Appender_knowsProperty...
     D                 PR              N
     D                                     extproc('LOG4RPG03+
     D                                     _Appender_knowsProperty+
     D                                     ')
     D  i_parameter                        const  like(LOG4RPG_Property_key_t  )
      *
      *  Returns a NULL appender.
      *  ==> PLOG4RPG
      *
      /ENDIF
