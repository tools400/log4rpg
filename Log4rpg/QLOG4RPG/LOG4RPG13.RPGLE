      *=====================================================================*
      *  SrvPgm: LOG4RPG - Repository                                       *
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
      *  25.10.2006  Th.Raddatz    Introduced Filter to Log4rpg.            *
      *                                                                     *
      *  27.10.2006  Th.Raddatz    Added isShutdown flag to repository.     *
      *                                                                     *
      *  20.06.2008  Th.Raddatz    Made separate procedures for clearing    *
      *                            filters and appenders.                   *
      *                            Added Repository_prepareReload().        *
      *                                                                     *
      *  14.02.2014  Th.Raddatz    Fixed problem, that the logger hierachy  *
      *                            was not propper managed for certain      *
      *                            cases.                                   *
      *                            Added Repository_dumpHierarchy() for     *
      *                            debugging purposes.                      *
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
      /COPY QLOG4RPG,PLOG4RPG13
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PTYPES                        Private type definitions
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,CEELIB                        CEE-Procedures
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      *
      /COPY QLOG4RPG,PLOG4RPG01                    Logger
      /COPY QLOG4RPG,PLOG4RPG02                    LoggerList
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
      /COPY QLOG4RPG,PLOG4RPG18                    FilterList
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Delete "forgotten" handles on termination of activation group.
     D PRIVATE_onActivationGroupEnd...
     D                 PR                  extproc('LOG4RPG13_PRIVATE_+
     D                                     onActivationGroupEnd')
     D  i_ag_mark                    10U 0 const
     D  i_reason                     10U 0 const
     D  io_result_code...
     D                               10U 0
     D  io_user_rc                   10U 0
      *
      *  Updates the parents of a given logger.
     D updateParents...
     D                 PR
     D  i_pLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Dumps the tree of children of a given logger.
     D dumpHierarchy...
     D                 PR
     D  i_pLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_level                      10I 0 const
      *
      *  Initializes this module.
     D initializeModule...
     D                 PR
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
     D g_isInit        S               N   inz(cFalse)
     D g_isShutdown    S               N   inz(cFalse)
      *
     D g_loggerRepos   S                   like(LOG4RPG_pLoggerList_t   ) inz
     D g_appendRepos   S                   like(LOG4RPG_pAppenderList_t ) inz
     D g_filterRepos   S                   like(LOG4RPG_pFilterList_t   ) inz
      *
      * -----------------------------------------
      *  Program status data structure
      * -----------------------------------------
      /DEFINE SDS_EXTENDED
      /COPY QLOG4RPG,SDS
      /UNDEFINE SDS_EXTENDED
      *
      *=========================================================================
      *  Adds a logger to the repository.
      *=========================================================================
      *  Parameters:
      *   i_pLogger     - Handle of the logger as it was returned by
      *                   Logger_getLogger() or Logger_getRootLogger().
      *
      *  Returns:
      *   index         - Returns the index of the logger on success, else -1.
      *=========================================================================
     P Repository_addLogger...
     P                 B                   export
      *
     D Repository_addLogger...
     D                 PI            10I 0
     D  i_pLogger                          const  like(LOG4RPG_hLogger_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return LoggerList_put(g_loggerRepos: i_pLogger);
 
      /END-FREE
      *
     P Repository_addLogger...
     P                 E
      *
      *=========================================================================
      *  Removes a logger from the logger list of the repository.
      *=========================================================================
      *  Parameters:
      *   i_logName     - Name of the logger.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P Repository_removeLogger...
     P                 B                   export
      *
     D Repository_removeLogger...
     D                 PI            10I 0
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return LoggerList_remove(g_loggerRepos: i_logName);
 
      /END-FREE
      *
     P Repository_removeLogger...
     P                 E
      *
      *=========================================================================
      *  Tests, whether the specified logger exists.
      *=========================================================================
      *  Parameters:
      *   i_logName     - Name of the logger.
      *
      *  Returns:
      *   exist         - Returns TRUE if the logger exists, else FALSE.
      *=========================================================================
     P Repository_existLogger...
     P                 B                   export
      *
     D Repository_existLogger...
     D                 PI              N
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      *
     D hLogger         S                   like(LOG4RPG_hLogger_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not LoggerList_exist(g_loggerRepos: i_logName));
            return cFalse;
         endif;
 
         return cTrue;
 
      /END-FREE
      *
     P Repository_existLogger...
     P                 E
      *
      *=========================================================================
      *  Searches the logger list for the specified logger.
      *=========================================================================
      *  Parameters:
      *   i_logName     - Name of the logger.
      *
      *  Returns:
      *   pLogger       - Returns the handle of the logger on success, else
      *                   a NULL handle.
      *=========================================================================
     P Repository_getLogger...
     P                 B                   export
      *
     D Repository_getLogger...
     D                 PI                         like(LOG4RPG_hLogger_t   )
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      *
      *  Return value
     D logger          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(pLogger)
      *
      *  Helper fields
     D c               S             10I 0 inz
      *
      *  Logger handle
     D node            DS                  likeds(LOG4RPG_logger_t)
     D                                     based(pNode)
     D parent          DS                  likeds(LOG4RPG_logger_t)
     D                                     based(pParent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P Repository_getLogger...
     P                 E
      *
      *=========================================================================
      *  Adds an appender to the repository.
      *=========================================================================
      *  Parameters:
      *   i_pAppender   - Handle of the appender as it was returned by
      *                   Appender_new().
      *
      *  Returns:
      *   index         - Returns 0 on success, else -1.
      *=========================================================================
     P Repository_addAppender...
     P                 B                   export
      *
     D Repository_addAppender...
     D                 PI            10I 0
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return AppenderList_put(g_appendRepos: i_pAppender);
 
      /END-FREE
      *
     P Repository_addAppender...
     P                 E
      *
      *=========================================================================
      *  Removes an appender from the appender list of the repository.
      *=========================================================================
      *  Parameters:
      *   i_appName     - Name of the appender.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P Repository_removeAppender...
     P                 B                   export
      *
     D Repository_removeAppender...
     D                 PI            10I 0
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return AppenderList_remove(g_appendRepos: i_appName);
 
      /END-FREE
      *
     P Repository_removeAppender...
     P                 E
      *
      *=========================================================================
      *  Tests, whether the specified appender exists.
      *=========================================================================
      *  Parameters:
      *   i_appName     - Name of the appender.
      *
      *  Returns:
      *   exist         - Returns TRUE if the logger exists, else FALSE.
      *=========================================================================
     P Repository_existAppender...
     P                 B                   export
      *
     D Repository_existAppender...
     D                 PI              N
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return AppenderList_exist(g_appendRepos: i_appName);
 
      /END-FREE
      *
     P Repository_existAppender...
     P                 E
      *
      *=========================================================================
      *  Searches the appender list for the specified appender.
      *=========================================================================
      *  Parameters:
      *   i_appName     - Name of the appender.
      *
      *  Returns:
      *   pAppender     - Returns the handle of the appender on success, else
      *                   a NULL handle.
      *=========================================================================
     P Repository_getAppender...
     P                 B                   export
      *
     D Repository_getAppender...
     D                 PI                         like(LOG4RPG_pAppender_t    )
     D  i_appName                          const  like(LOG4RPG_appenderName_t )
      *
      *  Return value
     D pAppender       S                   like(LOG4RPG_pAppender_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_verbose('Retrieving appender [' + i_appName + ']');
 
         pAppender = AppenderList_get(g_appendRepos: i_appName);
         if Appender_isNull(pAppender);
            return Appender_null();
         else;
            return pAppender;
         endif;
 
      /END-FREE
      *
     P Repository_getAppender...
     P                 E
      *
      *=========================================================================
      *  Adds a filter to the repository.
      *=========================================================================
      *  Parameters:
      *   i_pFilter     - Handle of the filter as it was returned by
      *                   Filter_new().
      *
      *  Returns:
      *   index         - Returns 0 on success, else -1.
      *=========================================================================
     P Repository_addFilter...
     P                 B                   export
      *
     D Repository_addFilter...
     D                 PI            10I 0
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return FilterList_put(g_filterRepos: i_pFilter);
 
      /END-FREE
      *
     P Repository_addFilter...
     P                 E
      *
      *=========================================================================
      *  Removes a filter from the filter list of the repository.
      *=========================================================================
      *  Parameters:
      *   i_fltName     - Name of the filter.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P Repository_removeFilter...
     P                 B                   export
      *
     D Repository_removeFilter...
     D                 PI            10I 0
     D  i_fltName                          const  like(LOG4RPG_filterName_t  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return FilterList_remove(g_filterRepos: i_fltName);
 
      /END-FREE
      *
     P Repository_removeFilter...
     P                 E
      *
      *=========================================================================
      *  Tests, whether the specified filter exists.
      *=========================================================================
      *  Parameters:
      *   i_fltName     - Name of the filter.
      *
      *  Returns:
      *   exist         - Returns TRUE if the logger exists, else FALSE.
      *=========================================================================
     P Repository_existFilter...
     P                 B                   export
      *
     D Repository_existFilter...
     D                 PI              N
     D  i_fltName                          const  like(LOG4RPG_filterName_t  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return FilterList_exist(g_filterRepos: i_fltName);
 
      /END-FREE
      *
     P Repository_existFilter...
     P                 E
      *
      *=========================================================================
      *  Searches the filter list for the specified filter.
      *=========================================================================
      *  Parameters:
      *   i_fltName     - Name of the filter.
      *
      *  Returns:
      *   pFilter       - Returns the handle of the filter on success, else
      *                   a NULL handle.
      *=========================================================================
     P Repository_getFilter...
     P                 B                   export
      *
     D Repository_getFilter...
     D                 PI                         like(LOG4RPG_pFilter_t    )
     D  i_fltName                          const  like(LOG4RPG_filterName_t )
      *
      *  Return value
     D pFilter         S                   like(LOG4RPG_pFilter_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_verbose('Retrieving filter [' + i_fltName + ']');
 
         pFilter = FilterList_get(g_filterRepos: i_fltName);
         if Filter_isNull(pFilter);
            return Filter_null();
         else;
            return pFilter;
         endif;
 
      /END-FREE
      *
     P Repository_getFilter...
     P                 E
      *
      *=========================================================================
      *  Sets the SHUTDOWN-Flag if the repository.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   void
      *=========================================================================
     P Repository_setShutdown...
     P                 B                   export
      *
     D Repository_setShutdown...
     D                 PI
     D  i_isShutdown                   N   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         g_isShutdown = i_isShutdown;
 
         if g_isShutdown;
            LogLog_verbose('Repository SHUTDOWN mode set to ON');
         else;
            LogLog_verbose('Repository SHUTDOWN mode set to OFF');
         endif;
 
         return;
 
      /END-FREE
      *
     P Repository_setShutdown...
     P                 E
      *
      *=========================================================================
      *  Tests, if the repository is in SHUTDOWN mode.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   void
      *=========================================================================
     P Repository_isShutdown...
     P                 B                   export
      *
     D Repository_isShutdown...
     D                 PI              N
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return g_isShutdown;
 
      /END-FREE
      *
     P Repository_isShutdown...
     P                 E
      *
      *=========================================================================
      *  Initializes the logger repository.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   void
      *=========================================================================
     P Repository_initialize...
     P                 B                   export
      *
     D Repository_initialize...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         initializeModule();
 
         return;
 
      /END-FREE
      *
     P Repository_initialize...
     P                 E
      *
      *=========================================================================
      *  Prepare repository for re-loading configuration data.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   void
      *=========================================================================
     P Repository_prepareReload...
     P                 B                   export
      *
     D Repository_prepareReload...
     D                 PI
      *
      *  Helper fields
     D x               S             10I 0 inz
     D pNode           S                   like(LOG4RPG_hLogger_t       ) inz
     D nodeIter        DS                  likeds(LOG4RPG_Logger...
     D                                                    ListIterator_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P Repository_prepareReload...
     P                 E
      *
      *===============================================================*
      *  Dumps the tree of children of a given logger.
      *===============================================================*
     P Repository_dumpHierarchy...
     P                 B                   export
     D                 PI
     D  i_pLogger                          const  like(LOG4RPG_hLogger_t )
     D                                            options(*nopass)
      *
      *  Parameter positions
     D p_pLogger       C                   1
      *
      *  Optional parameter fields
     D pLogger         S                   like(i_pLogger) inz
      *
      *  Helper fields
     D x               S             10I 0 inz
     D numChildren     S             10I 0 inz
     D logger          DS                  likeds(LOG4RPG_logger_t  )
     D                                     based(pLogger)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
     P                 E
      *
      *===============================================================*
      *  *** Private ***
      *  Dumps the tree of children of a given logger.
      *===============================================================*
     P dumpHierarchy...
     P                 B
     D                 PI
     D  i_pLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_level                      10I 0 const
      *
      *  Helper fields
     D x               S             10I 0 inz
     D numChildren     S             10I 0 inz
     D logger          DS                  likeds(LOG4RPG_logger_t  )
     D                                     based(pLogger)
     D child           DS                  likeds(LOG4RPG_logger_t  )
     D                                     based(pChild)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
     P                 E
      *
      *=========================================================================
      *  Clears the repository.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   void
      *=========================================================================
     P Repository_clear...
     P                 B                   export
      *
     D Repository_clear...
     D                 PI
      *
      *  Helper fields
     D x               S             10I 0 inz
     D pNode           S                   like(LOG4RPG_hLogger_t       ) inz
     D nodeIter        DS                  likeds(LOG4RPG_Logger...
     D                                                    ListIterator_t) inz
     D pAppender       S                   like(LOG4RPG_pAppender_t     ) inz
     D appIter         DS                  likeds(LOG4RPG_Appender...
     D                                                    ListIterator_t) inz
     D pFilter         S                   like(LOG4RPG_pFilter_t       ) inz
     D fltIter         DS                  likeds(LOG4RPG_Filter...
     D                                                    ListIterator_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Set repository SHUTDOWN-mode
         Repository_setShutdown(cTrue);
 
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
 
      /END-FREE
      *
     P Repository_clear...
     P                 E
      *
      *=========================================================================
      *  Clears all filters in the repository.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   void
      *=========================================================================
     P Repository_clearFilters...
     P                 B                   export
      *
     D Repository_clearFilters...
     D                 PI
      *
      *  Helper fields
     D x               S             10I 0 inz
     D pFilter         S                   like(LOG4RPG_pFilter_t       ) inz
     D fltIter         DS                  likeds(LOG4RPG_Filter...
     D                                                    ListIterator_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P Repository_clearFilters...
     P                 E
      *
      *=========================================================================
      *  Clears all appenders in the repository.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   void
      *=========================================================================
     P Repository_clearAppenders...
     P                 B                   export
      *
     D Repository_clearAppenders...
     D                 PI
      *
      *  Helper fields
     D x               S             10I 0 inz
     D pAppender       S                   like(LOG4RPG_pAppender_t     ) inz
     D appIter         DS                  likeds(LOG4RPG_Appender...
     D                                                    ListIterator_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P Repository_clearAppenders...
     P                 E
      *
      *===============================================================*
    R *  *** PRIVATE ***
      *  Free resources  on termination of activation group.
      *===============================================================*
      *  ag_mark (input)
      *      The activation group mark that uniquely identifies the activation
      *      group within the job.
      *  reason (input)
      *      The reason for the activation group being ended.  See Figure 2-1 for a
      *      description of the reason codes.
      *  result_code (I/O)
      *      The value passed as input is the action to be taken as specified by a
      *      previous exit procedure.  The value passed to the first exit procedure
      *      is 0.  The output value can specify an action to be taken.  If the
      *      result code does not match any of the following actions, the output
      *      value is ignored and the previous action remains unchanged.
      *
      *      No action
      *         0           Do not change the action.
      *
      *      Recover
      *         10          Do not perform any pending error requests.  This is
      *                             used if a previous exit procedure specified a result
      *                             code of 20 and a subsequent procedure recovers from
      *                             the error.  The message CEE9901, indicating an
      *                             application error, is not sent.
      *      Failure
      *
      *         20          Send message CEE9901 to the caller of the control
      *                     boundary after the remaining exit procedures are
      *                     called.
      *         21          Send message CEE9901 to the caller of the control
      *                     boundary.  The remaining exit procedures registered by
      *                     the CEE4RAGE API are not called.  This is used if an
      *                     unrecoverable error occurs in the exit procedure
      *                     requesting this action.
      *
      *  user_rc (I/O)
      *      The value passed as input is the user_rc returned as output from the
      *      previous exit procedure.  The value passed to the first exit procedure
      *      is 0.
      *
      *===============================================================*
     P PRIVATE_onActivationGroupEnd...
     P                 B                   export
      *
     D PRIVATE_onActivationGroupEnd...
     D                 PI
     D  i_ag_mark                    10U 0 const
     D  i_reason                     10U 0 const
     D  io_result_code...
     D                               10U 0
     D  io_user_rc                   10U 0
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P PRIVATE_onActivationGroupEnd...
     P                 E
      *
      *===============================================================*
    R *  *** Private ***
      *  Updates the parents of a given logger.
      *===============================================================*
     P updateParents...
     P                 B
      *
     D updateParents...
     D                 PI
     D  i_pLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Helper fields
     D x               S             10I 0 inz
     D logName         S                   like(LOG4RPG_loggerName_t) inz
     D substr          S                   like(logName             ) inz
     D parent          DS                  likeds(LOG4RPG_logger_t  )
     D                                     based(pParent)
     D child           DS                  likeds(LOG4RPG_logger_t  )
     D                                     based(pChild)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 B01
         if (Node_getParent(pChild) = Node_null());
            logName = Logger_getName(pChild);
            LogLog_debug('Parent not found. Set parent of node [' + logName                 //RADDAT
                          + '] to ''root''.');
            Node_addChild(Repository_getLogger(cROOT_LOGGER): pChild);
         endif;
 
      /END-FREE
      *
     P updateParents...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Initializes this module.
      *=========================================================================
     P initializeModule...
     P                 B
      *
     D initializeModule...
     D                 PI
      *
      *  Return value
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if g_isInit;
            return;
         endif;
 
         Loglog_verbose('Initializing module ' + sds.modContProc + '...');
 
         // Disable Repository SHUTDOWN-mode
         Repository_setShutdown(cFalse);
 
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
         g_isInit = cTrue;
 
         return;
 
      /END-FREE
      *
     P initializeModule...
     P                 E
      *
