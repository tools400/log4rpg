**free
/if NOT defined(PLOG4RPG62)
/define PLOG4RPG62

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
//  Custom layout ...
//  ... prototye: new, returns TRUE on success else FALSE
dcl-pr XMLLayout_new ind extproc('XMLLayout_new');
  i_pSuper    like(LOG4RPG_pLayout_t) const;
  io_pHandle  pointer;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  ... prototye: format, returns the formatted string on success, else ''.
dcl-pr XMLLayout_format extproc('XMLLayout_format');
  i_pHandle   pointer const;
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Returns the header of this layout.
dcl-pr XMLLayout_getHeader like(LOG4RPG_header_t) extproc('XMLLayout_getHeader');
  i_pHandle pointer const;
end-pr;

//  Returns the header of this layout.
dcl-pr XMLLayout_getFooter like(LOG4RPG_footer_t) extproc('XMLLayout_getFooter');
  i_pHandle pointer const;
end-pr;

//  ... prototye: setProperties, sets the proeprties for the layout
dcl-pr XMLLayout_setProperties extproc('XMLLayout_setProperties');
  i_pHandle   pointer const;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  ... prototye: delete, returns TRUE on success else FALSE
dcl-pr XMLLayout_delete ind extproc('XMLLayout_delete');
  io_pHandle pointer;
end-pr;

/endif