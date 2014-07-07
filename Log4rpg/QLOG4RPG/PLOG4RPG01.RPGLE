      /IF NOT DEFINED(PLOG4RPG01)
      /DEFINE PLOG4RPG01
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
      *    Refer to: PLOG4RPG
      *
      *  Creates a new logger instance.
     D Logger_new...
     D                 PR                         like(LOG4RPG_hLogger_t )
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_new+
     D                                     ')
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      *
      *  Resets the logging level of the specified logger to use the
      *  log level of the parent logger.
     D Logger_resetLevel...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_resetLevel+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Adds an appender to the specified logger.
      *  ==> PLOG4RPG
      *
      *  Removes the specified appender from a given logger.
     D Logger_removeAppender...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_removeAppender+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t       )
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
      *
      *  Removes all appenders from the specified logger.
     D Logger_removeAllAppenders...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_removeAllAppenders+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
      *
      *  Deletes a logger.
     D Logger_delete...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_delete+
     D                                     ')
     D  io_hLogger                                like(LOG4RPG_hLogger_t )
      *
      *  Adds a child to the specified logger node.
     D Logger_addChild...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_addChild+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_hChild                           const  like(LOG4RPG_hLogger_t )
      *
      *  Sets the parent logger of the specified logger.
     D Logger_setParent...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_setParent+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_hParent                          const  like(LOG4RPG_hLogger_t )
      *
      *  Returns the parent of the specified logger.
     D Logger_getParent...
     D                 PR                         like(LOG4RPG_hLogger_t )
     D                                     extproc('LOG4RPG01+
     D                                     _Logger_getParent+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  returns the name of a given Node.
     D Node_getName...
     D                 PR                         like(LOG4RPG_loggerName_t)
     D                                     extproc('LOG4RPG01+
     D                                     _Node_getName+
     D                                     ')
     D  i_hNode                            const  like(LOG4RPG_hLogger_t )
      *
      *  Test the specified logger handle for a logger node.
     D Node_isLoggerNode...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Node_isLoggerNode+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Test the specified logger handle for a provision node.
     D Node_isProvisionNode...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Node_isProvisionNode+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Returns the number of children of the specified node.
     D Node_getNumChildren...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG01+
     D                                     _Node_getNumChildren+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
      *
      *  Returns a reference to a child of the specified node.
     D Node_getChild...
     D                 PR                         like(LOG4RPG_hLogger_t   )
     D                                     extproc('LOG4RPG01+
     D                                     _Node_getChild+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
     D  i_index                      10I 0 const
      *
      *  Adds a child to the specified node.
     D Node_addChild...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG01+
     D                                     _Node_addChild+
     D                                     ')
     D  i_hNode                            const  like(LOG4RPG_hLogger_t   )
     D  i_hChild                           const  like(LOG4RPG_hLogger_t   )
      *
      *  Sets the parent node of the specified node.
     D Node_setParent...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _Node_setParent+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_hParent                          const  like(LOG4RPG_hLogger_t )
      *
      *  Returns the parent node of a given node.
     D Node_getParent...
     D                 PR                         like(LOG4RPG_hLogger_t )
     D                                     extproc('LOG4RPG01+
     D                                     _Node_getParent+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      *
      *  Removes a child from the list of children of the specified node.
     D Node_removeChild...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG01+
     D                                     _Node_removeChild+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
     D  i_index                      10I 0 const
      *
      *  Searches the children of a given node for a given child.
     D Node_findChild...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG01+
     D                                     _Node_findChild+
     D                                     ')
     D  i_hNode                            const  like(LOG4RPG_hLogger_t )
     D  i_hChild                           const  like(LOG4RPG_hLogger_t )
      *
      *  Tests the specified node handle for a NULL value.
     D Node_isNull...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _Node_isNull+
     D                                     ')
     D  i_hNode                            const  like(LOG4RPG_hLogger_t )
      *
      *  Returns a node NULL handle.
     D Node_null...
     D                 PR                         like(LOG4RPG_hLogger_t )
     D                                     extproc('LOG4RPG01+
     D                                     _Node_null+
     D                                     ')
      *
      *  Returns a brief description of the node.
     D Node_toString...
     D                 PR           117A          varying
     D                                     extproc('LOG4RPG01+
     D                                     _Node_toString+
     D                                     ')
     D  i_hNode                            const  like(LOG4RPG_hLogger_t   )
      *
      *  Returns the number of children of the specified provision node.
     D ProvisionNode_getNumChildren...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG01+
     D                                     _ProvisionNode_getNumChildren+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
      *
      *  Adds a child to the specified provision node.
     D ProvisionNode_addChild...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG01+
     D                                     _ProvisionNode_addChild+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
     D  i_hChild                           const  like(LOG4RPG_hLogger_t   )
      *
      *  Returns a reference to a child of the specified provision node.
     D ProvisionNode_getChild...
     D                 PR                         like(LOG4RPG_hLogger_t   )
     D                                     extproc('LOG4RPG01+
     D                                     _ProvisionNode_getChild+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
     D  i_index                      10I 0 const
      *
      *  Removes a child from the list of children of the specified logger.
     D ProvisionNode_removeChild...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG01+
     D                                     _ProvisionNode_removeChild+
     D                                     ')
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
     D  i_index                      10I 0 const
      *
      *  Sets the parent node of the specified logger.
     D ProvisionNode_setParent...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _ProvisionNode_setParent+
     D                                     ')
     D  i_hProvNode                        const  like(LOG4RPG_hLogger_t )
     D  i_hParent                          const  like(LOG4RPG_hLogger_t )
      *
      *  Returns the parent node of a given provision node.
     D ProvisionNode_getParent...
     D                 PR                         like(LOG4RPG_hLogger_t )
     D                                     extproc('LOG4RPG01+
     D                                     _ProvisionNode_getParent+
     D                                     ')
     D  i_hProvNode                        const  like(LOG4RPG_hLogger_t )
      *
      *  Factory: Produces a provision node and adds a child to it.
     D ProvisionNode_makeProvisionNode...
     D                 PR                         like(LOG4RPG_hLogger_t )
     D                                     extproc('LOG4RPG01+
     D                                     _ProvisionNode_makeProvisionNode+
     D                                     ')
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
     D  i_hChild                           const  like(LOG4RPG_hLogger_t   )
      *
      *  Frees a provision node.
     D ProvisionNode_free...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _ProvisionNode_free+
     D                                     ')
     D  io_hProvNode                              like(LOG4RPG_hLogger_t )
      *
      *  Moves the children to a given logger node.
     D ProvisionNode_moveChildren...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _ProvisionNode_moveChildren+
     D                                     ')
     D  i_hProvNode                               like(LOG4RPG_hLogger_t )
     D  i_hLogger                                 like(LOG4RPG_hLogger_t )
      *
      *  Tests the specified provision node handle for a NULL value.
     D ProvisionNode_isNull...
     D                 PR              N
     D                                     extproc('LOG4RPG01+
     D                                     _ProvisionNode_isNull+
     D                                     ')
     D  i_hNode                            const  like(LOG4RPG_hLogger_t )
      *
      *  Returns a provision node NULL handle.
     D ProvisionNode_null...
     D                 PR                         like(LOG4RPG_hLogger_t )
     D                                     extproc('LOG4RPG01+
     D                                     _ProvisionNode_null+
     D                                     ')
      *
      *  Sets an offset to let f_caller() skip the Log4rpg stub module
      *  if present.
      /IF NOT DEFINED(LOGGER_STUB)
     D setStubOfs...
     D                 PR
     D                                     extproc('LOG4RPG01+
     D                                     _setStubOfs Internal Use Only+
     D                                     ')
      /ELSE
     D setStubOfs...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.setStubOfs
     D                                     )
      /ENDIF
     D  i_stubOfs                     3I 0 const
      *
      /ENDIF
