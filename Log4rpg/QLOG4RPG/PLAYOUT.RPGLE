**free
/if NOT defined(PLAYOUT)
/define PLAYOUT

//  Who should use this copy book:   Developer of layouts
//
//  This copy book defines the prototypes that are needed to write an
//  implementation of a layout 'object'. In order to create a layout
//  you have to do these steps:
//     a) copy this copy book
//     b) rename 'SrvPgmLayout' to the name of your layout,
//        e.g. 'MySpecialLayout'.
//     c) Optionally remove the lines that are related to 'DEFINE_PROCPTR'.
//        You do not need the prototypes with procedure pointers. The
//        prototypes with procedure pointers are used by LOG4RPG11.
//     d) Make sure that your layout exports the following procedures:
//           MySpecialLayout_new()
//           MySpecialLayout_format()
//           MySpecialLayout_setProperties()
//           MySpecialLayout_delete()
//        Do not change the suffix of the procedures or the procedure
//        interface!
//     e) Optionally add these procedures to your layout. They might be called
//        when an Appender is initialized and closed:
//           MySpecialLayout_getHeader()
//           MySpecialLayout_getFooter()
//     f) Feel free to send the new layout to me. I would gladly
//        add the layout to the LOG4RPG distribution.
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PSHARE Type defs shared with appenders & layouts

// -----------------------------------------
//  Type Definitions
// -----------------------------------------
//
// -----------------------------------------
//  Layout Prototypes & Type Defs
// -----------------------------------------

//  Custom layout ...
//  ... prototye: new, returns TRUE on success else FALSE
/if defined(DEFINE_PROCPTR)
dcl-pr SrvPgmLayout_new ind extproc(g_pLayout_new);
/else
dcl-pr SrvPgmLayout_new ind extproc('SrvPgmLayout_new');
/endif
  i_pSuper   like(LOG4RPG_pLayout_t) const;
  io_pHandle pointer;
  i_propList like(LOG4RPG_pPropertyList_t) const;
  i_prefix   like(LOG4RPG_prefix_t) const;
end-pr;

//  ... prototye: format, returns the logging event as a formatted string
/if defined(DEFINE_PROCPTR)
dcl-pr SrvPgmLayout_format extproc(g_pLayout_format);
/else
dcl-pr SrvPgmLayout_format extproc('SrvPgmLayout_format');
/endif
  i_pHandle   pointer const;
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  ... prototye: getHeader, returns the header of the layout
/if defined(DEFINE_PROCPTR)
dcl-pr SrvPgmLayout_getHeader like(LOG4RPG_header_t) extproc(g_pLayout_getHeader);
/else
dcl-pr SrvPgmLayout_getHeader like(LOG4RPG_header_t) extproc('SrvPgmLayout_getHeader');
/endif
  i_pHandle pointer const;
end-pr;

//  ... prototye: getFooter, returns the footer of the layout
/if defined(DEFINE_PROCPTR)
dcl-pr SrvPgmLayout_getFooter like(LOG4RPG_footer_t) extproc(g_pLayout_getFooter);
/else
dcl-pr SrvPgmLayout_getFooter like(LOG4RPG_footer_t) extproc('SrvPgmLayout_getFooter');
/endif
  i_pHandle pointer const;
end-pr;

//  ... prototye: setProperties, sets the proeprties for the layout
/if defined(DEFINE_PROCPTR)
dcl-pr SrvPgmLayout_setProperties extproc(g_pLayout_setProperties);
/else
dcl-pr SrvPgmLayout_setProperties extproc('SrvPgmLayout_setProperties');
/endif
  i_pHandle  pointer const;
  i_propList like(LOG4RPG_pPropertyList_t) const;
  i_prefix   like(LOG4RPG_prefix_t) const;
end-pr;

//  ... prototye: delete, returns TRUE on success else FALSE
/if defined(DEFINE_PROCPTR)
dcl-pr SrvPgmLayout_delete ind extproc(g_pLayout_delete);
/else
dcl-pr SrvPgmLayout_delete ind extproc('SrvPgmLayout_delete');
/endif
  io_pHandle pointer;
end-pr;

/endif