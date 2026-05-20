**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: PatternLayout                            *
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
/copy QLOG4RPG,PLOG4RPG60

// -----------------------------------------
//  Type definitions
// -----------------------------------------
dcl-ds handle_t qualified template;
  pSuper        like(LOG4RPG_pLayout_t);
  pattern       varchar(128);
  tmStmpPattern likeds(tmStmpPattern_t);
end-ds;

dcl-ds tmStmpPattern_t qualified template;
  value  varchar(128);
  isMSec ind;
  length int(10);
end-ds;
// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,CLIB
/copy QLOG4RPG,PLOG4RPG07                    PropertyList
/copy QLOG4RPG,PLOG4RPG09                    Level
/copy QLOG4RPG,PLOG4RPG10                    LogLog
/copy QLOG4RPG,PLOG4RPG99                    Helper
/copy QLOG4RPG,QUSRJOBI                      Retrieve Job Information (QUSRJOBI) API

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Loads the configuration parameters from the specified property list.
dcl-pr loadConfiguration;
  io_handle   likeds(handle_t);
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  Retrieves job information into format jobi0600.
dcl-pr rtvJobInf likeds(jobi0600_t);
end-pr;

//  Returns the number of digits of the '%%ms' pattern value.
dcl-pr getTmStmpPattern likeds(tmStmpPattern_t);
  i_pattern varchar(128) const;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c; cTHIS_CLASS

     D                                            'PatternLayout'
//
dcl-c cPARAMETER_CONVERSION_PATTERN
      'conversionpattern';

dcl-c cTIMESTAMP_PATTERN 'timestamppattern';

dcl-c MSECS_PATTERN '%ms';
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
//  Creates a new PatternLayout.
//=========================================================================
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this PatternLayout.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.
//
//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc PatternLayout_new export;
  dcl-pi *n ind;
    i_pSuper    like(LOG4RPG_pLayout_t) const;
    io_pHandle  pointer;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Helper fields
  dcl-ds tempHandle likeds(handle_t) inz;

//  PatternLayout handle
  dcl-ds handle likeds(handle_t) based(io_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

clear tempHandle;

// Initialize handle
tempHandle.pSuper  = i_pSuper;   // Handle of the super class 'Layout'
tempHandle.pattern = '%z [%M.%F]  %-5p  %S - %m';
clear tempHandle.tmStmpPattern;

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
//                   this PatternLayout.
//   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
//                   text of the log event that is formated.
//
//  Returns:
//   text          - Returns the formatted text of the log event.
//=========================================================================
//
//  Pattern variables:
//  ------------------
//     %p      priority
//     %t      time
//     %d      date
//     %z      timestamp
//     %l      logger name
//     %m      application supplied message text
//     %n      new line
//     %P      program name
//     %L      program library name
//     %M      module name
//     %F      function/procedure name
//     %S      statement
//     %j      full qualified job name
//     %u      user name
//     %U      current user name
//
//  Sample pattern layout:
//  ----------------------
//
//  Layout:
//     '%z [%M.%F]  %-5p  %S - %m'
//
//  Result:
//     2006-02-22-11.38.42.567000 [LOG4RPG_T1.P_MAIN]  debug  0000010500 - Hello World
//
//  Description:
//     '%z' produces the current timestamp.
//     '%M' and '%F' prints the module and procedure name the logger was called from.
//     '%-5p' prints the logging priority, left adjusted in a 5 character space.
//     '%S' prints the statement identifier the logger was called from.
//     '%m' prints message text supplied by the application.
//
//=========================================================================
dcl-proc PatternLayout_format export;
  dcl-pi *n;
    i_pHandle   pointer const;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

//  Helper fields
  dcl-s x int(10) inz;
  dcl-s y int(10) inz;
  dcl-s lengthStr varchar(5) inz;
  dcl-s length int(10) inz;
  dcl-s pattern char(1) inz;
  dcl-s tmpText like(LOG4RPG_formattedText_t) inz;
  dcl-s string like(LOG4RPG_formattedText_t) inz;
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;
  dcl-ds jobi0600 likeds(jobi0600_t) inz;
  dcl-s buffer char(128);

//  Constants
  dcl-c cTMPTEXTMAXLEN 128;

  dcl-ds tm likeds(tm_t) based(ptm);
  dcl-s size int(10);
  dcl-s mSec int(10);
  dcl-s mSecStr varchar(10);
//  PatternLayout handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Load return message text with pattern layout
string = handle.pattern;

// Search for patterns and replace them
x = %scan('%': string: 1);
dow x > 0 and x < %len(string);

   lengthStr = '';
   length    = 0;
   pattern   = '';

   // get length if specified
   y = x + 1;
   if (%subst(string: y: 1) = '-') and (y < %len(string));
      y = y + 1;
      dow (y <= %len(string) and
          (%check('0123456789': %subst(string: y: 1)) = 0));
         lengthStr = lengthStr + %subst(string: y: 1);
         y = y + 1;
      enddo;
   endif;

   // get pattern
   pattern = %subst(string: y: 1);

   // get length
   length = atoi(lengthStr);

   // replace pattern
   select;
   when pattern = 'p';      // priority/level
      tmpText = Level_toString(LogEvent_getPriority(i_pLogEvent));
   when pattern = 't';      // Time
      tmpText = %char(%time(LogEvent_getTime(i_pLogEvent)): *jobrun);
   when pattern = 'd';      // Date
      tmpText = %char(%date(LogEvent_getTime(i_pLogEvent)): *jobrun);
   when pattern = 'z';      // Timestamp
      if (handle.tmStmpPattern.value = '');
         tmpText = %char(LogEvent_getTime(i_pLogEvent));
      else;
         ptm = localtime(time(*null));
         size = strftime(%addr(buffer): %size(buffer)
                       : handle.tmStmpPattern.value: tm);
         tmpText = %subst(buffer: 1: size);
         if (handle.tmStmpPattern.isMSec);
            mSec = %subdt(%timestamp(): *mseconds);
            mSecStr = %char(mSec);
            if (handle.tmStmpPattern.length <= %len(mSecStr));
               mSecStr = %subst(mSecStr: 1: handle.tmStmpPattern.length);
            else;
               LogLog_warning('Incorrect mSec-length: '
                             + %char(handle.tmStmpPattern.length) + '. '
                             + 'Value too short: ' + mSecStr + '. '
                            + 'Check appender property: timestampPattern'
                             );
            endif;
            tmpText = %scanrpl('%ms': mSecStr: tmpText);
         endif;
      endif;
   when pattern = 'l';      // Logger Name
      tmpText = LogEvent_getLoggerName(i_pLogEvent);
   when pattern = 'm';      // application supplied message
      tmpText = LogEvent_getText(i_pLogEvent);
   when pattern = 'n';      // New Line
      tmpText = '\n';
   when pattern = 'P';      // Program Name
      caller  = LogEvent_getCaller(i_pLogEvent);
      tmpText = %trimR(caller.pgm.name);
   when pattern = 'L';      // Program Library Name
      tmpText = %trimR(LogEvent_resolveCallerPgmLibrary(i_pLogEvent));
   when pattern = 'M';      // Module Name
      caller  = LogEvent_getCaller(i_pLogEvent);
      tmpText = %trimR(caller.module.name);
   when pattern = 'F';      // Procedure/Function Name
      caller  = LogEvent_getCaller(i_pLogEvent);
      tmpText = %trimR(caller.procedure);
   when pattern = 'S';      // Statement ID
      caller  = LogEvent_getCaller(i_pLogEvent);
      tmpText = %trim(caller.stmtID);
   when pattern = 'j';      // full qualified job name
      tmpText = %editc(sds.nbr: 'X') + '/' + %trimR(sds.user)
                                     + '/' + %trimR(sds.job );
   when pattern = 'u';      // user name
      tmpText = %trimR(sds.user);
   when pattern = 'U';      // current user name
      jobi0600 = rtvJobInf();
      tmpText = jobi0600.curUser;
   other;
      tmpText = '';
   endsl;

   if pattern <> '';
      if (length > 0) and (length < cTMPTEXTMAXLEN);
         %len(tmpText) = length;
      endif;

      string = %replace(tmpText: string: x: y-x+1);
   endif;

   if x < %len(string);
      x = %scan('%': string: y);
   else;
      x = 0;
   endif;

enddo;

LogEvent_setText(i_pLogEvent: string);

return;


end-proc;

//=====================================================================*
//  Used to set the properties of the layout.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this PatternLayout.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.

//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc PatternLayout_setProperties export;
  dcl-pi *n;
    i_pHandle   pointer const;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

//  PatternLayout handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

loadConfiguration(handle: i_pPropList: i_prefix);

return;


end-proc;

//=====================================================================*
//  Deletes a given PatternLayout.
//=====================================================================*
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this PatternLayout.

//  Returns:
//   void
//=====================================================================*
dcl-proc PatternLayout_delete export;
  dcl-pi *n ind;
    io_pHandle pointer;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  PatternLayout handle
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
      when parameter = cPARAMETER_CONVERSION_PATTERN;
         io_handle.pattern = property.value;
      when parameter = cTIMESTAMP_PATTERN;
         io_handle.tmStmpPattern = getTmStmpPattern(property.value);
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
//  Returns the number of digits of the '%%ms' pattern value.
//=========================================================================
dcl-proc getTmStmpPattern;
  dcl-pi *n likeds(tmStmpPattern_t);
    i_pattern varchar(128) const;
  end-pi;

//  Return value
  dcl-ds tmStmpPattern likeds(tmStmpPattern_t) inz;

//  Local fields
  dcl-s x int(10);
  dcl-s y int(10);
  dcl-s length int(10);
  dcl-s char char(1);
  dcl-s value varchar(20);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

clear tmStmpPattern;
tmStmpPattern.value = '';
tmStmpPattern.isMSec = *off;
tmStmpPattern.length = 0;

if (i_pattern = '');
   return tmStmpPattern;
endif;

x = %scan(MSECS_PATTERN: i_pattern);
if (x = 0);
   return tmStmpPattern;
endif;

x = x + %len(MSECS_PATTERN);
y = x;
value = '';

// Get digits following '%ms'...
dow (y <= %len(i_pattern));
   char = %subst(i_pattern: y: 1);
   if (char >= '0' and char <= '9');
      value += char;
   else;
      leave;
   endif;
   y += 1;
enddo;

// Produce return value
tmStmpPattern.isMSec = *on;
tmStmpPattern.length = 6;
tmStmpPattern.value = i_pattern;

// Override mSec length
if (y > x);
   monitor;
      length = y - x;
      tmStmpPattern.length = %int(%subst(i_pattern: x: length));
      tmStmpPattern.value = %replace('': i_pattern: x: length);
   on-error;
      LogLog_error('mSec-length pattern is not numeric: '
                  + i_pattern + '. '
                  + 'Check appender property: timestampPattern'
                  );
   endmon;
endif;

// Change '%ms' to '%%ms', because the first '%'
// is removed by strftime().
tmStmpPattern.value = %scanrpl(MSECS_PATTERN
                             : '%' + MSECS_PATTERN
                             : tmStmpPattern.value);

return tmStmpPattern;

end-proc;

//=========================================================================
//  *** Private ***
//  Retrieves job information into format jobi0600.
//=========================================================================
dcl-proc rtvJobInf;
  dcl-pi *n likeds(jobi0600_t);
  end-pi;

//  Return value
  dcl-ds jobi0600 likeds(jobi0600_t) inz;

//  Local fields
  dcl-ds qJob likeds(LOG4RPG_qJob_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

qjob.name = '*';
qjob.user = '';
qjob.nbr  = '';
errCode = f_newApiErrCode(*on);
QUSRJOBI(jobi0600: %size(jobi0600): 'JOBI0600': qJob: '': errCode);

return jobi0600;


end-proc;

