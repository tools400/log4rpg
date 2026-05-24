**free
/if NOT defined(PFILTER)
/define PFILTER

//  Who should use this copy book:   Developer of filter
//
//  This copy book defines the prototypes that are needed to write an
//  implementation of an filter 'object'. In order to create an
//  filter you have to do these steps:
//     a) copy this copy book
//     b) rename 'SrvPgmFilter' to the name of your filter,
//        e.g. 'MyFilter'.
//     c) Optionally remove the lines that are related to 'DEFINE_PROCPTR'.
//        You do not need the prototypes with procedure pointers. The
//        prototypes with procedure pointers are used by LOG4RPG03.
//     d) Make sure that your filter exports the following procedures:
//           YourFilter_new()
//           YourFilter_decide()
//           YourFilter_setProperties()
//           YourFilter_delete()
//        Do not change the suffix of the procedures or the procedure
//        interface!
//     e) Feel free to send the new filter to me. I would gladly
//        add the filter to the LOG4RPG distribution.
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PSHARE Type defs shared with appenders & layouts

// -----------------------------------------
//  Constants
// -----------------------------------------
//  Valid return values of Filter_decide():
dcl-c cFILTER_ACCEPT 1;
dcl-c cFILTER_DENY 2;
dcl-c cFILTER_NEUTRAL 3;

// -----------------------------------------
//  Filter Prototypes & Type Defs
// -----------------------------------------

//  Custom filter ...
//  ... prototye: new, returns TRUE on success else FALSE
/if defined(DEFINE_PROCPTR)
dcl-pr SrvPgmFilter_new ind extproc(g_pFilter_new);
/else
dcl-pr SrvPgmFilter_new ind extproc('SrvPgmFilter_new');
/endif
  i_pSuper   like(LOG4RPG_pFilter_t) const;
  io_pHandle pointer;
  i_propList like(LOG4RPG_pPropertyList_t) const;
  i_prefix   like(LOG4RPG_prefix_t) const;
end-pr;

//  ... prototye: decide, returns the decision of the filter
/if defined(DEFINE_PROCPTR)
dcl-pr SrvPgmFilter_decide int(10) extproc(g_pFilter_decide);
/else
dcl-pr SrvPgmFilter_decide int(10) extproc('SrvPgmFilter_decide');
/endif
  i_pHandle   pointer const;
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  ... prototye: setProperties, sets the properties for the filter
/if defined(DEFINE_PROCPTR)
dcl-pr SrvPgmFilter_setProperties extproc(g_pFilter_setProperties);
/else
dcl-pr SrvPgmFilter_setProperties extproc('SrvPgmFilter_setProperties');
/endif
  i_pHandle  pointer const;
  i_propList like(LOG4RPG_pPropertyList_t) const;
  i_prefix   like(LOG4RPG_prefix_t) const;
end-pr;

//  ... prototye: delete, returns TRUE on success else FALSE
/if defined(DEFINE_PROCPTR)
dcl-pr SrvPgmFilter_delete ind extproc(g_pFilter_delete);
/else
dcl-pr SrvPgmFilter_delete ind extproc('SrvPgmFilter_delete');
/endif
  io_pHandle pointer;
end-pr;

/endif