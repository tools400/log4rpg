**free
/if NOT defined(PLOG4RPG52)
/define PLOG4RPG52

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PSHARE // Type defs appenders, layouts, filters

// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
//  Custom appender ...
//  ... prototye: new, returns TRUE on success else FALSE
dcl-pr NullAppender_new ind extproc('NullAppender_new');
  i_pSuper    like(LOG4RPG_pAppender_t) const;
  io_pHandle  pointer;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  Returns TRUE if the appender requires a layout.
dcl-pr NullAppender_requiresLayout ind extproc('NullAppender_requiresLayout');
  i_pHandle pointer const;
end-pr;

//  ... prototye: append, returns TRUE on success else FALSE
dcl-pr NullAppender_doAppend ind extproc('NullAppender_doAppend');
  i_pHandle   pointer const;
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Used to set the properties of the appender.
dcl-pr NullAppender_setProperties extproc('NullAppender_setProperties');
  i_pHandle   pointer const;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  ... prototye: delete, returns TRUE on success else FALSE
dcl-pr NullAppender_delete ind extproc('NullAppender_delete');
  io_pHandle pointer;
end-pr;

/endif