**free
/if NOT defined(PLOG4RPG11)
/define PLOG4RPG11

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

//  Creates a new layout.
//  ==> PLOG4RPG

//  Formats the given string according to the layout.
dcl-pr Layout_format extproc('LOG4RPG11_Layout_format');
  i_pLayout   like(LOG4RPG_pLayout_t) const;
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Returns the header of the layout.
dcl-pr Layout_getHeader like(LOG4RPG_header_t) extproc('LOG4RPG11_Layout_getHeader');
  i_pLayout like(LOG4RPG_pLayout_t) const;
end-pr;

//  Returns the footer of the layout.
dcl-pr Layout_getFooter like(LOG4RPG_footer_t) extproc('LOG4RPG11_Layout_getFooter');
  i_pLayout like(LOG4RPG_pLayout_t) const;
end-pr;

//  Sets the properties of the specified layout.
dcl-pr Layout_setProperties extproc('LOG4RPG11_Layout_setProperties');
  i_pLayout   like(LOG4RPG_pLayout_t) const;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  Returns the new-line character.
dcl-pr Layout_newLine varchar(2) extproc('LOG4RPG11_Layout_newLine');
end-pr;

//  Deletes the specified layout.
dcl-pr Layout_delete ind extproc('LOG4RPG11_Layout_delete');
  io_pLayout like(LOG4RPG_pLayout_t);
end-pr;

//  Tests, whether the specified property is known by the
//  super Layout.
dcl-pr Layout_knowsProperty ind extproc('LOG4RPG11_Layout_knowsProperty');
  i_parameter like(LOG4RPG_Property_key_t) const;
end-pr;

//  Tests a given layout for a NULL value.
dcl-pr Layout_isNull ind extproc('LOG4RPG11_Layout_isNull');
  i_pLayout like(LOG4RPG_pLayout_t) const;
end-pr;

//  Returns a NULL layout.
//  ==> PLOG4RPG

/endif