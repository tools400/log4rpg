      /IF NOT DEFINED(PLAYOUT)
      /DEFINE PLAYOUT
      *
      *  Who should use this copy book:   Developer of layouts
      *
      *  This copy book defines the prototypes that are needed to write an
      *  implementation of a layout 'object'. In order to create a layout
      *  you have to do these steps:
      *     a) copy this copy book
      *     b) rename 'SrvPgmLayout' to the name of your layout,
      *        e.g. 'MySpecialLayout'.
      *     c) Optionally remove the lines that are related to 'DEFINE_PROCPTR'.
      *        You do not need the prototypes with procedure pointers. The
      *        prototypes with procedure pointers are used by LOG4RPG11.
      *     d) Make sure that your layout exports the following procedures:
      *           MySpecialLayout_new()
      *           MySpecialLayout_format()
      *           MySpecialLayout_setProperties()
      *           MySpecialLayout_delete()
      *        Do not change the suffix of the procedures or the procedure
      *        interface!
      *     e) Optionally add these procedures to your layout. They might be called
      *        when an Appender is initialized and closed:
      *           MySpecialLayout_getHeader()
      *           MySpecialLayout_getFooter()
      *     f) Feel free to send the new layout to me. I would gladly
      *        add the layout to the LOG4RPG distribution.
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PSHARE                        Type defs shared with appenders & layouts
      *
      * -----------------------------------------
      *  Type Definitions
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Layout Prototypes & Type Defs
      * -----------------------------------------
      *
      *  Custom layout ...
      *  ... prototye: new, returns TRUE on success else FALSE
      /IF DEFINED (DEFINE_PROCPTR)
     D SrvPgmLayout_new...
     D                 PR              N   extproc(g_pLayout_new)
      /ELSE
     D SrvPgmLayout_new...
     D                 PR              N   extproc('SrvPgmLayout_new')
      /ENDIF
     D  i_pSuper                           const  like(LOG4RPG_pLayout_t       )
     D  io_pHandle                     *
     D  i_propList                         const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  ... prototye: format, returns the logging event as a formatted string
      /IF DEFINED (DEFINE_PROCPTR)
     D SrvPgmLayout_format...
     D                 PR
     D                                     extproc(g_pLayout_format)
      /ELSE
     D SrvPgmLayout_format...
     D                 PR
     D                                     extproc('SrvPgmLayout_format')
      /ENDIF
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t)
      *
      *  ... prototye: getHeader, returns the header of the layout
      /IF DEFINED (DEFINE_PROCPTR)
     D SrvPgmLayout_getHeader...
     D                 PR                         like(LOG4RPG_header_t    )
     D                                     extproc(g_pLayout_getHeader)
      /ELSE
     D SrvPgmLayout_getHeader...
     D                 PR                         like(LOG4RPG_header_t    )
     D                                     extproc('SrvPgmLayout_getHeader')
      /ENDIF
     D  i_pHandle                      *   const
      *
      *  ... prototye: getFooter, returns the footer of the layout
      /IF DEFINED (DEFINE_PROCPTR)
     D SrvPgmLayout_getFooter...
     D                 PR                         like(LOG4RPG_footer_t    )
     D                                     extproc(g_pLayout_getFooter)
      /ELSE
     D SrvPgmLayout_getFooter...
     D                 PR                         like(LOG4RPG_footer_t    )
     D                                     extproc('SrvPgmLayout_getFooter')
      /ENDIF
     D  i_pHandle                      *   const
      *
      *  ... prototye: setProperties, sets the proeprties for the layout
      /IF DEFINED (DEFINE_PROCPTR)
     D SrvPgmLayout_setProperties...
     D                 PR
     D                                     extproc(g_pLayout_setProperties)
      /ELSE
     D SrvPgmLayout_setProperties...
     D                 PR
     D                                     extproc('SrvPgmLayout_setProperties')
      /ENDIF
     D  i_pHandle                      *   const
     D  i_propList                         const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  ... prototye: delete, returns TRUE on success else FALSE
      /IF DEFINED (DEFINE_PROCPTR)
     D SrvPgmLayout_delete...
     D                 PR              N   extproc(g_pLayout_delete)
      /ELSE
     D SrvPgmLayout_delete...
     D                 PR              N   extproc('SrvPgmLayout_delete')
      /ENDIF
     D  io_pHandle                     *
      *
      /ENDIF
