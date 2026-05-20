**free
/if NOT DEFINED(PLOG4RPG04)
/define PLOG4RPG04

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG03                    Appender

dcl-s LOG4RPG_pAppenderList_t pointer based(pDummy);

dcl-ds LOG4RPG_AppenderListIterator_t qualified based(pDummy);
  pAppList like(LOG4RPG_pAppenderList_t);
  lastApp  int(10);
end-ds;

// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------

//  Creates a new appender list.
dcl-pr AppenderList_new like(LOG4RPG_pAppenderList_t) extproc('LOG4RPG04_AppenderList_new');
end-pr;

//  Returns the number of entries in a given appender list.
dcl-pr AppenderList_getNumE int(10) extproc('LOG4RPG04_AppenderList_NumE');
  i_pAppList like(LOG4RPG_pAppenderList_t) const;
end-pr;

//  Adds an appender to a given appender list.
dcl-pr AppenderList_put int(10) extproc('LOG4RPG04_AppenderList_put');
  i_pAppList  like(LOG4RPG_pAppenderList_t) const;
  i_pAppender like(LOG4RPG_pAppender_t) const;
end-pr;

//  Removes the specified appender from the given appender list.
dcl-pr AppenderList_remove int(10) extproc('LOG4RPG04_AppenderList_remove');
  i_pAppList like(LOG4RPG_pAppenderList_t) const;
  i_appName  like(LOG4RPG_appenderName_t) const;
end-pr;

//  Returns the appender that matches the specified name.
dcl-pr AppenderList_get like(LOG4RPG_pAppender_t) extproc('LOG4RPG04_AppenderList_get');
  i_pAppList like(LOG4RPG_pAppenderList_t) const;
  i_appName  like(LOG4RPG_appenderName_t) const;
end-pr;

//  Tests, if the appender list contains the specified appender.
dcl-pr AppenderList_exist ind extproc('LOG4RPG04_AppenderList_exist');
  i_pAppList like(LOG4RPG_pAppenderList_t) const;
  i_appName  like(LOG4RPG_appenderName_t) const;
end-pr;

//  Returns an iterator for the specified appender list.
dcl-pr AppenderList_getIterator likeds(LOG4RPG_AppenderListIterator_t)
  extproc('LOG4RPG04_AppenderList_getIterator');
  i_pAppList like(LOG4RPG_pAppenderList_t) const;
end-pr;

//  Returns the first appender of the specified appender list.
dcl-pr AppenderList_getFirst like(LOG4RPG_pAppender_t) extproc('LOG4RPG04_AppenderList_getFirst');
  io_appIter likeds(LOG4RPG_AppenderListIterator_t);
end-pr;

//  Returns the next appender of the specified appender list.
dcl-pr AppenderList_getNext like(LOG4RPG_pAppender_t) extproc('LOG4RPG04_AppenderList_getNext');
  io_appIter likeds(LOG4RPG_AppenderListIterator_t);
end-pr;

//  Deletes a given appender list.
dcl-pr AppenderList_delete ind extproc('LOG4RPG04_AppenderList_delete');
  io_pAppList like(LOG4RPG_pAppenderList_t);
end-pr;

//  Test the specified appender list object for a NULL value.
dcl-pr AppenderList_isNull ind extproc('LOG4RPG04_AppenderList_isNull');
  i_pAppList like(LOG4RPG_pAppenderList_t) const;
end-pr;

//  Returns a NULL appender list.
dcl-pr AppenderList_null like(LOG4RPG_pAppenderList_t) extproc('LOG4RPG04_AppenderList_null');
end-pr;

/endif
