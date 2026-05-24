**free
/if NOT defined(PLOG4RPG61)
/define PLOG4RPG61

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
dcl-pr SimpleLayout_new ind extproc('SimpleLayout_new');
  i_pSuper    like(LOG4RPG_pLayout_t) const;
  io_pHandle  pointer;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  ... prototye: format, returns the formatted string on success, else ''.
dcl-pr SimpleLayout_format extproc('SimpleLayout_format');
  i_pHandle   pointer const;
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  ... prototye: setProperties, sets the proeprties for the layout
dcl-pr SimpleLayout_setProperties extproc('SimpleLayout_setProperties');
  i_pHandle   pointer const;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  ... prototye: delete, returns TRUE on success else FALSE
dcl-pr SimpleLayout_delete ind extproc('SimpleLayout_delete');
  io_pHandle pointer;
end-pr;

/endif