      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: PropertyList                             *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  13.06.2006                                              *
      *  E-mail  :  thomas.raddatz@tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  16.10.2006 Th.Raddatz     Fix bug in PropertyList_loadFromUrl().   *
      *                            Now returning cFalse on unknown URL      *
      *                            protocol.                                *
      *                                                                     *
      *  26.10.2006 Th.Raddatz     Added procedures:                        *
      *                               PropertyList_containsKey()            *
      *                               PropertyList_remove()                 *
      *                               PropertyList_clear()                  *
      *                                                                     *
      *  27.10.2006 Th.Raddatz     Now changing property key to lower       *
      *                            case, when adding a property.            *
      *                                                                     *
      *  18.04.2008 Th.Raddatz     Fixed problem that loadPropertiesFromMbr *
      *                            crashed with RNX0100 if the record length*
      *                            of a non-source member exceeded 512.     *
      *                                                                     *
      *  18.06.2008 Th.Raddatz     Added special value *SEARCH for the      *
      *                            library name when loading properties     *
      *                            from a physical file member.             *
      *                            Added PropertyList_getUrl() to return    *
      *                            actual URL used to load configuration    *
      *                            data.                                    *
      *                                                                     *
      *  19.06.2008 Th.Raddatz     Fixed potential memory leak. Now the     *
      *                            memory of the PropertyList handle is     *
      *                            correctly freed.                         *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< TGTRLS(V6R1M0  );                                    *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /COPY QLOG4RPG,H_SPEC
      *=====================================================================*
     FMBR       IF   F  512        DISK    usropn
     F                                     extfile(g_file)
     F                                     extmbr(g_mbr)
     F                                     infds(g_mbrInf)
      *
     D g_file          S             21A   inz
     D g_mbr           S             10A   inz
      *
     D g_mbrInf        DS                  qualified
     D  rcdLength            125    126I 0
     D  sourceFile           163    163A
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG07
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PTYPES                        Private type definitions
      *
     D handle_t...
     D                 DS                  qualified               based(pDummy)
     D  pMap                               like(BasicMap_handle_t )
     D  url                                like(url_t)
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,CEELIB                        CEE-Procedures
      /COPY QLOG4RPG,OPNLSTAPIS                    Process Open List APIs
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      /COPY QIFS,PIFS                              IFS Stream file support
      *
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
      /COPY QLOG4RPG,PLOG4RPG99                    Helpers
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Loads the properties from the specified stream file.
     D loadPropertiesFromStmf...
     D                 PR              N
     D  i_pMap                             const  like(BasicMap_handle_t    )
     D  i_path                             const  like(LOG4RPG_path_t       )
      *
      *  Loads the properties from the specified member.
     D loadPropertiesFromMbr...
     D                 PR              N
     D  i_pMap                             const  like(BasicMap_handle_t    )
     D  i_path                             const  like(LOG4RPG_path_t       )
      *
      *  Loads the properties from embedded string data.
     D loadPropertiesFromString...
     D                 PR              N
     D  i_pMap                             const  like(BasicMap_handle_t    )
     D  i_pString                      *   const  options(*string           )
      *
      *  Test the specified buffer, splitts the buffer and adds the property
      *  to the proeprty list.
     D addPropertyToList...
     D                 PR
     D  i_pMap                             const  like(BasicMap_handle_t    )
     D  i_buffer                    256A   const  varying
      *
      *  Splitts a path into pieces of file, library and member.
     D getMbrLocation...
     D                 PR
     D                                     extproc('+
     D                                     getMbrLocation+
     D                                     ')
     D  i_path                             const  like(LOG4RPG_path_t       )
     D  o_file                       10A
     D  o_lib                        10A
     D  o_mbr                        10A
      *
      *  Spin through all files in the library and search for the specified
      *  specified memebr. Return the library name of the library that
      *  contains the file that contains the member.
     D searchMemberAndReturnLibrary...
     D                 PR            10A
     D                                     extproc('+
     D                                     searchMemberAndReturnLibrary+
     D                                     ')
     D  i_file                       10A   const
     D  i_mbr                        10A   const
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=========================================================================
      *  Creates a new property list.
      *=========================================================================
      *  Parameters:
      *   i_pString     - Pointer to a string of properties.
      *
      *  Returns:
      *   pPropList     - Returns a handle to the property list on success, else
      *                   a NULL handle.
      *=========================================================================
     P PropertyList_new...
     P                 B                   export
      *
     D PropertyList_new...
     D                 PI                         like(LOG4RPG_pPropertyList_t )
     D  i_pString                      *   const  options(*nopass:
     D                                                    *omit  : *string)
      *
      *  Parameter positions
     D p_pString       C                   const(1)
      *
      *  Fields for optional parameters
     D pString         S                   like(i_pString   ) inz
      *
      *  Return value
     D propList        DS                  likeds(handle_t  )
     D                                     based(pPropList)
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
     D tempPropList    DS                  likeds(handle_t       ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Get optional parameters
         // ... pString
         if %parms() >= p_pString;
            CEETSTA(isPresent: p_pString: *omit);
         else;
            isPresent = 0;
         endif;
 
         if isPresent = 1;
            pString = i_pString;
         else;
            pString = *NULL;
         endif;
 
         LogLog_verbose('Creating properties list ...');
 
         pPropList = PropertyList_null();
 
         // Initialize property list handle
         clear tempPropList;
         tempPropList.pMap    = BasicMap_new();
         tempPropList.url     = '';
 
         // Load properties from string
         if pString <> *NULL;
            if not loadPropertiesFromString(tempPropList.pMap: pString);
               return pPropList;
            endif;
            tempPropList.url = '';
         endif;
 
         // Return properties list to caller
         pPropList = %alloc(%size(handle_t));
         propList = tempPropList;
 
         LogLog_verbose('+ Allocated memory for properties list.');
 
         return pPropList;
 
      /END-FREE
      *
     P PropertyList_new...
     P                 E
      *
      *=========================================================================
      *  Loads the properties from the specified location.
      *=========================================================================
      *  Parameters:
      *   i_pPropList   - Handle of the property list returned by
      *                   PropertyList_new().
      *   i_url         - The URL that specifies the location where to load the
      *                   properties from.
      *
      *  Returns:
      *   isLoaded      - Returns TRUE on success, else FALSE.
      *=========================================================================
     P PropertyList_loadFromUrl...
     P                 B                   export
      *
     D PropertyList_loadFromUrl...
     D                 PI              N
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_url                              const  like(url_t                   )
      *
      *  Property list handle
     D propList        DS                  likeds(handle_t    )
     D                                     based(i_pPropList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Load properties ...
         select;
         // ... from stream file
         when Url_getProtocol(i_url) = 'file';
            if not loadPropertiesFromStmf(propList.pMap: Url_getPath(i_url));
               return cFalse;
            endif;
            propList.url = i_url;
         when Url_getProtocol(i_url) = 'mbr';
            if not loadPropertiesFromMbr(propList.pMap: Url_getPath(i_url));
               return cFalse;
            endif;
            propList.url = 'mbr:' + %trim(g_file) + '.' + %trim(g_mbr);
         other;
            LogLog_warning('Unknown URL protocol: ' +
                            Url_getProtocol(i_url));
            return cFalse;
         endsl;
 
         return cTrue;
 
      /END-FREE
      *
     P PropertyList_loadFromUrl...
     P                 E
      *
      *=========================================================================
      *  Returns the final URL that was used to load the properties.
      *=========================================================================
      *  Parameters:
      *   i_pPropList   - Handle of the property list returned by
      *                   PropertyList_new().
      *
      *  Returns:
      *   url           - URL that was used to load the properties.
      *                   If the properties have been loaded from a string
      *                   an empty string is returned.
      *=========================================================================
     P PropertyList_getUrl...
     P                 B                   export
      *
     D PropertyList_getUrl...
     D                 PI                         like(url_t )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Property list handle
     D propList        DS                  likeds(handle_t    )
     D                                     based(i_pPropList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return propList.url;
 
      /END-FREE
      *
     P PropertyList_getUrl...
     P                 E
      *
      *=========================================================================
      *  Returns the number of entries in the specified property list.
      *=========================================================================
      *  Parameters:
      *   i_pPropList   - Handle of the property list returned by
      *                   PropertyList_new().
      *
      *  Returns:
      *   numE          - Returns the number of properties in this
      *                   property list on success, else -1.
      *=========================================================================
     P PropertyList_getNumE...
     P                 B                   export
      *
     D PropertyList_getNumE...
     D                 PI            10I 0
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Property list handle
     D propList        DS                  likeds(handle_t    )
     D                                     based(i_pPropList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return BasicMap_getNumE(propList.pMap);
 
      /END-FREE
      *
     P PropertyList_getNumE...
     P                 E
      *
      *=========================================================================
      *  Adds a property to the speciffied property list.
      *=========================================================================
      *  Parameters:
      *   i_pPropList   - Handle of the property list returned by
      *                   PropertyList_new().
      *   i_property    - Property that is added to this property list.
      *
      *  Returns:
      *   index         - Returns the index of the property on success,
      *                   else -1.
      *=========================================================================
     P PropertyList_put...
     P                 B                   export
      *
     D PropertyList_put...
     D                 PI            10I 0
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_property                         const  likeds(LOG4RPG_Property_t    )
      *
      *  Helper fields
     D property        DS                  likeds(i_property)
      *
      *  Property list handle
     D propList        DS                  likeds(handle_t    )
     D                                     based(i_pPropList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         property = i_property;
 
         return BasicMap_put(propList.pMap: property.key
                                          : %addr(property.value)
                                          : %len(property.value) + 2);
 
      /END-FREE
      *
     P PropertyList_put...
     P                 E
      *
      *=========================================================================
      *  Returns the value assigned to the specified key.
      *=========================================================================
      *  Parameters:
      *   i_pPropList   - Handle of the property list returned by
      *                   PropertyList_new().
      *   i_key         - Key, whose associated value is returned.
      *
      *  Returns:
      *   value         - Returns the associated value on success, else ''.
      *=========================================================================
     P PropertyList_get...
     P                 B                   export
      *
     D PropertyList_get...
     D                 PI                         like(LOG4RPG_Property_value_t)
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_key                              const  like(LOG4RPG_Property_key_t  )
      *
      *  Return value
     D value           S                   like(LOG4RPG_Property_value_t) inz
      *
      *  Property list handle
     D propList        DS                  likeds(handle_t    )
     D                                     based(i_pPropList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         BasicMap_get(propList.pMap: i_key: %addr(value): %size(value));
 
         return value;
 
      /END-FREE
      *
     P PropertyList_get...
     P                 E
      *
      *=========================================================================
      *  Returns an iterator for the specified property list.
      *=========================================================================
      *  Parameters:
      *   i_pPropList   - Handle of the property list returned by
      *                   PropertyList_new().
      *
      *  Returns:
      *   propIter      - Iterator for the property list.
      *=========================================================================
     P PropertyList_getIterator...
     P                 B                   export
      *
     D PropertyList_getIterator...
     D                 PI                         likeds(LOG4RPG_Property...
     D                                                           ListIterator_t)
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Return value
     D propIter        DS                  likeds(LOG4RPG_Property...
     D                                                    ListIterator_t) inz
      *
      *  Property list handle
     D propList        DS                  likeds(handle_t    )
     D                                     based(i_pPropList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clear propIter;
         propIter.pPropList = i_pPropList;
         propIter.lastProp  = 0;
 
         return propIter;
 
      /END-FREE
      *
     P PropertyList_getIterator...
     P                 E
      *
      *=========================================================================
      *  Returns the first property of the specified property list.
      *=========================================================================
      *  Parameters:
      *   i_pPropList   - Handle of the property list returned by
      *                   PropertyList_new().
      *
      *  Returns:
      *   property      - Returns the first property in the specified
      *                   property list on success, else ''.
      *=========================================================================
     P PropertyList_getFirst...
     P                 B                   export
      *
     D PropertyList_getFirst...
     D                 PI                         likeds(LOG4RPG_Property_t    )
     D  io_propIter                               likeds(LOG4RPG_Property...
     D                                                           ListIterator_t)
      *
      *  Return value
     D property        DS                  likeds(LOG4RPG_Property_t   ) inz
      *
      *  Property list handle
     D propList        DS                  likeds(handle_t    )
     D                                     based(io_propIter.pPropList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if PropertyList_getNumE(io_propIter.pPropList) = 0;
            return property;
         endif;
 
         io_propIter.lastProp = 1;
 
         property.key = BasicMap_getKeyByIndex(propList.pMap
                                               : io_propIter.lastProp);
         BasicMap_getValueByIndex(propList.pMap
                                  : io_propIter.lastProp
                                  : %addr(property.value)
                                  : %size(property.value));
 
         return property;
 
      /END-FREE
      *
     P PropertyList_getFirst...
     P                 E
      *
      *=========================================================================
      *  Returns the next property of the specified property list.
      *=========================================================================
      *  Parameters:
      *   i_pPropList   - Handle of the property list returned by
      *                   PropertyList_new().
      *
      *  Returns:
      *   property      - Returns the next property in the specified
      *                   property list on success, else ''.
      *=========================================================================
     P PropertyList_getNext...
     P                 B                   export
      *
     D PropertyList_getNext...
     D                 PI                         likeds(LOG4RPG_Property_t    )
     D  io_propIter                               likeds(LOG4RPG_Property...
     D                                                           ListIterator_t)
      *
      *  Return value
     D property        DS                  likeds(LOG4RPG_Property_t   ) inz
      *
      *  Property list handle
     D propList        DS                  likeds(handle_t    )
     D                                     based(io_propIter.pPropList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if PropertyList_getNumE(io_propIter.pPropList) <= io_propIter.lastProp;
            return property;
         endif;
 
         io_propIter.lastProp = io_propIter.lastProp + 1;
 
         property.key = BasicMap_getKeyByIndex(propList.pMap
                                               : io_propIter.lastProp);
         BasicMap_getValueByIndex(propList.pMap
                                  : io_propIter.lastProp
                                  : %addr(property.value)
                                  : %size(property.value));
 
         return property;
 
      /END-FREE
      *
     P PropertyList_getNext...
     P                 E
      *
      *=========================================================================
      *  Returns true if this property list contains a mapping for the
      *  specified key.
      *=========================================================================
      *  Parameters:
      *   i_pPropList   - Handle of the property list returned by
      *                   PropertyList_new().
      *   i_key         - Key of the property.
      *
      *  Returns:
      *   isFound       - Returns TRUE is this property list contains a mapping
      *                   for the specified key, else FALSE.
      *=========================================================================
     P PropertyList_containsKey...
     P                 B                   export
      *
     D PropertyList_containsKey...
     D                 PI              N
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_key                              const  like(LOG4RPG_Property_key_t  )
      *
      *  Property list handle
     D propList        DS                  likeds(handle_t    )
     D                                     based(i_pPropList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return BasicMap_containsKey(propList.pMap: i_key);
 
      /END-FREE
      *
     P PropertyList_containsKey...
     P                 E
      *
      *=========================================================================
      *  Removes the specified property from the property list.
      *=========================================================================
      *  Parameters:
      *   i_pPropList   - Handle of the property list returned by
      *                   PropertyList_new().
      *   i_key         - Key of the property.
      *
      *  Returns:
      *   void
      *=========================================================================
     P PropertyList_remove...
     P                 B                   export
      *
     D PropertyList_remove...
     D                 PI
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_key                              const  like(LOG4RPG_Property_key_t  )
      *
      *  Property list handle
     D propList        DS                  likeds(handle_t    )
     D                                     based(i_pPropList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         BasicMap_remove(propList.pMap: i_key);
 
         return;
 
      /END-FREE
      *
     P PropertyList_remove...
     P                 E
      *
      *=========================================================================
      *  Removes all properties from the specified property list.
      *=========================================================================
      *  Parameters:
      *   i_pPropList   - Handle of the property list returned by
      *                   PropertyList_new().
      *
      *  Returns:
      *   void
      *=========================================================================
     P PropertyList_clear...
     P                 B                   export
      *
     D PropertyList_clear...
     D                 PI
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Helper fields
     D x               S             10I 0 inz
     D numE            S             10I 0 inz
     D key             S                   like(LOG4RPG_Property_key_t  )
      *
      *  Property list handle
     D propList        DS                  likeds(handle_t    )
     D                                     based(i_pPropList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         numE = BasicMap_getNumE(propList.pMap);
 
         for x = 1 to numE;
            key = BasicMap_getKeyByIndex(propList.pMap: 1);
            BasicMap_remove(propList.pMap: key);
         endfor;
 
         return;
 
      /END-FREE
      *
     P PropertyList_clear...
     P                 E
      *
      *=========================================================================
      *  Deletes the specified property list.
      *=========================================================================
      *  Parameters:
      *   io_pPropList  - Handle of the property list returned by
      *                   PropertyList_new().
      *
      *  Returns:
      *   isDeleted     - Returns TRUE on success, else FALSE.
      *=========================================================================
     P PropertyList_delete...
     P                 B                   export
      *
     D PropertyList_delete...
     D                 PI              N
     D  io_pPropList                              like(LOG4RPG_pPropertyList_t )
      *
      *  Return value
     D isDeleted       S               N   inz(cFalse)
      *
      *  Property list handle
     D propList        DS                  likeds(handle_t    )
     D                                     based(io_pPropList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_verbose('Deleting properties list ...');
 
         if (not BasicMap_isNull(propList.pMap));
            BasicMap_delete(propList.pMap);
         endif;
 
         propList.url = '';
 
         clear propList;
         dealloc(N) io_pPropList;
 
         io_pPropList = PropertyList_null();
 
         LogLog_verbose('- Freed memory of properties list.');
 
         isDeleted = cTrue;
 
         return isDeleted;
 
      /END-FREE
      *
     P PropertyList_delete...
     P                 E
      *
      *=========================================================================
      *  Tests the specified property list for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_pPropList   - Handle of the property list returned by
      *                   PropertyList_new().
      *
      *  Returns:
      *   isNull        - Returns TRUE if the handle of the property list is a
      *                   NULL handle.
      *=========================================================================
     P PropertyList_isNull...
     P                 B                   export
      *
     D PropertyList_isNull...
     D                 PI              N
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Property list handle
     D propList        DS                  likeds(handle_t    )
     D                                     based(i_pPropList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if i_pPropList = PropertyList_null();
            return cTrue;
         else;
            return BasicMap_isNull(propList.pMap);
         endif;
 
      /END-FREE
      *
     P PropertyList_isNull...
     P                 E
      *
      *=========================================================================
      *  Returns a NULL properties list.
      *=========================================================================
      *  Parameters:
      *
      *  Returns:
      *   pPropList     - Property list NULL handle.
      *=========================================================================
     P PropertyList_null...
     P                 B                   export
      *
     D PropertyList_null...
     D                 PI                         like(LOG4RPG_pPropertyList_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return BasicMap_null();
 
      /END-FREE
      *
     P PropertyList_null...
     P                 E
      *
      *=========================================================================
      *  *** Private ***
      *  Loads the properties from the specified stream file.
      *=========================================================================
     P loadPropertiesFromStmf...
     P                 B
      *
     D loadPropertiesFromStmf...
     D                 PI              N
     D  i_pMap                             const  like(BasicMap_handle_t    )
     D  i_path                             const  like(LOG4RPG_path_t       )
      *
      *  Return value
     D isLoaded        S               N   inz(cFalse)
      *
      *  Helper fields
     D hFile           S                   like(ifs_hFile_t ) inz
     D bytesRed        S             10I 0                    inz
     D buffer          S           1024A                      inz
     D msg             DS                  likeds(msg_t             ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_debug('Loading properties from file [' + i_path + '] ...');
 
         // Test, if configuration file exists
         if not f_isIfsFile(i_path: msg);
            LogLog_warningMsg(msg);
            return isLoaded;
         endif;
 
         hFile = f_openIfsFile(i_path
                               : O_RDONLY + O_SHARE_RDONLY + O_TEXTDATA
                               : *omit: *omit: msg);
         if hFile = RC_ERROR;
            LogLog_warningMsg(msg);
            return isLoaded;
         endif;
 
         bytesRed = f_readLineIfsFile(hFile
                                      : %addr(buffer): %size(buffer): *omit);
         dow   bytesRed <> cIFS_EOF;
 
            if bytesRed > 0;
               addPropertyToList(i_pMap: %subst(buffer: 1: bytesRed));
            endif;
 
            bytesRed = f_readLineIfsFile(hFile
                                         : %addr(buffer): %size(buffer): *omit);
         enddo;
 
         f_closeIfsFile(hFile);
 
         LogLog_verbose('Loaded properties from file [' + i_path + '].');
 
         isLoaded = cTrue;
 
         return isLoaded;
 
      /END-FREE
      *
     P loadPropertiesFromStmf...
     P                 E
      *
      *=========================================================================
      *  *** Private ***
      *  Loads the properties from the specified member.
      *=========================================================================
     P loadPropertiesFromMbr...
     P                 B
      *
     D loadPropertiesFromMbr...
     D                 PI              N
     D  i_pMap                             const  like(BasicMap_handle_t    )
     D  i_path                             const  like(LOG4RPG_path_t       )
      *
      *  Return value
     D isLoaded        S               N   inz(cFalse)
      *
      *  Helper fields
     D file            S             10A   inz
     D lib             S             10A   inz
     D member          S             10A   inz
     D length          S             10I 0 inz
     D warnLength      S               N   inz(cFalse)
      *
     D inBufMbr        DS                  qualified
     D  data                        512A
      *
     D inBufSrcMbr     DS                  qualified
     D  srcSeq                        6S 2
     D  srcDat                        6S 0
     D  srcDta                      500A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_debug('Loading properties from member [' + i_path + '] ...');
 
         getMbrLocation(i_path: file: lib: member);
         if (f_ucase(lib) = cLOG4RPG_LIB_SEARCH);
            lib = searchMemberAndReturnLibrary(file: member);
         endif;
 
         // Test, if configuration file exists
         if not f_exist(file: lib: '*FILE': member);
            LogLog_warning('Member ' + %trim(member) + ' in file ' +
                            %trim(file) + ' in library ' +
                            %trim(lib)  + ' does not exist.');
            return isLoaded;
         endif;
 
         g_file = %trim(lib) + '/' + %trim(file);
         g_mbr  = %trim(member);
 
         open(E) MBR;
 
         if %error();
            LogLog_warning('Could not open member [' + %trim(member) + '].');
            return isLoaded;
         endif;
 
         p_rmvPgmMsg(cMsg_Rmv_All: *omit: cMsg_Same: cMsg_ToMyself);
 
         setll 1 MBR;
 
         dow %found(MBR);
            if g_mbrInf.sourceFile = 'Y';
               read MBR inBufSrcMbr;
            else;
               read MBR inBufMbr;
            endif;
 
            if %eof(MBR);
               leave;
            endif;
 
            if g_mbrInf.sourceFile = 'Y';
               length = g_mbrInf.rcdLength - (%size(inBufSrcMbr.SrcSeq) +
                                              %size(inBufSrcMbr.SrcDat));
               addPropertyToList(i_pMap: %subst(inBufSrcMbr.srcDta
                                                : 1
                                                : length));
            else;
               if g_mbrInf.rcdLength > %len(inBufMbr.data);
                  length = %len(inBufMbr.data);
                  if not warnLength;
                     // LogLog_warning('Record length of properties file +
                     //                 exceeded maximum of ' +
                     //                 %char(%len(inBufMbr.data)) + ' byte.');
                     warnLength = cTrue;
                  endif;
               else;
                  length = g_mbrInf.rcdLength;
               endif;
               addPropertyToList(i_pMap: %subst(inBufMbr.data
                                                : 1
                                                : length));
            endif;
         enddo;
 
         close MBR;
 
         LogLog_verbose('Loaded properties from member [' + i_path + '].');
 
         isLoaded = cTrue;
 
         return isLoaded;
 
      /END-FREE
      *
     P loadPropertiesFromMbr...
     P                 E
      *
      *=========================================================================
      *  *** Private ***
      *  Loads the properties from embedded string data.
      *=========================================================================
     P loadPropertiesFromString...
     P                 B
      *
     D loadPropertiesFromString...
     D                 PI              N
     D  i_pMap                             const  like(BasicMap_handle_t    )
     D  i_pString                      *   const  options(*string           )
      *
      *  Return value
     D isLoaded        S               N   inz(cFalse)
      *
      *  Helper fields
     D pToken          S               *   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_debug('Loading properties from string ...');
 
         pToken = strtok(i_pString: ';');
         dow pToken <> *NULL;
            addPropertyToList(i_pMap: %str(pToken));
            pToken = strtok(*NULL: ';');
         enddo;
 
         LogLog_verbose('Loaded properties from string.');
 
         isLoaded = cTrue;
 
         return isLoaded;
 
      /END-FREE
      *
     P loadPropertiesFromString...
     P                 E
      *
      *=========================================================================
      *  *** Private ***
      *  Test the specified buffer, splitts the buffer and adds the property
      *  to the proeprty list.
      *=========================================================================
     P addPropertyToList...
     P                 B
      *
     D addPropertyToList...
     D                 PI
     D  i_pMap                             const  like(BasicMap_handle_t    )
     D  i_buffer                    256A   const  varying
      *
      *  Helper fields
     D x               S             10I 0                    inz
     D char            S              1A                      inz
     D buffer          S                   like(i_buffer    ) inz
     D property        DS                  likeds(LOG4RPG_Property_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         buffer = %trim(i_buffer);
 
         if buffer = '';
            return;
         endif;
 
         char   = %subst(buffer: 1: 1);
 
         if (char <> '#') and (char <> ';') and (char <> '!');
            x = %scan('=': buffer);
            if (x > 1) and (x < %len(buffer));
 
               property.key   = f_lcase(%trim(%subst(buffer: 1: x-1)));
               property.value = %trim(%subst(buffer: x+1));
 
               BasicMap_put(i_pMap: property.key
                                  : %addr(property.value)
                                  : %len(property.value) + 2);
            endif;
         endif;
 
         return;
 
      /END-FREE
      *
     P addPropertyToList...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Splitts a path into pieces of file, library and member.
      *=========================================================================
     P getMbrLocation...
     P                 B
      *
     D getMbrLocation...
     D                 PI
     D  i_path                             const  like(LOG4RPG_path_t       )
     D  o_file                       10A
     D  o_lib                        10A
     D  o_mbr                        10A
      *
      *  Helper fields
     D x               S             10I 0 inz
     D path            S                   like(i_path   ) inz
     D closingChar     S              1A   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         o_file = '';
         o_lib  = '';
         o_mbr  = '';
 
         if i_path = '';
            LogLog_warning('Specified path is *BLANKS.');
            return;
         endif;
 
         path = f_ucase(%trim(i_path));
 
         // Get library name from path
         x = %scan('/': path);
 
         select;
         when x > 11;
            LogLog_warning('Library name is too long.');
            LogLog_warning('Path is: ' + i_path);
            return;
         when x > 1;
            o_lib = %subst(path: 1: x-1);
            if x < %len(path);
               path = %subst(path: x+1);
            else;
               LogLog_warning('Specified path does not contain +
                               file and member names.');
               LogLog_warning('Path is: ' + i_path);
               return;
            endif;
         when x = 1;
            o_lib = '*LIBL';
            path = %subst(path: x+1);
         other;
            o_lib = '*LIBL';
         endsl;
 
         // Get file name from path
         x = %scan('(': path);
         if x > 0;
            closingChar = ')';
         else;
            x = %scan('.': path);
            if x > 0;
               closingChar = '';
            else;
               x = %len(path) + 1;
            endif;
         endif;
 
         select;
         when x > 11;
            LogLog_warning('File name is too long.');
            LogLog_warning('Path is: ' + i_path);
            return;
         when x > 1;
            o_file = %subst(path: 1: x-1);
            if x < %len(path);
               path = %subst(path: x+1);
            else;
               o_mbr = '*FIRST';
               return;
            endif;
         when x = 1;
            LogLog_warning('File portion is missing in path.');
            LogLog_warning('Path is: ' + i_path);
            return;
         endsl;
 
         // Get member name from path
         if closingChar = '';
            x = %len(path) + 1;
         else;
            x = %scan(closingChar: path);
            if x = 0;
               LogLog_warning('Closing character [' + closingChar +
                               '] is missing.');
               LogLog_warning('Path is: ' + i_path);
               return;
            endif;
         endif;
 
         select;
         when x > 11;
            LogLog_warning('Member name is too long.');
            LogLog_warning('Path is: ' + i_path);
            return;
         when x > 1;
            o_mbr = %subst(path: 1: x-1);
         other;
            LogLog_warning('Member portion is missing in path.');
            LogLog_warning('Path is: ' + i_path);
            return;
         endsl;
 
         return;
 
      /END-FREE
      *
     P getMbrLocation...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Spin through all files in the library and search for the specified
      *  specified memebr. Return the library name of the library that
      *  contains the file that contains the member.
      *=========================================================================
     P searchMemberAndReturnLibrary...
     P                 B
      *
     D searchMemberAndReturnLibrary...
     D                 PI            10A
     D  i_file                       10A   const
     D  i_mbr                        10A   const
      *
      *  Helper fields
     D i               S             10I 0 inz
     D qObj            DS                  likeds(qObj_t    ) inz
      *
     D authCtrl        DS                  likeds(qgy_authCtrl_t   ) inz
     D selectCtrl      DS                  likeds(qgy_selectCtrl_t ) inz
     D listInf         DS                  likeds(qgy_opnListInf_t ) inz
     D sortInf         DS                  likeds(qgy_sortInf_t    ) inz
     D objInf          DS                  likeds(qgy_objInf_t     ) inz
      *
     D errCode         DS                  likeds(errCode_t        ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not f_exist('QGYOLOBJ': '*LIBL': '*PGM'));
            LogLog_warning('Open List of Objects (QGYOLOBJ) API not found.');
            LogLog_warning('- Please install the Host Servers option of i5/OS');
            LogLog_warning('  to be able to use the ' + cLOG4RPG_LIB_SEARCH +
                           ' special value.');
            return '*LIBL';
         endif;
 
         qObj.name = i_file;
         qObj.lib  = '*LIBL';
 
         authCtrl.length     = %size(authCtrl);
         authCtrl.callLvl    = 0;
         authCtrl.ofsObjAuth = %size(authCtrl) - %size(authCtrl.objAuthList)
                                               - %size(authCtrl.libAuthList);
         authCtrl.numObjAuth = 1;
         authCtrl.ofsLibAuth = %size(authCtrl) - %size(authCtrl.libAuthList);
         authCtrl.numLibAuth = 1;
         authCtrl.reserved_1 = *ALLx'00';
         authCtrl.objAuthList.auth(1) = '*USE';
         authCtrl.libAuthList.auth(1) = '*USE';
 
         selectCtrl.length     = %size(selectCtrl);
         selectCtrl.value      = 0;   // 0=select; 1=omit
         selectCtrl.ofsStat    = %size(selectCtrl) -
                                 %size(selectCtrl.statList);
         selectCtrl.numStat    = 1;
         selectCtrl.reserved_1 = 0;
         selectCtrl.statList.stat(1) = ' ';   // return no-eeror entries only
 
         clear objInf;
         clear listInf;
         errCode = f_newApiErrCode(cTrue);
 
         monitor;
            QGYOLOBJ(objInf: 0: listInf: -1: sortInf: qObj: '*ALL':
                     authCtrl: selectCtrl: 0: '': errCode);
 
            i = 0;
            dow (i < listInf.totalRcds);
               i = i + 1;
               // Get next object in list
               QGYGTLE(objInf: %size(objInf)
                       : listInf.hRequest: listInf: 1: i: errCode);
               if (f_exist(objInf.name: objInf.lib: '*FILE': i_mbr));
                  return objInf.lib;
               endif;
            enddo;
 
            // Close list of objects
            QGYCLST(listInf.hREquest: errCode);
         on-error;
            return '*LIBL';
         endmon;
 
         return '*LIBL';
 
      /END-FREE
      *
     P searchMemberAndReturnLibrary...
     P                 E
      *
