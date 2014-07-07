      /IF NOT DEFINED(PLOG4RPG06)
      /DEFINE PLOG4RPG06
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
     D LOG4RPG_Property_key_t...
     D                 S             64A   varying                 based(pDummy)
     D LOG4RPG_Property_value_t...
     D                 S            128A   varying                 based(pDummy)
      *
     D LOG4RPG_Property_t...
     D                 DS                  qualified               based(pDummy)
     D  key                                like(LOG4RPG_Property_key_t  )
     D  value                              like(LOG4RPG_Property_value_t)
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
    R *
    R *  Creates a new property.
    R *Property_new...
    R *                PR                         likeds(LOG4RPG_Property_t)
    R *                                    extproc('LOG4RPG06+
    R *                                    _Property_new+
    R *                                    ')
    R * i_key                              const  like(LOG4RPG_Property_key_t  )
    R * i_value                            const  like(LOG4RPG_Property_value_t)
    R *
    R *  Returns the key of a property.
    R *Property_getKey...
    R *                PR                         like(LOG4RPG_Property_key_t)
    R *                                    extproc('LOG4RPG06+
    R *                                    _Property_getKey+
    R *                                    ')
    R * i_property                         const  likeds(LOG4RPG_Property_t)
    R *
    R *  Returns the value of a property.
    R *Property_getValue...
    R *                PR                         like(LOG4RPG_Property_value_t)
    R *                                    extproc('LOG4RPG06+
    R *                                    _Property_getValue+
    R *                                    ')
    R * i_property                         const  likeds(LOG4RPG_Property_t)
    R *
    R *  Deletes a given property.
    R *Property_delete...
    R *                PR
    R *                                    extproc('LOG4RPG06+
    R *                                    _Property_delete+
    R *                                    ')
    R * io_property                               likeds(LOG4RPG_Property_t)
      *
      /ENDIF
