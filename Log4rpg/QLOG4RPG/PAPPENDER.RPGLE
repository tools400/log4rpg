**free
/if NOT defined(PAPPENDER)
/define PAPPENDER

//  Who should use this copy book:   Developer of appenders
//
//  This copy book defines the prototypes that are needed to write an
//  implementation of an appender 'object'. In order to create an
//  appender you have to do these steps:
//     a) copy this copy book
//     b) rename 'SrvPgmAppender' to the name of your appender,
//        e.g. 'MySocketAppender'.
//     c) Optionally remove the lines that are related to 'DEFINE_PROCPTR'.
//        You do not need the prototypes with procedure pointers. The
//        prototypes with procedure pointers are used by LOG4RPG03.
//     d) Make sure that your appender exports the following procedures:
//           YourAppender_new()
//           YourAppender_requiresLayout()
//           YourAppender_doAppend()
//           YourAppender_setProperties()
//           YourAppender_delete()
//        Do not change the suffix of the procedures or the procedure
//        interface!
//     e) Feel free to send the new appender to me. I would gladly
//        add the appender to the LOG4RPG distribution.
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PSHARE Type defs shared with appenders & layouts

// -----------------------------------------
//  Appender Prototypes & Type Defs
// -----------------------------------------

//  Custom appender ...
//  ... prototye: new, returns TRUE on success else FALSE
/if defined(DEFINE_PROCPTR)
dcl-pr SrvPgmAppender_new ind extproc(g_pAppender_new);
/else
dcl-pr SrvPgmAppender_new ind extproc('SrvPgmAppender_new');
/endif
  i_pSuper   like(LOG4RPG_pAppender_t) const;
  io_pHandle pointer;
  i_propList like(LOG4RPG_pPropertyList_t) const;
  i_prefix   like(LOG4RPG_prefix_t) const;
end-pr;

//  ... prototye: requiresLayout, returns TRUE if the appender requires a layout
/if defined(DEFINE_PROCPTR)
dcl-pr SrvPgmAppender_requiresLayout ind extproc(g_pAppender_requiresLayout);
/else
dcl-pr SrvPgmAppender_requiresLayout ind extproc('SrvPgmAppender_requiresLayout');
/endif
  i_pHandle pointer const;
end-pr;

//  ... prototye: doAppend, returns TRUE on success else FALSE
/if defined(DEFINE_PROCPTR)
dcl-pr SrvPgmAppender_doAppend ind extproc(g_pAppender_doAppend);
/else
dcl-pr SrvPgmAppender_doAppend ind extproc('SrvPgmAppender_doAppend');
/endif
  i_pHandle   pointer const;
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  ... prototye: setProperties, sets the proeprties for the appender
/if defined(DEFINE_PROCPTR)
dcl-pr SrvPgmAppender_setProperties extproc(g_pAppender_setProperties);
/else
dcl-pr SrvPgmAppender_setProperties extproc('SrvPgmAppender_setProperties');
/endif
  i_pHandle  pointer const;
  i_propList like(LOG4RPG_pPropertyList_t) const;
  i_prefix   like(LOG4RPG_prefix_t) const;
end-pr;

//  ... prototye: delete, returns TRUE on success else FALSE
/if defined(DEFINE_PROCPTR)
dcl-pr SrvPgmAppender_delete ind extproc(g_pAppender_delete);
/else
dcl-pr SrvPgmAppender_delete ind extproc('SrvPgmAppender_delete');
/endif
  io_pHandle pointer;
end-pr;

/endif