**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: AppenderList                             *
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
//
// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG04

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PTYPES Private type definitions

dcl-ds handle_t qualified based(pDummy);
  pMap like(BasicMap_handle_t);
end-ds;

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QBASICS1,PBASICS1 Basic RPG Extensions
/copy QIFS,PIFS IFS Stream file support

/copy QLOG4RPG,PLOG4RPG10 LogLog
/copy QLOG4RPG,PLOG4RPG99 Helpers

// -----------------------------------------
//  Private prototypes
// -----------------------------------------
//
// -----------------------------------------
//  Global constants
// -----------------------------------------
//
// -----------------------------------------
//  Global fields
// -----------------------------------------
//
//=========================================================================
//  Creates a new appender list.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pAppList      - Returns a handle to the appender list on success, else
//                   a NULL handle.
//=========================================================================
dcl-proc AppenderList_new export;
  dcl-pi *n like(LOG4RPG_pAppenderList_t);
  end-pi;

  //  Return value
  dcl-ds appList likeds(handle_t) based(pAppList);

  //  Helper fields
  dcl-ds tempAppList likeds(handle_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LogLog_verbose('Creating appender list ...');

  pAppList = AppenderList_null();

  // Initialize appender list handle
  clear tempAppList;
  tempAppList.pMap = BasicMap_new();

  // Return properties list to caller
  pAppList = %alloc(%size(handle_t));
  appList = tempAppList;

  LogLog_verbose('+ Allocated memory for appender list.');

  return pAppList;


end-proc;

//=========================================================================
//  Returns the number of entries in the specified appender list.
//=========================================================================
//  Parameters:
//   i_pAppList    - Appender list returned by AppenderList_new().
//
//  Returns:
//   numE          - Returns the number of appenders in this
//                   appender list on success, else -1.
//=========================================================================
dcl-proc AppenderList_getNumE export;
  dcl-pi *n int(10);
    i_pAppList like(LOG4RPG_pAppenderList_t) const;
  end-pi;

  //  Appender list handle
  dcl-ds appList likeds(handle_t) based(i_pAppList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return BasicMap_getNumE(appList.pMap);


end-proc;

//=========================================================================
//  Adds an appender to the specified appender list.
//=========================================================================
//  Parameters:
//   i_pAppList    - Appender list returned by AppenderList_new().
//   i_pAppender   - Appender that is added to this appender list.
//
//  Returns:
//   index         - Returns 0 on success, else -1.
//=========================================================================
dcl-proc AppenderList_put export;
  dcl-pi *n int(10);
    i_pAppList  like(LOG4RPG_pAppenderList_t) const;
    i_pAppender like(LOG4RPG_pAppender_t) const;
  end-pi;

  //  Helper fields
  dcl-s pAppender like(i_pAppender);

  //  Appender list handle
  dcl-ds appList likeds(handle_t) based(i_pAppList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pAppender = i_pAppender;

  return BasicMap_put(appList.pMap: Appender_getName(pAppender)
                                  : %addr(pAppender)
                                  : %len(pAppender ));


end-proc;

//=========================================================================
//  Removes the specified appender from the given appender list.
//=========================================================================
//  Parameters:
//   i_pAppList    - Appender list returned by AppenderList_new().
//   i_appName     - Name of the appender that is removed from
//                   this appender list.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc AppenderList_remove export;
  dcl-pi *n int(10);
    i_pAppList like(LOG4RPG_pAppenderList_t) const;
    i_appName  like(LOG4RPG_appenderName_t) const;
  end-pi;

  //  Appender list handle
  dcl-ds appList likeds(handle_t) based(i_pAppList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return BasicMap_remove(appList.pMap: i_appName);


end-proc;

//=========================================================================
//  Returns the appender assigned to the specified key.
//=========================================================================
//  Parameters:
//   i_pAppList    - Appender list returned by AppenderList_new().
//   i_appName     - Name of the appender that is returned.
//
//  Returns:
//   pAppender     - Returns the associated appender on ssuccess, else NULL.
//=========================================================================
dcl-proc AppenderList_get export;
  dcl-pi *n like(LOG4RPG_pAppender_t);
    i_pAppList like(LOG4RPG_pAppenderList_t) const;
    i_appName  like(LOG4RPG_appenderName_t) const;
  end-pi;

  //  Return value
  dcl-s pAppender like(LOG4RPG_pAppender_t) inz;

  //  Appender list handle
  dcl-ds appList likeds(handle_t) based(i_pAppList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  BasicMap_get(appList.pMap: i_appName: %addr(pAppender)
                                      : %size(pAppender));

  return pAppender;


end-proc;

//=========================================================================
//  Tests, if the appender list contains the specified appender.
//=========================================================================
//  Parameters:
//   i_pAppList    - Appender list returned by AppenderList_new().
//   i_appName     - Name of the appender.
//
//  Returns:
//   exist         - Returns TRUE if the appender exists, else FALSE.
//=========================================================================
dcl-proc AppenderList_exist export;
  dcl-pi *n ind;
    i_pAppList like(LOG4RPG_pAppenderList_t) const;
    i_appName  like(LOG4RPG_appenderName_t) const;
  end-pi;

  //  Appender list handle
  dcl-ds appList likeds(handle_t) based(i_pAppList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return BasicMap_containsKey(appList.pMap: i_appName);


end-proc;

//=========================================================================
//  Returns an iterator for the specified appender list.
//=========================================================================
//  Parameters:
//   i_pAppList    - Appender list returned by AppenderList_new().
//
//  Returns:
//   appIter       - Iterator for the appender list.
//=========================================================================
dcl-proc AppenderList_getIterator export;
  dcl-pi *n likeds(LOG4RPG_AppenderListIterator_t);
    i_pAppList like(LOG4RPG_pAppenderList_t) const;
  end-pi;

  //  Return value
  dcl-ds appIter likeds(LOG4RPG_AppenderListIterator_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear appIter;
  appIter.pAppList = i_pAppList;
  appIter.lastApp  = 0;

  return appIter;


end-proc;

//=========================================================================
//  Returns the first appender of the specified appender list.
//=========================================================================
//  Parameters:
//   io_appIter    - Iteratur returned by AppenderList_getIterator().
//
//  Returns:
//   pAppender     - Returns the first appender in the specified
//                   appender list on success, else a NULL handle.
//=========================================================================
dcl-proc AppenderList_getFirst export;
  dcl-pi *n like(LOG4RPG_pAppender_t);
    io_appIter likeds(LOG4RPG_AppenderListIterator_t);
  end-pi;

  //  Return value
  dcl-s pAppender like(LOG4RPG_pAppender_t) inz;

  //  Helper fields
  dcl-s appName like(LOG4RPG_appenderName_t) inz;

  //  Appender list handle
  dcl-ds appList likeds(handle_t) based(io_appIter.pAppList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pAppender = Appender_null();

  if AppenderList_getNumE(io_appIter.pAppList) = 0;
    return pAppender;
  endif;

  io_appIter.lastApp = 1;

  appName = BasicMap_getKeyByIndex(appList.pMap
                                   : io_appIter.lastApp);
  pAppender = AppenderList_get(io_appIter.pAppList: appName);

  return pAppender;


end-proc;

//=========================================================================
//  Returns the next appender of the specified appender list.
//=========================================================================
//  Parameters:
//   io_appIter    - Iteratur returned by AppenderList_getIterator().
//
//  Returns:
//   pAppender     - Returns the next appender in the specified
//                   appender list on success, else a NULL handle.
//=========================================================================
dcl-proc AppenderList_getNext export;
  dcl-pi *n like(LOG4RPG_pAppender_t);
    io_appIter likeds(LOG4RPG_AppenderListIterator_t);
  end-pi;

  //  Return value
  dcl-s pAppender like(LOG4RPG_pAppender_t) inz;

  //  Helper fields
  dcl-s appName like(LOG4RPG_appenderName_t) inz;

  //  Appender list handle
  dcl-ds appList likeds(handle_t) based(io_appIter.pAppList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pAppender = Appender_null();

  if AppenderList_getNumE(io_appIter.pAppList) <= io_appIter.lastApp;
    return pAppender;
  endif;

  io_appIter.lastApp = io_appIter.lastApp + 1;

  appName = BasicMap_getKeyByIndex(appList.pMap
                                   : io_appIter.lastApp);
  pAppender = AppenderList_get(io_appIter.pAppList: appName);

  return pAppender;


end-proc;

//=========================================================================
//  Deletes the specified appender list.
//=========================================================================
//  Parameters:
//   io_pAppList   - Appender list returned by AppenderList_new().
//
//  Returns:
//   isDeleted     - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc AppenderList_delete export;
  dcl-pi *n ind;
    io_pAppList like(LOG4RPG_pAppenderList_t);
  end-pi;

  //  Return value
  dcl-s isDeleted ind inz(*off);

  //  Helper fields
  dcl-s name like(LOG4RPG_appenderName_t) inz;
  dcl-ds appIter likeds(LOG4RPG_AppenderListIterator_t) inz;
  dcl-s pAppender like(LOG4RPG_pAppender_t) inz;

  //  Appender list handle
  dcl-ds appList likeds(handle_t) based(io_pAppList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if BasicMap_isNull(appList.pMap);
    return *on;
  endif;

  LogLog_verbose('Deleting appender list ...');

  p_assert(AppenderList_getNumE(io_pAppList) = 0
           : 'All appender should have been removed from this +
              appender list by the logger or the repository.');

  appIter = AppenderList_getIterator(io_pAppList);

  dow AppenderList_getNumE(io_pAppList) > 0;
    pAppender = AppenderList_getFirst(appIter);
    name = Appender_getName(pAppender);
    AppenderList_remove(io_pAppList: name);
    Appender_delete(pAppender);
  enddo;

  if BasicMap_delete(appList.pMap) = 0;
    isDeleted = *on;
  else;
    isDeleted = *off;
  endif;

  clear appList;
  dealloc(N) io_pAppList;

  io_pAppList = AppenderList_null();

  LogLog_verbose('- Freed memory of appender list.');

  return isDeleted;


end-proc;

//=========================================================================
//  Test the specified appender list for a NULL value.
//=========================================================================
//  Parameters:
//   i_appList     - Appender list returned by AppenderList_new().
//
//  Returns:
//   isNull        - Returns TRUE if the handle of the appender list is a
//                   NULL handle.
//=========================================================================
dcl-proc AppenderList_isNull export;
  dcl-pi *n ind;
    i_pAppList like(LOG4RPG_pAppenderList_t) const;
  end-pi;

  //  Appender list handle
  dcl-ds appList likeds(handle_t) based(i_pAppList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if i_pAppList = AppenderList_null();
    return *on;
  else;
    return BasicMap_isNull(appList.pMap);
  endif;


end-proc;

//=========================================================================
//  Returns a NULL appender list.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pAppList      - Appender list NULL handle.
//=========================================================================
dcl-proc AppenderList_null export;
  dcl-pi *n like(LOG4RPG_pAppenderList_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return BasicMap_null();


end-proc;
