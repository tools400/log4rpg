      /IF NOT DEFINED(PAPPENDER)
      /DEFINE PAPPENDER
      *
      *  Who should use this copy book:   Developer of appenders
      *
      *  This copy book defines the prototypes that are needed to write an
      *  implementation of an appender 'object'. In order to create an
      *  appender you have to do these steps:
      *     a) copy this copy book
      *     b) rename 'SrvPgmAppender' to the name of your appender,
      *        e.g. 'MySocketAppender'.
      *     c) Optionally remove the lines that are related to 'DEFINE_PROCPTR'.
      *        You do not need the prototypes with procedure pointers. The
      *        prototypes with procedure pointers are used by LOG4RPG03.
      *     d) Make sure that your appender exports the following procedures:
      *           YourAppender_new()
      *           YourAppender_requiresLayout()
      *           YourAppender_doAppend()
      *           YourAppender_setProperties()
      *           YourAppender_delete()
      *        Do not change the suffix of the procedures or the procedure
      *        interface!
      *     e) Feel free to send the new appender to me. I would gladly
      *        add the appender to the LOG4RPG distribution.
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PSHARE                        Type defs shared with appenders & layouts
      *
      * -----------------------------------------
      *  Appender Prototypes & Type Defs
      * -----------------------------------------
      *
      *  Custom appender ...
      *  ... prototye: new, returns TRUE on success else FALSE
      /IF DEFINED (DEFINE_PROCPTR)
     D SrvPgmAppender_new...
     D                 PR              N   extproc(g_pAppender_new)
      /ELSE
     D SrvPgmAppender_new...
     D                 PR              N   extproc('SrvPgmAppender_new')
      /ENDIF
     D  i_pSuper                           const  like(LOG4RPG_pAppender_t     )
     D  io_pHandle                     *
     D  i_propList                         const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  ... prototye: requiresLayout, returns TRUE if the appender requires a layout
      /IF DEFINED (DEFINE_PROCPTR)
     D SrvPgmAppender_requiresLayout...
     D                 PR              N   extproc(g_pAppender_requiresLayout)
      /ELSE
     D SrvPgmAppender_requiresLayout...
     D                 PR              N   extproc('SrvPgmAppender_+
     D                                     requiresLayout')
      /ENDIF
     D  i_pHandle                      *   const
      *
      *  ... prototye: doAppend, returns TRUE on success else FALSE
      /IF DEFINED (DEFINE_PROCPTR)
     D SrvPgmAppender_doAppend...
     D                 PR              N   extproc(g_pAppender_doAppend)
      /ELSE
     D SrvPgmAppender_doAppend...
     D                 PR              N   extproc('SrvPgmAppender_doAppend')
      /ENDIF
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const like(LOG4RPG_pLogEvent_t )
      *
      *  ... prototye: setProperties, sets the proeprties for the appender
      /IF DEFINED (DEFINE_PROCPTR)
     D SrvPgmAppender_setProperties...
     D                 PR
     D                                     extproc(g_pAppender_setProperties)
      /ELSE
     D SrvPgmAppender_setProperties...
     D                 PR
     D                                     extproc('SrvPgmAppender_+
     D                                              setProperties')
      /ENDIF
     D  i_pHandle                      *   const
     D  i_propList                         const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  ... prototye: delete, returns TRUE on success else FALSE
      /IF DEFINED (DEFINE_PROCPTR)
     D SrvPgmAppender_delete...
     D                 PR              N   extproc(g_pAppender_delete)
      /ELSE
     D SrvPgmAppender_delete...
     D                 PR              N   extproc('SrvPgmAppender_delete')
      /ENDIF
     D  io_pHandle                     *
      *
      /ENDIF
