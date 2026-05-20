**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Repository                                       *
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
//  25.10.2006  Th.Raddatz    Introduced Filter to Log4rpg.            *
//                                                                     *
//  27.10.2006  Th.Raddatz    Added isShutdown flag to repository.     *
//                                                                     *
//  20.06.2008  Th.Raddatz    Made separate procedures for clearing    *
//                            filters and appenders.                   *
//                            Added Repository_prepareReload().        *
//                                                                     *
//  14.02.2014  Th.Raddatz    Fixed problem, that the logger hierachy  *
//                            was not propper managed for certain      *
//                            cases.                                   *
//                            Added Repository_dumpHierarchy() for     *
//                            debugging purposes.                      *
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
/copy QLOG4RPG,PLOG4RPG13

// -----------------------------------------
//  Internal type templates
// -----------------------------------------
/copy QLOG4RPG,PTYPES

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,CEELIB                        CEE-Procedures
/copy QBASICS1,PBASICS1                      Basic RPG Extensions

/copy QLOG4RPG,PLOG4RPG01                    Logger
/copy QLOG4RPG,PLOG4RPG02                    LoggerList
/copy QLOG4RPG,PLOG4RPG10                    LogLog
/copy QLOG4RPG,PLOG4RPG18                    FilterList

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Delete "forgotten" handles on termination of activation group.
dcl-pr PRIVATE_onActivationGroupEnd extproc('LOG4RPG13_PRIVATE_onActivationGroupEnd');
  i_ag_mark      uns(10) const;
  i_reason       uns(10) const;
  io_result_code uns(10);
  io_user_rc     uns(10);
end-pr;

//  Updates the parents of a given logger.
dcl-pr updateParents;
  i_pLogger like(LOG4RPG_hLogger_t) const;
end-pr;

//  Dumps the tree of children of a given logger.
dcl-pr dumpHierarchy;
  i_pLogger like(LOG4RPG_hLogger_t) const;
  i_level   int(10) const;
end-pr;

//  Initializes this module.
dcl-pr initializeModule;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
//
// -----------------------------------------
//  Global fields
// -----------------------------------------
dcl-s g_isInit ind inz(*off);
dcl-s g_isShutdown ind inz(*off);

dcl-s g_loggerRepos like(LOG4RPG_pLoggerList_t) inz;
dcl-s g_appendRepos like(LOG4RPG_pAppenderList_t) inz;
dcl-s g_filterRepos like(LOG4RPG_pFilterList_t) inz;

// -----------------------------------------
//  Program status data structure
// -----------------------------------------
/define SDS_EXTENDED
/copy QLOG4RPG,SDS
/undefine SDS_EXTENDED

//=========================================================================
//  Adds a logger to the repository.
//=========================================================================
//  Parameters:
//   i_pLogger     - Handle of the logger as it was returned by
//                   Logger_getLogger() or Logger_getRootLogger().
//
//  Returns:
//   index         - Returns the index of the logger on success, else -1.
//=========================================================================
dcl-proc Repository_addLogger export;
  dcl-pi *n int(10);
    i_pLogger like(LOG4RPG_hLogger_t) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return LoggerList_put(g_loggerRepos: i_pLogger);


end-proc;

//=========================================================================
//  Removes a logger from the logger list of the repository.
//=========================================================================
//  Parameters:
//   i_logName     - Name of the logger.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc Repository_removeLogger export;
  dcl-pi *n int(10);
    i_logName like(LOG4RPG_loggerName_t) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return LoggerList_remove(g_loggerRepos: i_logName);


end-proc;

//=========================================================================
//  Tests, whether the specified logger exists.
//=========================================================================
//  Parameters:
//   i_logName     - Name of the logger.
//
//  Returns:
//   exist         - Returns TRUE if the logger exists, else FALSE.
//=========================================================================
dcl-proc Repository_existLogger export;
  dcl-pi *n ind;
    i_logName like(LOG4RPG_loggerName_t) const;
  end-pi;

  dcl-s hLogger like(LOG4RPG_hLogger_t);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (not LoggerList_exist(g_loggerRepos: i_logName));
   return *off;
endif;

return *on;


end-proc;

//=========================================================================
//  Searches the logger list for the specified logger.
//=========================================================================
//  Parameters:
//   i_logName     - Name of the logger.
//
//  Returns:
//   pLogger       - Returns the handle of the logger on success, else
//                   a NULL handle.
//=========================================================================
dcl-proc Repository_getLogger export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
    i_logName like(LOG4RPG_loggerName_t) const;
  end-pi;

//  Return value
  dcl-ds logger likeds(LOG4RPG_logger_t) based(pLogger);

//  Helper fields
  dcl-s c int(10) inz;

//  Logger handle
  dcl-ds node likeds(LOG4RPG_logger_t) based(pNode);
  dcl-ds parent likeds(LOG4RPG_logger_t) based(pParent);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

LogLog_verbose('Retrieving logger [' + i_logName + ']');

pLogger = Logger_null();

pNode = LoggerList_get(g_loggerRepos: i_logName);

select;
when pNode = *NULL;
   pLogger = Logger_new(i_logName);
   Repository_addLogger(pLogger);
   updateParents(pLogger);
   return pLogger;
when Node_isLoggerNode(pNode);
   pLogger = pNode;
   return pLogger;
when Node_isProvisionNode(pNode);

   // Remove provision node from repositiory
   Repository_removeLogger(node.name);

   // Disconnect provision node from parent
   pParent = ProvisionNode_getParent(pNode);
   c = Node_findChild(pParent: pNode);
   Node_removeChild(pParent: c);

   // Create a logger node and move children to the logger.
   pLogger = Logger_new(node.name);
   ProvisionNode_moveChildren(pNode: pLogger);
   ProvisionNode_free(pNode);

   // Add logger node to parent.
   Node_addChild(pParent: pLogger);

   // Add the new logger node to the repositiory
   Repository_addLogger(pLogger);
   return pLogger;
endsl;

return Logger_null();


end-proc;

//=========================================================================
//  Adds an appender to the repository.
//=========================================================================
//  Parameters:
//   i_pAppender   - Handle of the appender as it was returned by
//                   Appender_new().
//
//  Returns:
//   index         - Returns 0 on success, else -1.
//=========================================================================
dcl-proc Repository_addAppender export;
  dcl-pi *n int(10);
    i_pAppender like(LOG4RPG_pAppender_t) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return AppenderList_put(g_appendRepos: i_pAppender);


end-proc;

//=========================================================================
//  Removes an appender from the appender list of the repository.
//=========================================================================
//  Parameters:
//   i_appName     - Name of the appender.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc Repository_removeAppender export;
  dcl-pi *n int(10);
    i_appName like(LOG4RPG_appenderName_t) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return AppenderList_remove(g_appendRepos: i_appName);


end-proc;

//=========================================================================
//  Tests, whether the specified appender exists.
//=========================================================================
//  Parameters:
//   i_appName     - Name of the appender.
//
//  Returns:
//   exist         - Returns TRUE if the logger exists, else FALSE.
//=========================================================================
dcl-proc Repository_existAppender export;
  dcl-pi *n ind;
    i_appName like(LOG4RPG_appenderName_t) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return AppenderList_exist(g_appendRepos: i_appName);


end-proc;

//=========================================================================
//  Searches the appender list for the specified appender.
//=========================================================================
//  Parameters:
//   i_appName     - Name of the appender.
//
//  Returns:
//   pAppender     - Returns the handle of the appender on success, else
//                   a NULL handle.
//=========================================================================
dcl-proc Repository_getAppender export;
  dcl-pi *n like(LOG4RPG_pAppender_t);
    i_appName like(LOG4RPG_appenderName_t) const;
  end-pi;

//  Return value
  dcl-s pAppender like(LOG4RPG_pAppender_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

LogLog_verbose('Retrieving appender [' + i_appName + ']');

pAppender = AppenderList_get(g_appendRepos: i_appName);
if Appender_isNull(pAppender);
   return Appender_null();
else;
   return pAppender;
endif;


end-proc;

//=========================================================================
//  Adds a filter to the repository.
//=========================================================================
//  Parameters:
//   i_pFilter     - Handle of the filter as it was returned by
//                   Filter_new().
//
//  Returns:
//   index         - Returns 0 on success, else -1.
//=========================================================================
dcl-proc Repository_addFilter export;
  dcl-pi *n int(10);
    i_pFilter like(LOG4RPG_pFilter_t) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return FilterList_put(g_filterRepos: i_pFilter);


end-proc;

//=========================================================================
//  Removes a filter from the filter list of the repository.
//=========================================================================
//  Parameters:
//   i_fltName     - Name of the filter.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc Repository_removeFilter export;
  dcl-pi *n int(10);
    i_fltName like(LOG4RPG_filterName_t) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return FilterList_remove(g_filterRepos: i_fltName);


end-proc;

//=========================================================================
//  Tests, whether the specified filter exists.
//=========================================================================
//  Parameters:
//   i_fltName     - Name of the filter.
//
//  Returns:
//   exist         - Returns TRUE if the logger exists, else FALSE.
//=========================================================================
dcl-proc Repository_existFilter export;
  dcl-pi *n ind;
    i_fltName like(LOG4RPG_filterName_t) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return FilterList_exist(g_filterRepos: i_fltName);


end-proc;

//=========================================================================
//  Searches the filter list for the specified filter.
//=========================================================================
//  Parameters:
//   i_fltName     - Name of the filter.
//
//  Returns:
//   pFilter       - Returns the handle of the filter on success, else
//                   a NULL handle.
//=========================================================================
dcl-proc Repository_getFilter export;
  dcl-pi *n like(LOG4RPG_pFilter_t);
    i_fltName like(LOG4RPG_filterName_t) const;
  end-pi;

//  Return value
  dcl-s pFilter like(LOG4RPG_pFilter_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

LogLog_verbose('Retrieving filter [' + i_fltName + ']');

pFilter = FilterList_get(g_filterRepos: i_fltName);
if Filter_isNull(pFilter);
   return Filter_null();
else;
   return pFilter;
endif;


end-proc;

//=========================================================================
//  Sets the SHUTDOWN-Flag if the repository.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   void
//=========================================================================
dcl-proc Repository_setShutdown export;
  dcl-pi *n;
    i_isShutdown ind const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

g_isShutdown = i_isShutdown;

if g_isShutdown;
   LogLog_verbose('Repository SHUTDOWN mode set to ON');
else;
   LogLog_verbose('Repository SHUTDOWN mode set to OFF');
endif;

return;


end-proc;

//=========================================================================
//  Tests, if the repository is in SHUTDOWN mode.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   void
//=========================================================================
dcl-proc Repository_isShutdown export;
  dcl-pi *n ind;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return g_isShutdown;


end-proc;

//=========================================================================
//  Initializes the logger repository.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   void
//=========================================================================
dcl-proc Repository_initialize export;
  dcl-pi *n;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

initializeModule();

return;


end-proc;

//=========================================================================
//  Prepare repository for re-loading configuration data.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   void
//=========================================================================
dcl-proc Repository_prepareReload export;
  dcl-pi *n;
  end-pi;

//  Helper fields
  dcl-s x int(10) inz;
  dcl-s pNode like(LOG4RPG_hLogger_t) inz;
  dcl-ds nodeIter DS likeds(LOG4RPG_Logger: ListIterator_t) inz;
  end-ds;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// -------------------------------------------- //
//   Reset loggers                              //
// -------------------------------------------- //
LogLog_verbose('Preparing repository to +
               reload configuration data ...');

if not LoggerList_isNull(g_loggerRepos);
   nodeIter = LoggerList_getIterator(g_loggerRepos);

   pNode = LoggerList_getFirst(nodeIter);
   dow (pNode <> *NULL);
      if Node_isLoggerNode(pNode);
         LogLog_verbose('... resetting logger ' +
                        Logger_getName(pNode) + ' ...');
         Logger_removeAllAppenders(pNode);
         Logger_resetLevel(pNode);
         LogLog_verbose('... reset logger ' +
                        Logger_getName(pNode) + '.');
      endif;
      pNode = LoggerList_getNext(nodeIter);
   enddo;

endif;

// -------------------------------------------- //
//   Delete filter                              //
// -------------------------------------------- //
Repository_clearFilters();

// -------------------------------------------- //
//   Delete appender                            //
// -------------------------------------------- //
Repository_clearAppenders();

return;


end-proc;

//===============================================================*
//  Dumps the tree of children of a given logger.
//===============================================================*
dcl-proc Repository_dumpHierarchy export;
  dcl-pi *n;
    i_pLogger like(LOG4RPG_hLogger_t) options(*nopass) const;
  end-pi;

//  Parameter positions
  dcl-c p_pLogger 1;

//  Optional parameter fields
  dcl-s pLogger like(i_pLogger) inz;

//  Helper fields
  dcl-s x int(10) inz;
  dcl-s numChildren int(10) inz;
  dcl-ds logger likeds(LOG4RPG_logger_t) based(pLogger);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (LogLog_getInternalDebugMode() <> cLOG4RPG_DEBUG_VERBOSE);
   return;
endif;

if (%parms() >= p_pLogger and %addr(i_pLogger) <> *NULL);
   pLogger = i_pLogger;
else;
   pLogger = Repository_getLogger(cROOT_LOGGER);
endif;

if (Node_getNumChildren(pLogger) <= 0);
   return;
endif;

LogLog_verbose('');
LogLog_verbose('Logger Hierarchy:');
LogLog_verbose('----------------');

LogLog_verbose(f_space(0) + Node_toString(pLogger));

dumpHierarchy(pLogger: 1);

LogLog_verbose('----------------');

end-proc;

//===============================================================*
//  *** Private ***
//  Dumps the tree of children of a given logger.
//===============================================================*
dcl-proc dumpHierarchy;
  dcl-pi *n;
    i_pLogger like(LOG4RPG_hLogger_t) const;
    i_level   int(10) const;
  end-pi;

//  Helper fields
  dcl-s x int(10) inz;
  dcl-s numChildren int(10) inz;
  dcl-ds logger likeds(LOG4RPG_logger_t) based(pLogger);
  dcl-ds child likeds(LOG4RPG_logger_t) based(pChild);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pLogger = i_pLogger;

numChildren = Node_getNumChildren(i_pLogger);
if (numChildren <= 0);
   return;
endif;

for x = 1 to numChildren;
   pChild = Node_getChild(i_pLogger: x);

   LogLog_verbose(f_space(i_level) + Node_toString(pChild));

   p_assert(child.pParent = i_pLogger
            : 'Child''s parent does not match the actual parent');

   dumpHierarchy(pChild: i_level + 1);
endfor;

end-proc;

//=========================================================================
//  Clears the repository.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   void
//=========================================================================
dcl-proc Repository_clear export;
  dcl-pi *n;
  end-pi;

//  Helper fields
  dcl-s x int(10) inz;
  dcl-s pNode like(LOG4RPG_hLogger_t) inz;
  dcl-ds nodeIter DS likeds(LOG4RPG_Logger: ListIterator_t) inz;
  end-ds;
  dcl-s pAppender like(LOG4RPG_pAppender_t) inz;
  dcl-ds appIter DS likeds(LOG4RPG_Appender: ListIterator_t) inz;
  end-ds;
  dcl-s pFilter like(LOG4RPG_pFilter_t) inz;
  dcl-ds fltIter DS likeds(LOG4RPG_Filter: ListIterator_t) inz;
  end-ds;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Set repository SHUTDOWN-mode
Repository_setShutdown(*on);

// -------------------------------------------- //
//   Delete logger                              //
// -------------------------------------------- //
LogLog_verbose('Deleting loggers ...');

if not LoggerList_isNull(g_loggerRepos);
   nodeIter = LoggerList_getIterator(g_loggerRepos);

   x = LoggerList_getNumE(g_loggerRepos);
   dow (x > 0);
      pNode = LoggerList_getFirst(nodeIter);
      Repository_removeLogger(Node_getName(pNode));
      if Node_isProvisionNode(pNode);
         ProvisionNode_free(pNode);   // Also removes the node from the repository
      else;
         Logger_delete(pNode);   // Also removes the logger from the repository
      endif;
      x = LoggerList_getNumE(g_loggerRepos);
   enddo;

endif;

// -------------------------------------------- //
//   Delete filter                              //
// -------------------------------------------- //
Repository_clearFilters();

// -------------------------------------------- //
//   Delete appender                            //
// -------------------------------------------- //
Repository_clearAppenders();

return;


end-proc;

//=========================================================================
//  Clears all filters in the repository.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   void
//=========================================================================
dcl-proc Repository_clearFilters export;
  dcl-pi *n;
  end-pi;

//  Helper fields
  dcl-s x int(10) inz;
  dcl-s pFilter like(LOG4RPG_pFilter_t) inz;
  dcl-ds fltIter DS likeds(LOG4RPG_Filter: ListIterator_t) inz;
  end-ds;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// -------------------------------------------- //
//   Delete filter                              //
// -------------------------------------------- //
LogLog_verbose('Deleting filters ...');

if not FilterList_isNull(g_filterRepos);
   fltIter = FilterList_getIterator(g_filterRepos);

   x = FilterList_getNumE(g_filterRepos);
   dow (x > 0);
      pFilter = FilterList_getFirst(fltIter);
      Filter_delete(pFilter); // Also removes the filter from the repository
      x = FilterList_getNumE(g_filterRepos);
   enddo;

endif;

return;


end-proc;

//=========================================================================
//  Clears all appenders in the repository.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   void
//=========================================================================
dcl-proc Repository_clearAppenders export;
  dcl-pi *n;
  end-pi;

//  Helper fields
  dcl-s x int(10) inz;
  dcl-s pAppender like(LOG4RPG_pAppender_t) inz;
  dcl-ds appIter DS likeds(LOG4RPG_Appender: ListIterator_t) inz;
  end-ds;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// -------------------------------------------- //
//   Delete appender                            //
// -------------------------------------------- //
LogLog_verbose('Deleting appenders ...');

if not AppenderList_isNull(g_appendRepos);
   appIter = AppenderList_getIterator(g_appendRepos);

   x = AppenderList_getNumE(g_appendRepos);
   dow (x > 0);
      pAppender = AppenderList_getFirst(appIter);
      Appender_delete(pAppender); // Also removes the appender from the repository
      x = AppenderList_getNumE(g_appendRepos);
   enddo;

endif;

return;


end-proc;

//===============================================================*
//  *** PRIVATE ***
//  Free resources  on termination of activation group.
//===============================================================*
//  ag_mark (input)
//      The activation group mark that uniquely identifies the activation
//      group within the job.
//  reason (input)
//      The reason for the activation group being ended.  See Figure 2-1 for a
//      description of the reason codes.
//  result_code (I/O)
//      The value passed as input is the action to be taken as specified by a
//      previous exit procedure.  The value passed to the first exit procedure
//      is 0.  The output value can specify an action to be taken.  If the
//      result code does not match any of the following actions, the output
//      value is ignored and the previous action remains unchanged.

//      No action
//         0           Do not change the action.

//      Recover
//         10          Do not perform any pending error requests.  This is
//                             used if a previous exit procedure specified a result
//                             code of 20 and a subsequent procedure recovers from
//                             the error.  The message CEE9901, indicating an
//                             application error, is not sent.
//      Failure

//         20          Send message CEE9901 to the caller of the control
//                     boundary after the remaining exit procedures are
//                     called.
//         21          Send message CEE9901 to the caller of the control
//                     boundary.  The remaining exit procedures registered by
//                     the CEE4RAGE API are not called.  This is used if an
//                     unrecoverable error occurs in the exit procedure
//                     requesting this action.

//  user_rc (I/O)
//      The value passed as input is the user_rc returned as output from the
//      previous exit procedure.  The value passed to the first exit procedure
//      is 0.

//===============================================================*
dcl-proc PRIVATE_onActivationGroupEnd export;
  dcl-pi *n;
    i_ag_mark      uns(10) const;
    i_reason       uns(10) const;
    io_result_code uns(10);
    io_user_rc     uns(10);
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

LogLog_debug('=== Starting clean up for repository ===');

// -------------------------------------------- //
//   Clear configuration data                   //
// -------------------------------------------- //
Repository_clear();

// -------------------------------------------- //
//   Delete logger list                         //
// -------------------------------------------- //
p_assert(LoggerList_getNumE(g_loggerRepos) = 0
         : 'Loggers should have been deleted.');

if LoggerList_delete(g_loggerRepos);
   LogLog_verbose('- Deleted logger list of repository.');
else;
   LogLog_error('Failed to delete logger list of repository.');
endif;

// -------------------------------------------- //
//   Delete filter list                         //
// -------------------------------------------- //
p_assert(FilterList_getNumE(g_filterRepos) = 0
         : 'Filters should have been deleted.');

if FilterList_delete(g_filterRepos);
   LogLog_verbose('- Deleted filter list of repository.');
else;
   LogLog_error('Failed to delete filter list of repository.');
endif;

// -------------------------------------------- //
//   Delete appender list                       //
// -------------------------------------------- //
p_assert(AppenderList_getNumE(g_appendRepos) = 0
         : 'Appenders should have been deleted.');

if AppenderList_delete(g_appendRepos);
   LogLog_verbose('- Deleted appender list of repository.');
else;
   LogLog_error('Failed to delete appender list of repository.');
endif;

LogLog_verbose('- Freed repository.');

return;


end-proc;

//===============================================================*
//  *** Private ***
//  Updates the parents of a given logger.
//===============================================================*
dcl-proc updateParents;
  dcl-pi *n;
    i_pLogger like(LOG4RPG_hLogger_t) const;
  end-pi;

//  Helper fields
  dcl-s x int(10) inz;
  dcl-s logName like(LOG4RPG_loggerName_t) inz;
  dcl-s substr like(logName) inz;
  dcl-ds parent likeds(LOG4RPG_logger_t) based(pParent);
  dcl-ds child likeds(LOG4RPG_logger_t) based(pChild);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

logName = Logger_getName(i_pLogger);
if logName = cROOT_LOGGER;
   Logger_setParent(i_pLogger: Logger_null());
   return;
endif;

pChild = i_pLogger;
pParent = Logger_null();

x = f_scanR('.': logName: %len(logName));
dow x > 1;
   substr = f_left(logName: x-1);

   pParent = LoggerList_get(g_loggerRepos: substr);

   select;
   when pParent = *NULL;
      pParent = ProvisionNode_makeProvisionNode(substr: pChild);
      Repository_addLogger(pParent);
   when Node_isLoggerNode(pParent);
      if (Node_getParent(pChild) = Node_null());
         Logger_addChild(pParent: pChild);
      endif;
   when Node_isProvisionNode(pParent);
      if (ProvisionNode_getParent(pChild) = ProvisionNode_null());
         ProvisionNode_addChild(pParent: pChild);
      endif;
   endsl;

   p_assert(Node_getParent(pChild) = pParent
            : 'Parent node must match the child''s parent');

   x = f_scanR('.': logName: x-1);
   pChild = pParent;
enddo;

if (Node_getParent(pChild) = Node_null());
   logName = Logger_getName(pChild);
   LogLog_debug('Parent not found. Set parent of node [' + logName
                 + '] to ''root''.');
   Node_addChild(Repository_getLogger(cROOT_LOGGER): pChild);
endif;


end-proc;

//=========================================================================
//  *** private ***
//  Initializes this module.
//=========================================================================
dcl-proc initializeModule;
  dcl-pi *n;
  end-pi;

//  Return value
//
//  Helper fields
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if g_isInit;
   return;
endif;

Loglog_verbose('Initializing module ' + sds.modContProc + '...');

// Disable Repository SHUTDOWN-mode
Repository_setShutdown(*off);

// Register activation group exit procedure
CEE4RAGE(%paddr('LOG4RPG13_PRIVATE_onActivationGroupEnd'): *OMIT);

// Create logger 'repository'
g_loggerRepos = LoggerList_null();
g_loggerRepos = LoggerList_new();
if not LoggerList_isNull(g_loggerRepos);
   LogLog_verbose('+ Created logger list of repository.');
else;
   LogLog_error('+ Failed to create logger list of repository.');
endif;

// Create filter 'repository'
g_filterRepos = FilterList_null();
g_filterRepos = FilterList_new();
if not FilterList_isNull(g_filterRepos);
   LogLog_verbose('+ Created filter list of repository.');
else;
   LogLog_error('+ Failed to create filter list of repository.');
endif;

// Create appender 'repository'
g_appendRepos = AppenderList_null();
g_appendRepos = AppenderList_new();
if not AppenderList_isNull(g_appendRepos);
   LogLog_verbose('+ Created appender list of repository.');
else;
   LogLog_error('+ Failed to create appender list of repository.');
endif;

LogLog_verbose('+ Initialized repository.');

// Ready!
g_isInit = *on;

return;


end-proc;

