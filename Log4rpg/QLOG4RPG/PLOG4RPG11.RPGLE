      /IF NOT DEFINED(PLOG4RPG11)
      /DEFINE PLOG4RPG11
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
      *  Creates a new layout.
      *  ==> PLOG4RPG
      *
      *  Formats the given string according to the layout.
     D Layout_format...
     D                 PR
     D                                     extproc('LOG4RPG11+
     D                                     _Layout_format+
     D                                     ')
     D  i_pLayout                          const  like(LOG4RPG_pLayout_t   )
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t )
      *
      *  Returns the header of the layout.
     D Layout_getHeader...
     D                 PR                         like(LOG4RPG_header_t    )
     D                                     extproc('LOG4RPG11+
     D                                     _Layout_getHeader+
     D                                     ')
     D  i_pLayout                          const  like(LOG4RPG_pLayout_t   )
      *
      *  Returns the footer of the layout.
     D Layout_getFooter...
     D                 PR                         like(LOG4RPG_footer_t    )
     D                                     extproc('LOG4RPG11+
     D                                     _Layout_getFooter+
     D                                     ')
     D  i_pLayout                          const  like(LOG4RPG_pLayout_t   )
      *
      *  Sets the properties of the specified layout.
     D Layout_setProperties...
     D                 PR
     D                                     extproc('LOG4RPG11+
     D                                     _Layout_setProperties+
     D                                     ')
     D  i_pLayout                          const  like(LOG4RPG_pLayout_t       )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Returns the new-line character.
     D Layout_newLine...
     D                 PR             2A          varying
     D                                     extproc('LOG4RPG11+
     D                                     _Layout_newLine+
     D                                     ')
      *
      *  Deletes the specified layout.
     D Layout_delete...
     D                 PR              N
     D                                     extproc('LOG4RPG11+
     D                                     _Layout_delete+
     D                                     ')
     D  io_pLayout                                like(LOG4RPG_pLayout_t       )
      *
      *  Tests, whether the specified property is known by the
      *  super Layout.
     D Layout_knowsProperty...
     D                 PR              N
     D                                     extproc('LOG4RPG11+
     D                                     _Layout_knowsProperty+
     D                                     ')
     D  i_parameter                        const  like(LOG4RPG_Property_key_t  )
      *
      *  Tests a given layout for a NULL value.
     D Layout_isNull...
     D                 PR              N
     D                                     extproc('LOG4RPG11+
     D                                     _Layout_isNull+
     D                                     ')
     D  i_pLayout                          const  like(LOG4RPG_pLayout_t       )
      *
      *  Returns a NULL layout.
      *  ==> PLOG4RPG
      *
      /ENDIF
