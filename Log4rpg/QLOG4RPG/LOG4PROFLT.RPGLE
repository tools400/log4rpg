**free
/if NOT DEFINED(PROTOTYPES_ONLY)
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: PropertyFilter                           *
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
//     >>CMD<<     CRTSRVPGM    SRVPGM(&LI/&OB) +                      *
//                              MODULE(&LI/&OB) +                      *
//                              EXPORT(*ALL) +                         *
//                              ACTGRP(*CALLER) +                      *
//                              ALWUPD(*YES) +                         *
//                              ALWLIBUPD(*YES) +                      *
//                              BNDDIR(QC2LE) +                        *
//                              BNDSRVPGM(&LI/LOG4RPG   +              *
//                                        &LI/BASICS1 ) +              *
//                              TEXT('Tools/400 - Log4rpg +            *
//                                    Property Filter         ') +     *
//                              DETAIL(*BASIC);                        *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
/copy QLOG4RPG,H_SPEC
/copy QLOG4RPG,COPYRIGHT
//=====================================================================*
/endif

//  Creates a new PropertyFilter.
dcl-pr PropertyFilter_new ind extproc('PropertyFilter_new');
  i_pSuper    like(LOG4RPG_pFilter_t) const;
  io_pHandle  pointer;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  Decides what to do with the log event.
dcl-pr PropertyFilter_decide int(10) extproc('PropertyFilter_decide');
  i_pHandle   pointer const;
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Used to set the properties of the filter.
dcl-pr PropertyFilter_setProperties extproc('PropertyFilter_setProperties');
  i_pHandle   pointer const;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  Deletes a given PropertyFilter.
dcl-pr PropertyFilter_delete ind extproc('PropertyFilter_delete');
  io_pHandle pointer;
end-pr;

/if DEFINED(PROTOTYPES_ONLY)
/eof
/endif

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG52

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG                     Public interface & type definitions

dcl-ds handle_t qualified based(pDummy);
  pSuper    like(LOG4RPG_pFilter_t);
  hPropList like(LOG4RPG_pPropertyList_t);
end-ds;

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,CLIB                         C-Library

/copy QLOG4RPG,PLOG4RPG07                   PropertyList
/copy QLOG4RPG,PLOG4RPG10                   LogLog
/copy QLOG4RPG,PLOG4RPG99                   Helper

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Loads the configuration parameters from the specified property list.
dcl-pr loadConfiguration;
  io_handle   likeds(handle_t);
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cTHIS_CLASS;
     D                                            'PropertyFilter')
//
dcl-c cPARAMETER_PROPERTY
      const('property.');

/copy QLOG4RPG,PFILTER

// -----------------------------------------
//  Global fields
// -----------------------------------------

//=====================================================================*
//  Creates a new PropertyFilter.
//=====================================================================*
//  Parameters:
//   io_pHandle   - Handle that is passed around the various calls to
//                  this PropertyFilter.
//   i_pPropsList - Handle of the property list that contains the
//                  properties for the filter.
//   i_prefix     - Prefix of the relevant property keys.

//  Returns:
//   isDone       - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc PropertyFilter_new export;
  dcl-pi *n ind;
    i_pSuper    like(LOG4RPG_pFilter_t) const;
    io_pHandle  pointer;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Helper fields
  dcl-ds tmpHandle likeds(handle_t) inz;
  dcl-ds msg likeds(msg_t) inz;

//  Filter handle
  dcl-ds handle likeds(handle_t) based(io_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

clear tmpHandle;

// Initialize handle
tmpHandle.pSuper    = i_pSuper;   // Handle of the super class 'Filter'
tmpHandle.hPropList = PropertyList_new();

// Initialize handle from configuration properties
if (i_pPropList <> *NULL) and not PropertyList_isNull(i_pPropList);
   loadConfiguration(tmpHandle: i_pPropList: i_prefix);
endif;

io_pHandle = %alloc(%size(tmpHandle));
handle = tmpHandle;

LogLog_debug('Loaded instance of [' + cTHIS_CLASS + '].');

return isDone;


end-proc;

//=====================================================================*
//  Decides what to do with the log event.
//=====================================================================*
//  Parameters:
//   i_pHandle    - Handle that is passed around the various calls to
//                  this PropertyFilter.
//   i_pLogEvent  - Handle of the Log event.

//  Returns:
//   isDone       - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc PropertyFilter_decide export;
  dcl-pi *n int(10);
    i_pHandle   pointer const;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

//  Helper fields
  dcl-s hPropList like(LOG4RPG_pPropertyList_t) inz;
  dcl-ds property likeds(LOG4RPG_property_t) inz;
  dcl-ds propIter DS likeds(LOG4RPG_Property: ListIterator_t) inz;
  end-ds;

//  Filter handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Return if there are no properties to add
if PropertyList_getNumE(handle.hPropList) = 0;
   return cFILTER_NEUTRAL;
endif;

// Get property list of log event
hPropList = LogEvent_getPropertyList(i_pLogEvent);

// Add attributes to log event
propIter = PropertyList_getIterator(handle.hPropList);

property = PropertyList_getFirst(propIter);

dow property.key <> '';
   PropertyList_put(hPropList: property);
   property = PropertyList_getNext(propIter);
enddo;

return cFILTER_NEUTRAL;


end-proc;

//=====================================================================*
//  Used to set the properties of the filter.
//=====================================================================*
//  Parameters:
//   i_pHandle    - Handle that is passed around the various calls to
//                  this PropertyFilter.
//   i_pPropsList - Handle of the property list that contains the
//                  properties for the filter.
//   i_prefix     - Prefix of the relevant property keys.

//  Returns:
//   void
//=====================================================================*
dcl-proc PropertyFilter_setProperties export;
  dcl-pi *n;
    i_pHandle   pointer const;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

//  PropertyFilter-Handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

loadConfiguration(handle: i_pPropList: i_prefix);

return;


end-proc;

//=====================================================================*
//  Deletes a given PropertyFilter.
//=====================================================================*
//  Parameters:
//   io_pHandle   - Handle that is passed around the various calls to
//                  this PropertyFilter.

//  Returns:
//   void
//=====================================================================*
dcl-proc PropertyFilter_delete export;
  dcl-pi *n ind;
    io_pHandle pointer;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Filter handle
  dcl-ds handle likeds(handle_t) based(io_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Delete property list
if not PropertyList_isNull(handle.hPropList);
   PropertyList_delete(handle.hPropList);
endif;

// Clear handle data
clear handle;

// Free handle memory
dealloc(N) io_pHandle;

LogLog_verbose('Deleted instance of [' + cTHIS_CLASS + '].');

isDone = *on;

return isDone;


end-proc;

//=========================================================================
//  *** Private ***
//  Loads the configuration parameters from the specified property list.
//=========================================================================
dcl-proc loadConfiguration;
  dcl-pi *n;
    io_handle   likeds(handle_t);
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

//  Local fields
  dcl-s parameter like(property.key) inz;
  dcl-s prefix like(i_prefix) inz;
  dcl-ds property likeds(LOG4RPG_property_t) inz;
  dcl-ds tmpProperty likeds(LOG4RPG_property_t) inz;
  dcl-ds propIter DS likeds(LOG4RPG_Property: ListIterator_t) inz;
  end-ds;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

prefix = f_lcase(i_prefix);

propIter = PropertyList_getIterator(i_pPropList);

property = PropertyList_getFirst(propIter);

dow property.key <> '';

   if (prefix = '') or (f_startsWith(prefix: property.key) and
                        %len(property.key) > %len(prefix));

      parameter = %subst(property.key: %len(prefix) + 1);

      select;
      when f_startsWith(cPARAMETER_PROPERTY: parameter);
         tmpProperty.key = %subst(parameter
                                  : %len(cPARAMETER_PROPERTY) + 1);
         tmpProperty.value = property.value;
         PropertyList_put(io_handle.hPropList: tmpProperty);
      when Filter_knowsProperty(parameter);
         // Ignore all parameters known by super Filter class
      other;
         LogLog_warning('No such property ['     +
                         property.key            +
                        '] in [' + cTHIS_CLASS + ']');
      endsl;

   endif;

   property = PropertyList_getNext(propIter);
enddo;

return;


end-proc;

