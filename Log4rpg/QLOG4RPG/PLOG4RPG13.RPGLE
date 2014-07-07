      /IF NOT DEFINED(PLOG4RPG13)
      /DEFINE PLOG4RPG13
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PTYPES                        Private type definitions
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Adds a logger to the repository.
     D Repository_addLogger...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_addLogger+
     D                                     ')
     D  i_pLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Removes a logger from the logger list of the repository.
     D Repository_removeLogger...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_removeLogger+
     D                                     ')
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      *
      *  Test, whether the specified logger exists in the logger list.
     D Repository_existLogger...
     D                 PR              N
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_existLogger+
     D                                     ')
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      *
      *  Searches the logger list for the specified logger.
     D Repository_getLogger...
     D                 PR                         like(LOG4RPG_hLogger_t )
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_getLogger+
     D                                     ')
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      *
      *  Adds an appender to the repository.
     D Repository_addAppender...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_addAppender+
     D                                     ')
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t)
      *
      *  Removes an appender from the appender list of the repository.
     D Repository_removeAppender...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_removeAppender+
     D                                     ')
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
      *
      *  Test, whether the specified logger exists in the logger list.
     D Repository_existAppender...
     D                 PR              N
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_existAppender+
     D                                     ')
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
      *
      *  Searches the appender list for the specified appender.
     D Repository_getAppender...
     D                 PR                         like(LOG4RPG_pAppender_t    )
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_getAppender+
     D                                     ')
     D  i_appName                          const  like(LOG4RPG_appenderName_t )
      *
      *  Adds a filter to the repository.
     D Repository_addFilter...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_addFilter+
     D                                     ')
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t)
      *
      *  Removes a filter from the filter list of the repository.
     D Repository_removeFilter...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_removeFilter+
     D                                     ')
     D  i_fltName                          const  like(LOG4RPG_filterName_t  )
      *
      *  Test, whether the specified filter exists in the filter list.
     D Repository_existFilter...
     D                 PR              N
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_existFilter+
     D                                     ')
     D  i_fltName                          const  like(LOG4RPG_filterName_t  )
      *
      *  Searches the filter list for the specified filter.
     D Repository_getFilter...
     D                 PR                         like(LOG4RPG_pFilter_t    )
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_getFilter+
     D                                     ')
     D  i_fltName                          const  like(LOG4RPG_filterName_t )
      *
      *  Initializes the logger repositiory.
     D Repository_initialize...
     D                 PR
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_initialize+
     D                                     ')
      *
      *  Prepare repository for re-loading configuration data.
     D Repository_prepareReload...
     D                 PR
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_prepareReload+
     D                                     ')
      *
      *  Dumps the children of a given logger.
     D Repository_dumpHierarchy...
     D                 PR
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_dumpHierarchy+
     D                                     ')
     D  i_pLogger                          const  like(LOG4RPG_hLogger_t )
     D                                            options(*nopass)
      *
      *  Clears the repository.
     D Repository_clear...
     D                 PR
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_clear+
     D                                     ')
      *
      *  Clears all filters in the repository.
     D Repository_clearFilters...
     D                 PR
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_clearFilters+
     D                                     ')
      *
      *  Clears all appenders in the repository.
     D Repository_clearAppenders...
     D                 PR
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_clearAppenders+
     D                                     ')
      *
      *  Sets the SHUTDOWN-Flag if the repository.
     D Repository_setShutdown...
     D                 PR
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_setShutdown+
     D                                     ')
     D  i_isShutdown                   N   const
      *
      *  Tests, if the repository is in SHUTDOWN mode.
     D Repository_isShutdown...
     D                 PR              N
     D                                     extproc('LOG4RPG13+
     D                                     _Repository_isShutdown+
     D                                     ')
      *
      /ENDIF
