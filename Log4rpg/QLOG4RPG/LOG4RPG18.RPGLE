      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: FilterList                               *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  25.10.2006                                              *
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
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG18
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PTYPES                        Private type definitions
      *
     D handle_t...
     D                 DS                  qualified               based(pDummy)
     D  pMap                               like(BasicMap_handle_t )
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
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
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=========================================================================
      *  Creates a new filter list.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pFltList      - Returns a handle to the filter list on success, else
      *                   a NULL handle.
      *=========================================================================
     P FilterList_new...
     P                 B                   export
      *
     D FilterList_new...
     D                 PI                         like(LOG4RPG_pFilterList_t )
      *
      *  Return value
     D fltList         DS                  likeds(handle_t       )
     D                                     based(pFltList)
      *
      *  Helper fields
     D tempFltList     DS                  likeds(handle_t       ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P FilterList_new...
     P                 E
      *
      *=========================================================================
      *  Returns the number of entries in the specified filter list.
      *=========================================================================
      *  Parameters:
      *   i_pFltList    - Filter list returned by FilterList_new().
      *
      *  Returns:
      *   numE          - Returns the number of filters in this
      *                   filter list on success, else -1.
      *=========================================================================
     P FilterList_getNumE...
     P                 B                   export
      *
     D FilterList_getNumE...
     D                 PI            10I 0
     D  i_pFltList                         const  like(LOG4RPG_pFilterList_t )
      *
      *  Filter list handle
     D fltList         DS                  likeds(handle_t    )
     D                                     based(i_pFltList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return BasicMap_getNumE(fltList.pMap);
 
      /END-FREE
      *
     P FilterList_getNumE...
     P                 E
      *
      *=========================================================================
      *  Adds a filter to the specified filter list.
      *=========================================================================
      *  Parameters:
      *   i_pFltList    - Filter list returned by FilterList_new().
      *   i_pFilter     - Filter that is added to this filter list.
      *
      *  Returns:
      *   index         - Returns 0 on success, else -1.
      *=========================================================================
     P FilterList_put...
     P                 B                   export
      *
     D FilterList_put...
     D                 PI            10I 0
     D  i_pFltList                         const  like(LOG4RPG_pFilterList_t )
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t     )
      *
      *  Helper fields
     D pFilter         S                   like(i_pFilter              )
      *
      *  Filter list handle
     D fltList         DS                  likeds(handle_t    )
     D                                     based(i_pFltList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pFilter = i_pFilter;
 
         return BasicMap_put(fltList.pMap: Filter_getName(pFilter)
                                         : %addr(pFilter)
                                         : %len(pFilter ));
 
      /END-FREE
      *
     P FilterList_put...
     P                 E
      *
      *=========================================================================
      *  Removes the specified filter from the given filter list.
      *=========================================================================
      *  Parameters:
      *   i_pFltList    - Filter list returned by FilterList_new().
      *   i_fltName     - Name of the filter that is removed from
      *                   this filter list.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P FilterList_remove...
     P                 B                   export
      *
     D FilterList_remove...
     D                 PI            10I 0
     D  i_pFltList                         const  like(LOG4RPG_pFilterList_t )
     D  i_fltName                          const  like(LOG4RPG_filterName_t  )
      *
      *  Filter list handle
     D fltList         DS                  likeds(handle_t    )
     D                                     based(i_pFltList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return BasicMap_remove(fltList.pMap: i_fltName);
 
      /END-FREE
      *
     P FilterList_remove...
     P                 E
      *
      *=========================================================================
      *  Returns the filter assigned to the specified key.
      *=========================================================================
      *  Parameters:
      *   i_pFltList    - Filter list returned by FilterrList_new().
      *   i_fltName     - Name of the filter that is returned.
      *
      *  Returns:
      *   pFilter       - Returns the associated filter on ssuccess, else NULL.
      *=========================================================================
     P FilterList_get...
     P                 B                   export
      *
     D FilterList_get...
     D                 PI                         like(LOG4RPG_pFilter_t     )
     D  i_pFltList                         const  like(LOG4RPG_pFilterList_t )
     D  i_fltName                          const  like(LOG4RPG_filterName_t  )
      *
      *  Return value
     D pFilter         S                   like(LOG4RPG_pFilter_t     ) inz
      *
      *  Filter list handle
     D fltList         DS                  likeds(handle_t    )
     D                                     based(i_pFltList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         BasicMap_get(fltList.pMap: i_fltName: %addr(pFilter)
                                             : %size(pFilter));
 
         return pFilter;
 
      /END-FREE
      *
     P FilterList_get...
     P                 E
      *
      *=========================================================================
      *  Tests, if the filter list contains the specified filter.
      *=========================================================================
      *  Parameters:
      *   i_pFltList    - Filter list returned by FilterList_new().
      *   i_fltName     - Name of the filter.
      *
      *  Returns:
      *   exist         - Returns TRUE if the filter exists, else FALSE.
      *=========================================================================
     P FilterList_exist...
     P                 B                   export
      *
     D FilterList_exist...
     D                 PI              N
     D  i_pFltList                         const  like(LOG4RPG_pFilterList_t )
     D  i_fltName                          const  like(LOG4RPG_filterName_t  )
      *
      *  Filter list handle
     D fltList         DS                  likeds(handle_t    )
     D                                     based(i_pFltList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return BasicMap_containsKey(fltList.pMap: i_fltName);
 
      /END-FREE
      *
     P FilterList_exist...
     P                 E
      *
      *=========================================================================
      *  Returns an iterator for the specified filter list.
      *=========================================================================
      *  Parameters:
      *   i_pFltList    - Filter list returned by FilterList_new().
      *
      *  Returns:
      *   fltIter       - Iterator for the filter list.
      *=========================================================================
     P FilterList_getIterator...
     P                 B                   export
      *
     D FilterList_getIterator...
     D                 PI                        likeds(LOG4RPG_Filter...
     D                                                          ListIterator_t )
     D  i_pFltList                         const  like(LOG4RPG_pFilterList_t )
      *
      *  Return value
     D fltIter         DS                  likeds(LOG4RPG_Filter...
     D                                                    ListIterator_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clear fltIter;
         fltIter.pFltList = i_pFltList;
         fltIter.lastFlt  = 0;
 
         return fltIter;
 
      /END-FREE
      *
     P FilterList_getIterator...
     P                 E
      *
      *=========================================================================
      *  Returns the first filter of the specified filter list.
      *=========================================================================
      *  Parameters:
      *   io_fltIter    - Iteratur returned by FilterList_getIterator().
      *
      *  Returns:
      *   pFilter       - Returns the first filter in the specified
      *                   filter list on success, else a NULL handle.
      *=========================================================================
     P FilterList_getFirst...
     P                 B                   export
      *
     D FilterList_getFirst...
     D                 PI                         like(LOG4RPG_pFilter_t     )
     D  io_fltIter                                likeds(LOG4RPG_Filter...
     D                                                           ListIterator_t)
      *
      *  Return value
     D pFilter         S                   like(LOG4RPG_pFilter_t     ) inz
      *
      *  Helper fields
     D fltName         S                   like(LOG4RPG_filterName_t ) inz
      *
      *  Filter list handle
     D fltList         DS                  likeds(handle_t    )
     D                                     based(io_fltIter.pFltList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pFilter = Filter_null();
 
         if FilterList_getNumE(io_fltIter.pFltList) = 0;
            return pFilter;
         endif;
 
         io_fltIter.lastFlt = 1;
 
         fltName = BasicMap_getKeyByIndex(fltList.pMap
                                          : io_fltIter.lastFlt);
         pFilter = FilterList_get(io_fltIter.pFltList: fltName);
 
         return pFilter;
 
      /END-FREE
      *
     P FilterList_getFirst...
     P                 E
      *
      *=========================================================================
      *  Returns the next filter of the specified filter list.
      *=========================================================================
      *  Parameters:
      *   io_fltIter    - Iteratur returned by FilterList_getIterator().
      *
      *  Returns:
      *   pFilter       - Returns the next filter in the specified
      *                   filter list on success, else a NULL handle.
      *=========================================================================
     P FilterList_getNext...
     P                 B                   export
      *
     D FilterList_getNext...
     D                 PI                         like(LOG4RPG_pFilter_t     )
     D  io_fltIter                                likeds(LOG4RPG_Filter...
     D                                                           ListIterator_t)
      *
      *  Return value
     D pFilter         S                   like(LOG4RPG_pFilter_t     ) inz
      *
      *  Helper fields
     D fltName         S                   like(LOG4RPG_filterName_t ) inz
      *
      *  Filter list handle
     D fltList         DS                  likeds(handle_t    )
     D                                     based(io_fltIter.pFltList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pFilter = Filter_null();
 
         if FilterList_getNumE(io_fltIter.pFltList) <= io_fltIter.lastFlt;
            return pFilter;
         endif;
 
         io_fltIter.lastFlt = io_fltIter.lastFlt + 1;
 
         fltName = BasicMap_getKeyByIndex(fltList.pMap
                                          : io_fltIter.lastFlt);
         pFilter = FilterList_get(io_fltIter.pFltList: fltName);
 
         return pFilter;
 
      /END-FREE
      *
     P FilterList_getNext...
     P                 E
      *
      *=========================================================================
      *  Deletes the specified filter list.
      *=========================================================================
      *  Parameters:
      *   io_pFltList   - Filter list returned by FilterList_new().
      *
      *  Returns:
      *   isDeleted     - Returns TRUE on success, else FALSE.
      *=========================================================================
     P FilterList_delete...
     P                 B                   export
      *
     D FilterList_delete...
     D                 PI              N
     D  io_pFltList                               like(LOG4RPG_pFilterList_t )
      *
      *  Return value
     D isDeleted       S               N   inz(cFalse)
      *
      *  Helper fields
     D name            S                   like(LOG4RPG_filterName_t  ) inz
     D fltIter         DS                  likeds(LOG4RPG_Filter...
     D                                            ListIterator_t      ) inz
     D pFilter         S                   like(LOG4RPG_pFilter_t     ) inz
      *
      *  Filter list handle
     D fltList         DS                  likeds(handle_t    )
     D                                     based(io_pFltList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if BasicMap_isNull(fltList.pMap);
            return cTrue;
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
            isDeleted = cTrue;
         else;
            isDeleted = cFalse;
         endif;
 
         clear fltList;
         dealloc(N) io_pFltList;
 
         io_pFltList = FilterList_null();
 
         LogLog_verbose('- Freed memory of filter list.');
 
         return isDeleted;
 
      /END-FREE
      *
     P FilterList_delete...
     P                 E
      *
      *=========================================================================
      *  Test the specified filter list for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_fltList     - Filter list returned by FilterList_new().
      *
      *  Returns:
      *   isNull        - Returns TRUE if the handle of the filter list is a
      *                   NULL handle.
      *=========================================================================
     P FilterList_isNull...
     P                 B                   export
      *
     D FilterList_isNull...
     D                 PI              N
     D  i_pFltList                         const  like(LOG4RPG_pFilterList_t )
      *
      *  Filter list handle
     D fltList         DS                  likeds(handle_t    )
     D                                     based(i_pFltList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if i_pFltList = FilterList_null();
            return cTrue;
         else;
            return BasicMap_isNull(fltList.pMap);
         endif;
 
      /END-FREE
      *
     P FilterList_isNull...
     P                 E
      *
      *=========================================================================
      *  Returns a NULL filter list.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pFltList      - Filter list NULL handle.
      *=========================================================================
     P FilterList_null...
     P                 B                   export
      *
     D FilterList_null...
     D                 PI                         like(LOG4RPG_pFilterList_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return BasicMap_null();
 
      /END-FREE
      *
     P FilterList_null...
     P                 E
      *
