**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: Layout                                   *
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
//  27.10.2006  Th.Raddatz    Removed return value from procedure      *
//                            Layout_format().                         *
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
/copy QLOG4RPG,PLOG4RPG11

// -----------------------------------------
//  Type definitions
// -----------------------------------------
dcl-ds handle_t qualified based(pDummy);
  layoutImpl likeds(LOG4RPG_classLayout_t);
end-ds;

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,CLIB C Library
/copy QLOG4RPG,CEELIB CEE-Procedures
/copy QBASICS1,PBASICS1 Basic RPG Extensions

/copy QLOG4RPG,PLOG4RPG07 PropertyList
/copy QLOG4RPG,PLOG4RPG10 LogLog
/copy QLOG4RPG,PLOG4RPG12 ClassLoader
/copy QLOG4RPG,PLOG4RPG99 Helpers

/define DEFINE_PROCPTR
/copy QLOG4RPG,PLAYOUT Layout implementation
/undefine DEFINE_PROCPTR

// -----------------------------------------
//  Private prototypes
// -----------------------------------------
//
// -----------------------------------------
//  Global constants
// -----------------------------------------
//
// -----------------------------------------
//  Global fields
// -----------------------------------------
//
//=========================================================================
//  Creates a new layout.
//=========================================================================
//  Parameters:
//   i_layoutImpl  - A string that specifies the layout implementation
//                   object.
//   i_pPropString - A string that specifies the properties for the
//                   layout implementation object.
//
//  Returns:
//   pLayout       - Returns a handle to the layout object on success,
//                   else a NULL handle.
//=========================================================================
dcl-proc Layout_new export;
  dcl-pi *n like(LOG4RPG_pLayout_t);
    i_layoutImpl  like(LOG4RPG_implClass_t) const;
    i_pPropString pointer options(*nopass: *omit: *string) const;
  end-pi;

  //  Return value
  dcl-ds layout likeds(handle_t) based(pLayout);

  //  Paremeter positions
  dcl-c p_pPropString 2;

  //  Fields for optional parameters
  dcl-s pPropString like(i_pPropString) inz;

  //  Helper fields
  dcl-s isPresent int(10) inz;
  dcl-s pPropList like(LOG4RPG_pPropertyList_t) inz;
  dcl-ds tempLayout likeds(handle_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LogLog_debug('Creating layout ...');

  pLayout = Layout_null();

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

  // Initialize layout;
  if not ClassLoader_resolveLayout(i_layoutImpl: tempLayout.layoutImpl);
    return pLayout;
  endif;

  // Create properties list
  if pPropString <> *NULL;
    pPropList = PropertyList_new(pPropString);
  else;
    pPropList = PropertyList_null();
  endif;

  // Create layout handle
  pLayout = %alloc(%size(handle_t));
  layout = tempLayout;

  // Instanciate layout implementation object
  g_pLayout_new = layout.layoutImpl.procNew.procptr;
  SrvPgmLayout_new(pLayout
                   : layout.layoutImpl.pHandle
                   : pPropList
                   : '');

  // Destroy properties list
  if not PropertyList_isNull(pPropList);
    PropertyList_delete(pPropList);
  endif;

  LogLog_verbose('+ Allocated memory for layout.');

  return pLayout;


end-proc;

//=========================================================================
//  Formats the given string according to the layout.
//=========================================================================
//  Parameters:
//   i_pLayout     - Handle of the layout returned by Layout_new().
//
//  Returns:
//   text          - Returns the formatted text on success, else ''.
//=========================================================================
dcl-proc Layout_format export;
  dcl-pi *n;
    i_pLayout   like(LOG4RPG_pLayout_t) const;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  Layout handle
  dcl-ds layout likeds(handle_t) based(i_pLayout);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LogLog_verbose('-> Formatting log event of logger [' +
                     LogEvent_getLoggerName(i_pLogEvent) + ']...');

  g_pLayout_format = layout.layoutImpl.procFormat.procptr;
  SrvPgmLayout_format(layout.layoutImpl.pHandle
                      : i_pLogEvent);

  return;


end-proc;

//=========================================================================
//  Returns the header of the layout. (optional layout procedure)
//=========================================================================
//  Parameters:
//   i_pLayout     - Handle of the layout returned by Layout_new().
//
//  Returns:
//   header        - Returns the header of the layout.
//=========================================================================
dcl-proc Layout_getHeader export;
  dcl-pi *n like(LOG4RPG_header_t);
    i_pLayout like(LOG4RPG_pLayout_t) const;
  end-pi;

  //  Return value
  dcl-s header like(LOG4RPG_header_t) inz;

  //  Layout handle
  dcl-ds layout likeds(handle_t) based(i_pLayout);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_pLayout_getHeader = layout.layoutImpl.procGetHeader.procptr;

  if g_pLayout_getHeader <> *NULL;
    header = SrvPgmLayout_getHeader(layout.layoutImpl.pHandle);
  endif;

  return header;


end-proc;

//=========================================================================
//  Returns the footer of the layout. (optional layout procedure)
//=========================================================================
//  Parameters:
//   i_pLayout     - Handle of the layout returned by Layout_new().
//
//  Returns:
//   footer        - Returns the footer of the layout.
//=========================================================================
dcl-proc Layout_getFooter export;
  dcl-pi *n like(LOG4RPG_footer_t);
    i_pLayout like(LOG4RPG_pLayout_t) const;
  end-pi;

  //  Return value
  dcl-s footer like(LOG4RPG_footer_t) inz;

  //  Layout handle
  dcl-ds layout likeds(handle_t) based(i_pLayout);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_pLayout_getFooter = layout.layoutImpl.procGetFooter.procptr;

  if g_pLayout_getFooter <> *NULL;
    footer = SrvPgmLayout_getFooter(layout.layoutImpl.pHandle);
  endif;

  return footer;


end-proc;

//=========================================================================
//  Returns the new-line character.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   newLine       - The new line charcater of the system.
//=========================================================================
dcl-proc Layout_newLine export;
  dcl-pi *n varchar(2);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return '\n';


end-proc;

//=========================================================================
//  Sets the properties of the specified layout.
//=========================================================================
//  Parameters:
//   i_pLayout     - Handle of the layout returned by Layout_new().
//   i_pPropList   - Handle of the properties list.
//   i_prefix      - Prefix of the relevant property keys.
//
//  Returns:
//   void
//=========================================================================
dcl-proc Layout_setProperties export;
  dcl-pi *n;
    i_pLayout   like(LOG4RPG_pLayout_t) const;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

  //  Layout handle
  dcl-ds layout likeds(handle_t) based(i_pLayout);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_pLayout_setProperties =
        layout.layoutImpl.procSetProperties.procptr;
  SrvPgmLayout_setProperties(layout.layoutImpl.pHandle
                             : i_pPropList
                             : i_prefix);

  return;


end-proc;

//=========================================================================
//  Deletes the specified layout.
//=========================================================================
//  Parameters:
//   io_pLayout    - Handle of the layout returned by Layout_new().
//
//  Returns:
//   isDeleted     - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc Layout_delete export;
  dcl-pi *n ind;
    io_pLayout like(LOG4RPG_pLayout_t);
  end-pi;

  //  Return value
  dcl-s isDeleted ind inz(*off);

  //  Layout handle
  dcl-ds layout likeds(handle_t) based(io_pLayout);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LogLog_verbose('Deleting layout ...');

  // Delete layout
  g_pLayout_delete = layout.layoutImpl.procDelete.procptr;
  isDeleted = SrvPgmLayout_delete(layout.layoutImpl.pHandle);

  dealloc(N) io_pLayout;
  io_pLayout = Layout_null();

  LogLog_verbose('- Free memory of layout.');

  return isDeleted;


end-proc;

//=========================================================================
//  Tests, whether the specified property is known by the
//  super Layout.
//=========================================================================
//  Parameters:
//   i_parameter   - Parameter that is tested.
//
//  Returns:
//   isKnown       - Returns TRUE if the property is known by the super
//                   Layout "class", else FALSE.
//=========================================================================
dcl-proc Layout_knowsProperty export;
  dcl-pi *n ind;
    i_parameter like(LOG4RPG_Property_key_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  select;
  other;
    return *off;
  endsl;


end-proc;

//=========================================================================
//  Tests the specified layout for a NULL value.
//=========================================================================
//  Parameters:
//   i_pLayout     - Handle of the property list returned by
//                   Layout_new().
//
//  Returns:
//   isNull        - Returns TRUE if the handle of the layout is a
//                   NULL handle.
//=========================================================================
dcl-proc Layout_isNull export;
  dcl-pi *n ind;
    i_pLayout like(LOG4RPG_pLayout_t) const;
  end-pi;

  //  Return value
  dcl-s isNull ind inz(*off);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if i_pLayout = Layout_null();
    isNull = *on;
  else;
    isNull = *off;
  endif;

  return isNull;


end-proc;

//=========================================================================
//  Returns a NULL layout.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pLayout       - Layout NULL handle.
//=========================================================================
dcl-proc Layout_null export;
  dcl-pi *n like(LOG4RPG_pLayout_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return *NULL;


end-proc;
