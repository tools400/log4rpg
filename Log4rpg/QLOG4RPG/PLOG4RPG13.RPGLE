**FREE
/IF NOT DEFINED(PLOG4RPG13)
/DEFINE PLOG4RPG13
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/COPY QLOG4RPG,PTYPES                        Private type definitions
//
// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
//
//  Adds a logger to the repository.
dcl-pr Repository_addLogger
       int(10)
       extproc('LOG4RPG13+
       _Repository_addLogger+
       ');
  i_pLogger       const  like(LOG4RPG_hLogger_t );
end-pr;
//
//  Removes a logger from the logger list of the repository.
dcl-pr Repository_removeLogger
       int(10)
       extproc('LOG4RPG13+
       _Repository_removeLogger+
       ');
  i_logName       const  like(LOG4RPG_loggerName_t);
end-pr;
//
//  Test, whether the specified logger exists in the logger list.
dcl-pr Repository_existLogger
       ind
       extproc('LOG4RPG13+
       _Repository_existLogger+
       ');
  i_logName       const  like(LOG4RPG_loggerName_t);
end-pr;
//
//  Searches the logger list for the specified logger.
dcl-pr Repository_getLogger
       like(LOG4RPG_hLogger_t )
       extproc('LOG4RPG13+
       _Repository_getLogger+
       ');
  i_logName       const  like(LOG4RPG_loggerName_t);
end-pr;
//
//  Adds an appender to the repository.
dcl-pr Repository_addAppender
       int(10)
       extproc('LOG4RPG13+
       _Repository_addAppender+
       ');
  i_pAppender     const  like(LOG4RPG_pAppender_t);
end-pr;
//
//  Removes an appender from the appender list of the repository.
dcl-pr Repository_removeAppender
       int(10)
       extproc('LOG4RPG13+
       _Repository_removeAppender+
       ');
  i_appName       const  like(LOG4RPG_appenderName_t  );
end-pr;
//
//  Test, whether the specified logger exists in the logger list.
dcl-pr Repository_existAppender
       ind
       extproc('LOG4RPG13+
       _Repository_existAppender+
       ');
  i_appName       const  like(LOG4RPG_appenderName_t  );
end-pr;
//
//  Searches the appender list for the specified appender.
dcl-pr Repository_getAppender
       like(LOG4RPG_pAppender_t    )
       extproc('LOG4RPG13+
       _Repository_getAppender+
       ');
  i_appName       const  like(LOG4RPG_appenderName_t );
end-pr;
//
//  Adds a filter to the repository.
dcl-pr Repository_addFilter
       int(10)
       extproc('LOG4RPG13+
       _Repository_addFilter+
       ');
  i_pFilter       const  like(LOG4RPG_pFilter_t);
end-pr;
//
//  Removes a filter from the filter list of the repository.
dcl-pr Repository_removeFilter
       int(10)
       extproc('LOG4RPG13+
       _Repository_removeFilter+
       ');
  i_fltName       const  like(LOG4RPG_filterName_t  );
end-pr;
//
//  Test, whether the specified filter exists in the filter list.
dcl-pr Repository_existFilter
       ind
       extproc('LOG4RPG13+
       _Repository_existFilter+
       ');
  i_fltName       const  like(LOG4RPG_filterName_t  );
end-pr;
//
//  Searches the filter list for the specified filter.
dcl-pr Repository_getFilter
       like(LOG4RPG_pFilter_t    )
       extproc('LOG4RPG13+
       _Repository_getFilter+
       ');
  i_fltName       const  like(LOG4RPG_filterName_t );
end-pr;
//
//  Initializes the logger repositiory.
dcl-pr Repository_initialize
       extproc('LOG4RPG13+
       _Repository_initialize+
       ');
end-pr;
//
//  Prepare repository for re-loading configuration data.
dcl-pr Repository_prepareReload
       extproc('LOG4RPG13+
       _Repository_prepareReload+
       ');
end-pr;
//
//  Dumps the children of a given logger.
dcl-pr Repository_dumpHierarchy
       extproc('LOG4RPG13+
       _Repository_dumpHierarchy+
       ');
  i_pLogger       const  like(LOG4RPG_hLogger_t )
       options(*nopass);
end-pr;
//
//  Clears the repository.
dcl-pr Repository_clear
       extproc('LOG4RPG13+
       _Repository_clear+
       ');
end-pr;
//
//  Clears all filters in the repository.
dcl-pr Repository_clearFilters
       extproc('LOG4RPG13+
       _Repository_clearFilters+
       ');
end-pr;
//
//  Clears all appenders in the repository.
dcl-pr Repository_clearAppenders
       extproc('LOG4RPG13+
       _Repository_clearAppenders+
       ');
end-pr;
//
//  Sets the SHUTDOWN-Flag if the repository.
dcl-pr Repository_setShutdown
       extproc('LOG4RPG13+
       _Repository_setShutdown+
       ');
  i_isShutdown    ind const;
end-pr;
//
//  Tests, if the repository is in SHUTDOWN mode.
dcl-pr Repository_isShutdown
       ind
       extproc('LOG4RPG13+
       _Repository_isShutdown+
       ');
end-pr;
//
/ENDIF
