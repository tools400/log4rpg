**FREE
/IF NOT DEFINED(PLOG4RPG03)
/DEFINE PLOG4RPG03
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
//
//  Creates a new appender.
//  ==> PLOG4RPG
//
//  Appends a message to the specified appender.
dcl-pr Appender_doAppend
       ind
       extproc('LOG4RPG03+
       _Appender_doAppend+
       ');
  i_pAppender     const  like(LOG4RPG_pAppender_t     );
  i_pLogEvent     const  like(LOG4RPG_pLogEvent_t     );
end-pr;
//
//  Returns the name of the specified appender.
dcl-pr Appender_getName
       like(LOG4RPG_appenderName_t  )
       extproc('LOG4RPG03+
       _Appender_getName+
       ');
  i_pAppender     const  like(LOG4RPG_pAppender_t     );
end-pr;
//
//  Returns the layout of the specified appender.
dcl-pr Appender_getLayout
       like(LOG4RPG_pLayout_t       )
       extproc('LOG4RPG03+
       _Appender_getLayout+
       ');
  i_pAppender     const  like(LOG4RPG_pAppender_t     );
end-pr;
//
//  Sets the properties of the specified appender.
dcl-pr Appender_setProperties
       extproc('LOG4RPG03+
       _Appender_setProperties+
       ');
  i_pAppender     const  like(LOG4RPG_pAppender_t     );
  i_pPropList     const  like(LOG4RPG_pPropertyList_t );
  i_prefix        const  like(LOG4RPG_prefix_t        );
end-pr;
//
//  Deletes a given appender.
dcl-pr Appender_delete
       ind
       extproc('LOG4RPG03+
       _Appender_delete+
       ');
  io_pAppender    like(LOG4RPG_pAppender_t     );
end-pr;
//
//  Tests a given appender for a NULL value.
dcl-pr Appender_isNull
       ind
       extproc('LOG4RPG03+
       _Appender_isNull+
       ');
  i_pAppender     const  like(LOG4RPG_pAppender_t     );
end-pr;
//
//  Returns TRUE if the appender requires a layout.
dcl-pr Appender_requiresLayout
       ind
       extproc('LOG4RPG03+
       _Appender_requiresLayout+
       ');
  i_pAppender     const  like(LOG4RPG_pAppender_t     );
end-pr;
//
//  Sets the layout for the specified appender.
//  ==> PLOG4RPG
//
//  Sets the filter for the specified appender.
//  ==> PLOG4RPG
//
//  Returns the filter attached to the appender.
dcl-pr Appender_getFilter
       like(LOG4RPG_pFilter_t       )
       extproc('LOG4RPG03+
       _Appender_getFilter+
       ');
  i_pAppender     const  like(LOG4RPG_pAppender_t     );
end-pr;
//
//  Tests, whether the specified property is known by the
//  super Appender.
dcl-pr Appender_knowsProperty
       ind
       extproc('LOG4RPG03+
       _Appender_knowsProperty+
       ');
  i_parameter     const  like(LOG4RPG_Property_key_t  );
end-pr;
//
//  Returns a NULL appender.
//  ==> PLOG4RPG
//
/ENDIF
