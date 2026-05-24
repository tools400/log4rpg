**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: FilterList                               *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  25.10.2006                                              *
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
/copy QLOG4RPG,PLOG4RPG18

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
//  Creates a new filter list.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pFltList      - Returns a handle to the filter list on success, else
//                   a NULL handle.
//=========================================================================
dcl-proc FilterList_new export;
  dcl-pi *n like(LOG4RPG_pFilterList_t);
  end-pi;

  //  Return value
  dcl-ds fltList likeds(handle_t) based(pFltList);

  //  Helper fields
  dcl-ds tempFltList likeds(handle_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LogLog_verbose('Creating filter list ...');

  pFltList = FilterList_null();

  // Initialize filter list handle
  clear tempFltList;
  tempFltList.pMap = BasicMap_new();

  // Return properties list to caller
  pFltList = %alloc(%size(handle_t));
  fltList = tempFltList;

  LogLog_verbose('+ Allocated memory for filter list.');

  return pFltList;


end-proc;

//=========================================================================
//  Returns the number of entries in the specified filter list.
//=========================================================================
//  Parameters:
//   i_pFltList    - Filter list returned by FilterList_new().
//
//  Returns:
//   numE          - Returns the number of filters in this
//                   filter list on success, else -1.
//=========================================================================
dcl-proc FilterList_getNumE export;
  dcl-pi *n int(10);
    i_pFltList like(LOG4RPG_pFilterList_t) const;
  end-pi;

  //  Filter list handle
  dcl-ds fltList likeds(handle_t) based(i_pFltList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return BasicMap_getNumE(fltList.pMap);


end-proc;

//=========================================================================
//  Adds a filter to the specified filter list.
//=========================================================================
//  Parameters:
//   i_pFltList    - Filter list returned by FilterList_new().
//   i_pFilter     - Filter that is added to this filter list.
//
//  Returns:
//   index         - Returns 0 on success, else -1.
//=========================================================================
dcl-proc FilterList_put export;
  dcl-pi *n int(10);
    i_pFltList like(LOG4RPG_pFilterList_t) const;
    i_pFilter  like(LOG4RPG_pFilter_t) const;
  end-pi;

  //  Helper fields
  dcl-s pFilter like(i_pFilter);

  //  Filter list handle
  dcl-ds fltList likeds(handle_t) based(i_pFltList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pFilter = i_pFilter;

  return BasicMap_put(fltList.pMap: Filter_getName(pFilter)
                                  : %addr(pFilter)
                                  : %len(pFilter ));


end-proc;

//=========================================================================
//  Removes the specified filter from the given filter list.
//=========================================================================
//  Parameters:
//   i_pFltList    - Filter list returned by FilterList_new().
//   i_fltName     - Name of the filter that is removed from
//                   this filter list.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc FilterList_remove export;
  dcl-pi *n int(10);
    i_pFltList like(LOG4RPG_pFilterList_t) const;
    i_fltName  like(LOG4RPG_filterName_t) const;
  end-pi;

  //  Filter list handle
  dcl-ds fltList likeds(handle_t) based(i_pFltList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return BasicMap_remove(fltList.pMap: i_fltName);


end-proc;

//=========================================================================
//  Returns the filter assigned to the specified key.
//=========================================================================
//  Parameters:
//   i_pFltList    - Filter list returned by FilterrList_new().
//   i_fltName     - Name of the filter that is returned.
//
//  Returns:
//   pFilter       - Returns the associated filter on ssuccess, else NULL.
//=========================================================================
dcl-proc FilterList_get export;
  dcl-pi *n like(LOG4RPG_pFilter_t);
    i_pFltList like(LOG4RPG_pFilterList_t) const;
    i_fltName  like(LOG4RPG_filterName_t) const;
  end-pi;

  //  Return value
  dcl-s pFilter like(LOG4RPG_pFilter_t) inz;

  //  Filter list handle
  dcl-ds fltList likeds(handle_t) based(i_pFltList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  BasicMap_get(fltList.pMap: i_fltName: %addr(pFilter)
                                      : %size(pFilter));

  return pFilter;


end-proc;

//=========================================================================
//  Tests, if the filter list contains the specified filter.
//=========================================================================
//  Parameters:
//   i_pFltList    - Filter list returned by FilterList_new().
//   i_fltName     - Name of the filter.
//
//  Returns:
//   exist         - Returns TRUE if the filter exists, else FALSE.
//=========================================================================
dcl-proc FilterList_exist export;
  dcl-pi *n ind;
    i_pFltList like(LOG4RPG_pFilterList_t) const;
    i_fltName  like(LOG4RPG_filterName_t) const;
  end-pi;

  //  Filter list handle
  dcl-ds fltList likeds(handle_t) based(i_pFltList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return BasicMap_containsKey(fltList.pMap: i_fltName);


end-proc;

//=========================================================================
//  Returns an iterator for the specified filter list.
//=========================================================================
//  Parameters:
//   i_pFltList    - Filter list returned by FilterList_new().
//
//  Returns:
//   fltIter       - Iterator for the filter list.
//=========================================================================
dcl-proc FilterList_getIterator export;
  dcl-pi *n likeds(LOG4RPG_FilterListIterator_t);
    i_pFltList like(LOG4RPG_pFilterList_t) const;
  end-pi;

  //  Return value
  dcl-ds fltIter likeds(LOG4RPG_FilterListIterator_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear fltIter;
  fltIter.pFltList = i_pFltList;
  fltIter.lastFlt  = 0;

  return fltIter;

end-proc;

//=========================================================================
//  Returns the first filter of the specified filter list.
//=========================================================================
//  Parameters:
//   io_fltIter    - Iteratur returned by FilterList_getIterator().
//
//  Returns:
//   pFilter       - Returns the first filter in the specified
//                   filter list on success, else a NULL handle.
//=========================================================================
dcl-proc FilterList_getFirst export;
  dcl-pi *n like(LOG4RPG_pFilter_t);
    io_fltIter likeds(LOG4RPG_FilterListIterator_t);
  end-pi;

  //  Return value
  dcl-s pFilter like(LOG4RPG_pFilter_t) inz;

  //  Helper fields
  dcl-s fltName like(LOG4RPG_filterName_t) inz;

  //  Filter list handle
  dcl-ds fltList likeds(handle_t) based(io_fltIter.pFltList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pFilter = Filter_null();

  if FilterList_getNumE(io_fltIter.pFltList) = 0;
    return pFilter;
  endif;

  io_fltIter.lastFlt = 1;

  fltName = BasicMap_getKeyByIndex(fltList.pMap
                                   : io_fltIter.lastFlt);
  pFilter = FilterList_get(io_fltIter.pFltList: fltName);

  return pFilter;


end-proc;

//=========================================================================
//  Returns the next filter of the specified filter list.
//=========================================================================
//  Parameters:
//   io_fltIter    - Iteratur returned by FilterList_getIterator().
//
//  Returns:
//   pFilter       - Returns the next filter in the specified
//                   filter list on success, else a NULL handle.
//=========================================================================
dcl-proc FilterList_getNext export;
  dcl-pi *n like(LOG4RPG_pFilter_t);
    io_fltIter likeds(LOG4RPG_FilterListIterator_t);
  end-pi;

  //  Return value
  dcl-s pFilter like(LOG4RPG_pFilter_t) inz;

  //  Helper fields
  dcl-s fltName like(LOG4RPG_filterName_t) inz;

  //  Filter list handle
  dcl-ds fltList likeds(handle_t) based(io_fltIter.pFltList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pFilter = Filter_null();

  if FilterList_getNumE(io_fltIter.pFltList) <= io_fltIter.lastFlt;
    return pFilter;
  endif;

  io_fltIter.lastFlt = io_fltIter.lastFlt + 1;

  fltName = BasicMap_getKeyByIndex(fltList.pMap
                                   : io_fltIter.lastFlt);
  pFilter = FilterList_get(io_fltIter.pFltList: fltName);

  return pFilter;


end-proc;

//=========================================================================
//  Deletes the specified filter list.
//=========================================================================
//  Parameters:
//   io_pFltList   - Filter list returned by FilterList_new().
//
//  Returns:
//   isDeleted     - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc FilterList_delete export;
  dcl-pi *n ind;
    io_pFltList like(LOG4RPG_pFilterList_t);
  end-pi;

  //  Return value
  dcl-s isDeleted ind inz(*off);

  //  Helper fields
  dcl-s name like(LOG4RPG_filterName_t) inz;
  dcl-ds fltIter likeds(LOG4RPG_FilterListIterator_t) inz;
  dcl-s pFilter like(LOG4RPG_pFilter_t) inz;

  //  Filter list handle
  dcl-ds fltList likeds(handle_t) based(io_pFltList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if BasicMap_isNull(fltList.pMap);
    return *on;
  endif;

  LogLog_verbose('Deleting filter list ...');

  p_assert(FilterList_getNumE(io_pFltList) = 0
           : 'All filters should have been removed from this +
              filter list by the logger or the repository.');

  fltIter = FilterList_getIterator(io_pFltList);

  dow FilterList_getNumE(io_pFltList) > 0;
    pFilter = FilterList_getFirst(fltIter);
    name = Filter_getName(pFilter);
    FilterList_remove(io_pFltList: name);
    Filter_delete(pFilter);
  enddo;

  if BasicMap_delete(fltList.pMap) = 0;
    isDeleted = *on;
  else;
    isDeleted = *off;
  endif;

  clear fltList;
  dealloc(N) io_pFltList;

  io_pFltList = FilterList_null();

  LogLog_verbose('- Freed memory of filter list.');

  return isDeleted;


end-proc;

//=========================================================================
//  Test the specified filter list for a NULL value.
//=========================================================================
//  Parameters:
//   i_fltList     - Filter list returned by FilterList_new().
//
//  Returns:
//   isNull        - Returns TRUE if the handle of the filter list is a
//                   NULL handle.
//=========================================================================
dcl-proc FilterList_isNull export;
  dcl-pi *n ind;
    i_pFltList like(LOG4RPG_pFilterList_t) const;
  end-pi;

  //  Filter list handle
  dcl-ds fltList likeds(handle_t) based(i_pFltList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if i_pFltList = FilterList_null();
    return *on;
  else;
    return BasicMap_isNull(fltList.pMap);
  endif;


end-proc;

//=========================================================================
//  Returns a NULL filter list.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pFltList      - Filter list NULL handle.
//=========================================================================
dcl-proc FilterList_null export;
  dcl-pi *n like(LOG4RPG_pFilterList_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return BasicMap_null();


end-proc;
