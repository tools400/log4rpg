**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: Filter                                   *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  18.10.2006                                              *
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
/copy QLOG4RPG,PLOG4RPG17

// -----------------------------------------
//  Type definitions
// -----------------------------------------
dcl-ds handle_t qualified based(pDummy);
  name        like(LOG4RPG_filterName_t);
  filterImpl  likeds(LOG4RPG_classFilter_t);
  pNextFilter like(LOG4RPG_pFilter_t);
end-ds;

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,CEELIB                        CEE-Procedures
/copy QBASICS1,PBASICS1                      Basic RPG Extensions

/copy QLOG4RPG,PLOG4RPG07                    PropertyList
/copy QLOG4RPG,PLOG4RPG10                    LogLog
/copy QLOG4RPG,PLOG4RPG12                    ClassLoader
/copy QLOG4RPG,PLOG4RPG13                    Repository
/copy QLOG4RPG,PLOG4RPG16                    LogEvent

/define DEFINE_PROCPTR
/copy QLOG4RPG,PFILTER                       Filter implementation
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
dcl-c cPARAMETER_NEXT_FILTER 'nextfilter';

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
//  Creates a new filter.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pFilter       - Returns a handle to the filter on success, else
//                   a NULL handle.
//=========================================================================
dcl-proc Filter_new export;
  dcl-pi *n like(LOG4RPG_pFilter_t);
    i_fltName     like(LOG4RPG_filterName_t) const;
    i_fltImpl     like(LOG4RPG_implClass_t) const;
    i_pPropString pointer options(*nopass: *omit: *string) const;
  end-pi;

//  Return value
  dcl-ds filter likeds(handle_t) based(pFilter);

//  Paremeter positions
  dcl-c p_pPropString 3;

//  Fields for optional parameters
  dcl-s pPropString like(i_pPropString) inz;

//  Helper fields
  dcl-s isPresent int(10) inz;
  dcl-s pPropList like(LOG4RPG_pPropertyList_t) inz;
  dcl-ds tempFilter likeds(handle_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

initializeModule();

LogLog_debug('Creating filter [' + i_fltName + '] ...');

pFilter = Filter_null();

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

// Initialize filter
tempFilter.name    = i_fltName;
if not ClassLoader_resolveFilter(i_fltImpl: tempFilter.filterImpl);
   return pFilter;
endif;
tempFilter.pNextFilter = Filter_null();

// Create properties list
if pPropString <> *NULL;
   pPropList = PropertyList_new(pPropString);
else;
   pPropList = PropertyList_null();
endif;

// Create filter handle
pFilter  = %alloc(%size(handle_t));
filter   = tempFilter;

// Instanciate filter implementation object
g_pFilter_new = filter.filterImpl.procNew.procptr;
SrvPgmFilter_new(pFilter
                 : filter.filterImpl.pHandle
                 : pPropList
                 : '');

// Destroy properties list
if not PropertyList_isNull(pPropList);
   PropertyList_delete(pPropList);
endif;

// Add filter to the repository
Repository_addFilter(pFilter);

LogLog_verbose('+ Allocated memory for filter [' +
                  filter.name + '].');

return pFilter;


end-proc;

//=========================================================================
//  Decides what to do with the log event.
//=========================================================================
//  Parameters:
//   i_pLogEvent   - Handle of the Log event.
//
//  Returns:
//   decision      - The decison of the filter how to treat the log event.
//                   Valid values are:   cFILTER_ACCEPT
//                                       cFILTER_DENY
//                                       cFILTER_NEUTRAL
//=========================================================================
dcl-proc Filter_decide export;
  dcl-pi *n int(10);
    i_pFilter   like(LOG4RPG_pFilter_t) const;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

//  Return value
  dcl-s decision int(10) inz;

//  Helper fields

//  Filter handle
  dcl-ds filter likeds(handle_t) based(i_pFilter);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

LogLog_verbose('-> Filtering log event of logger [' +
                   LogEvent_getLoggerName(i_pLogEvent) + ']...');

g_pFilter_decide = filter.filterImpl.procDecide.procptr;
decision = SrvPgmFilter_decide(filter.filterImpl.pHandle
                               : i_pLogEvent);

LogLog_verbose('-> Decision: ' + %char(decision));

return decision;


end-proc;

//=========================================================================
//  Returns the name of the filter.
//=========================================================================
//  Parameters:
//   i_pFilter     - Handle of the filter returned by Filter_new().
//
//  Returns:
//   name          - Name of the specidfied filter.
//=========================================================================
dcl-proc Filter_getName export;
  dcl-pi *n like(LOG4RPG_filterName_t);
    i_pFilter like(LOG4RPG_pFilter_t) const;
  end-pi;

//  Filter handle
  dcl-ds filter likeds(handle_t) based(i_pFilter);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return filter.name;


end-proc;

//=========================================================================
//  Returns the next filter.
//=========================================================================
//  Parameters:
//   i_pFilter     - Handle of the filter returned by Filter_new().
//
//  Returns:
//   pFilter       - Next filter of filter chain.
//=========================================================================
dcl-proc Filter_getNext export;
  dcl-pi *n like(LOG4RPG_pFilter_t);
    i_pFilter like(LOG4RPG_pFilter_t) const;
  end-pi;

//  Filter handle
  dcl-ds filter likeds(handle_t) based(i_pFilter);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return filter.pNextFilter;


end-proc;

//=========================================================================
//  Sets the next filter of the filter chain.
//=========================================================================
//  Parameters:
//   i_pFilter     - Handle of the filter returned by Filter_new().
//   i_pNextFilter - Next filter of filter chain.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Filter_setNext export;
  dcl-pi *n;
    i_pFilter     like(LOG4RPG_pFilter_t) const;
    i_pNextFilter like(LOG4RPG_pFilter_t) const;
  end-pi;

//  Filter handle
  dcl-ds filter likeds(handle_t) based(i_pFilter);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

filter.pNextFilter = i_pNextFilter;

return;


end-proc;

//=========================================================================
//  Sets the properties of the specified filter.
//=========================================================================
//  Parameters:
//   i_pFilter     - Handle of the filter returned by Filter_new().
//   i_pPropList   - Handle of the properties list.
//   i_prefix      - Prefix of the relevant property keys.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Filter_setProperties export;
  dcl-pi *n;
    i_pFilter   like(LOG4RPG_pFilter_t) const;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

//  Filter handle
  dcl-ds filter likeds(handle_t) based(i_pFilter);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

g_pFilter_setProperties =
      filter.filterImpl.procSetProperties.procptr;
SrvPgmFilter_setProperties(filter.filterImpl.pHandle
                           : i_pPropList
                           : i_prefix);

return;


end-proc;

//=========================================================================
//  Deletes a given filter.
//=========================================================================
//  Parameters:
//   io_pFilter    - Handle of the filter returned by Filter_new().
//
//  Returns:
//   isDeleted     - Returns TRUE on success, else FALSE.
//=========================================================================

dcl-proc Filter_delete export;
  dcl-pi *n ind;
    io_pFilter like(LOG4RPG_pFilter_t);
  end-pi;

//  Return value
  dcl-s isDeleted ind inz(*off);

//  Helper fields
  dcl-s name like(filter.name) inz;

//  Filter handle
  dcl-ds filter likeds(handle_t) based(io_pFilter);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

initializeModule();

if not Repository_existFilter(filter.name);
   io_pFilter = Filter_null();
   return *on;
endif;

LogLog_verbose('Deleting filter [' + filter.name + '] ...');

name = filter.name;

// Remove filter from repository
Repository_removeFilter(filter.name);

// Delete filter
g_pFilter_delete = filter.filterImpl.procDelete.procptr;
isDeleted = SrvPgmFilter_delete(filter.filterImpl.pHandle);

dealloc(N) io_pFilter;
io_pFilter = Filter_null();

LogLog_verbose('- Freed memory of filter [' + name + '].');

return isDeleted;


end-proc;

//=========================================================================
//  Tests, whether the specified property is known by the
//  super filter.
//=========================================================================
//  Parameters:
//   i_parameter   - Parameter that is tested.
//
//  Returns:
//   isKnown       - Returns TRUE if the property is known by the super
//                   Filter "class", else FALSE.
//=========================================================================
dcl-proc Filter_knowsProperty export;
  dcl-pi *n ind;
    i_parameter like(LOG4RPG_Property_key_t) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

select;
when i_parameter = cPARAMETER_NEXT_FILTER or
     f_startsWith(cPARAMETER_NEXT_FILTER + '.': i_parameter);
   return *on;
other;
   return *off;
endsl;


end-proc;

//=========================================================================
//  Tests a given filter for a NULL value.
//=========================================================================
//  Parameters:
//   i_pFilter     - Handle of the filter returned by Filter_new().
//
//  Returns:
//   isNull        - Returns TRUE if the handle of the filter is a
//                   NULL handle.
//=========================================================================
dcl-proc Filter_isNull export;
  dcl-pi *n ind;
    i_pFilter like(LOG4RPG_pFilter_t) const;
  end-pi;

//  Return value
  dcl-s isNull ind inz(*off);

//  Filter handle
  dcl-ds filter likeds(handle_t) based(i_pFilter);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if i_pFilter = Filter_null();
   isNull = *on;
else;
   isNull = *off;
endif;

return isNull;


end-proc;

//=========================================================================
//  Returns a NULL filter.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pFilter       - Filter NULL handle.
//=========================================================================
dcl-proc Filter_null export;
  dcl-pi *n like(LOG4RPG_pFilter_t);
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

