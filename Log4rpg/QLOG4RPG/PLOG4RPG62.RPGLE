      /IF NOT DEFINED(PLOG4RPG62)
      /DEFINE PLOG4RPG62
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
      *  Custom layout ...
      *  ... prototye: new, returns TRUE on success else FALSE
     D XMLLayout_new...
     D                 PR              N
     D                                     extproc('XMLLayout_+
     D                                     new+
     D                                     ')
     D  i_pSuper                           const  like(LOG4RPG_pLayout_t       )
     D  io_pHandle                     *
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  ... prototye: format, returns the formatted string on success, else ''.
     D XMLLayout_format...
     D                 PR
     D                                     extproc('XMLLayout_+
     D                                     format+
     D                                     ')
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t )
      *
      *  Returns the header of this layout.
     D XMLLayout_getHeader...
     D                 PR                         like(LOG4RPG_header_t)
     D                                     extproc('XMLLayout+
     D                                     _getHeader')
     D  i_pHandle                      *   const
      *
      *  Returns the header of this layout.
     D XMLLayout_getFooter...
     D                 PR                         like(LOG4RPG_footer_t)
     D                                     extproc('XMLLayout+
     D                                     _getFooter')
     D  i_pHandle                      *   const
      *
      *  ... prototye: setProperties, sets the proeprties for the layout
     D XMLLayout_setProperties...
     D                 PR
     D                                     extproc('XMLLayout_+
     D                                     setProperties+
     D                                     ')
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  ... prototye: delete, returns TRUE on success else FALSE
     D XMLLayout_delete...
     D                 PR              N
     D                                     extproc('XMLLayout_+
     D                                     delete+
     D                                     ')
     D  io_pHandle                     *
      *
      /ENDIF
