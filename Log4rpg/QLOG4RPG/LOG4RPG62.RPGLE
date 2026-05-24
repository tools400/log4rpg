**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: XMLLayout                                *
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
//  27.10.2006  Th.Raddatz    Replaced data structure logEvent with    *
//                            object LogEvent.                         *
//                            Removed return value from procedure      *
//                            PatternLayout_format().                  *
//                            Fixed problem that properties were not   *
//                            found because auf case mismatch.         *
//                                                                     *
//  25.04.2007  Th.Raddatz    The log event was not correctly produced *
//                            when i_text contained ']]>'. Now ']]>'   *
//                            is replaced with ']]&gt'.                *
//                                                                     *
//  03.04.2012  Th.Raddatz    Fixed problem that some special          *
//                            charcaters were not properly translated  *
//                            to job CCSID when producing the XML      *
//                            message.                                 *
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
/copy QLOG4RPG,PLOG4RPG62

// -----------------------------------------
//  Type definitions
// -----------------------------------------

dcl-ds handle_t qualified based(pDummy);
  pSuper           like(LOG4RPG_pLayout_t);
  rplUnprtChars    ind;
  substitutionChar varchar(1);
  encoding         varchar(32);
end-ds;

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG07 PropertyList
/copy QLOG4RPG,PLOG4RPG09 Level
/copy QLOG4RPG,PLOG4RPG10 LogLog
/copy QLOG4RPG,PLOG4RPG99 Helper

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Loads the configuration parameters from the specified property list.
dcl-pr loadConfiguration extproc('loadConfiguration');
  io_handle   likeds(handle_t);
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  Ersetzt nicht darstellbare Zeichen
dcl-pr rplcUnprtChars like(LOG4RPG_formattedText_t) extproc('rplcUnprtChars');
  i_handle likeds(handle_t) const;
  i_text   like(LOG4RPG_formattedText_t) const;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cTHIS_CLASS 'XMLLayout';

dcl-c cPARAMETER_REPLACE_UNPRINTABLE_CHARACTERS 'replaceunprintablecharacters';
dcl-c cPARAMETER_SUBSTITUTION_CHARACTER 'substitutionCharacter';
dcl-c cPARAMETER_ENCODING 'encoding';

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
//  Creates a new XMLLayout.
//=========================================================================
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this XMLLayout.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.
//
//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc XMLLayout_new export;
  dcl-pi *n ind;
    i_pSuper    like(LOG4RPG_pLayout_t) const;
    io_pHandle  pointer;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

  //  Return value
  dcl-s isDone ind inz(*off);

  dcl-s REPLACEMENT_CHARACTER ucs2(1) inz(u'00F7');

  //  Helper fields
  dcl-ds tempHandle likeds(handle_t) inz;

  //  XMLLayout handle
  dcl-ds handle likeds(handle_t) based(io_pHandle);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear tempHandle;

  // Initialize handle
  tempHandle.pSuper        = i_pSuper;   // Handle of the super class 'Layout'
  tempHandle.rplUnprtChars = *off;
  tempHandle.substitutionChar = REPLACEMENT_CHARACTER;
  tempHandle.encoding         = '';

  // Initialize handle from configuration properties
  if (i_pPropList <> *NULL) and not PropertyList_isNull(i_pPropList);
    loadConfiguration(tempHandle: i_pPropList: i_prefix);
  endif;

  io_pHandle = %alloc(%size(tempHandle));
  handle = tempHandle;

  LogLog_debug('Loaded instance of [' + cTHIS_CLASS + '].');

  return isDone;


end-proc;

//=========================================================================
//  Formats a logging event and returns the result as a string.
//=========================================================================
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this XMLLayout.
//   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
//                   text of the log event that is formated.
//
//  Returns:
//   text          - Returns the formatted text of the log event.
//=========================================================================
dcl-proc XMLLayout_format export;
  dcl-pi *n;
    i_pHandle   pointer const;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  Helper fields
  dcl-s xmlString like(LOG4RPG_formattedText_t) inz;
  dcl-s isStarted ind inz(*off);
  dcl-s pPropList like(LOG4RPG_pPropertyList_t) inz;
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;
  dcl-ds property likeds(LOG4RPG_property_t) inz;
  dcl-ds propIter likeds(LOG4RPG_PropertyListIterator_t) inz;

  //  Convert RPG timestamp to Epoch time (mSeconds since January 1, 1970)
  dcl-s elapsedEpochTime uns(20) inz;
  dcl-s mSeconds uns(20) inz;
  dcl-s logTime timestamp inz;

  dcl-c cBASE_TIME z'1970-01-01-00.00.00.000000';

  //  Get Offset from Universal Time Coordinated to Local Time (CEEUTCO) API
  dcl-s hours int(10) inz;
  dcl-s minutes int(10) inz;
  dcl-s seconds float(8) inz;

  dcl-pr CEEUTCO opdesc;
    Hours   int(10);
    Minutes int(10);
    Seconds float(8);
  end-pr;

  //  XMLLayout handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);

  dcl-s START_CDATA ucs2(9) inz(u'003C0021005B00430044004100540041005B'); // <![CDATA[
  dcl-s END_CDATA ucs2(3) inz(u'005D005D003E'); // ]]>
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Convert log timestamp to Epoch time since this is
  // what 'Chainsaw' expects:
  mSeconds = %subdt(LogEvent_getTime(i_pLogEvent): *MSECONDS);
  logTime  = LogEvent_getTime(i_pLogEvent) - %mseconds(mSeconds);
  elapsedEpochTime = %diff(logTime: cBASE_TIME: *SECONDS);
  CEEUTCO(hours: minutes: seconds);
  elapsedEpochTime = elapsedEpochTime - seconds;
  elapsedEpochTime = (elapsedEpochTime * 1000) + (mSeconds / 1000);

  // Start log event ...
  xmlString = '<log4j:event logger="'                  +
                 LogEvent_getLoggerName(i_pLogEvent)   + '" ' +
              'timestamp="'                            +
                 %char(elapsedEpochTime)               + '" ' +
              'level="'                                +
                 Level_toString(
                    LogEvent_getPriority(i_pLogEvent)) + '" ' +
              'thread="'                               +
                 %editc(sds.nbr: 'X') + '/' +
                 %trimR(sds.user)     + '/' +
                 %trimR(sds.job )                      + '" ' +
              '>';

  // ... append message text
  xmlString = xmlString +
              '<log4j:message>' + %char(START_CDATA) +
                 rplcUnprtChars(handle
                                : LogEvent_getText(i_pLogEvent)) +
              %char(END_CDATA) +
              '</log4j:message>';

  // ... append caller information
  caller = LogEvent_getCaller(i_pLogEvent);

  xmlString = xmlString +
              '<log4j:locationInfo class="' +
                 %trimR(caller.pgm.name)    + '" ' +
              'method="'                    +
                 %trimR(caller.procedure)   + '" ' +
              'file="'                      +
                 %trimR(caller.module.name) + '" ' +
              'line="'                      +
                 %trimR(caller.stmtID)      + '" ' +
              '/>';

  // ... append properties
  pPropList = LogEvent_getPropertyList(i_pLogEvent);

  if not PropertyList_isNull(pPropList);

    propIter = PropertyList_getIterator(pPropList);

    isStarted = *off;
    property = PropertyList_getFirst(propIter);

    dow property.key <> '';

      if not isStarted;
        xmlString = xmlString + '<log4j:properties>';
        isStarted = *on;
      endif;

      xmlString = xmlString +
                  '<log4j:data name="' + property.key   +
                           '" value="' + property.value + '"' +
                  '/>';

      property = PropertyList_getNext(propIter);
    enddo;

    if isStarted;
      xmlString = xmlString + '</log4j:properties>';
    endif;
  endif;

  // ... close.
  xmlString = xmlString + '</log4j:event>';

  LogEvent_setText(i_pLogEvent: xmlString);

  return;


end-proc;

//=====================================================================*
//  Returns the header of this layout.
//=====================================================================*
//  Parameters:
//   i_pHandle    - Handle that is passed around the various calls to
//                  this XMLLayout.

//  Returns:
//   header       - The header string of this layout.
//=====================================================================*
dcl-proc XMLLayout_getHeader export;
  dcl-pi *n like(LOG4RPG_header_t);
    i_pHandle pointer const;
  end-pi;

  //  Helper fields
  dcl-s xmlString like(LOG4RPG_header_t) inz;

  //  Layout handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  xmlString = '';

  return xmlString;


end-proc;

//=====================================================================*
//  Returns the footer of this layout.
//=====================================================================*
//  Parameters:
//   i_pHandle    - Handle that is passed around the various calls to
//                  this XMLLayout.

//  Returns:
//   footer       - The footer string of this layout.
//=====================================================================*
dcl-proc XMLLayout_getFooter export;
  dcl-pi *n like(LOG4RPG_footer_t);
    i_pHandle pointer const;
  end-pi;

  //  Helper fields
  dcl-s xmlString like(LOG4RPG_footer_t) inz;

  //  Layout handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  xmlString = '';

  return xmlString;


end-proc;

//=====================================================================*
//  Used to set the properties of the layout.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this XMLLayout.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.

//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc XMLLayout_setProperties export;
  dcl-pi *n;
    i_pHandle   pointer const;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

  //  XMLLayout handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  loadConfiguration(handle: i_pPropList: i_prefix);

  return;


end-proc;

//=====================================================================*
//  Deletes a given XMLLayout.
//=====================================================================*
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this XMLLayout.

//  Returns:
//   void
//=====================================================================*
dcl-proc XMLLayout_delete export;
  dcl-pi *n ind;
    io_pHandle pointer;
  end-pi;

  //  Return value
  dcl-s isDone ind inz(*off);

  //  XMLLayout handle
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
  dcl-ds propIter likeds(LOG4RPG_PropertyListIterator_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  prefix = f_lcase(i_prefix);

  propIter = PropertyList_getIterator(i_pPropList);

  property = PropertyList_getFirst(propIter);

  dow property.key <> '';

    if (prefix = '') or (f_startsWith(prefix: property.key) and
                         %len(property.key) > %len(prefix));

      parameter = f_lcase(%subst(property.key: %len(prefix) + 1));

      select;
      when parameter = cPARAMETER_REPLACE_UNPRINTABLE_CHARACTERS;
        if property.value = '1' or f_lcase(property.value) = 'true';
          io_handle.rplUnprtChars = *on;
        else;
          io_handle.rplUnprtChars = *off;
        endif;
      when parameter = cPARAMETER_SUBSTITUTION_CHARACTER;
        io_handle.substitutionChar = property.value;
      when parameter = cPARAMETER_ENCODING;
        io_handle.encoding         = property.value;
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

//=====================================================================*
//  *** private ***
//  Entfernt nicht darstellbare Zeichen
//=====================================================================*
dcl-proc rplcUnprtChars export;
  dcl-pi *n like(LOG4RPG_formattedText_t);
    i_handle likeds(handle_t) const;
    i_text   like(LOG4RPG_formattedText_t) const;
  end-pi;

  //  Return value
  dcl-s text1 like(LOG4RPG_formattedText_t) inz;
  dcl-s text2 like(LOG4RPG_formattedText_t) inz;

  //  Arbeitsfelder
  dcl-s x int(10) inz;

  dcl-s END_CDATA ucs2(3) inz(u'005D005D003E'); // ]]>
  dcl-s ESC_END_CDATA ucs2(6) inz(u'005D005D002600670074003B'); // ]]&gt;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Replace closing string of CDATA section
  text1 = f_replace(%char(END_CDATA): %char(ESC_END_CDATA): i_text);

  // Replace unprintable characters
  if not i_handle.rplUnprtChars;
    return text1;
  endif;

  for x = 1 to %len(text1);
    if %subst(text1: x: 1) < x'40' or %subst(text1: x: 1) > x'FE';
      text2 = text2 + i_handle.substitutionChar;
    else;
      text2 = text2 + %subst(text1: x: 1);
    endif;
  endfor;

  return text2;


end-proc;
