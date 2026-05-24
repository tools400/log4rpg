**free
/if NOT defined(PLOG4RPG01)
/define PLOG4RPG01

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
//    Refer to: PLOG4RPG

//  Creates a new logger instance.
dcl-pr Logger_new like(LOG4RPG_hLogger_t) extproc('LOG4RPG01_Logger_new');
  i_logName like(LOG4RPG_loggerName_t) const;
end-pr;

//  Resets the logging level of the specified logger to use the
//  log level of the parent logger.
dcl-pr Logger_resetLevel extproc('LOG4RPG01_Logger_resetLevel');
  i_hLogger like(LOG4RPG_hLogger_t) const;
end-pr;

//  Adds an appender to the specified logger.
//  ==> PLOG4RPG

//  Removes the specified appender from a given logger.
dcl-pr Logger_removeAppender extproc('LOG4RPG01_Logger_removeAppender');
  i_hLogger like(LOG4RPG_hLogger_t) const;
  i_appName like(LOG4RPG_appenderName_t) const;
end-pr;

//  Removes all appenders from the specified logger.
dcl-pr Logger_removeAllAppenders extproc('LOG4RPG01_Logger_removeAllAppenders');
  i_hLogger like(LOG4RPG_hLogger_t) const;
end-pr;

//  Deletes a logger.
dcl-pr Logger_delete extproc('LOG4RPG01_Logger_delete');
  io_hLogger like(LOG4RPG_hLogger_t);
end-pr;

//  Adds a child to the specified logger node.
dcl-pr Logger_addChild int(10) extproc('LOG4RPG01_Logger_addChild');
  i_hLogger like(LOG4RPG_hLogger_t) const;
  i_hChild  like(LOG4RPG_hLogger_t) const;
end-pr;

//  Sets the parent logger of the specified logger.
dcl-pr Logger_setParent extproc('LOG4RPG01_Logger_setParent');
  i_hLogger like(LOG4RPG_hLogger_t) const;
  i_hParent like(LOG4RPG_hLogger_t) const;
end-pr;

//  Returns the parent of the specified logger.
dcl-pr Logger_getParent like(LOG4RPG_hLogger_t) extproc('LOG4RPG01_Logger_getParent');
  i_hLogger like(LOG4RPG_hLogger_t) const;
end-pr;

//  returns the name of a given Node.
dcl-pr Node_getName like(LOG4RPG_loggerName_t) extproc('LOG4RPG01_Node_getName');
  i_hNode like(LOG4RPG_hLogger_t) const;
end-pr;

//  Test the specified logger handle for a logger node.
dcl-pr Node_isLoggerNode ind extproc('LOG4RPG01_Node_isLoggerNode');
  i_hLogger like(LOG4RPG_hLogger_t) const;
end-pr;

//  Test the specified logger handle for a provision node.
dcl-pr Node_isProvisionNode ind extproc('LOG4RPG01_Node_isProvisionNode');
  i_hLogger like(LOG4RPG_hLogger_t) const;
end-pr;

//  Returns the number of children of the specified node.
dcl-pr Node_getNumChildren int(10) extproc('LOG4RPG01_Node_getNumChildren');
  i_hLogger like(LOG4RPG_hLogger_t) const;
end-pr;

//  Returns a reference to a child of the specified node.
dcl-pr Node_getChild like(LOG4RPG_hLogger_t) extproc('LOG4RPG01_Node_getChild');
  i_hLogger like(LOG4RPG_hLogger_t) const;
  i_index   int(10) const;
end-pr;

//  Adds a child to the specified node.
dcl-pr Node_addChild int(10) extproc('LOG4RPG01_Node_addChild');
  i_hNode  like(LOG4RPG_hLogger_t) const;
  i_hChild like(LOG4RPG_hLogger_t) const;
end-pr;

//  Sets the parent node of the specified node.
dcl-pr Node_setParent extproc('LOG4RPG01_Node_setParent');
  i_hLogger like(LOG4RPG_hLogger_t) const;
  i_hParent like(LOG4RPG_hLogger_t) const;
end-pr;

//  Returns the parent node of a given node.
dcl-pr Node_getParent like(LOG4RPG_hLogger_t) extproc('LOG4RPG01_Node_getParent');
  i_hLogger like(LOG4RPG_hLogger_t) const;
end-pr;

//  Removes a child from the list of children of the specified node.
dcl-pr Node_removeChild int(10) extproc('LOG4RPG01_Node_removeChild');
  i_hLogger like(LOG4RPG_hLogger_t) const;
  i_index   int(10) const;
end-pr;

//  Searches the children of a given node for a given child.
dcl-pr Node_findChild int(10) extproc('LOG4RPG01_Node_findChild');
  i_hNode  like(LOG4RPG_hLogger_t) const;
  i_hChild like(LOG4RPG_hLogger_t) const;
end-pr;

//  Tests the specified node handle for a NULL value.
dcl-pr Node_isNull ind extproc('LOG4RPG01_Node_isNull');
  i_hNode like(LOG4RPG_hLogger_t) const;
end-pr;

//  Returns a node NULL handle.
dcl-pr Node_null like(LOG4RPG_hLogger_t) extproc('LOG4RPG01_Node_null');
end-pr;

//  Returns a brief description of the node.
dcl-pr Node_toString varchar(117) extproc('LOG4RPG01_Node_toString');
  i_hNode like(LOG4RPG_hLogger_t) const;
end-pr;

//  Returns the number of children of the specified provision node.
dcl-pr ProvisionNode_getNumChildren int(10) extproc('LOG4RPG01_ProvisionNode_getNumChildren');
  i_hLogger like(LOG4RPG_hLogger_t) const;
end-pr;

//  Adds a child to the specified provision node.
dcl-pr ProvisionNode_addChild int(10) extproc('LOG4RPG01_ProvisionNode_addChild');
  i_hLogger like(LOG4RPG_hLogger_t) const;
  i_hChild  like(LOG4RPG_hLogger_t) const;
end-pr;

//  Returns a reference to a child of the specified provision node.
dcl-pr ProvisionNode_getChild like(LOG4RPG_hLogger_t) extproc('LOG4RPG01_ProvisionNode_getChild');
  i_hLogger like(LOG4RPG_hLogger_t) const;
  i_index   int(10) const;
end-pr;

//  Removes a child from the list of children of the specified logger.
dcl-pr ProvisionNode_removeChild int(10) extproc('LOG4RPG01_ProvisionNode_removeChild');
  i_hLogger like(LOG4RPG_hLogger_t) const;
  i_index   int(10) const;
end-pr;

//  Sets the parent node of the specified logger.
dcl-pr ProvisionNode_setParent extproc('LOG4RPG01_ProvisionNode_setParent');
  i_hProvNode like(LOG4RPG_hLogger_t) const;
  i_hParent   like(LOG4RPG_hLogger_t) const;
end-pr;

//  Returns the parent node of a given provision node.
dcl-pr ProvisionNode_getParent like(LOG4RPG_hLogger_t) extproc('LOG4RPG01_ProvisionNode_getParent');
  i_hProvNode like(LOG4RPG_hLogger_t) const;
end-pr;

//  Factory: Produces a provision node and adds a child to it.
dcl-pr ProvisionNode_makeProvisionNode like(LOG4RPG_hLogger_t)
  extproc('LOG4RPG01_ProvisionNode_makeProvisionNode');
  i_logName like(LOG4RPG_loggerName_t) const;
  i_hChild  like(LOG4RPG_hLogger_t) const;
end-pr;

//  Frees a provision node.
dcl-pr ProvisionNode_free extproc('LOG4RPG01_ProvisionNode_free');
  io_hProvNode like(LOG4RPG_hLogger_t);
end-pr;

//  Moves the children to a given logger node.
dcl-pr ProvisionNode_moveChildren extproc('LOG4RPG01_ProvisionNode_moveChildren');
  i_hProvNode like(LOG4RPG_hLogger_t);
  i_hLogger   like(LOG4RPG_hLogger_t);
end-pr;

//  Tests the specified provision node handle for a NULL value.
dcl-pr ProvisionNode_isNull ind extproc('LOG4RPG01_ProvisionNode_isNull');
  i_hNode like(LOG4RPG_hLogger_t) const;
end-pr;

//  Returns a provision node NULL handle.
dcl-pr ProvisionNode_null like(LOG4RPG_hLogger_t) extproc('LOG4RPG01_ProvisionNode_null');
end-pr;

//  Sets an offset to let f_caller() skip the Log4rpg stub module
//  if present.
/if NOT defined(LOGGER_STUB)
dcl-pr setStubOfs extproc('LOG4RPG01_setStubOfs Internal Use Only');
/else
dcl-pr setStubOfs extproc(g_procptr.setStubOfs);
/endif
  i_stubOfs int(3) const;
end-pr;

/endif