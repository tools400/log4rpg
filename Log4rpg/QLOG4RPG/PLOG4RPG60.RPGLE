**FREE
/IF NOT DEFINED(PLOG4RPG60)
/DEFINE PLOG4RPG60
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
dcl-pr PatternLayout_new
       ind
       extproc('PatternLayout_+
       new+
       ');
  i_pSuper        const  like(LOG4RPG_pLayout_t       );
  io_pHandle      pointer;
  i_pPropList     const  like(LOG4RPG_pPropertyList_t );
  i_prefix        const  like(LOG4RPG_prefix_t        );
end-pr;
//
//  ... prototye: format, returns the formatted string on success, else ''.
dcl-pr PatternLayout_format
       extproc('PatternLayout_+
       format+
       ');
  i_pHandle       pointer const;
  i_pLogEvent     const  like(LOG4RPG_pLogEvent_t );
end-pr;
//
//  ... prototye: setProperties, sets the proeprties for the layout
dcl-pr PatternLayout_setProperties
       extproc('PatternLayout_+
       setProperties+
       ');
  i_pHandle       pointer const;
  i_pPropList     const  like(LOG4RPG_pPropertyList_t );
  i_prefix        const  like(LOG4RPG_prefix_t        );
end-pr;
//
//  ... prototye: delete, returns TRUE on success else FALSE
dcl-pr PatternLayout_delete
       ind
       extproc('PatternLayout_+
       delete+
       ');
  io_pHandle      pointer;
end-pr;
//
/ENDIF
