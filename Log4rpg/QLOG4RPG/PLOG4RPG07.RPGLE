**free
/if NOT DEFINED(PLOG4RPG07)
/define PLOG4RPG07

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QBASICS1,PBASICS1                      URL
/copy QLOG4RPG,PLOG4RPG06                    Property

dcl-s LOG4RPG_pPropertyList_t pointer based(pDummy);

dcl-ds LOG4RPG_PropertyListIterator_t qualified based(pDummy);
  pPropList like(LOG4RPG_pPropertyList_t);
  lastProp  int(10);
end-ds;

// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------

//  Creates a new property list.
dcl-pr PropertyList_new like(LOG4RPG_pPropertyList_t) extproc('LOG4RPG07_PropertyList_new');
  i_pString pointer options(*nopass: *omit: *string) const;
end-pr;

//  Loads the properties from the specified location.
dcl-pr PropertyList_loadFromUrl ind extproc('LOG4RPG07_PropertyList_loadFromUrl');
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_url       like(url_t) const;
end-pr;

//  Returns the final URL that was used to load the properties.
dcl-pr PropertyList_getUrl like(url_t) extproc('LOG4RPG07_PropertyList_getUrl');
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
end-pr;

//  Returns the number of entries in the specified property list.
dcl-pr PropertyList_getNumE int(10) extproc('LOG4RPG07_PropertyList_getNumE');
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
end-pr;

//  Adds a property to the specified property list.
dcl-pr PropertyList_put int(10) extproc('LOG4RPG07_PropertyList_put');
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_property  likeds(LOG4RPG_Property_t) const;
end-pr;

//  Returns the value assigned to the specified key.
dcl-pr PropertyList_get like(LOG4RPG_Property_value_t) extproc('LOG4RPG07_PropertyList_get');
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_key       like(LOG4RPG_Property_key_t) const;
end-pr;

//  Returns an iterator for the specified property list.
dcl-pr PropertyList_getIterator likeds(LOG4RPG_PropertyListIterator_t)
  extproc('LOG4RPG07_PropertyList_getIterator');
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
end-pr;

//  Returns the first property of the specified property list.
dcl-pr PropertyList_getFirst likeds(LOG4RPG_Property_t) extproc('LOG4RPG07_PropertyList_getFirst');
  io_propIter likeds(LOG4RPG_PropertyListIterator_t);
end-pr;

//  Returns the next property of the specified property list.
dcl-pr PropertyList_getNext likeds(LOG4RPG_Property_t) extproc('LOG4RPG07_PropertyList_getNext');
  io_propIter likeds(LOG4RPG_PropertyListIterator_t);
end-pr;

//  Returns true if this property list contains a mapping for the
//  specified key.
dcl-pr PropertyList_containsKey ind extproc('LOG4RPG07_PropertyList_containsKey');
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_key       like(LOG4RPG_Property_key_t) const;
end-pr;

//  Removes the specified property from the property list.
dcl-pr PropertyList_remove extproc('LOG4RPG07_PropertyList_remove');
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_key       like(LOG4RPG_Property_key_t) const;
end-pr;

//  Removes all properties from the specified property list.
dcl-pr PropertyList_clear extproc('LOG4RPG07_PropertyList_clear');
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
end-pr;

//  Deletes the specified given property list.
dcl-pr PropertyList_delete ind extproc('LOG4RPG07_PropertyList_delete');
  io_pPropList like(LOG4RPG_pPropertyList_t);
end-pr;

//  Test the specified Property List object for a NULL value.
dcl-pr PropertyList_isNull ind extproc('LOG4RPG07_PropertyList_isNull');
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
end-pr;

//  Returns a NULL properties list.
dcl-pr PropertyList_null like(LOG4RPG_pPropertyList_t) extproc('LOG4RPG07_PropertyList_null');
end-pr;

/endif
