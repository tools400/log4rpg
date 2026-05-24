**free
/if NOT defined(PLOG4RPG17)
/define PLOG4RPG17

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

//  Creates a new filter.
//  ==> PLOG4RPG

//  Decides what to do with the log event.
dcl-pr Filter_decide int(10) extproc('LOG4RPG17_Filter_decide');
  i_pFilter   like(LOG4RPG_pFilter_t) const;
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Returns the name of the filter.
dcl-pr Filter_getName like(LOG4RPG_filterName_t) extproc('LOG4RPG17_Filter_getName');
  i_pFilter like(LOG4RPG_pFilter_t) const;
end-pr;

//  Returns the next filter.
dcl-pr Filter_getNext like(LOG4RPG_pFilter_t) extproc('LOG4RPG17_Filter_getNext');
  i_pFilter like(LOG4RPG_pFilter_t) const;
end-pr;

//  Sets the next filter of the filter chain.
//  ==> PLOG4RPG

//  Sets the properties of the specified filter.
dcl-pr Filter_setProperties extproc('LOG4RPG17_Filter_setProperties');
  i_pFilter   like(LOG4RPG_pFilter_t) const;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  Tests, whether the specified property is known by the
//  super filter.
dcl-pr Filter_knowsProperty ind extproc('LOG4RPG17_Filter_knowsProperty');
  i_parameter like(LOG4RPG_Property_key_t) const;
end-pr;

//  Deletes a given filter.
dcl-pr Filter_delete ind extproc('LOG4RPG17_Filter_delete');
  io_pFilter like(LOG4RPG_pFilter_t);
end-pr;

//  Tests a given filter for a NULL value.
dcl-pr Filter_isNull ind extproc('LOG4RPG17_Filter_isNull');
  i_pFilter like(LOG4RPG_pFilter_t) const;
end-pr;

//  Returns a NULL filter.
//  ==> PLOG4RPG

/endif