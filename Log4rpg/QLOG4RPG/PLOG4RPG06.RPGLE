**free
/if NOT DEFINED(PLOG4RPG06)
/define PLOG4RPG06

// -----------------------------------------
//  Type definitions
// -----------------------------------------
dcl-s LOG4RPG_Property_key_t varchar(64) based(pDummy);
dcl-s LOG4RPG_Property_value_t varchar(128) based(pDummy);

dcl-ds LOG4RPG_Property_t qualified based(pDummy);
  key   like(LOG4RPG_Property_key_t);
  value like(LOG4RPG_Property_value_t);
end-ds;

// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------

//  Creates a new property.
//Property_new...
//                PR                         likeds(LOG4RPG_Property_t)
//                                    extproc('LOG4RPG06+
//                                    _Property_new+
//                                    ')
// i_key                              const  like(LOG4RPG_Property_key_t  )
// i_value                            const  like(LOG4RPG_Property_value_t)

//  Returns the key of a property.
//Property_getKey...
//                PR                         like(LOG4RPG_Property_key_t)
//                                    extproc('LOG4RPG06+
//                                    _Property_getKey+
//                                    ')
// i_property                         const  likeds(LOG4RPG_Property_t)

//  Returns the value of a property.
//Property_getValue...
//                PR                         like(LOG4RPG_Property_value_t)
//                                    extproc('LOG4RPG06+
//                                    _Property_getValue+
//                                    ')
// i_property                         const  likeds(LOG4RPG_Property_t)

//  Deletes a given property.
//Property_delete...
//                PR
//                                    extproc('LOG4RPG06+
//                                    _Property_delete+
//                                    ')
// io_property                               likeds(LOG4RPG_Property_t)

/endif
