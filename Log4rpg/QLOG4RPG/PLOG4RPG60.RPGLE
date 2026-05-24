**free
/if NOT defined(PLOG4RPG60)
/define PLOG4RPG60

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
//  Custom layout ...
//  ... prototye: new, returns TRUE on success else FALSE
dcl-pr PatternLayout_new ind extproc('PatternLayout_new');
  i_pSuper    like(LOG4RPG_pLayout_t) const;
  io_pHandle  pointer;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  ... prototye: format, returns the formatted string on success, else ''.
dcl-pr PatternLayout_format extproc('PatternLayout_format');
  i_pHandle   pointer const;
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  ... prototye: setProperties, sets the proeprties for the layout
dcl-pr PatternLayout_setProperties extproc('PatternLayout_setProperties');
  i_pHandle   pointer const;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  ... prototye: delete, returns TRUE on success else FALSE
dcl-pr PatternLayout_delete ind extproc('PatternLayout_delete');
  io_pHandle pointer;
end-pr;

/endif