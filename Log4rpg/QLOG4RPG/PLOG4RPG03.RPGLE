**free
/if NOT defined(PLOG4RPG03)
/define PLOG4RPG03

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PSHARE Type defs appenders, layouts, filters

// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------

//  Creates a new appender.
//  ==> PLOG4RPG

//  Appends a message to the specified appender.
dcl-pr Appender_doAppend ind extproc('LOG4RPG03_Appender_doAppend');
  i_pAppender like(LOG4RPG_pAppender_t) const;
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Returns the name of the specified appender.
dcl-pr Appender_getName like(LOG4RPG_appenderName_t) extproc('LOG4RPG03_Appender_getName');
  i_pAppender like(LOG4RPG_pAppender_t) const;
end-pr;

//  Returns the layout of the specified appender.
dcl-pr Appender_getLayout like(LOG4RPG_pLayout_t) extproc('LOG4RPG03_Appender_getLayout');
  i_pAppender like(LOG4RPG_pAppender_t) const;
end-pr;

//  Sets the properties of the specified appender.
dcl-pr Appender_setProperties extproc('LOG4RPG03_Appender_setProperties');
  i_pAppender like(LOG4RPG_pAppender_t) const;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  Deletes a given appender.
dcl-pr Appender_delete ind extproc('LOG4RPG03_Appender_delete');
  io_pAppender like(LOG4RPG_pAppender_t);
end-pr;

//  Tests a given appender for a NULL value.
dcl-pr Appender_isNull ind extproc('LOG4RPG03_Appender_isNull');
  i_pAppender like(LOG4RPG_pAppender_t) const;
end-pr;

//  Returns TRUE if the appender requires a layout.
dcl-pr Appender_requiresLayout ind extproc('LOG4RPG03_Appender_requiresLayout');
  i_pAppender like(LOG4RPG_pAppender_t) const;
end-pr;

//  Sets the layout for the specified appender.
//  ==> PLOG4RPG

//  Sets the filter for the specified appender.
//  ==> PLOG4RPG

//  Returns the filter attached to the appender.
dcl-pr Appender_getFilter like(LOG4RPG_pFilter_t) extproc('LOG4RPG03_Appender_getFilter');
  i_pAppender like(LOG4RPG_pAppender_t) const;
end-pr;

//  Tests, whether the specified property is known by the
//  super Appender.
dcl-pr Appender_knowsProperty ind extproc('LOG4RPG03_Appender_knowsProperty');
  i_parameter like(LOG4RPG_Property_key_t) const;
end-pr;

//  Returns a NULL appender.
//  ==> PLOG4RPG

/endif