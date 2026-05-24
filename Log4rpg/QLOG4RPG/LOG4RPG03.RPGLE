**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: Appender                                 *
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
//  26.10.2006  Th.Raddatz    Introduced Filter to Log4rpg.            *
//                            Added procedure Appender_knowsProperty().*
//                            Moved wordWrap processing to Appender    *
//                            implementation objects.                  *
//                                                                     *
//  09.09.2008  Th.Raddatz    Changed parameter 'i_filterName' of      *
//                            Appender_setFilter() to 'i_pFilter' to   *
//                            be consistent with Filter_setNext().     *
//                                                                     *
//  23.05.2011  Th.Raddatz    Fixed problem that the following         *
//                            procedure did not return a return value: *
//                               Appender_setFilter()                  *
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
/copy QLOG4RPG,PLOG4RPG03

// -----------------------------------------
//  Type definitions
// -----------------------------------------
dcl-ds handle_t qualified based(pDummy);
  name         like(LOG4RPG_appenderName_t);
  appenderImpl likeds(LOG4RPG_classAppender_t);
  pLayout      like(LOG4RPG_pLayout_t);
  pFilter      like(LOG4RPG_pFilter_t);
end-ds;

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,CEELIB CEE-Procedures
/copy QBASICS1,PBASICS1 Basic RPG Extensions

/copy QLOG4RPG,PLOG4RPG06 Property
/copy QLOG4RPG,PLOG4RPG07 PropertyList
/copy QLOG4RPG,PLOG4RPG10 LogLog
/copy QLOG4RPG,PLOG4RPG12 ClassLoader
/copy QLOG4RPG,PLOG4RPG13 Repository
/copy QLOG4RPG,PLOG4RPG17 Filter
/copy QLOG4RPG,PLOG4RPG99 Helpers

/copy QLOG4RPG,PFILTER Filter implementation

/define DEFINE_PROCPTR
/copy QLOG4RPG,PAPPENDER Appender implementation
/undefine DEFINE_PROCPTR

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Initializes this module.
dcl-pr initializeModule;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cPARAMETER_LAYOUT 'layout';
dcl-c cPARAMETER_FILTER 'filter';

// -----------------------------------------
//  Global fields
// -----------------------------------------
dcl-s g_isInit ind inz(*off);

// -----------------------------------------
//  Program status data structure
// -----------------------------------------
/define SDS_EXTENDED
/copy QLOG4RPG,SDS
/undefine SDS_EXTENDED

//=========================================================================
//  Creates a new appender.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pAppender     - Returns a handle to the appender on success, else
//                   a NULL handle.
//=========================================================================
dcl-proc Appender_new export;
  dcl-pi *n like(LOG4RPG_pAppender_t);
    i_appName     like(LOG4RPG_appenderName_t) const;
    i_appImpl     like(LOG4RPG_implClass_t) const;
    i_pPropString pointer options(*nopass: *omit: *string) const;
  end-pi;

  //  Return value
  dcl-ds appender likeds(handle_t) based(pAppender);

  //  Paremeter positions
  dcl-c p_pPropString 3;

  //  Fields for optional parameters
  dcl-s pPropString like(i_pPropString) inz;

  //  Helper fields
  dcl-s isPresent int(10) inz;
  dcl-s pPropList like(LOG4RPG_pPropertyList_t) inz;
  dcl-ds tempAppender likeds(handle_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  initializeModule();

  LogLog_debug('Creating appender [' + i_appName + '] ...');

  pAppender = Appender_null();

  // Get optional parameters ...
  // ... property string
  if %parms() >= p_pPropString;
    CEETSTA(isPresent: p_pPropString: *omit);
  else;
    isPresent = 0;
  endif;

  if isPresent = 1;
    pPropString = i_pPropString;
  else;
    pPropString = *NULL;
  endif;

  // Initialize appender
  tempAppender.name    = i_appName;
  if not ClassLoader_resolveAppender(i_appImpl
                                     : tempAppender.appenderImpl);
    return pAppender;
  endif;
  tempAppender.pLayout  = Layout_null();
  tempAppender.pFilter  = Filter_null();

  // Create properties list
  if pPropString <> *NULL;
    pPropList = PropertyList_new(pPropString);
  else;
    pPropList = PropertyList_null();
  endif;

  // Create appender handle
  pAppender = %alloc(%size(handle_t));
  appender = tempAppender;

  // Instanciate appender implementation object
  g_pAppender_new = appender.appenderImpl.procNew.procptr;
  SrvPgmAppender_new(pAppender
                     : appender.appenderImpl.pHandle
                     : pPropList
                     : '');

  // Destroy properties list
  if not PropertyList_isNull(pPropList);
    PropertyList_delete(pPropList);
  endif;

  // Add appender to the repository
  Repository_addAppender(pAppender);

  LogLog_verbose('+ Allocated memory for appender [' +
                    appender.name + '].');

  return pAppender;


end-proc;

//=========================================================================
//  Appends a message to the specified appender.
//=========================================================================
//  Parameters:
//   i_pAppender   - Handle of the appender returned by Appender_new().
//   i_pLogEvent   - Handle of the Log event that is logged.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Appender_doAppend export;
  dcl-pi *n ind;
    i_pAppender like(LOG4RPG_pAppender_t) const;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  Return value
  dcl-s isAppended ind inz(*off);

  //  Helper fields
  dcl-s decision int(10) inz;
  dcl-s pFilter like(LOG4RPG_pFilter_t) inz;

  //  Appender handle
  dcl-ds appender likeds(handle_t) based(i_pAppender);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Let the filter decide what to do with the log event
  pFilter = Appender_getFilter(i_pAppender);
  dow not Filter_isNull(pFilter);
    decision = Filter_decide(pFilter: i_pLogEvent);
    select;
    when decision = cFILTER_DENY;
      return *off;
    when decision = cFILTER_ACCEPT;
      leave;
    when decision = cFILTER_NEUTRAL;
      pFilter = Filter_getNext(pFilter);
    other;
      LogLog_warning('Invalid return value returned by +
                      Filter_decide() of filter [' +
                      Filter_getName(pFilter) + ']');
      leave;
    endsl;
  enddo;

  // Layout text of logging event
  if Appender_requiresLayout(i_pAppender) and
     not Layout_isNull(appender.pLayout);
    Layout_format(appender.pLayout: i_pLogEvent);
  endif;

  // Append line of log statement to log
  g_pAppender_doAppend = appender.appenderImpl.procDoAppend.procptr;
  isAppended = SrvPgmAppender_doAppend(
                  appender.appenderImpl.pHandle: i_pLogEvent);

  return isAppended;


end-proc;

//=========================================================================
//  Returns the name of the appender.
//=========================================================================
//  Parameters:
//   i_pAppender   - Handle of the appender returned by Appender_new().
//
//  Returns:
//   name          - Name of the specidfied appender.
//=========================================================================
dcl-proc Appender_getName export;
  dcl-pi *n like(LOG4RPG_appenderName_t);
    i_pAppender like(LOG4RPG_pAppender_t) const;
  end-pi;

  //  Appender handle
  dcl-ds appender likeds(handle_t) based(i_pAppender);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return appender.name;


end-proc;

//=========================================================================
//  Returns the layout of the appender.
//=========================================================================
//  Parameters:
//   i_pAppender   - Handle of the appender returned by Appender_new().
//
//  Returns:
//   i_pLayout     - Handle of the layout.
//=========================================================================
dcl-proc Appender_getLayout export;
  dcl-pi *n like(LOG4RPG_pLayout_t);
    i_pAppender like(LOG4RPG_pAppender_t) const;
  end-pi;

  //  Appender handle
  dcl-ds appender likeds(handle_t) based(i_pAppender);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return appender.pLayout;


end-proc;

//=========================================================================
//  Sets the properties of the specified appender.
//=========================================================================
//  Parameters:
//   i_pAppender   - Handle of the appender returned by Appender_new().
//   i_pPropList   - Handle of the properties list.
//   i_prefix      - Prefix of the relevant property keys.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Appender_setProperties export;
  dcl-pi *n;
    i_pAppender like(LOG4RPG_pAppender_t) const;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

  //  Appender handle
  dcl-ds appender likeds(handle_t) based(i_pAppender);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_pAppender_setProperties =
        appender.appenderImpl.procSetProperties.procptr;
  SrvPgmAppender_setProperties(appender.appenderImpl.pHandle
                               : i_pPropList
                               : i_prefix);

  return;


end-proc;

//=========================================================================
//  Deletes a given appender.
//=========================================================================
//  Parameters:
//   io_pAppender  - Handle of the appender returned by Appender_new().
//
//  Returns:
//   isDeleted     - Returns TRUE on success, else FALSE.
//=========================================================================

dcl-proc Appender_delete export;
  dcl-pi *n ind;
    io_pAppender like(LOG4RPG_pAppender_t);
  end-pi;

  //  Return value
  dcl-s isDeleted ind inz(*off);

  //  Helper fields
  dcl-s name like(appender.name) inz;

  //  Appender handle
  dcl-ds appender likeds(handle_t) based(io_pAppender);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  initializeModule();

  if not Repository_existAppender(appender.name);
    io_pAppender = Appender_null();
    return *on;
  endif;

  LogLog_verbose('Deleting appender [' + appender.name + '] ...');

  name = appender.name;

  // Remove appender from repository
  Repository_removeAppender(appender.name);

  // Delete appender (close appender)
  g_pAppender_delete = appender.appenderImpl.procDelete.procptr;
  isDeleted = SrvPgmAppender_delete(appender.appenderImpl.pHandle);

  // Delete layout
  if Appender_requiresLayout(io_pAppender);
    if not Layout_isNull(appender.pLayout);
      Layout_delete(appender.pLayout);
      appender.pLayout = Layout_null();
    endif;
  endif;

  // Detach filter from appender
  appender.pFilter = Filter_null();

  dealloc(N) io_pAppender;
  io_pAppender = Appender_null();

  LogLog_verbose('- Freed memory of appender [' + name + '].');

  return isDeleted;


end-proc;

//=========================================================================
//  Returns TRUE if the appender requires a layout.
//=========================================================================
//  Parameters:
//   i_pAppender   - Handle of the appender returned by Appender_new().
//
//  Returns:
//   reqLayout     - Returns TRUE if the appender requires a layout,
//                   else FALSE.
//=========================================================================
dcl-proc Appender_requiresLayout export;
  dcl-pi *n ind;
    i_pAppender like(LOG4RPG_pAppender_t) const;
  end-pi;

  //  Return value
  dcl-s reqLayout ind inz(*off);

  //  Appender handle
  dcl-ds appender likeds(handle_t) based(i_pAppender);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_pAppender_requiresLayout =
              appender.appenderImpl.procRequiresLayout.procptr;
  reqLayout = SrvPgmAppender_requiresLayout(
                                appender.appenderImpl.pHandle);

  return reqLayout;


end-proc;

//=========================================================================
//  Sets the layout for the specified appender.
//=========================================================================
//  Parameters:
//   i_pAppender   - Handle of the appender returned by Appender_new().
//   i_pLayout     - Handle of the layout.
//
//  Returns:
//   isSet         - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc Appender_setLayout export;
  dcl-pi *n ind;
    i_pAppender like(LOG4RPG_pAppender_t) const;
    i_pLayout   like(LOG4RPG_pLayout_t) const;
  end-pi;

  //  Appender handle
  dcl-ds appender likeds(handle_t) based(i_pAppender);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  appender.pLayout = i_pLayout;

  return *on;


end-proc;

//=========================================================================
//  Sets the filter for the specified appender.
//=========================================================================
//  Parameters:
//   i_pAppender   - Handle of the appender returned by Appender_new().
//   i_filterName  - Name of the filter.
//
//  Returns:
//   isSet         - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc Appender_setFilter export;
  dcl-pi *n ind;
    i_pAppender like(LOG4RPG_pAppender_t) const;
    i_pFilter   like(LOG4RPG_pFilter_t) const;
  end-pi;

  //  Helper fields
  dcl-s filterName like(LOG4RPG_filterName_t) inz;

  //  Appender handle
  dcl-ds appender likeds(handle_t) based(i_pAppender);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if Filter_isNull(i_pFilter);
    LogLog_warning('Filter is NULL. Please check call from [' +
                   f_caller() + '] to [' + f_this() + '].');
    return *off;
  endif;

  filterName = Filter_getName(i_pFilter);

  if not Repository_existFilter(filterName);
    LogLog_warning('Filter [' + filterName +
                   '] does not exist in repository.');
    return *off;
  endif;

  appender.pFilter = i_pFilter;

  LogLog_debug('Filter [' + filterName +
               '] attached to appender [' + appender.name + '].');

  return *on;


end-proc;

//=========================================================================
//  Returns the filter attached to the appender.
//=========================================================================
//  Parameters:
//   i_pAppender   - Handle of the appender returned by Appender_new().
//
//  Returns:
//   pFilter       - Returns the handle of the filter on success, else
//                   Filter_null();
//=========================================================================
dcl-proc Appender_getFilter export;
  dcl-pi *n like(LOG4RPG_pFilter_t);
    i_pAppender like(LOG4RPG_pAppender_t) const;
  end-pi;

  //  Appender handle
  dcl-ds appender likeds(handle_t) based(i_pAppender);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return appender.pFilter;


end-proc;

//=========================================================================
//  Tests, whether the specified property is known by the
//  super Appender.
//=========================================================================
//  Parameters:
//   i_parameter   - Parameter that is tested.
//
//  Returns:
//   isKnown       - Returns TRUE if the property is known by the super
//                   Appender "class", else FALSE.
//=========================================================================
dcl-proc Appender_knowsProperty export;
  dcl-pi *n ind;
    i_parameter like(LOG4RPG_Property_key_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  select;
  when i_parameter = cPARAMETER_LAYOUT or
       f_startsWith(cPARAMETER_LAYOUT + '.': i_parameter);
    return *on;
  when i_parameter = cPARAMETER_FILTER or
       f_startsWith(cPARAMETER_FILTER + '.': i_parameter);
    return *on;
  other;
    return *off;
  endsl;


end-proc;

//=========================================================================
//  Tests a given appender for a NULL value.
//=========================================================================
//  Parameters:
//   i_pAppender   - Handle of the appender returned by Appender_new().
//
//  Returns:
//   isNull        - Returns TRUE if the handle of the appender is a
//                   NULL handle.
//=========================================================================
dcl-proc Appender_isNull export;
  dcl-pi *n ind;
    i_pAppender like(LOG4RPG_pAppender_t) const;
  end-pi;

  //  Return value
  dcl-s isNull ind inz(*off);

  //  Appender handle
  dcl-ds appender likeds(handle_t) based(i_pAppender);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if i_pAppender = Appender_null();
    isNull = *on;
  else;
    isNull = *off;
  endif;

  return isNull;


end-proc;

//=========================================================================
//  Returns a NULL appender.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pAppender     - Appender NULL handle.
//=========================================================================
dcl-proc Appender_null export;
  dcl-pi *n like(LOG4RPG_pAppender_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return *NULL;


end-proc;

//=========================================================================
//  *** private ***
//  Initializes this module.
//=========================================================================
dcl-proc initializeModule;
  dcl-pi *n;
  end-pi;

  //  Return value
  //
  //  Helper fields
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if g_isInit;
    return;
  endif;

  Loglog_verbose('Initializing module ' + sds.modContProc + '...');

  Repository_initialize();

  g_isInit = *on;

  return;


end-proc;
