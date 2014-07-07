      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: LoggerList                               *
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
      /COPY QLOG4RPG,PLOG4RPG02
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
      *  Creates a new logger list instance.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pLoggerList   - Returns a handle to the logger list on success, else
      *                   a NULL handle.
      *=========================================================================
     P LoggerList_new...
     P                 B                   export
      *
     D LoggerList_new...
     D                 PI                         like(LOG4RPG_pLoggerList_t )
      *
      *  Return value
     D logList         DS                  likeds(handle_t       )
     D                                     based(pLogList)
      *
      *  Helper fields
     D tempLogList     DS                  likeds(handle_t       ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_verbose('Creating logger list ...');
 
         pLogList = LoggerList_null();
 
         // Initialize appender list handle
         clear tempLogList;
         tempLogList.pMap = BasicMap_new();
 
         // Return properties list to caller
         pLogList = %alloc(%size(handle_t));
         logList = tempLogList;
 
         LogLog_verbose('+ Allocated memory for logger list.');
 
         return pLogList;
 
      /END-FREE
      *
     P LoggerList_new...
     P                 E
      *
      *=========================================================================
      *  Returns the number of entries in the specified logger list.
      *=========================================================================
      *  Parameters:
      *   i_pLogList    - Logger list returned by LoggerList_new().
      *
      *  Returns:
      *   numE          - Returns the number of loggers in this
      *                   logger list on success, else -1.
      *=========================================================================
     P LoggerList_getNumE...
     P                 B                   export
      *
     D LoggerList_getNumE...
     D                 PI            10I 0
     D  i_pLogList                         const  like(LOG4RPG_pLoggerList_t )
      *
      *  Logger list handle
     D logList         DS                  likeds(handle_t    )
     D                                     based(i_pLogList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return BasicMap_getNumE(logList.pMap);
 
      /END-FREE
      *
     P LoggerList_getNumE...
     P                 E
      *
      *=========================================================================
      *  Adds a logger to the specified logger list.
      *=========================================================================
      *  Parameters:
      *   i_pLogList    - Logger list returned by LoggerList_new().
      *   i_pLogger     - Logger that is added to this logger list.
      *
      *  Returns:
      *   index         - Returns the index of the logger on success,
      *                   else -1.
      *=========================================================================
     P LoggerList_put...
     P                 B                   export
      *
     D LoggerList_put...
     D                 PI            10I 0
     D  i_pLogList                         const  like(LOG4RPG_pLoggerList_t )
     D  i_pLogger                          const  like(LOG4RPG_hLogger_t     )
      *
      *  Helper fields
     D pLogger         S                   like(i_pLogger)
      *
      *  Logger list handle
     D logList         DS                  likeds(handle_t    )
     D                                     based(i_pLogList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pLogger = i_pLogger;
 
         return BasicMap_put(logList.pMap: Logger_getName(pLogger)
                                         : %addr(pLogger)
                                         : %len(pLogger ));
 
      /END-FREE
      *
     P LoggerList_put...
     P                 E
      *
      *=========================================================================
      *  Removes the specified logger from the given logger list.
      *=========================================================================
      *  Parameters:
      *   i_pLogList    - Logger list returned by LoggerList_new().
      *   i_logName     - Name of the logger that is removed from
      *                   this logger list.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P LoggerList_remove...
     P                 B                   export
      *
     D LoggerList_remove...
     D                 PI            10I 0
     D  i_pLogList                         const  like(LOG4RPG_pLoggerList_t )
     D  i_logName                          const  like(LOG4RPG_loggerName_t  )
      *
      *  Logger list handle
     D logList         DS                  likeds(handle_t    )
     D                                     based(i_pLogList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return BasicMap_remove(logList.pMap: i_logName);
 
      /END-FREE
      *
     P LoggerList_remove...
     P                 E
      *
      *=========================================================================
      *  Returns the logger assigned to the specified logger name.
      *=========================================================================
      *  Parameters:
      *   i_pLogList    - Logger list returned by LoggerList_new().
      *   i_logName     - Name of the logger that is returned.
      *
      *  Returns:
      *   pLogger       - Returns the associated logger on ssuccess, else NULL.
      *=========================================================================
     P LoggerList_get...
     P                 B                   export
      *
     D LoggerList_get...
     D                 PI                         like(LOG4RPG_hLogger_t     )
     D  i_pLogList                         const  like(LOG4RPG_pLoggerList_t )
     D  i_logName                          const  like(LOG4RPG_loggerName_t  )
      *
      *  Return value
     D pLogger         S                   like(LOG4RPG_hLogger_t       ) inz
      *
      *  Logger list handle
     D logList         DS                  likeds(handle_t    )
     D                                     based(i_pLogList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         BasicMap_get(logList.pMap: i_logName: %addr(pLogger)
                                             : %size(pLogger));
 
         return pLogger;
 
      /END-FREE
      *
     P LoggerList_get...
     P                 E
      *
      *=========================================================================
      *  Tests, if the logger list contains the specified logger.
      *=========================================================================
      *  Parameters:
      *   i_pLogList    - Logger list returned by LoggerList_new().
      *   i_logName     - Name of the logger.
      *
      *  Returns:
      *   exist         - Returns TRUE if the logger exists, else FALSE.
      *=========================================================================
     P LoggerList_exist...
     P                 B                   export
      *
     D LoggerList_exist...
     D                 PI              N
     D  i_pLogList                         const  like(LOG4RPG_pLoggerList_t )
     D  i_logName                          const  like(LOG4RPG_loggerName_t  )
      *
      *  Logger list handle
     D logList         DS                  likeds(handle_t    )
     D                                     based(i_pLogList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return BasicMap_containsKey(logList.pMap: i_logName);
 
      /END-FREE
      *
     P LoggerList_exist...
     P                 E
      *
      *=========================================================================
      *  Returns an iterator for the specified logger list.
      *=========================================================================
      *  Parameters:
      *   i_pLogList    - Logger list returned by LoggerList_new().
      *
      *  Returns:
      *   logIter       - Iterator for the logger list.
      *=========================================================================
     P LoggerList_getIterator...
     P                 B                   export
      *
     D LoggerList_getIterator...
     D                 PI                         likeds(LOG4RPG_Logger...
     D                                                           ListIterator_t)
     D  i_pLogList                         const  like(LOG4RPG_pLoggerList_t )
      *
      *  Return value
     D logIter         DS                  likeds(LOG4RPG_Logger...
     D                                                    ListIterator_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clear logIter;
         logIter.pLogList = i_pLogList;
         logIter.lastLog  = 0;
 
         return logIter;
 
      /END-FREE
      *
     P LoggerList_getIterator...
     P                 E
      *
      *=========================================================================
      *  Returns the first logger of the specified logger list.
      *=========================================================================
      *  Parameters:
      *   i_logIter     - Iteratur returned by LoggerList_getIterator().
      *
      *  Returns:
      *   pLogger       - Returns the first logger in the specified
      *                   logger list on success, else a NULL handle.
      *=========================================================================
     P LoggerList_getFirst...
     P                 B                   export
      *
     D LoggerList_getFirst...
     D                 PI                         like(LOG4RPG_hLogger_t       )
     D  io_logIter                                likeds(LOG4RPG_Logger...
     D                                                           ListIterator_t)
      *
      *  Return value
     D pLogger         S                   like(LOG4RPG_hLogger_t       ) inz
      *
      *  Helper fields
     D logName         S                   like(LOG4RPG_loggerName_t   ) inz
      *
      *  Logger list handle
     D logList         DS                  likeds(handle_t    )
     D                                     based(io_logIter.pLogList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pLogger = Logger_null();
 
         if LoggerList_getNumE(io_logIter.pLogList) = 0;
            return pLogger;
         endif;
 
         io_logIter.lastLog = 1;
 
         logName = BasicMap_getKeyByIndex(logList.pMap
                                       : io_logIter.lastLog);
         pLogger = LoggerList_get(io_logIter.pLogList: logName);
 
         return pLogger;
 
      /END-FREE
      *
     P LoggerList_getFirst...
     P                 E
      *
      *=========================================================================
      *  Returns the next logger of the specified logger list.
      *=========================================================================
      *  Parameters:
      *   i_logIter     - Iteratur returned by LoggerList_getIterator().
      *
      *  Returns:
      *   pLogger       - Returns the next logger in the specified
      *                   logger list on success, else a NULL handle.
      *=========================================================================
     P LoggerList_getNext...
     P                 B                   export
      *
     D LoggerList_getNext...
     D                 PI                         like(LOG4RPG_hLogger_t       )
     D  io_logIter                                likeds(LOG4RPG_Logger...
     D                                                           ListIterator_t)
      *
      *  Return value
     D pLogger         S                   like(LOG4RPG_hLogger_t       ) inz
      *
      *  Helper fields
     D logName         S                   like(LOG4RPG_loggerName_t   ) inz
      *
      *  Logger list handle
     D logList         DS                  likeds(handle_t    )
     D                                     based(io_logIter.pLogList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pLogger = Logger_null();
 
         if LoggerList_getNumE(io_logIter.pLogList) <= io_logIter.lastLog;
            return pLogger;
         endif;
 
         io_logIter.lastLog = io_logIter.lastLog + 1;
 
         logName = BasicMap_getKeyByIndex(logList.pMap
                                       : io_logIter.lastLog);
         pLogger = LoggerList_get(io_logIter.pLogList: logName);
 
         return pLogger;
 
      /END-FREE
      *
     P LoggerList_getNext...
     P                 E
      *
      *=========================================================================
      *  Deletes the specified logger list.
      *=========================================================================
      *  Parameters:
      *   io_pLogList   - Logger list returned by LoggerList_new().
      *
      *  Returns:
      *   isDeleted     - Returns TRUE on success, else FALSE.
      *=========================================================================
     P LoggerList_delete...
     P                 B                   export
      *
     D LoggerList_delete...
     D                 PI              N
     D  io_pLogList                               like(LOG4RPG_pLoggerList_t )
      *
      *  Return value
     D isDeleted       S               N   inz(cFalse)
      *
      *  Helper fields
     D logIter         DS                  likeds(LOG4RPG_Logger...
     D                                            ListIterator_t        ) inz
     D pLogger         S                   like(LOG4RPG_hLogger_t       ) inz
      *
      *  Logger list handle
     D logList         DS                  likeds(handle_t    )
     D                                     based(io_pLogList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if BasicMap_isNull(logList.pMap);
            return cTrue;
         endif;
 
         LogLog_verbose('Deleting logger list ...');
 
         p_assert(LoggerList_getNumE(io_pLogList) = 0
                  : 'All loggers should have been removed from this +
                     logger list by the repository.');
 
         logIter = LoggerList_getIterator(io_pLogList);
 
         dow LoggerList_getNumE(io_pLogList) > 0;
            pLogger = LoggerList_getFirst(logIter);
            LoggerList_remove(io_pLogList: Logger_getName(pLogger));
            Logger_delete(pLogger);
         enddo;
 
         if BasicMap_delete(logList.pMap) = 0;
            isDeleted = cTrue;
         else;
            isDeleted = cFalse;
         endif;
 
         io_pLogList = LoggerList_null();
 
         LogLog_verbose('- Deleted Logger list');
 
         return isDeleted;
 
      /END-FREE
      *
     P LoggerList_delete...
     P                 E
      *
      *=========================================================================
      *  Tests the specified logger list for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_logList     - Logger list returned by LoggerList_new().
      *
      *  Returns:
      *   isNull        - Returns TRUE if the handle of the logger list is a
      *                   NULL handle.
      *=========================================================================
     P LoggerList_isNull...
     P                 B                   export
      *
     D LoggerList_isNull...
     D                 PI              N
     D  i_pLogList                         const  like(LOG4RPG_pLoggerList_t )
      *
      *  Logger list handle
     D logList         DS                  likeds(handle_t    )
     D                                     based(i_pLogList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if i_pLogList = LoggerList_null();
            return cTrue;
         else;
            return BasicMap_isNull(logList.pMap);
         endif;
 
      /END-FREE
      *
     P LoggerList_isNull...
     P                 E
      *
      *=========================================================================
      *  Returns a NULL logger list.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pLogList      - Logger list NULL handle.
      *=========================================================================
     P LoggerList_null...
     P                 B                   export
      *
     D LoggerList_null...
     D                 PI                         like(LOG4RPG_pLoggerList_t )
      *
      *  Return value
     D logList         S                   like(LOG4RPG_pLoggerList_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return BasicMap_null();
 
      /END-FREE
      *
     P LoggerList_null...
     P                 E
      *
