**free
/if NOT defined(PLOG4RPG13)
/define PLOG4RPG13

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PTYPES Private type definitions

// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------

//  Adds a logger to the repository.
dcl-pr Repository_addLogger int(10) extproc('LOG4RPG13_Repository_addLogger');
  i_pLogger like(LOG4RPG_hLogger_t) const;
end-pr;

//  Removes a logger from the logger list of the repository.
dcl-pr Repository_removeLogger int(10) extproc('LOG4RPG13_Repository_removeLogger');
  i_logName like(LOG4RPG_loggerName_t) const;
end-pr;

//  Test, whether the specified logger exists in the logger list.
dcl-pr Repository_existLogger ind extproc('LOG4RPG13_Repository_existLogger');
  i_logName like(LOG4RPG_loggerName_t) const;
end-pr;

//  Searches the logger list for the specified logger.
dcl-pr Repository_getLogger like(LOG4RPG_hLogger_t) extproc('LOG4RPG13_Repository_getLogger');
  i_logName like(LOG4RPG_loggerName_t) const;
end-pr;

//  Adds an appender to the repository.
dcl-pr Repository_addAppender int(10) extproc('LOG4RPG13_Repository_addAppender');
  i_pAppender like(LOG4RPG_pAppender_t) const;
end-pr;

//  Removes an appender from the appender list of the repository.
dcl-pr Repository_removeAppender int(10) extproc('LOG4RPG13_Repository_removeAppender');
  i_appName like(LOG4RPG_appenderName_t) const;
end-pr;

//  Test, whether the specified logger exists in the logger list.
dcl-pr Repository_existAppender ind extproc('LOG4RPG13_Repository_existAppender');
  i_appName like(LOG4RPG_appenderName_t) const;
end-pr;

//  Searches the appender list for the specified appender.
dcl-pr Repository_getAppender like(LOG4RPG_pAppender_t) extproc('LOG4RPG13_Repository_getAppender');
  i_appName like(LOG4RPG_appenderName_t) const;
end-pr;

//  Adds a filter to the repository.
dcl-pr Repository_addFilter int(10) extproc('LOG4RPG13_Repository_addFilter');
  i_pFilter like(LOG4RPG_pFilter_t) const;
end-pr;

//  Removes a filter from the filter list of the repository.
dcl-pr Repository_removeFilter int(10) extproc('LOG4RPG13_Repository_removeFilter');
  i_fltName like(LOG4RPG_filterName_t) const;
end-pr;

//  Test, whether the specified filter exists in the filter list.
dcl-pr Repository_existFilter ind extproc('LOG4RPG13_Repository_existFilter');
  i_fltName like(LOG4RPG_filterName_t) const;
end-pr;

//  Searches the filter list for the specified filter.
dcl-pr Repository_getFilter like(LOG4RPG_pFilter_t) extproc('LOG4RPG13_Repository_getFilter');
  i_fltName like(LOG4RPG_filterName_t) const;
end-pr;

//  Initializes the logger repositiory.
dcl-pr Repository_initialize extproc('LOG4RPG13_Repository_initialize');
end-pr;

//  Prepare repository for re-loading configuration data.
dcl-pr Repository_prepareReload extproc('LOG4RPG13_Repository_prepareReload');
end-pr;

//  Dumps the children of a given logger.
dcl-pr Repository_dumpHierarchy extproc('LOG4RPG13_Repository_dumpHierarchy');
  i_pLogger like(LOG4RPG_hLogger_t) options(*nopass) const;
end-pr;

//  Clears the repository.
dcl-pr Repository_clear extproc('LOG4RPG13_Repository_clear');
end-pr;

//  Clears all filters in the repository.
dcl-pr Repository_clearFilters extproc('LOG4RPG13_Repository_clearFilters');
end-pr;

//  Clears all appenders in the repository.
dcl-pr Repository_clearAppenders extproc('LOG4RPG13_Repository_clearAppenders');
end-pr;

//  Sets the SHUTDOWN-Flag if the repository.
dcl-pr Repository_setShutdown extproc('LOG4RPG13_Repository_setShutdown');
  i_isShutdown ind const;
end-pr;

//  Tests, if the repository is in SHUTDOWN mode.
dcl-pr Repository_isShutdown ind extproc('LOG4RPG13_Repository_isShutdown');
end-pr;

/endif