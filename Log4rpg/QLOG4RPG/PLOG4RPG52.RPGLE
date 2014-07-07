      /IF NOT DEFINED(PLOG4RPG52)
      /DEFINE PLOG4RPG52
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
      *  Custom appender ...
      *  ... prototye: new, returns TRUE on success else FALSE
     D NullAppender_new...
     D                 PR              N
     D                                     extproc('NullAppender_+
     D                                     new+
     D                                     ')
     D  i_pSuper                           const  like(LOG4RPG_pAppender_t     )
     D  io_pHandle                     *
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Returns TRUE if the appender requires a layout.
     D NullAppender_requiresLayout...
     D                 PR              N
     D                                     extproc('NullAppender_+
     D                                     requiresLayout+
     D                                     ')
     D  i_pHandle                      *   const
      *
      *  ... prototye: append, returns TRUE on success else FALSE
     D NullAppender_doAppend...
     D                 PR              N
     D                                     extproc('NullAppender_+
     D                                     doAppend+
     D                                     ')
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const like(LOG4RPG_pLogEvent_t )
      *
      *  Used to set the properties of the appender.
     D NullAppender_setProperties...
     D                 PR
     D                                     extproc('NullAppender_+
     D                                     setProperties+
     D                                     ')
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  ... prototye: delete, returns TRUE on success else FALSE
     D NullAppender_delete...
     D                 PR              N
     D                                     extproc('NullAppender_+
     D                                     delete+
     D                                     ')
     D  io_pHandle                     *
      *
      /ENDIF
