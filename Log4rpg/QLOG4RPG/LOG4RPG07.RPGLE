**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: PropertyList                             *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  13.06.2006                                              *
//  E-mail  :  thomas.raddatz@tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  16.10.2006 Th.Raddatz     Fix bug in PropertyList_loadFromUrl().   *
//                            Now returning cFalse on unknown URL      *
//                            protocol.                                *
//                                                                     *
//  26.10.2006 Th.Raddatz     Added procedures:                        *
//                               PropertyList_containsKey()            *
//                               PropertyList_remove()                 *
//                               PropertyList_clear()                  *
//                                                                     *
//  27.10.2006 Th.Raddatz     Now changing property key to lower       *
//                            case, when adding a property.            *
//                                                                     *
//  18.04.2008 Th.Raddatz     Fixed problem that loadPropertiesFromMbr *
//                            crashed with RNX0100 if the record length*
//                            of a non-source member exceeded 512.     *
//                                                                     *
//  18.06.2008 Th.Raddatz     Added special value *SEARCH for the      *
//                            library name when loading properties     *
//                            from a physical file member.             *
//                            Added PropertyList_getUrl() to return    *
//                            actual URL used to load configuration    *
//                            data.                                    *
//                                                                     *
//  19.06.2008 Th.Raddatz     Fixed potential memory leak. Now the     *
//                            memory of the PropertyList handle is     *
//                            correctly freed.                         *
//                                                                     *
//  23.03.2025                Resolve special library and member       *
//                            values (*LIBL, *FIRST).                  *
//                                                                     *
//  01.03.2026 Th. Raddatz    Fix loading properties from UTF-8        *
//                            encoded stream files.                    *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//                                                                     *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) +                     *
//                              SRCMBR(&SM);                           *
//                                                                     *
//     >>COMPILE<<                                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TGTRLS(V7R3M0  );                                    *
//     >>END-COMPILE<<                                                 *
//                                                                     *
//     >>EXECUTE<<                                                     *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
/copy QLOG4RPG,H_SPEC
//=====================================================================*
dcl-f MBR disk(512) usropn extfile(g_file) extmbr(g_mbr) infds(g_mbrInf);

dcl-s g_file char(21) inz;
dcl-s g_mbr char(10) inz;

dcl-ds g_mbrInf qualified;
  rcdLength  int(5) pos(125);
  sourceFile char(1) pos(163);
end-ds;

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG07

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PTYPES                        Private type definitions

dcl-ds handle_t qualified based(pDummy);
  pMap like(BasicMap_handle_t);
  url  like(url_t);
end-ds;

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,CEELIB                        CEE-Procedures
/copy QLOG4RPG,OPNLSTAPIS                    Process Open List APIs
/copy QBASICS1,PBASICS1                      Basic RPG Extensions
/copy QIFS,PIFS                              IFS Stream file support

/copy QLOG4RPG,PLOG4RPG10                    LogLog
/copy QLOG4RPG,PLOG4RPG99                    Helpers

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Loads the properties from the specified stream file.
dcl-pr loadPropertiesFromStmf ind;
  i_pMap like(BasicMap_handle_t) const;
  i_path like(LOG4RPG_path_t) const;
end-pr;

//  Loads the properties from the specified member.
dcl-pr loadPropertiesFromMbr ind;
  i_pMap like(BasicMap_handle_t) const;
  i_path like(LOG4RPG_path_t) const;
end-pr;

//  Loads the properties from embedded string data.
dcl-pr loadPropertiesFromString ind;
  i_pMap    like(BasicMap_handle_t) const;
  i_pString pointer options(*string) const;
end-pr;

//  Test the specified buffer, splitts the buffer and adds the property
//  to the proeprty list.
dcl-pr addPropertyToList;
  i_pMap   like(BasicMap_handle_t) const;
  i_buffer varchar(256) const;
end-pr;

//  Splitts a path into pieces of file, library and member.
dcl-pr getMbrLocation extproc('getMbrLocation');
  i_path like(LOG4RPG_path_t) const;
  o_file char(10);
  o_lib  char(10);
  o_mbr  char(10);
end-pr;

//  Spin through all files in the library and search for the specified
//  specified memebr. Return the library name of the library that
//  contains the file that contains the member.
dcl-pr searchMemberAndReturnLibrary char(10) extproc('searchMemberAndReturnLibrary');
  i_file char(10) const;
  i_mbr  char(10) const;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
//
// -----------------------------------------
//  Global fields
// -----------------------------------------
//
//=========================================================================
//  Creates a new property list.
//=========================================================================
//  Parameters:
//   i_pString     - Pointer to a string of properties.
//
//  Returns:
//   pPropList     - Returns a handle to the property list on success, else
//                   a NULL handle.
//=========================================================================
dcl-proc PropertyList_new export;
  dcl-pi *n like(LOG4RPG_pPropertyList_t);
    i_pString pointer options(*nopass: *omit: *string) const;
  end-pi;

//  Parameter positions
  dcl-c p_pString 1;

//  Fields for optional parameters
  dcl-s pString like(i_pString) inz;

//  Return value
  dcl-ds propList likeds(handle_t) based(pPropList);

//  Helper fields
  dcl-s isPresent int(10) inz;
  dcl-ds tempPropList likeds(handle_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Loads the properties from the specified location.
//=========================================================================
//  Parameters:
//   i_pPropList   - Handle of the property list returned by
//                   PropertyList_new().
//   i_url         - The URL that specifies the location where to load the
//                   properties from.
//
//  Returns:
//   isLoaded      - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc PropertyList_loadFromUrl export;
  dcl-pi *n ind;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_url       like(url_t) const;
  end-pi;

//  Property list handle
  dcl-ds propList likeds(handle_t) based(i_pPropList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Load properties ...
select;
   // ... from stream file
when Url_getProtocol(i_url) = 'file';
   if not loadPropertiesFromStmf(propList.pMap: Url_getPath(i_url));
      return *off;
   endif;
   propList.url = i_url;
when Url_getProtocol(i_url) = 'mbr';
   if not loadPropertiesFromMbr(propList.pMap: Url_getPath(i_url));
      return *off;
   endif;
   propList.url = 'mbr:' + %trim(g_file) + '.' + %trim(g_mbr);
other;
   LogLog_warning('Unknown URL protocol: ' +
                   Url_getProtocol(i_url));
   return *off;
endsl;

return *on;


end-proc;

//=========================================================================
//  Returns the final URL that was used to load the properties.
//=========================================================================
//  Parameters:
//   i_pPropList   - Handle of the property list returned by
//                   PropertyList_new().
//
//  Returns:
//   url           - URL that was used to load the properties.
//                   If the properties have been loaded from a string
//                   an empty string is returned.
//=========================================================================
dcl-proc PropertyList_getUrl export;
  dcl-pi *n like(url_t);
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
  end-pi;

//  Property list handle
  dcl-ds propList likeds(handle_t) based(i_pPropList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return propList.url;


end-proc;

//=========================================================================
//  Returns the number of entries in the specified property list.
//=========================================================================
//  Parameters:
//   i_pPropList   - Handle of the property list returned by
//                   PropertyList_new().
//
//  Returns:
//   numE          - Returns the number of properties in this
//                   property list on success, else -1.
//=========================================================================
dcl-proc PropertyList_getNumE export;
  dcl-pi *n int(10);
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
  end-pi;

//  Property list handle
  dcl-ds propList likeds(handle_t) based(i_pPropList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return BasicMap_getNumE(propList.pMap);


end-proc;

//=========================================================================
//  Adds a property to the speciffied property list.
//=========================================================================
//  Parameters:
//   i_pPropList   - Handle of the property list returned by
//                   PropertyList_new().
//   i_property    - Property that is added to this property list.
//
//  Returns:
//   index         - Returns the index of the property on success,
//                   else -1.
//=========================================================================
dcl-proc PropertyList_put export;
  dcl-pi *n int(10);
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_property  likeds(LOG4RPG_Property_t) const;
  end-pi;

//  Helper fields
  dcl-ds property likeds(i_property);

//  Property list handle
  dcl-ds propList likeds(handle_t) based(i_pPropList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

property = i_property;

return BasicMap_put(propList.pMap: property.key
                                 : %addr(property.value)
                                 : %len(property.value) + 2);


end-proc;

//=========================================================================
//  Returns the value assigned to the specified key.
//=========================================================================
//  Parameters:
//   i_pPropList   - Handle of the property list returned by
//                   PropertyList_new().
//   i_key         - Key, whose associated value is returned.
//
//  Returns:
//   value         - Returns the associated value on success, else ''.
//=========================================================================
dcl-proc PropertyList_get export;
  dcl-pi *n like(LOG4RPG_Property_value_t);
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_key       like(LOG4RPG_Property_key_t) const;
  end-pi;

//  Return value
  dcl-s value like(LOG4RPG_Property_value_t) inz;

//  Property list handle
  dcl-ds propList likeds(handle_t) based(i_pPropList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

BasicMap_get(propList.pMap: i_key: %addr(value): %size(value));

return value;


end-proc;

//=========================================================================
//  Returns an iterator for the specified property list.
//=========================================================================
//  Parameters:
//   i_pPropList   - Handle of the property list returned by
//                   PropertyList_new().
//
//  Returns:
//   propIter      - Iterator for the property list.
//=========================================================================
dcl-proc PropertyList_getIterator export;

  dcl-ds PropertyList_getIteratorPI likeds(LOG4RPG_Property: ListIterator_t);
i_pPropList     const  like(LOG4RPG_pPropertyList_t );
  end-ds;

//  Return value
  dcl-ds propIter DS likeds(LOG4RPG_Property: ListIterator_t) inz;
  end-ds;

//  Property list handle
  dcl-ds propList likeds(handle_t) based(i_pPropList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

clear propIter;
propIter.pPropList = i_pPropList;
propIter.lastProp  = 0;

return propIter;


end-proc;

//=========================================================================
//  Returns the first property of the specified property list.
//=========================================================================
//  Parameters:
//   i_pPropList   - Handle of the property list returned by
//                   PropertyList_new().
//
//  Returns:
//   property      - Returns the first property in the specified
//                   property list on success, else ''.
//=========================================================================
dcl-proc PropertyList_getFirst export;
  dcl-pi *n likeds(LOG4RPG_Property_t);
    io_propIter likeds(LOG4RPG_PropertyListIterator_t);
  end-pi;

//  Return value
  dcl-ds property likeds(LOG4RPG_Property_t) inz;

//  Property list handle
  dcl-ds propList likeds(handle_t) based(io_propIter.pPropList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Returns the next property of the specified property list.
//=========================================================================
//  Parameters:
//   i_pPropList   - Handle of the property list returned by
//                   PropertyList_new().
//
//  Returns:
//   property      - Returns the next property in the specified
//                   property list on success, else ''.
//=========================================================================
dcl-proc PropertyList_getNext export;
  dcl-pi *n likeds(LOG4RPG_Property_t);
    io_propIter likeds(LOG4RPG_PropertyListIterator_t);
  end-pi;

//  Return value
  dcl-ds property likeds(LOG4RPG_Property_t) inz;

//  Property list handle
  dcl-ds propList likeds(handle_t) based(io_propIter.pPropList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Returns true if this property list contains a mapping for the
//  specified key.
//=========================================================================
//  Parameters:
//   i_pPropList   - Handle of the property list returned by
//                   PropertyList_new().
//   i_key         - Key of the property.
//
//  Returns:
//   isFound       - Returns TRUE is this property list contains a mapping
//                   for the specified key, else FALSE.
//=========================================================================
dcl-proc PropertyList_containsKey export;
  dcl-pi *n ind;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_key       like(LOG4RPG_Property_key_t) const;
  end-pi;

//  Property list handle
  dcl-ds propList likeds(handle_t) based(i_pPropList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return BasicMap_containsKey(propList.pMap: i_key);


end-proc;

//=========================================================================
//  Removes the specified property from the property list.
//=========================================================================
//  Parameters:
//   i_pPropList   - Handle of the property list returned by
//                   PropertyList_new().
//   i_key         - Key of the property.
//
//  Returns:
//   void
//=========================================================================
dcl-proc PropertyList_remove export;
  dcl-pi *n;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_key       like(LOG4RPG_Property_key_t) const;
  end-pi;

//  Property list handle
  dcl-ds propList likeds(handle_t) based(i_pPropList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

BasicMap_remove(propList.pMap: i_key);

return;


end-proc;

//=========================================================================
//  Removes all properties from the specified property list.
//=========================================================================
//  Parameters:
//   i_pPropList   - Handle of the property list returned by
//                   PropertyList_new().
//
//  Returns:
//   void
//=========================================================================
dcl-proc PropertyList_clear export;
  dcl-pi *n;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
  end-pi;

//  Helper fields
  dcl-s x int(10) inz;
  dcl-s numE int(10) inz;
  dcl-s key like(LOG4RPG_Property_key_t);

//  Property list handle
  dcl-ds propList likeds(handle_t) based(i_pPropList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

numE = BasicMap_getNumE(propList.pMap);

for x = 1 to numE;
   key = BasicMap_getKeyByIndex(propList.pMap: 1);
   BasicMap_remove(propList.pMap: key);
endfor;

return;


end-proc;

//=========================================================================
//  Deletes the specified property list.
//=========================================================================
//  Parameters:
//   io_pPropList  - Handle of the property list returned by
//                   PropertyList_new().
//
//  Returns:
//   isDeleted     - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc PropertyList_delete export;
  dcl-pi *n ind;
    io_pPropList like(LOG4RPG_pPropertyList_t);
  end-pi;

//  Return value
  dcl-s isDeleted ind inz(*off);

//  Property list handle
  dcl-ds propList likeds(handle_t) based(io_pPropList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

LogLog_verbose('Deleting properties list ...');

if (not BasicMap_isNull(propList.pMap));
   BasicMap_delete(propList.pMap);
endif;

propList.url = '';

clear propList;
dealloc(N) io_pPropList;

io_pPropList = PropertyList_null();

LogLog_verbose('- Freed memory of properties list.');

isDeleted = *on;

return isDeleted;


end-proc;

//=========================================================================
//  Tests the specified property list for a NULL value.
//=========================================================================
//  Parameters:
//   i_pPropList   - Handle of the property list returned by
//                   PropertyList_new().
//
//  Returns:
//   isNull        - Returns TRUE if the handle of the property list is a
//                   NULL handle.
//=========================================================================
dcl-proc PropertyList_isNull export;
  dcl-pi *n ind;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
  end-pi;

//  Property list handle
  dcl-ds propList likeds(handle_t) based(i_pPropList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if i_pPropList = PropertyList_null();
   return *on;
else;
   return BasicMap_isNull(propList.pMap);
endif;


end-proc;

//=========================================================================
//  Returns a NULL properties list.
//=========================================================================
//  Parameters:
//
//  Returns:
//   pPropList     - Property list NULL handle.
//=========================================================================
dcl-proc PropertyList_null export;
  dcl-pi *n like(LOG4RPG_pPropertyList_t);
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return BasicMap_null();


end-proc;

//=========================================================================
//  *** Private ***
//  Loads the properties from the specified stream file.
//=========================================================================
dcl-proc loadPropertiesFromStmf;
  dcl-pi *n ind;
    i_pMap like(BasicMap_handle_t) const;
    i_path like(LOG4RPG_path_t) const;
  end-pi;

//  Return value
  dcl-s isLoaded ind inz(*off);

//  Helper fields
  dcl-s hFile like(ifs_hFile_t) inz;
  dcl-s bytesRed int(10) inz;
  dcl-s buffer char(1024) inz;
  dcl-ds msg likeds(msg_t) inz;
  dcl-ds st_stat likeds(st_stat_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

LogLog_debug('Loading properties from file [' + i_path + '] ...');

// Test, if configuration file exists
if not f_isIfsFile(i_path: msg);
   LogLog_warningMsg(msg);
   return isLoaded;
endif;

if not f_isIfsFile(i_path: msg);
   LogLog_warningMsg(msg);
   return isLoaded;
endif;

stat(i_path: %addr(st_stat));

hFile = f_openIfsFile(i_path
                      : O_RDONLY + O_SHARE_RDONLY + O_CREAT +
                        O_TEXTDATA + O_TEXT_CREAT + O_CCSID
                      : st_stat.ccsid: *omit: msg);
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

isLoaded = *on;

return isLoaded;


end-proc;

//=========================================================================
//  *** Private ***
//  Loads the properties from the specified member.
//=========================================================================
dcl-proc loadPropertiesFromMbr;
  dcl-pi *n ind;
    i_pMap like(BasicMap_handle_t) const;
    i_path like(LOG4RPG_path_t) const;
  end-pi;

//  Return value
  dcl-s isLoaded ind inz(*off);

//  Helper fields
  dcl-s file char(10) inz;
  dcl-s lib char(10) inz;
  dcl-s member char(10) inz;
  dcl-s length int(10) inz;
  dcl-s warnLength ind inz(*off);

  dcl-ds inBufMbr qualified;
    data char(512);
  end-ds;

  dcl-ds inBufSrcMbr qualified;
    srcSeq zoned(6: 2);
    srcDat zoned(6);
    srcDta char(500);
  end-ds;

  dcl-s isPathUpdated ind;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

isPathUpdated = *off;

LogLog_debug('Loading properties from member [' + i_path + '] ...');

getMbrLocation(i_path: file: lib: member);
if (f_ucase(lib) = cLOG4RPG_LIB_SEARCH);
   lib = searchMemberAndReturnLibrary(file: member);
endif;

if (f_startsWith('*': lib));
   lib = rslvLibName(file: lib: '*FILE');
   isPathUpdated = *on;
endif;

if (f_startsWith('*': member));
   member = rslvMbrName(file: lib: member);
   isPathUpdated = *on;
endif;

if (isPathUpdated);
   LogLog_debug('Resolved member to ['
               +  %trim(lib) + '/' + %trim(file)
               + '(' + %trim(member) + ')'
               + '] ...');
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
            warnLength = *on;
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

isLoaded = *on;

return isLoaded;


end-proc;

//=========================================================================
//  *** Private ***
//  Loads the properties from embedded string data.
//=========================================================================
dcl-proc loadPropertiesFromString;
  dcl-pi *n ind;
    i_pMap    like(BasicMap_handle_t) const;
    i_pString pointer options(*string) const;
  end-pi;

//  Return value
  dcl-s isLoaded ind inz(*off);

//  Helper fields
  dcl-s pToken pointer inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

LogLog_debug('Loading properties from string ...');

pToken = strtok(i_pString: ';');
dow pToken <> *NULL;
   addPropertyToList(i_pMap: %str(pToken));
   pToken = strtok(*NULL: ';');
enddo;

LogLog_verbose('Loaded properties from string.');

isLoaded = *on;

return isLoaded;


end-proc;

//=========================================================================
//  *** Private ***
//  Test the specified buffer, splitts the buffer and adds the property
//  to the proeprty list.
//=========================================================================
dcl-proc addPropertyToList;
  dcl-pi *n;
    i_pMap   like(BasicMap_handle_t) const;
    i_buffer varchar(256) const;
  end-pi;

//  Helper fields
  dcl-s x int(10) inz;
  dcl-s char char(1) inz;
  dcl-s buffer like(i_buffer) inz;
  dcl-ds property likeds(LOG4RPG_Property_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  *** Private ***
//  Splitts a path into pieces of file, library and member.
//=========================================================================
dcl-proc getMbrLocation;
  dcl-pi *n;
    i_path like(LOG4RPG_path_t) const;
    o_file char(10);
    o_lib  char(10);
    o_mbr  char(10);
  end-pi;

//  Helper fields
  dcl-s x int(10) inz;
  dcl-s path like(i_path) inz;
  dcl-s closingChar char(1) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  *** Private ***
//  Spin through all files in the library and search for the specified
//  specified memebr. Return the library name of the library that
//  contains the file that contains the member.
//=========================================================================
dcl-proc searchMemberAndReturnLibrary;
  dcl-pi *n char(10);
    i_file char(10) const;
    i_mbr  char(10) const;
  end-pi;

//  Helper fields
  dcl-s i int(10) inz;
  dcl-ds qObj likeds(qObj_t) inz;

  dcl-ds authCtrl likeds(qgy_authCtrl_t) inz;
  dcl-ds selectCtrl likeds(qgy_selectCtrl_t) inz;
  dcl-ds listInf likeds(qgy_opnListInf_t) inz;
  dcl-ds sortInf likeds(qgy_sortInf_t) inz;
  dcl-ds objInf likeds(qgy_objInf_t) inz;

  dcl-ds errCode likeds(errCode_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
errCode = f_newApiErrCode(*on);

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


end-proc;

