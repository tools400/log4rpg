**free
/if NOT defined(PROTOTYPES_ONLY)
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: HTMLLayout                               *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  02.11.2006                                              *
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
//  07.11.2006  Th.Raddatz    Added missing '</title>' tag.            *
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
//                              BNDSRVPGM(*LIBL/LOG4RPG   +            *
//                                        *LIBL/BASICS1 ) +            *
//                              TEXT('Tools/400 - Log4rpg +            *
//                                    HTMLLayout              ') +     *
//                              DETAIL(*BASIC);                        *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
/copy QLOG4RPG,H_SPEC
/copy QLOG4RPG,COPYRIGHT
//=====================================================================*
/endif

//  Creates a new HTMLLayout.
dcl-pr HTMLLayout_new ind extproc('HTMLLayout_new');
  i_pSuper    like(LOG4RPG_pLayout_t) const;
  io_pHandle  pointer;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  Renders the log event.
dcl-pr HTMLLayout_format extproc('HTMLLayout_format');
  i_pHandle   pointer const;
  i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
end-pr;

//  Returns the header of this layout.
dcl-pr HTMLLayout_getHeader like(LOG4RPG_header_t) extproc('HTMLLayout_getHeader');
  i_pHandle pointer const;
end-pr;

//  Returns the header of this layout.
dcl-pr HTMLLayout_getFooter like(LOG4RPG_footer_t) extproc('HTMLLayout_getFooter');
  i_pHandle pointer const;
end-pr;

//  Used to set the properties of the layout.
dcl-pr HTMLLayout_setProperties extproc('HTMLLayout_setProperties');
  i_pHandle   pointer const;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  Deletes a given HTMLLayout.
dcl-pr HTMLLayout_delete ind extproc('HTMLLayout_delete');
  io_pHandle pointer;
end-pr;

/if defined(PROTOTYPES_ONLY)
/eof
/endif

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG52

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG Public interface & type definitions

dcl-ds handle_t qualified based(pDummy);
  pSuper like(LOG4RPG_pLayout_t);
  title  varchar(128);
  color  likeds(color_t);
end-ds;

dcl-ds color_t qualified based(pDummy);
  info  like(LOG4RPG_colorAttr_t);
  debug like(LOG4RPG_colorAttr_t);
  warn  like(LOG4RPG_colorAttr_t);
  error like(LOG4RPG_colorAttr_t);
  fatal like(LOG4RPG_colorAttr_t);
end-ds;

dcl-s LOG4RPG_colorAttr_t varchar(32) based(pDummy);

dcl-s LOG4RPG_color_t varchar(7) based(pDummy);

dcl-s LOG4RPG_strong_t varchar(6) based(pDummy);

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,CLIB C-Library

//COPY QLOG4RPG,PLOG4RPG07                    PropertyList
/copy QLOG4RPG,PLOG4RPG09 Level
/copy QLOG4RPG,PLOG4RPG10 LogLog
/copy QLOG4RPG,PLOG4RPG99 Helper

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Loads the configuration parameters from the specified property list.
dcl-pr loadConfiguration;
  io_handle   likeds(handle_t);
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  Returns the color for a log event.
dcl-pr getColorAttr like(LOG4RPG_colorAttr_t);
  i_handle likeds(handle_t) const;
  i_level  like(LOG4RPG_level_t) const;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cTHIS_CLASS 'HTMLLayout';

/copy QLOG4RPG,PLAYOUT

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

//=====================================================================*
//  Creates a new HTMLLayout.
//=====================================================================*
//  Parameters:
//   io_pHandle   - Handle that is passed around the various calls to
//                  this HTMLLayout.
//   i_pPropsList - Handle of the property list that contains the
//                  properties for the layout.
//   i_prefix     - Prefix of the relevant property keys.

//  Returns:
//   isDone       - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc HTMLLayout_new export;
  dcl-pi *n ind;
    i_pSuper    like(LOG4RPG_pLayout_t) const;
    io_pHandle  pointer;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

  //  Return value
  dcl-s isDone ind inz(*off);

  //  Helper fields
  dcl-ds tmpHandle likeds(handle_t) inz;
  dcl-ds msg likeds(msg_t) inz;

  //  Layout handle
  dcl-ds handle likeds(handle_t) based(io_pHandle);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear tmpHandle;

  // Initialize handle
  tmpHandle.pSuper    = i_pSuper;   // Handle of the super class 'Layout'
  tmpHandle.title     = 'Log4rpg Log Messages';

  tmpHandle.color.info  = '';
  tmpHandle.color.debug = '#339933';              // green
  tmpHandle.color.warn  = '#FFCC00; strong';      // orange
  tmpHandle.color.error = '#CC3300; strong';      // red
  tmpHandle.color.fatal = '#993300; strong';      // dark red

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
//                  this HTMLLayout.
//   i_pLogEvent  - Handle of the Log event.

//  Returns:
//   isDone       - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc HTMLLayout_format export;
  dcl-pi *n;
    i_pHandle   pointer const;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  Helper fields
  dcl-s htmlString like(LOG4RPG_formattedText_t) inz;
  dcl-s colorAttr varchar(32) inz;
  dcl-s color like(LOG4RPG_color_t) inz;
  dcl-s strong like(LOG4RPG_strong_t) inz;
  dcl-s pToken pointer inz;
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;

  //  Layout handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Start log event ...
  htmlString = Layout_newLine() + '<tr>' + Layout_newLine();

  // ... adding time
  htmlString = htmlString +
     '<td title="Time">' +
        %char(LogEvent_getTime(i_pLogEvent)) +
     '</td>' + Layout_newLine();

  // ... adding job (thread)
  htmlString = htmlString +
     '<td title="Qualified job name">' + %editc(sds.nbr: 'X') + '/' +
                                         %trimR(sds.user)     + '/' +
                                         %trimR(sds.job )           +
     '</td>' + Layout_newLine();

  // ... adding level
  htmlString = htmlString +
     '<td title="Level">';

  colorAttr = getColorAttr(handle: LogEvent_getLevel(i_pLogEvent));

  pToken = strtok(colorAttr: ';');
  if pToken <> *NULL;
    color = %trim(%str(pToken));
    pToken = strtok(*NULL: ';');
  endif;

  if pToken <> *NULL;
    strong = %trim(%str(pToken));
  endif;

  if color = '';
    htmlString = htmlString + LogEvent_getLevel(i_pLogEvent);
  else;
    htmlString = htmlString + '<font color="' + color + '">';
    if strong <> '';
      htmlString = htmlString + '<strong>';
    endif;
    htmlString = htmlString + LogEvent_getLevel(i_pLogEvent);
    if strong <> '';
      htmlString = htmlString + '</strong>';
    endif;
    htmlString = htmlString +  '</font>';
  endif;

  htmlString = htmlString +
     '</td>' + Layout_newLine();

  // ... adding logger name
  htmlString = htmlString +
     '<td title="Logger name">' +
        LogEvent_getLoggerName(i_pLogEvent) +
     '</td>' + Layout_newLine();

  // ... adding caller information
  caller = LogEvent_getCaller(i_pLogEvent);

  htmlString = htmlString +
     '<td title="Procedure:Line">' +
        caller.procedure + ':' + caller.stmtID +
     '</td>' + Layout_newLine();

  // ... adding message
  htmlString = htmlString +
     '<td title="Message">' +
        LogEvent_getText(i_pLogEvent) +
     '</td>' + Layout_newLine();

  // ... close.
  htmlString = htmlString + '</tr>'  + Layout_newLine();

  LogEvent_setText(i_pLogEvent: htmlString);

  return;


end-proc;

//=====================================================================*
//  Returns the header of this layout.
//=====================================================================*
//  Parameters:
//   i_pHandle    - Handle that is passed around the various calls to
//                  this HTMLLayout.

//  Returns:
//   header       - The header string of this layout.
//=====================================================================*
dcl-proc HTMLLayout_getHeader export;
  dcl-pi *n like(LOG4RPG_header_t);
    i_pHandle pointer const;
  end-pi;

  //  Helper fields
  dcl-s htmlString like(LOG4RPG_header_t) inz;

  //  Layout handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  htmlString =
     '<!DOCTYPE HTML PUBLIC "-// 3C//DTD HTML 4.01 Transitional//EN" +
        "http://www.w3.org/TR/html4/loose.dtd">' + Layout_newLine();

  htmlString = htmlString +
     '<html>' + Layout_newLine();

  htmlString = htmlString +
     '<head>' + Layout_newLine();

  htmlString = htmlString +
     '<title>' + handle.title + '</title>' + Layout_newLine();

  htmlString = htmlString +
     '<style type="text/css">' + Layout_newLine();

  htmlString = htmlString +
     '<!--' + Layout_newLine();

  htmlString = htmlString +
     'body, table {font-family: arial,sans-serif; font-size: x-small;}' +
  Layout_newLine();

  htmlString = htmlString +
     'th {background: #336699; color: #FFFFFF; text-align: left;}' +
      Layout_newLine();

  htmlString = htmlString +
     '-->' + Layout_newLine();

  htmlString = htmlString +
     '</style>' + Layout_newLine();

  htmlString = htmlString +
     '</head>' + Layout_newLine();

  htmlString = htmlString +
     '<body bgcolor="#FFFFFF" topmargin="6" leftmargin="6">' +
      Layout_newLine();

  htmlString = htmlString +
     '<hr size="1" noshade>' + Layout_newLine();

  htmlString = htmlString +
     'Log session start time ' + %char(%date: *JOBRUN) + ', ' +
                                 %char(%time: *JOBRUN) +
      '<br>' + Layout_newLine();

  htmlString = htmlString +
     '<br>' + Layout_newLine();

  htmlString = htmlString +
     '<table cellspacing="0" cellpadding="4" border="1" +
      bordercolor="#224466" width="100%">' +
      Layout_newLine();

  htmlString = htmlString +
     '<tr>' + Layout_newLine();

  htmlString = htmlString +
     '<th>Time</th>' + Layout_newLine();

  htmlString = htmlString +
     '<th>Job</th>' + Layout_newLine();

  htmlString = htmlString +
     '<th>Level</th>' + Layout_newLine();

  htmlString = htmlString +
     '<th>Logger</th>' + Layout_newLine();

  htmlString = htmlString +
     '<th>Proc:Line</th>' + Layout_newLine();

  htmlString = htmlString +
     '<th>Message</th>' + Layout_newLine();

  htmlString = htmlString +
     '</tr>' + Layout_newLine();

  return htmlString;


end-proc;

//=====================================================================*
//  Returns the footer of this layout.
//=====================================================================*
//  Parameters:
//   i_pHandle    - Handle that is passed around the various calls to
//                  this HTMLLayout.

//  Returns:
//   footer       - The footer string of this layout.
//=====================================================================*
dcl-proc HTMLLayout_getFooter export;
  dcl-pi *n like(LOG4RPG_footer_t);
    i_pHandle pointer const;
  end-pi;

  //  Helper fields
  dcl-s htmlString like(LOG4RPG_footer_t) inz;

  //  Layout handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  htmlString =
     '</table>' + Layout_newLine();

  htmlString = htmlString +
     '<br>' + Layout_newLine();

  htmlString = htmlString +
     '</body></html>' + Layout_newLine();

  return htmlString;


end-proc;

//=====================================================================*
//  Used to set the properties of the layout.
//=====================================================================*
//  Parameters:
//   i_pHandle    - Handle that is passed around the various calls to
//                  this HTMLLayout.
//   i_pPropsList - Handle of the property list that contains the
//                  properties for the layout.
//   i_prefix     - Prefix of the relevant property keys.

//  Returns:
//   void
//=====================================================================*
dcl-proc HTMLLayout_setProperties export;
  dcl-pi *n;
    i_pHandle   pointer const;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

  //  HTMLLayout-Handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  loadConfiguration(handle: i_pPropList: i_prefix);

  return;


end-proc;

//=====================================================================*
//  Deletes a given HTMLLayout.
//=====================================================================*
//  Parameters:
//   io_pHandle   - Handle that is passed around the various calls to
//                  this HTMLLayout.

//  Returns:
//   void
//=====================================================================*
dcl-proc HTMLLayout_delete export;
  dcl-pi *n ind;
    io_pHandle pointer;
  end-pi;

  //  Return value
  dcl-s isDone ind inz(*off);

  //  Layout handle
  dcl-ds handle likeds(handle_t) based(io_pHandle);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
  dcl-ds propIter likeds(LOG4RPG_PropertyListIterator_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  prefix = f_lcase(i_prefix);

  propIter = PropertyList_getIterator(i_pPropList);

  property = PropertyList_getFirst(propIter);

  dow property.key <> '';

    if (prefix = '') or (f_startsWith(prefix: property.key) and
                         %len(property.key) > %len(prefix));

      parameter = %subst(property.key: %len(prefix) + 1);

      select;
      when Layout_knowsProperty(parameter);
      // Ignore all parameters known by super Layout class
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

//=========================================================================
//  *** Private ***
//  Loads the configuration parameters from the specified property list.
//=========================================================================
dcl-proc getColorAttr;
  dcl-pi *n like(LOG4RPG_colorAttr_t);
    i_handle likeds(handle_t) const;
    i_level  like(LOG4RPG_level_t) const;
  end-pi;

  //  Return value
  dcl-s colorAttr like(LOG4RPG_colorAttr_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  select;
  when i_level = cLOG4RPG_LEVEL_DEBUG;
    colorAttr = i_handle.color.debug;
  when i_level = cLOG4RPG_LEVEL_INFO;
    colorAttr = i_handle.color.info;
  when i_level = cLOG4RPG_LEVEL_WARN;
    colorAttr = i_handle.color.warn;
  when i_level = cLOG4RPG_LEVEL_ERROR;
    colorAttr = i_handle.color.error;
  when i_level = cLOG4RPG_LEVEL_FATAL;
    colorAttr = i_handle.color.fatal;
  other;
    colorAttr = '';
  endsl;

  return colorAttr;


end-proc;
