**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: LoggerList                               *
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
//  Imported functions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG                      Public API Specification

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG02

// -----------------------------------------
//  Internal type templates
// -----------------------------------------
/copy QLOG4RPG,PTYPES

dcl-ds handle_t qualified based(pDummy);
  pMap like(BasicMap_handle_t);
end-ds;

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QBASICS1,PBASICS1                      Basic RPG Extensions
/copy QIFS,PIFS                              IFS Stream file support

/copy QLOG4RPG,PLOG4RPG10                    LogLog
/copy QLOG4RPG,PLOG4RPG99                    Helpers

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
//  Creates a new logger list instance.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pLoggerList   - Returns a handle to the logger list on success, else
//                   a NULL handle.
//=========================================================================
dcl-proc LoggerList_new export;
  dcl-pi *n like(LOG4RPG_pLoggerList_t);
  end-pi;

//  Return value
  dcl-ds logList likeds(handle_t) based(pLogList);

//  Helper fields
  dcl-ds tempLogList likeds(handle_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Returns the number of entries in the specified logger list.
//=========================================================================
//  Parameters:
//   i_pLogList    - Logger list returned by LoggerList_new().
//
//  Returns:
//   numE          - Returns the number of loggers in this
//                   logger list on success, else -1.
//=========================================================================
dcl-proc LoggerList_getNumE export;
  dcl-pi *n int(10);
    i_pLogList like(LOG4RPG_pLoggerList_t) const;
  end-pi;

//  Logger list handle
  dcl-ds logList likeds(handle_t) based(i_pLogList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return BasicMap_getNumE(logList.pMap);


end-proc;

//=========================================================================
//  Adds a logger to the specified logger list.
//=========================================================================
//  Parameters:
//   i_pLogList    - Logger list returned by LoggerList_new().
//   i_pLogger     - Logger that is added to this logger list.
//
//  Returns:
//   index         - Returns the index of the logger on success,
//                   else -1.
//=========================================================================
dcl-proc LoggerList_put export;
  dcl-pi *n int(10);
    i_pLogList like(LOG4RPG_pLoggerList_t) const;
    i_pLogger  like(LOG4RPG_hLogger_t) const;
  end-pi;

//  Helper fields
  dcl-s pLogger like(i_pLogger);

//  Logger list handle
  dcl-ds logList likeds(handle_t) based(i_pLogList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pLogger = i_pLogger;

return BasicMap_put(logList.pMap: Logger_getName(pLogger)
                                : %addr(pLogger)
                                : %len(pLogger ));


end-proc;

//=========================================================================
//  Removes the specified logger from the given logger list.
//=========================================================================
//  Parameters:
//   i_pLogList    - Logger list returned by LoggerList_new().
//   i_logName     - Name of the logger that is removed from
//                   this logger list.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc LoggerList_remove export;
  dcl-pi *n int(10);
    i_pLogList like(LOG4RPG_pLoggerList_t) const;
    i_logName  like(LOG4RPG_loggerName_t) const;
  end-pi;

//  Logger list handle
  dcl-ds logList likeds(handle_t) based(i_pLogList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return BasicMap_remove(logList.pMap: i_logName);


end-proc;

//=========================================================================
//  Returns the logger assigned to the specified logger name.
//=========================================================================
//  Parameters:
//   i_pLogList    - Logger list returned by LoggerList_new().
//   i_logName     - Name of the logger that is returned.
//
//  Returns:
//   pLogger       - Returns the associated logger on ssuccess, else NULL.
//=========================================================================
dcl-proc LoggerList_get export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
    i_pLogList like(LOG4RPG_pLoggerList_t) const;
    i_logName  like(LOG4RPG_loggerName_t) const;
  end-pi;

//  Return value
  dcl-s pLogger like(LOG4RPG_hLogger_t) inz;

//  Logger list handle
  dcl-ds logList likeds(handle_t) based(i_pLogList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

BasicMap_get(logList.pMap: i_logName: %addr(pLogger)
                                    : %size(pLogger));

return pLogger;


end-proc;

//=========================================================================
//  Tests, if the logger list contains the specified logger.
//=========================================================================
//  Parameters:
//   i_pLogList    - Logger list returned by LoggerList_new().
//   i_logName     - Name of the logger.
//
//  Returns:
//   exist         - Returns TRUE if the logger exists, else FALSE.
//=========================================================================
dcl-proc LoggerList_exist export;
  dcl-pi *n ind;
    i_pLogList like(LOG4RPG_pLoggerList_t) const;
    i_logName  like(LOG4RPG_loggerName_t) const;
  end-pi;

//  Logger list handle
  dcl-ds logList likeds(handle_t) based(i_pLogList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return BasicMap_containsKey(logList.pMap: i_logName);


end-proc;

//=========================================================================
//  Returns an iterator for the specified logger list.
//=========================================================================
//  Parameters:
//   i_pLogList    - Logger list returned by LoggerList_new().
//
//  Returns:
//   logIter       - Iterator for the logger list.
//=========================================================================
dcl-proc LoggerList_getIterator export;

  dcl-ds LoggerList_getIteratorPI likeds(LOG4RPG_Logger: ListIterator_t);
i_pLogList      const  like(LOG4RPG_pLoggerList_t );
  end-ds;

//  Return value
  dcl-ds logIter DS likeds(LOG4RPG_Logger: ListIterator_t) inz;
  end-ds;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

clear logIter;
logIter.pLogList = i_pLogList;
logIter.lastLog  = 0;

return logIter;


end-proc;

//=========================================================================
//  Returns the first logger of the specified logger list.
//=========================================================================
//  Parameters:
//   i_logIter     - Iteratur returned by LoggerList_getIterator().
//
//  Returns:
//   pLogger       - Returns the first logger in the specified
//                   logger list on success, else a NULL handle.
//=========================================================================
dcl-proc LoggerList_getFirst export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
    io_logIter likeds(LOG4RPG_LoggerListIterator_t);
  end-pi;

//  Return value
  dcl-s pLogger like(LOG4RPG_hLogger_t) inz;

//  Helper fields
  dcl-s logName like(LOG4RPG_loggerName_t) inz;

//  Logger list handle
  dcl-ds logList likeds(handle_t) based(io_logIter.pLogList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pLogger = Logger_null();

if LoggerList_getNumE(io_logIter.pLogList) = 0;
   return pLogger;
endif;

io_logIter.lastLog = 1;

logName = BasicMap_getKeyByIndex(logList.pMap
                              : io_logIter.lastLog);
pLogger = LoggerList_get(io_logIter.pLogList: logName);

return pLogger;


end-proc;

//=========================================================================
//  Returns the next logger of the specified logger list.
//=========================================================================
//  Parameters:
//   i_logIter     - Iteratur returned by LoggerList_getIterator().
//
//  Returns:
//   pLogger       - Returns the next logger in the specified
//                   logger list on success, else a NULL handle.
//=========================================================================
dcl-proc LoggerList_getNext export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
    io_logIter likeds(LOG4RPG_LoggerListIterator_t);
  end-pi;

//  Return value
  dcl-s pLogger like(LOG4RPG_hLogger_t) inz;

//  Helper fields
  dcl-s logName like(LOG4RPG_loggerName_t) inz;

//  Logger list handle
  dcl-ds logList likeds(handle_t) based(io_logIter.pLogList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pLogger = Logger_null();

if LoggerList_getNumE(io_logIter.pLogList) <= io_logIter.lastLog;
   return pLogger;
endif;

io_logIter.lastLog = io_logIter.lastLog + 1;

logName = BasicMap_getKeyByIndex(logList.pMap
                              : io_logIter.lastLog);
pLogger = LoggerList_get(io_logIter.pLogList: logName);

return pLogger;


end-proc;

//=========================================================================
//  Deletes the specified logger list.
//=========================================================================
//  Parameters:
//   io_pLogList   - Logger list returned by LoggerList_new().
//
//  Returns:
//   isDeleted     - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc LoggerList_delete export;
  dcl-pi *n ind;
    io_pLogList like(LOG4RPG_pLoggerList_t);
  end-pi;

//  Return value
  dcl-s isDeleted ind inz(*off);

//  Helper fields
  dcl-ds logIter DS likeds(LOG4RPG_Logger: ListIterator_t) inz;
  end-ds;
  dcl-s pLogger like(LOG4RPG_hLogger_t) inz;

//  Logger list handle
  dcl-ds logList likeds(handle_t) based(io_pLogList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if BasicMap_isNull(logList.pMap);
   return *on;
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
   isDeleted = *on;
else;
   isDeleted = *off;
endif;

io_pLogList = LoggerList_null();

LogLog_verbose('- Deleted Logger list');

return isDeleted;


end-proc;

//=========================================================================
//  Tests the specified logger list for a NULL value.
//=========================================================================
//  Parameters:
//   i_logList     - Logger list returned by LoggerList_new().
//
//  Returns:
//   isNull        - Returns TRUE if the handle of the logger list is a
//                   NULL handle.
//=========================================================================
dcl-proc LoggerList_isNull export;
  dcl-pi *n ind;
    i_pLogList like(LOG4RPG_pLoggerList_t) const;
  end-pi;

//  Logger list handle
  dcl-ds logList likeds(handle_t) based(i_pLogList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if i_pLogList = LoggerList_null();
   return *on;
else;
   return BasicMap_isNull(logList.pMap);
endif;


end-proc;

//=========================================================================
//  Returns a NULL logger list.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pLogList      - Logger list NULL handle.
//=========================================================================
dcl-proc LoggerList_null export;
  dcl-pi *n like(LOG4RPG_pLoggerList_t);
  end-pi;

//  Return value
  dcl-s logList like(LOG4RPG_pLoggerList_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return BasicMap_null();


end-proc;

