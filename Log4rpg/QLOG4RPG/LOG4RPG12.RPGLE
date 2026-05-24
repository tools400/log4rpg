**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: ClassLoader                              *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  13.06.2006                                              *
//  E-mail  :  thomas.raddatz@tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  18.10.2006  Th.Raddatz    Introduced Filter to Log4rpg.            *
//                                                                     *
//  14.11.2006  Th.Raddatz    Changed call to f_getProcPtrByName()     *
//                            to omit message parameter to avoid       *
//                            program crash on error.                  *
//                            Now using LogLog_verbose() to log        *
//                            errors when Layout_getHeader() or        *
//                            Layout_getFooter() could not be resolved.*
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//                                                                     *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) +                     *
//                              SRCMBR(&SM);                           *
//                                                                     *
//     >>COMPILE<<                                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TGTRLS(V7R3M0  );                                    *
//     >>END-COMPILE<<                                                 *
//                                                                     *
//     >>EXECUTE<<                                                     *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
/copy QLOG4RPG,H_SPEC
//=====================================================================*
//
// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG12

// -----------------------------------------
//  Type definitions
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QBASICS1,PBASICS1 Basic RPG Extensions

/copy QLOG4RPG,PLOG4RPG10 LogLog
/copy QLOG4RPG,PLOG4RPG99 Helpers

// -----------------------------------------
//  Private prototypes
// -----------------------------------------
//
// -----------------------------------------
//  Global constants
// -----------------------------------------
//  Appender:
dcl-c cAPPENDER_NEW '_new';
dcl-c cAPPENDER_DOAPPEND '_doAppend';
dcl-c cAPPENDER_REQUIRES_LAYOUT '_requiresLayout';
dcl-c cAPPENDER_SET_PROPERTIES '_setProperties';
dcl-c cAPPENDER_DELETE '_delete';

//  Layout:
dcl-c cLAYOUT_NEW '_new';
dcl-c cLAYOUT_FORMAT '_format';
dcl-c cLAYOUT_SET_PROPERTIES '_setProperties';
dcl-c cLAYOUT_DELETE '_delete';
dcl-c cLAYOUT_GET_HEADER '_getHeader';
dcl-c cLAYOUT_GET_FOOTER '_getFooter';

//  Filter:
dcl-c cFILTER_NEW '_new';
dcl-c cFILTER_DECIDE '_decide';
dcl-c cFILTER_SET_PROPERTIES '_setProperties';
dcl-c cFILTER_DELETE '_delete';

// -----------------------------------------
//  Global fields
// -----------------------------------------
//
// -----------------------------------------
//  Program status data structure
// -----------------------------------------
/define SDS_EXTENDED
/copy QLOG4RPG,SDS
/undefine SDS_EXTENDED

//=========================================================================
//  Resolves the service program that provides the implementation
//  of an appender.
//=========================================================================
//  Parameters:
//   i_appendImpl  - A string that specifies the appender implementation
//                   object.
//   o_classAppender - The "class" that implements the appender.
//
//  Returns:
//   isResolved    - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc ClassLoader_resolveAppender export;
  dcl-pi *n ind;
    i_appendImpl    like(LOG4RPG_Property_value_t) const;
    o_classAppender likeds(LOG4RPG_classAppender_t);
  end-pi;

  //  Return value
  dcl-s isResolved ind inz(*off);

  //  Helper fields
  dcl-ds srvPgm likeds(qObj_t) inz;
  dcl-s proc like(LOG4RPG_procedure_t) inz;
  dcl-ds tempClassAppender likeds(LOG4RPG_classAppender_t) inz;
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

  isResolved = *on;

  return isResolved;


end-proc;

//=========================================================================
//  Resolves the service program that provides the implementation
//  of a layout.
//=========================================================================
//  Parameters:
//   i_layoutImpl  - A string that specifies the layout implementation
//                   object.
//   o_classLayout - The "class" that implements the layout.
//
//  Returns:
//   isResolved    - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc ClassLoader_resolveLayout export;
  dcl-pi *n ind;
    i_layoutImpl  like(LOG4RPG_Property_value_t) const;
    o_classLayout likeds(LOG4RPG_classLayout_t);
  end-pi;

  //  Return value
  dcl-s isResolved ind inz(*off);

  //  Helper fields
  dcl-ds srvPgm likeds(qObj_t) inz;
  dcl-s proc like(LOG4RPG_procedure_t) inz;
  dcl-ds tempClassLayout likeds(LOG4RPG_classLayout_t) inz;
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

  isResolved = *on;

  return isResolved;


end-proc;

//=========================================================================
//  Resolves the service program that provides the implementation
//  of a filter.
//=========================================================================
//  Parameters:
//   i_filterImpl  - A string that specifies the filter implementation
//                   object.
//   o_classFilter - The "class" that implements the filter.
//
//  Returns:
//   isResolved    - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc ClassLoader_resolveFilter export;
  dcl-pi *n ind;
    i_filterImpl  like(LOG4RPG_Property_value_t) const;
    o_classFilter likeds(LOG4RPG_classFilter_t);
  end-pi;

  //  Return value
  dcl-s isResolved ind inz(*off);

  //  Helper fields
  dcl-ds srvPgm likeds(qObj_t) inz;
  dcl-s proc like(LOG4RPG_procedure_t) inz;
  dcl-ds tempClassFilter likeds(LOG4RPG_classFilter_t) inz;
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

  isResolved = *on;

  return isResolved;


end-proc;
