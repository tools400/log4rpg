      /IF NOT DEFINED(PLOG4RPG51)
      /DEFINE PLOG4RPG51
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
     D DailyRollingPrintAppender_new...
     D                 PR              N
     D                                     extproc('DailyRollingPrintAppender_+
     D                                     new+
     D                                     ')
     D  i_pSuper                           const  like(LOG4RPG_pAppender_t     )
     D  io_pHandle                     *
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Returns TRUE if the appender requires a layout.
     D DailyRollingPrintAppender_requiresLayout...
     D                 PR              N
     D                                     extproc('DailyRollingPrintAppender_+
     D                                     requiresLayout+
     D                                     ')
     D  i_pHandle                      *   const
      *
      *  ... prototye: append, returns TRUE on success else FALSE
     D DailyRollingPrintAppender_doAppend...
     D                 PR              N
     D                                     extproc('DailyRollingPrintAppender_+
     D                                     doAppend+
     D                                     ')
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const like(LOG4RPG_pLogEvent_t )
      *
      *  Used to set the properties of the appender.
     D DailyRollingPrintAppender_setProperties...
     D                 PR
     D                                     extproc('DailyRollingPrintAppender_+
     D                                     setProperties+
     D                                     ')
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  ... prototye: delete, returns TRUE on success else FALSE
     D DailyRollingPrintAppender_delete...
     D                 PR              N
     D                                     extproc('DailyRollingPrintAppender_+
     D                                     delete+
     D                                     ')
     D  io_pHandle                     *
      *
      /ENDIF
