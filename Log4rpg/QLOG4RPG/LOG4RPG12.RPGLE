      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: ClassLoader                              *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  13.06.2006                                              *
      *  E-mail  :  thomas.raddatz@tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  18.10.2006  Th.Raddatz    Introduced Filter to Log4rpg.            *
      *                                                                     *
      *  14.11.2006  Th.Raddatz    Changed call to f_getProcPtrByName()     *
      *                            to omit message parameter to avoid       *
      *                            program crash on error.                  *
      *                            Now using LogLog_verbose() to log        *
      *                            errors when Layout_getHeader() or        *
      *                            Layout_getFooter() could not be resolved.*
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< TGTRLS(V6R1M0  );                                    *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /COPY QLOG4RPG,H_SPEC
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG12
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      *
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
      /COPY QLOG4RPG,PLOG4RPG99                    Helpers
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *  Appender:
     D cAPPENDER_NEW...
     D                 C                   const('_new')
     D cAPPENDER_DOAPPEND...
     D                 C                   const('_doAppend')
     D cAPPENDER_REQUIRES_LAYOUT...
     D                 C                   const('_requiresLayout')
     D cAPPENDER_SET_PROPERTIES...
     D                 C                   const('_setProperties')
     D cAPPENDER_DELETE...
     D                 C                   const('_delete')
      *
      *  Layout:
     D cLAYOUT_NEW...
     D                 C                   const('_new')
     D cLAYOUT_FORMAT...
     D                 C                   const('_format')
     D cLAYOUT_SET_PROPERTIES...
     D                 C                   const('_setProperties')
     D cLAYOUT_DELETE...
     D                 C                   const('_delete')
     D cLAYOUT_GET_HEADER...
     D                 C                   const('_getHeader')
     D cLAYOUT_GET_FOOTER...
     D                 C                   const('_getFooter')
      *
      *  Filter:
     D cFILTER_NEW...
     D                 C                   const('_new')
     D cFILTER_DECIDE...
     D                 C                   const('_decide')
     D cFILTER_SET_PROPERTIES...
     D                 C                   const('_setProperties')
     D cFILTER_DELETE...
     D                 C                   const('_delete')
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Program status data structure
      * -----------------------------------------
      /DEFINE SDS_EXTENDED
      /COPY QLOG4RPG,SDS
      /UNDEFINE SDS_EXTENDED
      *
      *=========================================================================
      *  Resolves the service program that provides the implementation
      *  of an appender.
      *=========================================================================
      *  Parameters:
      *   i_appendImpl  - A string that specifies the appender implementation
      *                   object.
      *   o_classAppender - The "class" that implements the appender.
      *
      *  Returns:
      *   isResolved    - Returns TRUE on success, else FALSE.
      *=========================================================================
     P ClassLoader_resolveAppender...
     P                 B                   export
      *
     D ClassLoader_resolveAppender...
     D                 PI              N
     D  i_appendImpl                       const like(LOG4RPG_Property_value_t )
     D  o_classAppender...
     D                                           likeds(LOG4RPG_classAppender_t)
      *
      *  Return value
     D isResolved      S               N   inz(cFalse)
      *
      *  Helper fields
     D srvPgm          DS                  likeds(qObj_t                 ) inz
     D proc            S                   like(LOG4RPG_procedure_t      ) inz
     D tempClassAppender...
     D                 DS                  likeds(LOG4RPG_classAppender_t) inz
     D msg             DS                  likeds(msg_t                  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clear o_classAppender;
         clear tempClassAppender;
 
         srvPgm = getSrvPgm(i_appendImpl);
         proc   = getProcedure(i_appendImpl);
 
         tempClassAppender.pHandle = *NULL;
         tempClassAppender.srvPgm  = f_activateSrvPgm(srvPgm.name
                                                      : srvPgm.lib
                                                      : msg);
         if msg.ID <> cMSG_ID_OK;
            LogLog_warning('Can not activate service program [' +
                            i_appendImpl + ']');
            return isResolved;
         endif;
 
         tempClassAppender.proc = proc;
 
         tempClassAppender.procNew            =
                       f_getProcPtrByName(proc + cAPPENDER_NEW
                                          : tempClassAppender.srvPgm: *omit);
         if tempClassAppender.procNew.procptr = *NULL;
            LogLog_error('Could not resolve procedure: ' +
                          proc + cAPPENDER_NEW);
            return isResolved;
         endif;
 
         tempClassAppender.procRequiresLayout =
                       f_getProcPtrByName(proc + cAPPENDER_REQUIRES_LAYOUT
                                          : tempClassAppender.srvPgm: *omit);
         if tempClassAppender.procRequiresLayout.procptr = *NULL;
            LogLog_error('Could not resolve procedure: ' +
                          proc + cAPPENDER_REQUIRES_LAYOUT);
            return isResolved;
         endif;
 
         tempClassAppender.procDoAppend       =
                       f_getProcPtrByName(proc + cAPPENDER_DOAPPEND
                                          : tempClassAppender.srvPgm: *omit);
         if tempClassAppender.procDoAppend.procptr = *NULL;
            LogLog_error('Could not resolve procedure: ' +
                          proc + cAPPENDER_DOAPPEND);
            return isResolved;
         endif;
 
         tempClassAppender.procSetProperties  =
                       f_getProcPtrByName(proc + cAPPENDER_SET_PROPERTIES
                                          : tempClassAppender.srvPgm: *omit);
         if tempClassAppender.procSetProperties.procptr = *NULL;
            LogLog_error('Could not resolve procedure: ' +
                          proc + cAPPENDER_SET_PROPERTIES);
            return isResolved;
         endif;
 
         tempClassAppender.procDelete         =
                       f_getProcPtrByName(proc + cAPPENDER_DELETE
                                          : tempClassAppender.srvPgm: *omit);
         if tempClassAppender.procDelete.procptr = *NULL;
            LogLog_error('Could not resolve procedure: ' +
                          proc + cAPPENDER_DELETE);
            return isResolved;
         endif;
 
         o_classAppender = tempClassAppender;
 
         isResolved = cTrue;
 
         return isResolved;
 
      /END-FREE
      *
     P ClassLoader_resolveAppender...
     P                 E
      *
      *=========================================================================
      *  Resolves the service program that provides the implementation
      *  of a layout.
      *=========================================================================
      *  Parameters:
      *   i_layoutImpl  - A string that specifies the layout implementation
      *                   object.
      *   o_classLayout - The "class" that implements the layout.
      *
      *  Returns:
      *   isResolved    - Returns TRUE on success, else FALSE.
      *=========================================================================
     P ClassLoader_resolveLayout...
     P                 B                   export
      *
     D ClassLoader_resolveLayout...
     D                 PI              N
     D  i_layoutImpl                       const like(LOG4RPG_Property_value_t )
     D  o_classLayout                            likeds(LOG4RPG_classLayout_t  )
      *
      *  Return value
     D isResolved      S               N   inz(cFalse)
      *
      *  Helper fields
     D srvPgm          DS                  likeds(qObj_t                 ) inz
     D proc            S                   like(LOG4RPG_procedure_t      ) inz
     D tempClassLayout...
     D                 DS                  likeds(LOG4RPG_classLayout_t  ) inz
     D msg             DS                  likeds(msg_t                  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clear o_classLayout;
         clear tempClassLayout;
 
         srvPgm = getSrvPgm(i_layoutImpl);
         proc   = getProcedure(i_layoutImpl);
 
         tempClassLayout.pHandle = *NULL;
         tempClassLayout.srvPgm  = f_activateSrvPgm(srvPgm.name
                                                    : srvPgm.lib
                                                    : msg);
         if msg.ID <> cMSG_ID_OK;
            LogLog_warning('Can not activate service program [' +
                            i_layoutImpl + ']');
            return isResolved;
         endif;
 
         tempClassLayout.proc = proc;
 
         tempClassLayout.procNew            =
                       f_getProcPtrByName(proc + cLAYOUT_NEW
                                          : tempClassLayout.srvPgm: *omit);
         if tempClassLayout.procNew.procptr = *NULL;
            LogLog_error('Could not resolve procedure: ' +
                          proc + cLAYOUT_NEW);
            return isResolved;
         endif;
 
         tempClassLayout.procFormat         =
                       f_getProcPtrByName(proc + cLAYOUT_FORMAT
                                          : tempClassLayout.srvPgm: *omit);
         if tempClassLayout.procFormat.procptr = *NULL;
            LogLog_error('Could not resolve procedure: ' +
                          proc + cLAYOUT_NEW);
            return isResolved;
         endif;
 
         tempClassLayout.procSetProperties  =
                       f_getProcPtrByName(proc + cLAYOUT_SET_PROPERTIES
                                          : tempClassLayout.srvPgm: *omit);
         if tempClassLayout.procSetProperties.procptr = *NULL;
            LogLog_error('Could not resolve procedure: ' +
                          proc + cLAYOUT_NEW);
            return isResolved;
         endif;
 
         tempClassLayout.procDelete         =
                       f_getProcPtrByName(proc + cLAYOUT_DELETE
                                          : tempClassLayout.srvPgm: *omit);
         if tempClassLayout.procDelete.procptr = *NULL;
            LogLog_error('Could not resolve procedure: ' +
                          proc + cLAYOUT_NEW);
            return isResolved;
         endif;
 
         // Resolve optional procedures
         tempClassLayout.procGetHeader      =
                       f_getProcPtrByName(proc + cLAYOUT_GET_HEADER
                                          : tempClassLayout.srvPgm: *omit);
         if tempClassLayout.procGetHeader.procptr = *NULL;
            LogLog_verbose('Could not resolve procedure: ' +
                            proc + cLAYOUT_GET_HEADER);
         endif;
 
         tempClassLayout.procGetFooter      =
                       f_getProcPtrByName(proc + cLAYOUT_GET_FOOTER
                                          : tempClassLayout.srvPgm: *omit);
         if tempClassLayout.procGetFooter.procptr = *NULL;
            LogLog_verbose('Could not resolve procedure: ' +
                            proc + cLAYOUT_GET_FOOTER);
         endif;
 
         o_classLayout = tempClassLayout;
 
         isResolved = cTrue;
 
         return isResolved;
 
      /END-FREE
      *
     P ClassLoader_resolveLayout...
     P                 E
      *
      *=========================================================================
      *  Resolves the service program that provides the implementation
      *  of a filter.
      *=========================================================================
      *  Parameters:
      *   i_filterImpl  - A string that specifies the filter implementation
      *                   object.
      *   o_classFilter - The "class" that implements the filter.
      *
      *  Returns:
      *   isResolved    - Returns TRUE on success, else FALSE.
      *=========================================================================
     P ClassLoader_resolveFilter...
     P                 B                   export
      *
     D ClassLoader_resolveFilter...
     D                 PI              N
     D  i_filterImpl                       const like(LOG4RPG_Property_value_t )
     D  o_classFilter                            likeds(LOG4RPG_classFilter_t  )
      *
      *  Return value
     D isResolved      S               N   inz(cFalse)
      *
      *  Helper fields
     D srvPgm          DS                  likeds(qObj_t                 ) inz
     D proc            S                   like(LOG4RPG_procedure_t      ) inz
     D tempClassFilter...
     D                 DS                  likeds(LOG4RPG_classFilter_t  ) inz
     D msg             DS                  likeds(msg_t                  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clear o_classFilter;
         clear tempClassFilter;
 
         srvPgm = getSrvPgm(i_filterImpl);
         proc   = getProcedure(i_filterImpl);
 
         tempClassFilter.pHandle = *NULL;
         tempClassFilter.srvPgm  = f_activateSrvPgm(srvPgm.name
                                                    : srvPgm.lib
                                                    : msg);
         if msg.ID <> cMSG_ID_OK;
            LogLog_warning('Can not activate service program [' +
                            i_filterImpl + ']');
            return isResolved;
         endif;
 
         tempClassFilter.proc = proc;
 
         tempClassFilter.procNew            =
                       f_getProcPtrByName(proc + cFILTER_NEW
                                          : tempClassFilter.srvPgm: *omit);
         if tempClassFilter.procNew.procptr = *NULL;
            LogLog_error('Could not resolve procedure: ' +
                          proc + cFILTER_NEW);
            return isResolved;
         endif;
 
         tempClassFilter.procDecide         =
                       f_getProcPtrByName(proc + cFILTER_DECIDE
                                          : tempClassFilter.srvPgm: *omit);
         if tempClassFilter.procDecide.procptr = *NULL;
            LogLog_error('Could not resolve procedure: ' +
                          proc + cFILTER_DECIDE);
            return isResolved;
         endif;
 
         tempClassFilter.procSetProperties  =
                       f_getProcPtrByName(proc + cFILTER_SET_PROPERTIES
                                          : tempClassFilter.srvPgm: *omit);
         if tempClassFilter.procSetProperties.procptr = *NULL;
            LogLog_error('Could not resolve procedure: ' +
                          proc + cFILTER_SET_PROPERTIES);
            return isResolved;
         endif;
 
         tempClassFilter.procDelete         =
                       f_getProcPtrByName(proc + cFILTER_DELETE
                                          : tempClassFilter.srvPgm: *omit);
         if tempClassFilter.procDelete.procptr = *NULL;
            LogLog_error('Could not resolve procedure: ' +
                          proc + cFILTER_DELETE);
            return isResolved;
         endif;
 
         o_classFilter = tempClassFilter;
 
         isResolved = cTrue;
 
         return isResolved;
 
      /END-FREE
      *
     P ClassLoader_resolveFilter...
     P                 E
      *
