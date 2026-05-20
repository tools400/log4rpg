**FREE
/IF NOT DEFINED(PLOG4RPG51)
/DEFINE PLOG4RPG51
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
//  Custom appender ...
//  ... prototye: new, returns TRUE on success else FALSE
dcl-pr DailyRollingPrintAppender_new
       ind
       extproc('DailyRollingPrintAppender_+
       new+
       ');
  i_pSuper        const  like(LOG4RPG_pAppender_t     );
  io_pHandle      pointer;
  i_pPropList     const  like(LOG4RPG_pPropertyList_t );
  i_prefix        const  like(LOG4RPG_prefix_t        );
end-pr;
//
//  Returns TRUE if the appender requires a layout.
dcl-pr DailyRollingPrintAppender_requiresLayout
       ind
       extproc('DailyRollingPrintAppender_+
       requiresLayout+
       ');
  i_pHandle       pointer const;
end-pr;
//
//  ... prototye: append, returns TRUE on success else FALSE
dcl-pr DailyRollingPrintAppender_doAppend
       ind
       extproc('DailyRollingPrintAppender_+
       doAppend+
       ');
  i_pHandle       pointer const;
  i_pLogEvent     const like(LOG4RPG_pLogEvent_t );
end-pr;
//
//  Used to set the properties of the appender.
dcl-pr DailyRollingPrintAppender_setProperties
       extproc('DailyRollingPrintAppender_+
       setProperties+
       ');
  i_pHandle       pointer const;
  i_pPropList     const  like(LOG4RPG_pPropertyList_t );
  i_prefix        const  like(LOG4RPG_prefix_t        );
end-pr;
//
//  ... prototye: delete, returns TRUE on success else FALSE
dcl-pr DailyRollingPrintAppender_delete
       ind
       extproc('DailyRollingPrintAppender_+
       delete+
       ');
  io_pHandle      pointer;
end-pr;
//
/ENDIF
