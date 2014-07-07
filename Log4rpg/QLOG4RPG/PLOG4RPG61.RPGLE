      /IF NOT DEFINED(PLOG4RPG61)
      /DEFINE PLOG4RPG61
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
     D SimpleLayout_new...
     D                 PR              N
     D                                     extproc('SimpleLayout_+
     D                                     new+
     D                                     ')
     D  i_pSuper                           const  like(LOG4RPG_pLayout_t       )
     D  io_pHandle                     *
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  ... prototye: format, returns the formatted string on success, else ''.
     D SimpleLayout_format...
     D                 PR
     D                                     extproc('SimpleLayout_+
     D                                     format+
     D                                     ')
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t )
      *
      *  ... prototye: setProperties, sets the proeprties for the layout
     D SimpleLayout_setProperties...
     D                 PR
     D                                     extproc('SimpleLayout_+
     D                                     setProperties+
     D                                     ')
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  ... prototye: delete, returns TRUE on success else FALSE
     D SimpleLayout_delete...
     D                 PR              N
     D                                     extproc('SimpleLayout_+
     D                                     delete+
     D                                     ')
     D  io_pHandle                     *
      *
      /ENDIF
