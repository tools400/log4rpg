      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: AppenderList                             *
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
      /COPY QLOG4RPG,PLOG4RPG04
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
      *  Creates a new appender list.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pAppList      - Returns a handle to the appender list on success, else
      *                   a NULL handle.
      *=========================================================================
     P AppenderList_new...
     P                 B                   export
      *
     D AppenderList_new...
     D                 PI                         like(LOG4RPG_pAppenderList_t )
      *
      *  Return value
     D appList         DS                  likeds(handle_t       )
     D                                     based(pAppList)
      *
      *  Helper fields
     D tempAppList     DS                  likeds(handle_t       ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P AppenderList_new...
     P                 E
      *
      *=========================================================================
      *  Returns the number of entries in the specified appender list.
      *=========================================================================
      *  Parameters:
      *   i_pAppList    - Appender list returned by AppenderList_new().
      *
      *  Returns:
      *   numE          - Returns the number of appenders in this
      *                   appender list on success, else -1.
      *=========================================================================
     P AppenderList_getNumE...
     P                 B                   export
      *
     D AppenderList_getNumE...
     D                 PI            10I 0
     D  i_pAppList                         const  like(LOG4RPG_pAppenderList_t )
      *
      *  Appender list handle
     D appList         DS                  likeds(handle_t    )
     D                                     based(i_pAppList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return BasicMap_getNumE(appList.pMap);
 
      /END-FREE
      *
     P AppenderList_getNumE...
     P                 E
      *
      *=========================================================================
      *  Adds an appender to the specified appender list.
      *=========================================================================
      *  Parameters:
      *   i_pAppList    - Appender list returned by AppenderList_new().
      *   i_pAppender   - Appender that is added to this appender list.
      *
      *  Returns:
      *   index         - Returns 0 on success, else -1.
      *=========================================================================
     P AppenderList_put...
     P                 B                   export
      *
     D AppenderList_put...
     D                 PI            10I 0
     D  i_pAppList                         const  like(LOG4RPG_pAppenderList_t )
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
      *
      *  Helper fields
     D pAppender       S                   like(i_pAppender            )
      *
      *  Appender list handle
     D appList         DS                  likeds(handle_t    )
     D                                     based(i_pAppList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pAppender = i_pAppender;
 
         return BasicMap_put(appList.pMap: Appender_getName(pAppender)
                                         : %addr(pAppender)
                                         : %len(pAppender ));
 
      /END-FREE
      *
     P AppenderList_put...
     P                 E
      *
      *=========================================================================
      *  Removes the specified appender from the given appender list.
      *=========================================================================
      *  Parameters:
      *   i_pAppList    - Appender list returned by AppenderList_new().
      *   i_appName     - Name of the appender that is removed from
      *                   this appender list.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P AppenderList_remove...
     P                 B                   export
      *
     D AppenderList_remove...
     D                 PI            10I 0
     D  i_pAppList                         const  like(LOG4RPG_pAppenderList_t )
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
      *
      *  Appender list handle
     D appList         DS                  likeds(handle_t    )
     D                                     based(i_pAppList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return BasicMap_remove(appList.pMap: i_appName);
 
      /END-FREE
      *
     P AppenderList_remove...
     P                 E
      *
      *=========================================================================
      *  Returns the appender assigned to the specified key.
      *=========================================================================
      *  Parameters:
      *   i_pAppList    - Appender list returned by AppenderList_new().
      *   i_appName     - Name of the appender that is returned.
      *
      *  Returns:
      *   pAppender     - Returns the associated appender on ssuccess, else NULL.
      *=========================================================================
     P AppenderList_get...
     P                 B                   export
      *
     D AppenderList_get...
     D                 PI                         like(LOG4RPG_pAppender_t     )
     D  i_pAppList                         const  like(LOG4RPG_pAppenderList_t )
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
      *
      *  Return value
     D pAppender       S                   like(LOG4RPG_pAppender_t     ) inz
      *
      *  Appender list handle
     D appList         DS                  likeds(handle_t    )
     D                                     based(i_pAppList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         BasicMap_get(appList.pMap: i_appName: %addr(pAppender)
                                             : %size(pAppender));
 
         return pAppender;
 
      /END-FREE
      *
     P AppenderList_get...
     P                 E
      *
      *=========================================================================
      *  Tests, if the appender list contains the specified appender.
      *=========================================================================
      *  Parameters:
      *   i_pAppList    - Appender list returned by AppenderList_new().
      *   i_appName     - Name of the appender.
      *
      *  Returns:
      *   exist         - Returns TRUE if the appender exists, else FALSE.
      *=========================================================================
     P AppenderList_exist...
     P                 B                   export
      *
     D AppenderList_exist...
     D                 PI              N
     D  i_pAppList                         const  like(LOG4RPG_pAppenderList_t )
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
      *
      *  Appender list handle
     D appList         DS                  likeds(handle_t    )
     D                                     based(i_pAppList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return BasicMap_containsKey(appList.pMap: i_appName);
 
      /END-FREE
      *
     P AppenderList_exist...
     P                 E
      *
      *=========================================================================
      *  Returns an iterator for the specified appender list.
      *=========================================================================
      *  Parameters:
      *   i_pAppList    - Appender list returned by AppenderList_new().
      *
      *  Returns:
      *   appIter       - Iterator for the appender list.
      *=========================================================================
     P AppenderList_getIterator...
     P                 B                   export
      *
     D AppenderList_getIterator...
     D                 PI                        likeds(LOG4RPG_Appender...
     D                                                          ListIterator_t )
     D  i_pAppList                         const  like(LOG4RPG_pAppenderList_t )
      *
      *  Return value
     D appIter         DS                  likeds(LOG4RPG_Appender...
     D                                                    ListIterator_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clear appIter;
         appIter.pAppList = i_pAppList;
         appIter.lastApp  = 0;
 
         return appIter;
 
      /END-FREE
      *
     P AppenderList_getIterator...
     P                 E
      *
      *=========================================================================
      *  Returns the first appender of the specified appender list.
      *=========================================================================
      *  Parameters:
      *   io_appIter    - Iteratur returned by AppenderList_getIterator().
      *
      *  Returns:
      *   pAppender     - Returns the first appender in the specified
      *                   appender list on success, else a NULL handle.
      *=========================================================================
     P AppenderList_getFirst...
     P                 B                   export
      *
     D AppenderList_getFirst...
     D                 PI                         like(LOG4RPG_pAppender_t     )
     D  io_appIter                                likeds(LOG4RPG_Appender...
     D                                                           ListIterator_t)
      *
      *  Return value
     D pAppender       S                   like(LOG4RPG_pAppender_t     ) inz
      *
      *  Helper fields
     D appName         S                   like(LOG4RPG_appenderName_t ) inz
      *
      *  Appender list handle
     D appList         DS                  likeds(handle_t    )
     D                                     based(io_appIter.pAppList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pAppender = Appender_null();
 
         if AppenderList_getNumE(io_appIter.pAppList) = 0;
            return pAppender;
         endif;
 
         io_appIter.lastApp = 1;
 
         appName = BasicMap_getKeyByIndex(appList.pMap
                                          : io_appIter.lastApp);
         pAppender = AppenderList_get(io_appIter.pAppList: appName);
 
         return pAppender;
 
      /END-FREE
      *
     P AppenderList_getFirst...
     P                 E
      *
      *=========================================================================
      *  Returns the next appender of the specified appender list.
      *=========================================================================
      *  Parameters:
      *   io_appIter    - Iteratur returned by AppenderList_getIterator().
      *
      *  Returns:
      *   pAppender     - Returns the next appender in the specified
      *                   appender list on success, else a NULL handle.
      *=========================================================================
     P AppenderList_getNext...
     P                 B                   export
      *
     D AppenderList_getNext...
     D                 PI                         like(LOG4RPG_pAppender_t     )
     D  io_appIter                                likeds(LOG4RPG_Appender...
     D                                                           ListIterator_t)
      *
      *  Return value
     D pAppender       S                   like(LOG4RPG_pAppender_t     ) inz
      *
      *  Helper fields
     D appName         S                   like(LOG4RPG_appenderName_t ) inz
      *
      *  Appender list handle
     D appList         DS                  likeds(handle_t    )
     D                                     based(io_appIter.pAppList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pAppender = Appender_null();
 
         if AppenderList_getNumE(io_appIter.pAppList) <= io_appIter.lastApp;
            return pAppender;
         endif;
 
         io_appIter.lastApp = io_appIter.lastApp + 1;
 
         appName = BasicMap_getKeyByIndex(appList.pMap
                                          : io_appIter.lastApp);
         pAppender = AppenderList_get(io_appIter.pAppList: appName);
 
         return pAppender;
 
      /END-FREE
      *
     P AppenderList_getNext...
     P                 E
      *
      *=========================================================================
      *  Deletes the specified appender list.
      *=========================================================================
      *  Parameters:
      *   io_pAppList   - Appender list returned by AppenderList_new().
      *
      *  Returns:
      *   isDeleted     - Returns TRUE on success, else FALSE.
      *=========================================================================
     P AppenderList_delete...
     P                 B                   export
      *
     D AppenderList_delete...
     D                 PI              N
     D  io_pAppList                               like(LOG4RPG_pAppenderList_t )
      *
      *  Return value
     D isDeleted       S               N   inz(cFalse)
      *
      *  Helper fields
     D name            S                   like(LOG4RPG_appenderName_t  ) inz
     D appIter         DS                  likeds(LOG4RPG_Appender...
     D                                            ListIterator_t        ) inz
     D pAppender       S                   like(LOG4RPG_pAppender_t     ) inz
      *
      *  Appender list handle
     D appList         DS                  likeds(handle_t    )
     D                                     based(io_pAppList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if BasicMap_isNull(appList.pMap);
            return cTrue;
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
            isDeleted = cTrue;
         else;
            isDeleted = cFalse;
         endif;
 
         clear appList;
         dealloc(N) io_pAppList;
 
         io_pAppList = AppenderList_null();
 
         LogLog_verbose('- Freed memory of appender list.');
 
         return isDeleted;
 
      /END-FREE
      *
     P AppenderList_delete...
     P                 E
      *
      *=========================================================================
      *  Test the specified appender list for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_appList     - Appender list returned by AppenderList_new().
      *
      *  Returns:
      *   isNull        - Returns TRUE if the handle of the appender list is a
      *                   NULL handle.
      *=========================================================================
     P AppenderList_isNull...
     P                 B                   export
      *
     D AppenderList_isNull...
     D                 PI              N
     D  i_pAppList                         const  like(LOG4RPG_pAppenderList_t )
      *
      *  Appender list handle
     D appList         DS                  likeds(handle_t    )
     D                                     based(i_pAppList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if i_pAppList = AppenderList_null();
            return cTrue;
         else;
            return BasicMap_isNull(appList.pMap);
         endif;
 
      /END-FREE
      *
     P AppenderList_isNull...
     P                 E
      *
      *=========================================================================
      *  Returns a NULL appender list.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pAppList      - Appender list NULL handle.
      *=========================================================================
     P AppenderList_null...
     P                 B                   export
      *
     D AppenderList_null...
     D                 PI                         like(LOG4RPG_pAppenderList_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return BasicMap_null();
 
      /END-FREE
      *
     P AppenderList_null...
     P                 E
      *
