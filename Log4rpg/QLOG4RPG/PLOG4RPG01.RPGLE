**FREE
/IF NOT DEFINED(PLOG4RPG01)
/DEFINE PLOG4RPG01
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
//    Refer to: PLOG4RPG
//
//  Creates a new logger instance.
dcl-pr Logger_new
       like(LOG4RPG_hLogger_t )
       extproc('LOG4RPG01+
       _Logger_new+
       ');
  i_logName       const  like(LOG4RPG_loggerName_t);
end-pr;
//
//  Resets the logging level of the specified logger to use the
//  log level of the parent logger.
dcl-pr Logger_resetLevel
       extproc('LOG4RPG01+
       _Logger_resetLevel+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t );
end-pr;
//
//  Adds an appender to the specified logger.
//  ==> PLOG4RPG
//
//  Removes the specified appender from a given logger.
dcl-pr Logger_removeAppender
       extproc('LOG4RPG01+
       _Logger_removeAppender+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t       );
  i_appName       const  like(LOG4RPG_appenderName_t  );
end-pr;
//
//  Removes all appenders from the specified logger.
dcl-pr Logger_removeAllAppenders
       extproc('LOG4RPG01+
       _Logger_removeAllAppenders+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t   );
end-pr;
//
//  Deletes a logger.
dcl-pr Logger_delete
       extproc('LOG4RPG01+
       _Logger_delete+
       ');
  io_hLogger      like(LOG4RPG_hLogger_t );
end-pr;
//
//  Adds a child to the specified logger node.
dcl-pr Logger_addChild
       int(10)
       extproc('LOG4RPG01+
       _Logger_addChild+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t );
  i_hChild        const  like(LOG4RPG_hLogger_t );
end-pr;
//
//  Sets the parent logger of the specified logger.
dcl-pr Logger_setParent
       extproc('LOG4RPG01+
       _Logger_setParent+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t );
  i_hParent       const  like(LOG4RPG_hLogger_t );
end-pr;
//
//  Returns the parent of the specified logger.
dcl-pr Logger_getParent
       like(LOG4RPG_hLogger_t )
       extproc('LOG4RPG01+
       _Logger_getParent+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t );
end-pr;
//
//  returns the name of a given Node.
dcl-pr Node_getName
       like(LOG4RPG_loggerName_t)
       extproc('LOG4RPG01+
       _Node_getName+
       ');
  i_hNode         const  like(LOG4RPG_hLogger_t );
end-pr;
//
//  Test the specified logger handle for a logger node.
dcl-pr Node_isLoggerNode
       ind
       extproc('LOG4RPG01+
       _Node_isLoggerNode+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t );
end-pr;
//
//  Test the specified logger handle for a provision node.
dcl-pr Node_isProvisionNode
       ind
       extproc('LOG4RPG01+
       _Node_isProvisionNode+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t );
end-pr;
//
//  Returns the number of children of the specified node.
dcl-pr Node_getNumChildren
       int(10)
       extproc('LOG4RPG01+
       _Node_getNumChildren+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t   );
end-pr;
//
//  Returns a reference to a child of the specified node.
dcl-pr Node_getChild
       like(LOG4RPG_hLogger_t   )
       extproc('LOG4RPG01+
       _Node_getChild+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t   );
  i_index         int(10) const;
end-pr;
//
//  Adds a child to the specified node.
dcl-pr Node_addChild
       int(10)
       extproc('LOG4RPG01+
       _Node_addChild+
       ');
  i_hNode         const  like(LOG4RPG_hLogger_t   );
  i_hChild        const  like(LOG4RPG_hLogger_t   );
end-pr;
//
//  Sets the parent node of the specified node.
dcl-pr Node_setParent
       extproc('LOG4RPG01+
       _Node_setParent+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t );
  i_hParent       const  like(LOG4RPG_hLogger_t );
end-pr;
//
//  Returns the parent node of a given node.
dcl-pr Node_getParent
       like(LOG4RPG_hLogger_t )
       extproc('LOG4RPG01+
       _Node_getParent+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t );
end-pr;
//
//  Removes a child from the list of children of the specified node.
dcl-pr Node_removeChild
       int(10)
       extproc('LOG4RPG01+
       _Node_removeChild+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t   );
  i_index         int(10) const;
end-pr;
//
//  Searches the children of a given node for a given child.
dcl-pr Node_findChild
       int(10)
       extproc('LOG4RPG01+
       _Node_findChild+
       ');
  i_hNode         const  like(LOG4RPG_hLogger_t );
  i_hChild        const  like(LOG4RPG_hLogger_t );
end-pr;
//
//  Tests the specified node handle for a NULL value.
dcl-pr Node_isNull
       ind
       extproc('LOG4RPG01+
       _Node_isNull+
       ');
  i_hNode         const  like(LOG4RPG_hLogger_t );
end-pr;
//
//  Returns a node NULL handle.
dcl-pr Node_null
       like(LOG4RPG_hLogger_t )
       extproc('LOG4RPG01+
       _Node_null+
       ');
end-pr;
//
//  Returns a brief description of the node.
dcl-pr Node_toString
       varchar(117)
       extproc('LOG4RPG01+
       _Node_toString+
       ');
  i_hNode         const  like(LOG4RPG_hLogger_t   );
end-pr;
//
//  Returns the number of children of the specified provision node.
dcl-pr ProvisionNode_getNumChildren
       int(10)
       extproc('LOG4RPG01+
       _ProvisionNode_getNumChildren+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t   );
end-pr;
//
//  Adds a child to the specified provision node.
dcl-pr ProvisionNode_addChild
       int(10)
       extproc('LOG4RPG01+
       _ProvisionNode_addChild+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t   );
  i_hChild        const  like(LOG4RPG_hLogger_t   );
end-pr;
//
//  Returns a reference to a child of the specified provision node.
dcl-pr ProvisionNode_getChild
       like(LOG4RPG_hLogger_t   )
       extproc('LOG4RPG01+
       _ProvisionNode_getChild+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t   );
  i_index         int(10) const;
end-pr;
//
//  Removes a child from the list of children of the specified logger.
dcl-pr ProvisionNode_removeChild
       int(10)
       extproc('LOG4RPG01+
       _ProvisionNode_removeChild+
       ');
  i_hLogger       const  like(LOG4RPG_hLogger_t   );
  i_index         int(10) const;
end-pr;
//
//  Sets the parent node of the specified logger.
dcl-pr ProvisionNode_setParent
       extproc('LOG4RPG01+
       _ProvisionNode_setParent+
       ');
  i_hProvNode     const  like(LOG4RPG_hLogger_t );
  i_hParent       const  like(LOG4RPG_hLogger_t );
end-pr;
//
//  Returns the parent node of a given provision node.
dcl-pr ProvisionNode_getParent
       like(LOG4RPG_hLogger_t )
       extproc('LOG4RPG01+
       _ProvisionNode_getParent+
       ');
  i_hProvNode     const  like(LOG4RPG_hLogger_t );
end-pr;
//
//  Factory: Produces a provision node and adds a child to it.
dcl-pr ProvisionNode_makeProvisionNode
       like(LOG4RPG_hLogger_t )
       extproc('LOG4RPG01+
       _ProvisionNode_makeProvisionNode+
       ');
  i_logName       const  like(LOG4RPG_loggerName_t);
  i_hChild        const  like(LOG4RPG_hLogger_t   );
end-pr;
//
//  Frees a provision node.
dcl-pr ProvisionNode_free
       extproc('LOG4RPG01+
       _ProvisionNode_free+
       ');
  io_hProvNode    like(LOG4RPG_hLogger_t );
end-pr;
//
//  Moves the children to a given logger node.
dcl-pr ProvisionNode_moveChildren
       extproc('LOG4RPG01+
       _ProvisionNode_moveChildren+
       ');
  i_hProvNode     like(LOG4RPG_hLogger_t );
  i_hLogger       like(LOG4RPG_hLogger_t );
end-pr;
//
//  Tests the specified provision node handle for a NULL value.
dcl-pr ProvisionNode_isNull
       ind
       extproc('LOG4RPG01+
       _ProvisionNode_isNull+
       ');
  i_hNode         const  like(LOG4RPG_hLogger_t );
end-pr;
//
//  Returns a provision node NULL handle.
dcl-pr ProvisionNode_null
       like(LOG4RPG_hLogger_t )
       extproc('LOG4RPG01+
       _ProvisionNode_null+
       ');
end-pr;
//
//  Sets an offset to let f_caller() skip the Log4rpg stub module
//  if present.
/IF NOT DEFINED(LOGGER_STUB)
dcl-pr setStubOfs
       extproc('LOG4RPG01+
       _setStubOfs Internal Use Only+
       ');
/ELSE
dcl-pr setStubOfs
       extproc(
       g_procptr.setStubOfs
       );
/ENDIF
     i_stubOfs                     int(5) const
end-pr;

/ENDIF
