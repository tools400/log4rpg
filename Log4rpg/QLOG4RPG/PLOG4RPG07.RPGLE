      /IF NOT DEFINED(PLOG4RPG07)
      /DEFINE PLOG4RPG07
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1                      URL
      /COPY QLOG4RPG,PLOG4RPG06                    Property
      *
     D LOG4RPG_pPropertyList_t...
     D                 S               *                           based(pDummy)
      *
     D LOG4RPG_PropertyListIterator_t...
     D                 DS                  qualified               based(pDummy)
     D  pPropList                          like(LOG4RPG_pPropertyList_t )
     D  lastProp                     10I 0
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Creates a new property list.
     D PropertyList_new...
     D                 PR                         like(LOG4RPG_pPropertyList_t )
     D                                     extproc('LOG4RPG07+
     D                                     _PropertyList_new+
     D                                     ')
     D  i_pString                      *   const  options(*nopass:
     D                                                    *omit  : *string)
      *
      *  Loads the properties from the specified location.
     D PropertyList_loadFromUrl...
     D                 PR              N
     D                                     extproc('LOG4RPG07+
     D                                     _PropertyList_loadFromUrl+
     D                                     ')
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_url                              const  like(url_t            )
      *
      *  Returns the final URL that was used to load the properties.
     D PropertyList_getUrl...
     D                 PR                         like(url_t )
     D                                     extproc('LOG4RPG07+
     D                                     _PropertyList_getUrl+
     D                                     ')
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Returns the number of entries in the specified property list.
     D PropertyList_getNumE...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG07+
     D                                     _PropertyList_getNumE+
     D                                     ')
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Adds a property to the specified property list.
     D PropertyList_put...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG07+
     D                                     _PropertyList_put+
     D                                     ')
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_property                         const  likeds(LOG4RPG_Property_t    )
      *
      *  Returns the value assigned to the specified key.
     D PropertyList_get...
     D                 PR                  like(LOG4RPG_Property_value_t)
     D                                     extproc('LOG4RPG07+
     D                                     _PropertyList_get+
     D                                     ')
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_key                              const  like(LOG4RPG_Property_key_t  )
      *
      *  Returns an iterator for the specified property list.
     D PropertyList_getIterator...
     D                 PR                  likeds(LOG4RPG_Property...
     D                                                    ListIterator_t   )
     D                                     extproc('LOG4RPG07+
     D                                     _PropertyList_getIterator+
     D                                     ')
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Returns the first property of the specified property list.
     D PropertyList_getFirst...
     D                 PR                  likeds(LOG4RPG_Property_t   )
     D                                     extproc('LOG4RPG07+
     D                                     _PropertyList_getFirst+
     D                                     ')
     D  io_propIter                               likeds(LOG4RPG_Property...
     D                                                           ListIterator_t)
      *
      *  Returns the next property of the specified property list.
     D PropertyList_getNext...
     D                 PR                  likeds(LOG4RPG_Property_t   )
     D                                     extproc('LOG4RPG07+
     D                                     _PropertyList_getNext+
     D                                     ')
     D  io_propIter                               likeds(LOG4RPG_Property...
     D                                                           ListIterator_t)
      *
      *  Returns true if this property list contains a mapping for the
      *  specified key.
     D PropertyList_containsKey...
     D                 PR              N
     D                                     extproc('LOG4RPG07+
     D                                     _PropertyList_containsKey+
     D                                     ')
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_key                              const  like(LOG4RPG_Property_key_t  )
      *
      *  Removes the specified property from the property list.
     D PropertyList_remove...
     D                 PR
     D                                     extproc('LOG4RPG07+
     D                                     _PropertyList_remove+
     D                                     ')
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_key                              const  like(LOG4RPG_Property_key_t  )
      *
      *  Removes all properties from the specified property list.
     D PropertyList_clear...
     D                 PR
     D                                     extproc('LOG4RPG07+
     D                                     _PropertyList_clear+
     D                                     ')
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Deletes the specified given property list.
     D PropertyList_delete...
     D                 PR              N
     D                                     extproc('LOG4RPG07+
     D                                     _PropertyList_delete+
     D                                     ')
     D  io_pPropList                              like(LOG4RPG_pPropertyList_t )
      *
      *  Test the specified Property List object for a NULL value.
     D PropertyList_isNull...
     D                 PR              N
     D                                     extproc('LOG4RPG07+
     D                                     _PropertyList_isNull+
     D                                     ')
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Returns a NULL properties list.
     D PropertyList_null...
     D                 PR                         like(LOG4RPG_pPropertyList_t )
     D                                     extproc('LOG4RPG07+
     D                                     _PropertyList_null+
     D                                     ')
      *
      /ENDIF
