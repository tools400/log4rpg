      /IF NOT DEFINED(PLOG4RPG12)
      /DEFINE PLOG4RPG12
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PTYPES                        Private type definitions
      *
      *  Appender:
     D LOG4RPG_classAppender_t...
     D                 DS                  qualified               based(pDummy)
     D  srvPgm                             likeds(actSrvPgm_t )
     D  pHandle                        *
     D  proc                               like(LOG4RPG_procedure_t )
     D  procNew                            likeds(actProc_t   )
     D  procRequiresLayout...
     D                                     likeds(actProc_t   )
     D  procDoAppend                       likeds(actProc_t   )
     D  procSetProperties...
     D                                     likeds(actProc_t   )
     D  procDelete                         likeds(actProc_t   )
      *
      *  Layout:
     D LOG4RPG_classLayout_t...
     D                 DS                  qualified               based(pDummy)
     D  srvPgm                             likeds(actSrvPgm_t )
     D  pHandle                        *
     D  proc                               like(LOG4RPG_procedure_t )
     D  procNew                            likeds(actProc_t   )
     D  procFormat                         likeds(actProc_t   )
     D  procSetProperties...
     D                                     likeds(actProc_t   )
     D  procDelete                         likeds(actProc_t   )
     D  procGetHeader                      likeds(actProc_t   )
     D  procGetFooter                      likeds(actProc_t   )
      *
      *  Filter:
     D LOG4RPG_classFilter_t...
     D                 DS                  qualified               based(pDummy)
     D  srvPgm                             likeds(actSrvPgm_t )
     D  pHandle                        *
     D  proc                               like(LOG4RPG_procedure_t )
     D  procNew                            likeds(actProc_t   )
     D  procDecide                         likeds(actProc_t   )
     D  procSetProperties...
     D                                     likeds(actProc_t   )
     D  procDelete                         likeds(actProc_t   )
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *  Appender:
     D g_pAppender_new...
     D                 S               *   procptr
     D g_pAppender_requiresLayout...
     D                 S               *   procptr
     D g_pAppender_doAppend...
     D                 S               *   procptr
     D g_pAppender_setProperties...
     D                 S               *   procptr
     D g_pAppender_delete...
     D                 S               *   procptr
      *
      *  Layout:
     D g_pLayout_new...
     D                 S               *   procptr
     D g_pLayout_format...
     D                 S               *   procptr
     D g_pLayout_setProperties...
     D                 S               *   procptr
     D g_pLayout_delete...
     D                 S               *   procptr
     D g_pLayout_getHeader...
     D                 S               *   procptr
     D g_pLayout_getFooter...
     D                 S               *   procptr
      *
      *  Filter:
     D g_pFilter_new...
     D                 S               *   procptr
     D g_pFilter_decide...
     D                 S               *   procptr
     D g_pFilter_setProperties...
     D                 S               *   procptr
     D g_pFilter_delete...
     D                 S               *   procptr
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Resolves the service program that provides the implementation
      *  of an appender.
     D ClassLoader_resolveAppender...
     D                 PR              N
     D                                     extproc('LOG4RPG12+
     D                                     _ClassLoader_resolveAppender+
     D                                     ')
     D  i_value                            const like(LOG4RPG_Property_value_t )
     D  o_classAppender...
     D                                           likeds(LOG4RPG_classAppender_t)
      *
      *  Resolves the service program that provides the implementation
      *  of a layout.
     D ClassLoader_resolveLayout...
     D                 PR              N
     D                                     extproc('LOG4RPG12+
     D                                     _ClassLoader_resolveLayout+
     D                                     ')
     D  i_value                            const like(LOG4RPG_Property_value_t )
     D  o_classLayout                            likeds(LOG4RPG_classLayout_t  )
      *
      *  Resolves the service program that provides the implementation
      *  of a filter.
     D ClassLoader_resolveFilter...
     D                 PR              N
     D                                     extproc('LOG4RPG12+
     D                                     _ClassLoader_resolveFilter+
     D                                     ')
     D  i_value                            const like(LOG4RPG_Property_value_t )
     D  o_classFilter                            likeds(LOG4RPG_classFilter_t  )
      *
      /ENDIF
