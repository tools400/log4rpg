**FREE
/IF NOT DEFINED(PLOG4RPG62)
/DEFINE PLOG4RPG62
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/COPY QLOG4RPG,PSHARE                        Type defs appenders, layouts, filters
//
// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
//  Custom layout ...
//  ... prototye: new, returns TRUE on success else FALSE
dcl-pr XMLLayout_new
       ind
       extproc('XMLLayout_+
       new+
       ');
  i_pSuper        const  like(LOG4RPG_pLayout_t       );
  io_pHandle      pointer;
  i_pPropList     const  like(LOG4RPG_pPropertyList_t );
  i_prefix        const  like(LOG4RPG_prefix_t        );
end-pr;
//
//  ... prototye: format, returns the formatted string on success, else ''.
dcl-pr XMLLayout_format
       extproc('XMLLayout_+
       format+
       ');
  i_pHandle       pointer const;
  i_pLogEvent     const  like(LOG4RPG_pLogEvent_t );
end-pr;
//
//  Returns the header of this layout.
dcl-pr XMLLayout_getHeader
       like(LOG4RPG_header_t)
       extproc('XMLLayout+
       _getHeader');
  i_pHandle       pointer const;
end-pr;
//
//  Returns the header of this layout.
dcl-pr XMLLayout_getFooter
       like(LOG4RPG_footer_t)
       extproc('XMLLayout+
       _getFooter');
  i_pHandle       pointer const;
end-pr;
//
//  ... prototye: setProperties, sets the proeprties for the layout
dcl-pr XMLLayout_setProperties
       extproc('XMLLayout_+
       setProperties+
       ');
  i_pHandle       pointer const;
  i_pPropList     const  like(LOG4RPG_pPropertyList_t );
  i_prefix        const  like(LOG4RPG_prefix_t        );
end-pr;
//
//  ... prototye: delete, returns TRUE on success else FALSE
dcl-pr XMLLayout_delete
       ind
       extproc('XMLLayout_+
       delete+
       ');
  io_pHandle      pointer;
end-pr;
//
/ENDIF
