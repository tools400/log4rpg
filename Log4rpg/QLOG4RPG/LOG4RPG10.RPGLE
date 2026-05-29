**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: LogLog                                   *
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
//  27.10.2006  Th.Raddatz    Added feature to completely enable/      *
//                            disable Log4rpg. Logger_isLogging().     *
//                                                                     *
//  15.11.2006  Th.Raddatz    Added procedures:                        *
//                            LogLog_getInternalDebugMode()            *
//                            LogLog_getInternalDebugOutput()          *
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
dcl-f LOG4RPG printer(132) usage(*output) usropn;

// -----------------------------------------
//  Imported functions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG Public API Specification

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG10

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG Public interface & type definitions

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,CLIB C-Library
/copy QBASICS1,PBASICS1 Basic RPG Extensions
/copy QLOG4RPG,PLOG4RPG14 DebugMode
/copy QLOG4RPG,PLOG4RPG15 DebugOutput

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  This method is used to output log4rpg internal
//  statements.
dcl-pr streamOut;
  i_text like(LOG4RPG_formattedText_t) const;
end-pr;

//  This method is used to output log4rpg internal
//  statements. Output goes to stdout.
dcl-pr writeToStdout;
  i_text like(LOG4RPG_formattedText_t) const;
end-pr;

//  This method is used to output log4rpg internal
//  statements. Output goes to the printer.
dcl-pr writeToPrinter;
  i_text like(LOG4RPG_formattedText_t) const;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cPREFIX 'log4rpg: ';
dcl-c cERR_PREFIX 'log4rpg:ERROR ';
dcl-c cWARN_PREFIX 'log4rpg:WARN ';

// Constants for printf()
dcl-c cESC_NEW_LINE x'15';
dcl-c cESC_TAB x'05';
dcl-c cESC_BACKSLASH x'EC';

// -----------------------------------------
//  Global fields
// -----------------------------------------
dcl-s g_debugMode uns(5) inz(cLOG4RPG_INT_DEBUG_OFF);
dcl-s g_output uns(5) inz(cLOG4RPG_INT_DEBUG_OUTPUT_PRINTER);

// -----------------------------------------
//  Output to printer
// -----------------------------------------
//     OLOG4RPG   E            printLine
//     O                       g_printText        127
//
//=========================================================================
//  Allows to enable/disable log4rpg internal logging.
//=========================================================================
//  Parameters:
//   i_debugMode   - Specifies the debug mode for the log4rpg
//                   internal logging.
//
//  Returns:
//   void
//=========================================================================
dcl-proc LogLog_setInternalDebugging export;
  dcl-pi *n;
    i_debugMode like(LOG4RPG_debugMode_t) const;
    i_output    like(LOG4RPG_debugOutput_t) options(*nopass) const;
  end-pi;

  //  Parameter positions
  dcl-c p_output 2;

  //  Fields for optional parameters
  dcl-s output like(i_output) inz;

  //  Helper fields
  dcl-s mode like(i_debugMode) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if %parms() >= p_output;
    output = f_lcase(i_output);
  else;
    output = cLOG4RPG_DEBUG_OUTPUT_PRINTER;
  endif;

  mode = f_lcase(i_debugMode);

  if DebugMode_isValid(mode);
    g_debugMode = DebugMode_toInt(mode);
  else;
    g_debugMode = DebugMode_toInt(cLOG4RPG_DEBUG_ON);
    LogLog_error('Unexpected value [' + mode +
                  '] passed for parameter ''debug mode'' to +
                  procedure [' + f_this + ']');
  endif;

  if DebugOutput_isValid(output);
    g_output = DebugOutput_toInt(output);
  else;
    g_output = cLOG4RPG_INT_DEBUG_OUTPUT_PRINTER;
    LogLog_error('Unexpected value [' + output +
                  '] passed for parameter ''output'' to +
                  procedure [' + f_this + ']');
  endif;

  if (g_output <> cLOG4RPG_INT_DEBUG_OUTPUT_PRINTER) and %open(LOG4RPG);
    close LOG4RPG;
  endif;

  return;


end-proc;

//=========================================================================
//  Returns the internal debug mode.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   debugMode     - Mode of the internal logging.
//=========================================================================
dcl-proc LogLog_getInternalDebugMode export;
  dcl-pi *n like(LOG4RPG_debugMode_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return DebugMode_toString(g_debugMode);


end-proc;

//=========================================================================
//  Returns the target for internal log events.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   output        - Output target for internal log events.
//=========================================================================
dcl-proc LogLog_getInternalDebugOutput export;
  dcl-pi *n like(LOG4RPG_debugOutput_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return DebugOutput_toString(g_output);


end-proc;

//=========================================================================
//  This method is used to output log4rpg internal debug statements.
//=========================================================================
//  Parameters:
//   i_text        - The debug statement.
//
//  Returns:
//   void
//=========================================================================
dcl-proc LogLog_debug export;
  dcl-pi *n;
    i_text like(LOG4RPG_text_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if not Logger_isLogging();
    return;
  endif;

  if g_debugMode = cLOG4RPG_INT_DEBUG_QUIET;
    return;
  endif;

  if g_debugMode <> cLOG4RPG_INT_DEBUG_OFF;
    streamOut(cPREFIX + i_text);
  endif;

  return;


end-proc;

//=========================================================================
//  This method is used to output log4rpg internal debug messages.
//=========================================================================
//  Parameters:
//   i_msg         - The debug message.
//
//  Returns:
//   void
//=========================================================================
dcl-proc LogLog_debugMsg export;
  dcl-pi *n;
    i_msg likeds(msg_t) const;
  end-pi;

  //  Helper fields
  dcl-s text like(LOG4RPG_text_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if not Logger_isLogging();
    return;
  endif;

  if g_debugMode = cLOG4RPG_INT_DEBUG_QUIET;
    return;
  endif;

  if g_debugMode <> cLOG4RPG_INT_DEBUG_OFF;
    text = %trimR(f_rtvMsgText(i_msg: *omit));
    LogLog_debug(text);
  endif;

  return;


end-proc;

//=========================================================================
//  This method is used to output log4rpg internal error statements.
//=========================================================================
//  Parameters:
//   i_text        - The error statement.
//
//  Returns:
//   void
//=========================================================================
dcl-proc LogLog_error export;
  dcl-pi *n;
    i_text like(LOG4RPG_text_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if not Logger_isLogging();
    return;
  endif;

  if g_debugMode = cLOG4RPG_INT_DEBUG_QUIET;
    return;
  endif;

  streamOut(cERR_PREFIX + i_text);

  return;


end-proc;

//=========================================================================
//  This method is used to output log4rpg internal error messages.
//=========================================================================
//  Parameters:
//   i_msg         - The error message.
//
//  Returns:
//   void
//=========================================================================
dcl-proc LogLog_errorMsg export;
  dcl-pi *n;
    i_msg likeds(msg_t) const;
  end-pi;

  //  Helper fields
  dcl-s text like(LOG4RPG_text_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if not Logger_isLogging();
    return;
  endif;

  if g_debugMode = cLOG4RPG_INT_DEBUG_QUIET;
    return;
  endif;

  text = %trimR(f_rtvMsgText(i_msg: *omit));
  LogLog_error(text);

  return;


end-proc;

//=========================================================================
//  This method is used to output log4rpg internal warning statements.
//=========================================================================
//  Parameters:
//   i_text        - The warning statement.
//
//  Returns:
//   void
//=========================================================================
dcl-proc LogLog_warning export;
  dcl-pi *n;
    i_text like(LOG4RPG_text_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if not Logger_isLogging();
    return;
  endif;

  if g_debugMode = cLOG4RPG_INT_DEBUG_QUIET;
    return;
  endif;

  streamOut(cWARN_PREFIX + i_text);

  return;


end-proc;

//=========================================================================
//  This method is used to output log4rpg internal warning message.
//=========================================================================
//  Parameters:
//   i_msg         - The warning message.
//
//  Returns:
//   void
//=========================================================================
dcl-proc LogLog_warningMsg export;
  dcl-pi *n;
    i_msg likeds(msg_t) const;
  end-pi;

  //  Helper fields
  dcl-s text like(LOG4RPG_text_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if not Logger_isLogging();
    return;
  endif;

  if g_debugMode = cLOG4RPG_INT_DEBUG_QUIET;
    return;
  endif;

  text = %trimR(f_rtvMsgText(i_msg: *omit));
  LogLog_warning(text);

  return;


end-proc;

//=========================================================================
//  This method is used to output log4rpg internal verbose statements.
//=========================================================================
//  Parameters:
//   i_text        - The verbose statement.
//
//  Returns:
//   void
//=========================================================================
dcl-proc LogLog_verbose export;
  dcl-pi *n;
    i_text like(LOG4RPG_text_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if not Logger_isLogging();
    return;
  endif;

  if g_debugMode = cLOG4RPG_INT_DEBUG_QUIET;
    return;
  endif;

  if g_debugMode = cLOG4RPG_INT_DEBUG_VERBOSE;
    streamOut(cPREFIX + i_text);
  endif;

  return;


end-proc;

//=========================================================================
//  This method is used to output log4rpg internal verbose message.
//=========================================================================
//  Parameters:
//   i_msg         - The verbose message.
//
//  Returns:
//   void
//=========================================================================
dcl-proc LogLog_verboseMsg export;
  dcl-pi *n;
    i_msg likeds(msg_t) const;
  end-pi;

  //  Helper fields
  dcl-s text like(LOG4RPG_text_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if not Logger_isLogging();
    return;
  endif;

  if g_debugMode = cLOG4RPG_INT_DEBUG_QUIET;
    return;
  endif;

  if g_debugMode = cLOG4RPG_INT_DEBUG_VERBOSE;
    text = %trimR(f_rtvMsgText(i_msg: *omit));
    LogLog_verbose(text);
  endif;

  return;


end-proc;

//=========================================================================
//  *** Private ***
//  This method is used write log4rpg internal statements to the output.
//=========================================================================
dcl-proc streamOut;
  dcl-pi *n;
    i_text like(LOG4RPG_formattedText_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  select;
  when g_output = cLOG4RPG_INT_DEBUG_OUTPUT_PRINTER;
    writeToPrinter(i_text);
  when g_output = cLOG4RPG_INT_DEBUG_OUTPUT_STDOUT;
    writeToStdout(i_text);
  endsl;

  return;


end-proc;

//=========================================================================
//  *** Private ***
//  This method is used to output log4rpg internal statements.
//  Output goes to printer.
//=========================================================================
dcl-proc writeToPrinter;
  dcl-pi *n;
    i_text like(LOG4RPG_formattedText_t) const;
  end-pi;

  //  Helper fields
  dcl-s startPos uns(10) inz(1);

  //  Printer output
  dcl-ds lineOutput len(132) inz;
  end-ds;

  dcl-c LEFT_BORDER 10;
  dcl-c RIGHT_BORDER 5;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if i_text = '';
    return;
  endif;

  if not %open(LOG4RPG);
    system('OVRPRTF FILE(LOG4RPG) +
            TOFILE(QSYS/QSYSPRT) OVRSCOPE(*CALLLVL)');
    open LOG4RPG;
  endif;

  dow   startPos > 0;
    lineOutput = f_wordWrap(i_text
                            : %len(lineOutput) - LEFT_BORDER - RIGHT_BORDER
                            : startPos
                            : cWORDWRAP_PARAGRAPH_TEXT);
    write LOG4RPG lineOutput;
  enddo;

  return;


end-proc;

//=========================================================================
//  *** Private ***
//  This method is used to output log4rpg internal statements.
//  Output goes to stdout.
//=========================================================================
dcl-proc writeToStdout;
  dcl-pi *n;
    i_text like(LOG4RPG_formattedText_t) const;
  end-pi;

  //  printf -- Print Formatted Characters
  dcl-pr printf int(10) extproc('printf');
    i_fmtString pointer options(*string) value;
  end-pr;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  printf(i_text + cESC_NEW_LINE);

  return;


end-proc;
