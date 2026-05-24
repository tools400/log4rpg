**free
/if NOT defined(PLOG4RPG12)
/define PLOG4RPG12

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PTYPES Private type definitions

//  Appender:
dcl-ds LOG4RPG_classAppender_t qualified based(pDummy);
  srvPgm             likeds(actSrvPgm_t);
  pHandle            pointer;
  proc               like(LOG4RPG_procedure_t);
  procNew            likeds(actProc_t);
  procRequiresLayout likeds(actProc_t);
  procDoAppend       likeds(actProc_t);
  procSetProperties  likeds(actProc_t);
  procDelete         likeds(actProc_t);
end-ds;

//  Layout:
dcl-ds LOG4RPG_classLayout_t qualified based(pDummy);
  srvPgm            likeds(actSrvPgm_t);
  pHandle           pointer;
  proc              like(LOG4RPG_procedure_t);
  procNew           likeds(actProc_t);
  procFormat        likeds(actProc_t);
  procSetProperties likeds(actProc_t);
  procDelete        likeds(actProc_t);
  procGetHeader     likeds(actProc_t);
  procGetFooter     likeds(actProc_t);
end-ds;

//  Filter:
dcl-ds LOG4RPG_classFilter_t qualified based(pDummy);
  srvPgm            likeds(actSrvPgm_t);
  pHandle           pointer;
  proc              like(LOG4RPG_procedure_t);
  procNew           likeds(actProc_t);
  procDecide        likeds(actProc_t);
  procSetProperties likeds(actProc_t);
  procDelete        likeds(actProc_t);
end-ds;

// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Global fields
// -----------------------------------------
//  Appender:
dcl-s g_pAppender_new pointer(*proc);
dcl-s g_pAppender_requiresLayout pointer(*proc);
dcl-s g_pAppender_doAppend pointer(*proc);
dcl-s g_pAppender_setProperties pointer(*proc);
dcl-s g_pAppender_delete pointer(*proc);

//  Layout:
dcl-s g_pLayout_new pointer(*proc);
dcl-s g_pLayout_format pointer(*proc);
dcl-s g_pLayout_setProperties pointer(*proc);
dcl-s g_pLayout_delete pointer(*proc);
dcl-s g_pLayout_getHeader pointer(*proc);
dcl-s g_pLayout_getFooter pointer(*proc);

//  Filter:
dcl-s g_pFilter_new pointer(*proc);
dcl-s g_pFilter_decide pointer(*proc);
dcl-s g_pFilter_setProperties pointer(*proc);
dcl-s g_pFilter_delete pointer(*proc);

// -----------------------------------------
//  Prototypes
// -----------------------------------------

//  Resolves the service program that provides the implementation
//  of an appender.
dcl-pr ClassLoader_resolveAppender ind extproc('LOG4RPG12_ClassLoader_resolveAppender');
  i_value         like(LOG4RPG_Property_value_t) const;
  o_classAppender likeds(LOG4RPG_classAppender_t);
end-pr;

//  Resolves the service program that provides the implementation
//  of a layout.
dcl-pr ClassLoader_resolveLayout ind extproc('LOG4RPG12_ClassLoader_resolveLayout');
  i_value       like(LOG4RPG_Property_value_t) const;
  o_classLayout likeds(LOG4RPG_classLayout_t);
end-pr;

//  Resolves the service program that provides the implementation
//  of a filter.
dcl-pr ClassLoader_resolveFilter ind extproc('LOG4RPG12_ClassLoader_resolveFilter');
  i_value       like(LOG4RPG_Property_value_t) const;
  o_classFilter likeds(LOG4RPG_classFilter_t);
end-pr;

/endif