**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: DailyRollingPrintAppender                *
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
//  25.10.2006  Th.Raddatz    Replaced data structure logEvent with    *
//                            object LogEvent.                         *
//                                                                     *
//  26.10.2006  Th.Raddatz    Moved wordWrap processing to Appender    *
//                            implementation objects.                  *
//                                                                     *
//  27.10.2006  Th.Raddatz    Fixed problem that properties were not   *
//                            found because auf case mismatch.         *
//                                                                     *
//  22.04.2008  Th.Raddatz    Now usinng the OptionConverter to        *
//                            convert properties.                      *
//                                                                     *
//  09.09.2008  Th.Raddatz    Change doAppend() procedure to call      *
//                            LogEvent_getFirstLineOfText() and        *
//                            LogEvent_getNextLineOfText() instead     *
//                            utilizing f_wordwrap().                  *
//                            Improving performance by passing a       *
//                            pointer instead of a field to Rwrite().  *
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
/copy QLOG4RPG,PLOG4RPG51

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG                     Public interface & type definitions
/copy QLOG4RPG,PLOG4RPG12                   ClassLoader

dcl-ds handle_t qualified based(pDummy);
  pSuper      like(LOG4RPG_pAppender_t);
  isOpen      ind;
  hFile       pointer;
  outQ        like(LOG4RPG_path_t);
  splfname    char(10);
  usrDta      char(10);
  length      int(10);
  width       int(10);
  lpi         int(10);
  cpi         int(10);
  ovrflw      int(10);
  leftMargin  int(10);
  rightMargin int(10);
  datePattern varchar(32);
  dateValue   varchar(32);
  layoutImpl  likeds(LOG4RPG_classLayout_t);
end-ds;

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,CLIB                         C-Library
/copy QLOG4RPG,CLIB2                        C-Library 2 (Record IO)

/copy QLOG4RPG,PLOG4RPG07                   PropertyList
/copy QLOG4RPG,PLOG4RPG10                   LogLog
/copy QLOG4RPG,PLOG4RPG98                   OptionConverter
/copy QLOG4RPG,PLOG4RPG99                   Helper

//  Execute Command (QCMDEXC) API
dcl-pr QCMDEXC extpgm('QCMDEXC');
  i_cmd    char(32702) options(*varsize) const;
  i_length packed(15: 5) const;
end-pr;

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Opens a DailyRollingPrintAppender for output.
dcl-pr openAppender ind;
  i_pHandle pointer const;
end-pr;

//  Closes a DailyRollingPrintAppender.
dcl-pr closeAppender ind;
  i_pHandle pointer const;
end-pr;

//  Check if a new file must be started.
dcl-pr isNewFileCondition ind;
  i_handle likeds(handle_t) const;
end-pr;

//  Replace variables.
dcl-pr replaceVariables like(handle_t.datePattern);
  i_string like(handle_t.datePattern) const;
end-pr;

//  Returns the overwrite command for the printer file.
dcl-pr getOverwriteCmd varchar(512);
  i_handle likeds(handle_t) const;
end-pr;

//  Returns the output queue from handle.outQ.
dcl-pr getOutQ like(qObj_t);
  i_path like(LOG4RPG_path_t) const;
end-pr;

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
     D                                            'DailyRollingPrintAppender')
//
dcl-c cDEFAULT_LENGTH
      const(70);
dcl-c cDEFAULT_WIDTH 132;
dcl-c cDEFAULT_LPI 6;
dcl-c cDEFAULT_CPI 10;
dcl-c cDEFAULT_OVRFLW 60;
dcl-c cDEFAULT_LEFT_MARGIN 10;
dcl-c cDEFAULT_RIGHT_MARGIN 10;

dcl-c cPARAMETER_OUTQ 'outq';
dcl-c cPARAMETER_SPLFNAME 'splfname';
dcl-c cPARAMETER_USRDTA 'usrdta';
dcl-c cPARAMETER_PAGE_LENGTH 'length';
dcl-c cPARAMETER_PAGE_WIDTH 'width';
dcl-c cPARAMETER_LPI 'lpi';
dcl-c cPARAMETER_CPI 'cpi';
dcl-c cPARAMETER_OVERFLOW 'ovrflw';
dcl-c cPARAMETER_LEFT_MARGIN 'leftmargin';
dcl-c cPARAMETER_RIGHT_MARGIN 'rightmargin';
dcl-c cPARAMETER_DATE_PATTERN 'datepattern';

dcl-c cDATE_PATTERN_DAYS 'dd';
dcl-c cDATE_PATTERN_MONTHS 'MM';
dcl-c cDATE_PATTERN_YEARS 'yyyy';
dcl-c cDATE_PATTERN_MINUTES 'mm';
dcl-c cDATE_PATTERN_HOURS 'HH';

// -----------------------------------------
//  Global fields
// -----------------------------------------

//=====================================================================*
//  Creates a new DailyRollingPrintAppender.
//=====================================================================*
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this DailyRollingPrintAppender.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.

//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc DailyRollingPrintAppender_new export;
  dcl-pi *n ind;
    i_pSuper    like(LOG4RPG_pAppender_t) const;
    io_pHandle  pointer;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Helper fields
  dcl-ds tempHandle likeds(handle_t) inz;

//  Appender handle
  dcl-ds handle likeds(handle_t) based(io_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

clear tempHandle;

// Initialize handle
tempHandle.pSuper          = i_pSuper;
tempHandle.isOpen          = *off;
tempHandle.hFile           = *NULL;
tempHandle.outQ            = '*N/LOG4RPG';
tempHandle.splfname        = 'LOG4RPG';
tempHandle.usrdta          = 'LOG';
tempHandle.length          = cDEFAULT_LENGTH;
tempHandle.width           = cDEFAULT_WIDTH;
tempHandle.lpi             = cDEFAULT_LPI;
tempHandle.cpi             = cDEFAULT_CPI;
tempHandle.ovrflw          = cDEFAULT_OVRFLW;
tempHandle.leftMargin      = cDEFAULT_LEFT_MARGIN;
tempHandle.rightMargin     = cDEFAULT_RIGHT_MARGIN;
tempHandle.datePattern     = 'yyyy-MM-dd';
tempHandle.dateValue       = '';

// Initialize handle from configuration properties
if (i_pPropList <> *NULL) and not PropertyList_isNull(i_pPropList);
   loadConfiguration(tempHandle: i_pPropList: i_prefix);
endif;

io_pHandle = %alloc(%size(tempHandle));
handle = tempHandle;

LogLog_debug('Loaded instance of [' + cTHIS_CLASS + '].');

return isDone;


end-proc;

//=====================================================================*
//  Returns TRUE if the appender requires a layout.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this DailyRollingPrintAppender.

//  Returns:
//   isDone        - Returns TRUE if the appender requires a layout,
//                   else FALSE.
//=====================================================================*
dcl-proc DailyRollingPrintAppender_requiresLayout export;
  dcl-pi *n ind;
    i_pHandle pointer const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return *on;


end-proc;

//=====================================================================*
//  Appends a message to the PrinterAppender.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this DailyRollingPrintAppender.
//   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().

//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc DailyRollingPrintAppender_doAppend export;
  dcl-pi *n ind;
    i_pHandle   pointer const;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Helper fields
  dcl-s isText ind inz;
  dcl-s pageWidth uns(10) inz;
  dcl-s text like(LOG4RPG_formattedText_t) inz;
  dcl-ds msg likeds(msg_t) inz;
  dcl-ds RIOFB likeds(RIOFB_t) based(pRIOFB);

//  Appender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Return if there is no text
if LogEvent_textLength(i_pLogEvent) = 0;
   return *on;
endif;

// Open the appender for output is it is not yet open
if not handle.isOpen;
   openAppender(i_pHandle);
endif;

// Check if a new file must be started.
if isNewFileCondition(handle);
   if handle.isOpen;
      closeAppender(i_pHandle);
   endif;
   openAppender(i_pHandle);
endif;

// Write to file
f_clrErrno();

pageWidth = handle.width - handle.leftMargin - handle.rightMargin;
text = LogEvent_getFirstLineOfText(i_pLogEvent: isText: pageWidth);
dow isText;

   if handle.leftMargin > 0;
      text = f_space(handle.leftMargin) + text;
   endif;

   %len(text) = handle.width;   // Add trailing blanks to clear
   // print line of QSYSPRT

   monitor;
      text = text;
      pRIOFB = Rwrite(handle.hFile: %addr(text)+2: %len(text));
      if RIOFB.numByt = 0;
         isDone = *off;
      else;
         isDone = *on;
      endif;
   on-error;
      p_rmvPgmMsg(cMsg_Rmv_All: *omit: cMsg_Same: cMsg_ToMyself);
      isDone = *off;
   endmon;

   text = LogEvent_getNextLineOfText(i_pLogEvent: isText: pageWidth);
enddo;

if not isDone;
   LogLog_error('Failed to write logEevent to file [' +
                 handle.outQ + ']');
   if f_errno() <> 0;
      LogLog_errorMsg(f_cvtErrnoToMsg(f_errno));
   endif;
endif;

return isDone;


end-proc;

//=====================================================================*
//  Used to set the properties of the appender.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this DailyRollingFileAppender.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.

//  Returns:
//   void
//=====================================================================*
dcl-proc DailyRollingPrintAppender_setProperties export;
  dcl-pi *n;
    i_pHandle   pointer const;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

//  DailyRollingPrintAppender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

loadConfiguration(handle: i_pPropList: i_prefix);

return;


end-proc;

//=====================================================================*
//  Deletes a given DailyRollingPrintAppender.
//=====================================================================*
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this DailyRollingPrintAppender.

//  Returns:
//   void
//=====================================================================*
dcl-proc DailyRollingPrintAppender_delete export;
  dcl-pi *n ind;
    io_pHandle pointer;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Appender handle
  dcl-ds handle likeds(handle_t) based(io_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Close file if it is left open
if handle.isOpen;
   closeAppender(io_pHandle);
endif;

// Clear handle data
clear handle;

// Free handle memory
dealloc(N) io_pHandle;

LogLog_verbose('Deleted instance of [' + cTHIS_CLASS + '].');

isDone = *on;

return isDone;


end-proc;

//=====================================================================*
//  *** Private ***
//  Opens a DailyRollingPrintAppender for output.
//=====================================================================*
dcl-proc openAppender;
  dcl-pi *n ind;
    i_pHandle pointer const;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Appender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);

//  Helper fields
  dcl-s cmd varchar(512) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Set end of livetime of file
handle.dateValue = replaceVariables(handle.datePattern);

// Open new instance of file
if handle.hFile = *NULL;
   cmd   = getOverwriteCmd(handle);

   monitor;
      p_rmvPgmMsg(cMsg_Rmv_All: *omit: cMsg_Same: cMsg_ToMyself);
      qcmdexc(cmd: %len(cmd));
   on-error;
      p_rmvPgmMsg(cMsg_Rmv_All: *omit: cMsg_Same: cMsg_ToMyself);
      LogLog_error('Error on OVRPRTF with command ' + cmd);
   endmon;

   handle.hFile = Ropen('*LIBL/QSYSPRT': 'wr');

   if handle.hFile = *NULL;
      isDone = *off;
   else;
      isDone = *on;
      handle.isOpen = *on;
   endif;

endif;

return isDone;


end-proc;

//=====================================================================*
//  *** Private ***
//  Closes a DailyRollingPrintAppender.
//=====================================================================*
dcl-proc closeAppender;
  dcl-pi *n ind;
    i_pHandle pointer const;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Appender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if Rclose(handle.hFile) = 0;
   handle.isOpen = *off;
   handle.hFile  = *NULL;
   isDone = *on;
else;
   isDone = *off;
endif;

return isDone;


end-proc;

//=====================================================================*
//  *** private ***
//  Check overflow condition.
//=====================================================================*
dcl-proc isNewFileCondition;
  dcl-pi *n ind;
    i_handle likeds(handle_t) const;
  end-pi;

//  Return value
  dcl-s isNewFile ind inz(*off);

//  Helper fields
  dcl-s cmpDateValue like(i_handle.dateValue) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cmpdateValue = replaceVariables(i_handle.datePattern);

if i_handle.dateValue <> cmpDateValue;
   isNewFile = *on;
else;
   isNewFile = *off;
endif;

return isNewFile;


end-proc;

//=========================================================================
//  *** Private ***
//  Replace variables.
//=========================================================================
dcl-proc replaceVariables;
  dcl-pi *n like(handle_t.datePattern);
    i_string like(handle_t.datePattern) const;
  end-pi;

//  Return value
  dcl-s string like(handle_t.datePattern) inz;

//  Helper fields
  dcl-s timestamp timestamp inz;
  dcl-s days zoned(2) inz;
  dcl-s months zoned(2) inz;
  dcl-s years zoned(4) inz;
  dcl-s minutes zoned(2) inz;
  dcl-s hours zoned(2) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

timestamp = %timestamp();
days    = %subdt(timestamp: *DAYS    );
months  = %subdt(timestamp: *MONTHS  );
years   = %subdt(timestamp: *YEARS   );
minutes = %subdt(timestamp: *MINUTES );
hours   = %subdt(timestamp: *HOURS   );

string = i_string;

string = f_replace(cDATE_PATTERN_DAYS
                   : %editc(days   : 'X'): string);
string = f_replace(cDATE_PATTERN_MONTHS
                   : %editc(months : 'X'): string);
string = f_replace(cDATE_PATTERN_YEARS
                   : %editc(years  : 'X'): string);
string = f_replace(cDATE_PATTERN_MINUTES
                   : %editc(minutes: 'X'): string);
string = f_replace(cDATE_PATTERN_HOURS
                   : %editc(hours  : 'X'): string);

return string;


end-proc;

//=========================================================================
//  *** Private ***
//  Returns the overwrite command for the printer file.
//=========================================================================
dcl-proc getOverwriteCmd;
  dcl-pi *n varchar(512);
    i_handle likeds(handle_t) const;
  end-pi;

//  Return value
  dcl-s cmd varchar(512) inz;

//  Helper fields
  dcl-ds qOutq likeds(qObj_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

qOutQ = getOutQ(i_handle.outQ);

cmd = 'OVRPRTF ' +
         'FILE(QSYSPRT) ' +
         'TOFILE(*FILE) ' +
         'PAGESIZE('   + %char(i_handle.length)  + ' ' +
                         %char(i_handle.width )  + ') ' +
         'LPI('        + %char(i_handle.lpi)     + ') ' +
         'CPI('        + %char(i_handle.cpi)     + ') ' +
         'OVRFLW('     + %char(i_handle.ovrflw)  + ') ' +
         'OUTQ('       + %trim(qOutQ.lib)  + '/' +
                         %trim(qOutQ.name)       + ') ' +
         'USRDTA('''   + i_handle.usrDta         + ''') ' +
         'SPLFNAME('   + i_handle.splfname       + ') ' +
         'OVRSCOPE(*CALLLVL)';

return cmd;


end-proc;

//=========================================================================
//  *** Private ***
//  Returns the output queue from handle.outQ.
//=========================================================================
dcl-proc getOutQ;
  dcl-pi *n like(qObj_t);
    i_outQ like(LOG4RPG_path_t) const;
  end-pi;

//  Return value
  dcl-ds qOutQ likeds(qObj_t) inz;

//  Local fields
  dcl-s x int(10) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if i_outQ = '';
   qOutQ.name = '*N';
   qOutQ.lib  = '*N';
   return qOutQ;
endif;

x = %scan('/': i_outQ);

if (x > 1) and (x < %len(i_outQ));
   qOutQ.name = %subst(i_outQ: x+1);
   qOutQ.lib  = f_left(i_outQ: x-1);
else;
   qOutQ.name = i_outQ;
   qOutQ.lib  = '*N';
endif;

return qOutQ;


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
  dcl-ds propIter DS likeds(LOG4RPG_Property: ListIterator_t) inz;
  end-ds;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

prefix = f_lcase(i_prefix);

propIter = PropertyList_getIterator(i_pPropList);

property = PropertyList_getFirst(propIter);

dow property.key <> '';

   if (prefix = '') or (f_startsWith(prefix: property.key) and
                        %len(property.key) > %len(prefix));

      parameter = f_lcase(%subst(property.key: %len(prefix) + 1));

      select;
      when parameter = cPARAMETER_OUTQ;
         io_handle.outQ        = property.value;
      when parameter = cPARAMETER_SPLFNAME;
         io_handle.splfname    = property.value;
      when parameter = cPARAMETER_USRDTA;
         io_handle.usrdta      = property.value;
      when parameter = cPARAMETER_PAGE_LENGTH;
         io_handle.length =
            OptionConverter_toInt(
               property.value: cDEFAULT_LENGTH);
      when parameter = cPARAMETER_PAGE_WIDTH;
         io_handle.width =
            OptionConverter_toInt(
               property.value: cDEFAULT_WIDTH);
      when parameter = cPARAMETER_LPI;
         io_handle.lpi =
            OptionConverter_toInt(
               property.value: cDEFAULT_LPI);
      when parameter = cPARAMETER_CPI;
         io_handle.cpi =
            OptionConverter_toInt(
               property.value: cDEFAULT_CPI);
      when parameter = cPARAMETER_OVERFLOW;
         io_handle.ovrflw =
            OptionConverter_toInt(
               property.value: cDEFAULT_OVRFLW);
      when parameter = cPARAMETER_LEFT_MARGIN;
         io_handle.leftMargin =
            OptionConverter_toInt(
               property.value: cDEFAULT_LEFT_MARGIN);
      when parameter = cPARAMETER_RIGHT_MARGIN;
         io_handle.rightMargin =
            OptionConverter_toInt(
               property.value: cDEFAULT_RIGHT_MARGIN);
      when parameter = cPARAMETER_DATE_PATTERN;
         io_handle.datePattern = property.value;
      when Appender_knowsProperty(parameter);
         // Ignore all parameters known by super Appender class
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

