**FREE
/IF NOT DEFINED(PFILTER)
/DEFINE PFILTER
//
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
/COPY QLOG4RPG,PSHARE                        Type defs shared with appenders & layouts
//
// -----------------------------------------
//  Constants
// -----------------------------------------
//  Valid return values of Filter_decide():
dcl-c cFILTER_ACCEPT
      const(1);
dcl-c cFILTER_DENY
      const(2);
dcl-c cFILTER_NEUTRAL
      const(3);
//
// -----------------------------------------
//  Filter Prototypes & Type Defs
// -----------------------------------------
//
//  Custom filter ...
//  ... prototye: new, returns TRUE on success else FALSE
/IF DEFINED (DEFINE_PROCPTR)
dcl-pr SrvPgmFilter_new
       ind extproc(g_pFilter_new);
end-pr;
/ELSE
dcl-pr SrvPgmFilter_new
       ind extproc('SrvPgmFilter_new');
end-pr;
/ENDIF
     D  i_pSuper                           const  like(LOG4RPG_pFilter_t       )
     D  io_pHandle                     *
     D  i_propList                         const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
//
//  ... prototye: decide, returns the decision of the filter
/IF DEFINED (DEFINE_PROCPTR)
dcl-pr SrvPgmFilter_decide
       int(10) extproc(g_pFilter_decide);
end-pr;
/ELSE
dcl-pr SrvPgmFilter_decide
       int(10) extproc('SrvPgmFilter_decide');
end-pr;
/ENDIF
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t)
//
//  ... prototye: setProperties, sets the proeprties for the filter
/IF DEFINED (DEFINE_PROCPTR)
dcl-pr SrvPgmFilter_setProperties
       extproc(g_pFilter_setProperties);
end-pr;
/ELSE
dcl-pr SrvPgmFilter_setProperties
       extproc('SrvPgmFilter_+
       setProperties');
end-pr;
/ENDIF
     D  i_pHandle                      *   const
     D  i_propList                         const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
//
//  ... prototye: delete, returns TRUE on success else FALSE
/IF DEFINED (DEFINE_PROCPTR)
dcl-pr SrvPgmFilter_delete
       ind extproc(g_pFilter_delete);
end-pr;
/ELSE
dcl-pr SrvPgmFilter_delete
       ind extproc('SrvPgmFilter_delete');
end-pr;
/ENDIF
     D  io_pHandle                     *
//
/ENDIF
