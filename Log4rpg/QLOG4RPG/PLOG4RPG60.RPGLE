      /IF NOT DEFINED(PLOG4RPG60)
      /DEFINE PLOG4RPG60
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
     D PatternLayout_new...
     D                 PR              N
     D                                     extproc('PatternLayout_+
     D                                     new+
     D                                     ')
     D  i_pSuper                           const  like(LOG4RPG_pLayout_t       )
     D  io_pHandle                     *
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  ... prototye: format, returns the formatted string on success, else ''.
     D PatternLayout_format...
     D                 PR
     D                                     extproc('PatternLayout_+
     D                                     format+
     D                                     ')
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t )
      *
      *  ... prototye: setProperties, sets the proeprties for the layout
     D PatternLayout_setProperties...
     D                 PR
     D                                     extproc('PatternLayout_+
     D                                     setProperties+
     D                                     ')
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  ... prototye: delete, returns TRUE on success else FALSE
     D PatternLayout_delete...
     D                 PR              N
     D                                     extproc('PatternLayout_+
     D                                     delete+
     D                                     ')
     D  io_pHandle                     *
      *
      /ENDIF
