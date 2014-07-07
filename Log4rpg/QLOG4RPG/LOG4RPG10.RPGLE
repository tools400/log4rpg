      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: LogLog                                   *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  13.06.2006                                              *
      *  E-mail  :  thomas.raddatz@tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  27.10.2006  Th.Raddatz    Added feature to completely enable/      *
      *                            disable Log4rpg. Logger_isLogging().     *
      *                                                                     *
      *  15.11.2006  Th.Raddatz    Added procedures:                        *
      *                            LogLog_getInternalDebugMode()            *
      *                            LogLog_getInternalDebugOutput()          *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< TGTRLS(V6R1M0  );                                    *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /COPY QLOG4RPG,H_SPEC
      *=====================================================================*
     FLOG4RPG   O    F  132        PRINTER usropn
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG10
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG                      Public interface & type definitions
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,CLIB                          C-Library
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      /COPY QLOG4RPG,PLOG4RPG14                    DebugMode
      /COPY QLOG4RPG,PLOG4RPG15                    DebugOutput
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  This method is used to output log4rpg internal
      *  statements.
     D streamOut...
     D                 PR
     D  i_text                             const  like(LOG4RPG_formattedText_t)
      *
      *  This method is used to output log4rpg internal
      *  statements. Output goes to stdout.
     D writeToStdout...
     D                 PR
     D  i_text                             const  like(LOG4RPG_formattedText_t)
      *
      *  This method is used to output log4rpg internal
      *  statements. Output goes to the printer.
     D writeToPrinter...
     D                 PR
     D  i_text                             const  like(LOG4RPG_formattedText_t)
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cPREFIX...
     D                 C                   const('log4rpg: ')
     D cERR_PREFIX...
     D                 C                   const('log4rpg:ERROR ')
     D cWARN_PREFIX...
     D                 C                   const('log4rpg:WARN ')
      *
      * Constants for printf()
     D cESC_NEW_LINE   C                   const(x'15')
     D cESC_TAB        C                   const(x'05')
     D cESC_BACKSLASH  C                   const(x'EC')
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
     D g_debugMode     S              5U 0 inz(
     D                                        cLOG4RPG_INT_DEBUG_OFF)
     D g_output        S              5U 0 inz(
     D                                        cLOG4RPG_INT_DEBUG_OUTPUT_PRINTER)
      *
     D g_printText     S            117A
      *
      * -----------------------------------------
      *  Output to printer
      * -----------------------------------------
     OLOG4RPG   E            printLine
     O                       g_printText        127
      *
      *=========================================================================
      *  Allows to enable/disable log4rpg internal logging.
      *=========================================================================
      *  Parameters:
      *   i_debugMode   - Specifies the debug mode for the log4rpg
      *                   internal logging.
      *
      *  Returns:
      *   void
      *=========================================================================
     P LogLog_setInternalDebugging...
     P                 B                   export
      *
     D LogLog_setInternalDebugging...
     D                 PI
     D  i_debugMode                        const  like(LOG4RPG_debugMode_t  )
     D  i_output                           const  like(LOG4RPG_debugOutput_t)
     D                                            options(*nopass)
      *
      *  Parameter positions
     D p_output        C                   const(2)
      *
      *  Fields for optional parameters
     D output          S                   like(i_output ) inz
      *
      *  Helper fields
     D mode            S                   like(i_debugMode ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P LogLog_setInternalDebugging...
     P                 E
      *
      *=========================================================================
      *  Returns the internal debug mode.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   debugMode     - Mode of the internal logging.
      *=========================================================================
     P LogLog_getInternalDebugMode...
     P                 B                   export
      *
     D LogLog_getInternalDebugMode...
     D                 PI                         like(LOG4RPG_debugMode_t  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return DebugMode_toString(g_debugMode);
 
      /END-FREE
      *
     P LogLog_getInternalDebugMode...
     P                 E
      *
      *=========================================================================
      *  Returns the target for internal log events.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   output        - Output target for internal log events.
      *=========================================================================
     P LogLog_getInternalDebugOutput...
     P                 B                   export
      *
     D LogLog_getInternalDebugOutput...
     D                 PI                         like(LOG4RPG_debugOutput_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return DebugOutput_toString(g_output);
 
      /END-FREE
      *
     P LogLog_getInternalDebugOutput...
     P                 E
      *
      *=========================================================================
      *  This method is used to output log4rpg internal debug statements.
      *=========================================================================
      *  Parameters:
      *   i_text        - The debug statement.
      *
      *  Returns:
      *   void
      *=========================================================================
     P LogLog_debug...
     P                 B                   export
      *
     D LogLog_debug...
     D                 PI
     D  i_text                             const  like(LOG4RPG_text_t    )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P LogLog_debug...
     P                 E
      *
      *=========================================================================
      *  This method is used to output log4rpg internal debug messages.
      *=========================================================================
      *  Parameters:
      *   i_msg         - The debug message.
      *
      *  Returns:
      *   void
      *=========================================================================
     P LogLog_debugMsg...
     P                 B                   export
      *
     D LogLog_debugMsg...
     D                 PI
     D  i_msg                              const  likeds(msg_t           )
      *
      *  Helper fields
     D text            S                   like(LOG4RPG_text_t    ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P LogLog_debugMsg...
     P                 E
      *
      *=========================================================================
      *  This method is used to output log4rpg internal error statements.
      *=========================================================================
      *  Parameters:
      *   i_text        - The error statement.
      *
      *  Returns:
      *   void
      *=========================================================================
     P LogLog_error...
     P                 B                   export
      *
     D LogLog_error...
     D                 PI
     D  i_text                             const  like(LOG4RPG_text_t    )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if not Logger_isLogging();
            return;
         endif;
 
         if g_debugMode = cLOG4RPG_INT_DEBUG_QUIET;
            return;
         endif;
 
         streamOut(cERR_PREFIX + i_text);
 
         return;
 
      /END-FREE
      *
     P LogLog_error...
     P                 E
      *
      *=========================================================================
      *  This method is used to output log4rpg internal error messages.
      *=========================================================================
      *  Parameters:
      *   i_msg         - The error message.
      *
      *  Returns:
      *   void
      *=========================================================================
     P LogLog_errorMsg...
     P                 B                   export
      *
     D LogLog_errorMsg...
     D                 PI
     D  i_msg                              const  likeds(msg_t           )
      *
      *  Helper fields
     D text            S                   like(LOG4RPG_text_t    ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if not Logger_isLogging();
            return;
         endif;
 
         if g_debugMode = cLOG4RPG_INT_DEBUG_QUIET;
            return;
         endif;
 
         text = %trimR(f_rtvMsgText(i_msg: *omit));
         LogLog_error(text);
 
         return;
 
      /END-FREE
      *
     P LogLog_errorMsg...
     P                 E
      *
      *=========================================================================
      *  This method is used to output log4rpg internal warning statements.
      *=========================================================================
      *  Parameters:
      *   i_text        - The warning statement.
      *
      *  Returns:
      *   void
      *=========================================================================
     P LogLog_warning...
     P                 B                   export
      *
     D LogLog_warning...
     D                 PI
     D  i_text                             const  like(LOG4RPG_text_t    )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if not Logger_isLogging();
            return;
         endif;
 
         if g_debugMode = cLOG4RPG_INT_DEBUG_QUIET;
            return;
         endif;
 
         streamOut(cWARN_PREFIX + i_text);
 
         return;
 
      /END-FREE
      *
     P LogLog_warning...
     P                 E
      *
      *=========================================================================
      *  This method is used to output log4rpg internal warning message.
      *=========================================================================
      *  Parameters:
      *   i_msg         - The warning message.
      *
      *  Returns:
      *   void
      *=========================================================================
     P LogLog_warningMsg...
     P                 B                   export
      *
     D LogLog_warningMsg...
     D                 PI
     D  i_msg                              const  likeds(msg_t           )
      *
      *  Helper fields
     D text            S                   like(LOG4RPG_text_t    ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if not Logger_isLogging();
            return;
         endif;
 
         if g_debugMode = cLOG4RPG_INT_DEBUG_QUIET;
            return;
         endif;
 
         text = %trimR(f_rtvMsgText(i_msg: *omit));
         LogLog_warning(text);
 
         return;
 
      /END-FREE
      *
     P LogLog_warningMsg...
     P                 E
      *
      *=========================================================================
      *  This method is used to output log4rpg internal verbose statements.
      *=========================================================================
      *  Parameters:
      *   i_text        - The verbose statement.
      *
      *  Returns:
      *   void
      *=========================================================================
     P LogLog_verbose...
     P                 B                   export
      *
     D LogLog_verbose...
     D                 PI
     D  i_text                             const  like(LOG4RPG_text_t    )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P LogLog_verbose...
     P                 E
      *
      *=========================================================================
      *  This method is used to output log4rpg internal verbose message.
      *=========================================================================
      *  Parameters:
      *   i_msg         - The verbose message.
      *
      *  Returns:
      *   void
      *=========================================================================
     P LogLog_verboseMsg...
     P                 B                   export
      *
     D LogLog_verboseMsg...
     D                 PI
     D  i_msg                              const  likeds(msg_t           )
      *
      *  Helper fields
     D text            S                   like(LOG4RPG_text_t    ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P LogLog_verboseMsg...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  This method is used write log4rpg internal statements to the output.
      *=========================================================================
     P streamOut...
     P                 B
      *
     D streamOut...
     D                 PI
     D  i_text                             const  like(LOG4RPG_formattedText_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         select;
         when g_output = cLOG4RPG_INT_DEBUG_OUTPUT_PRINTER;
            writeToPrinter(i_text);
         when g_output = cLOG4RPG_INT_DEBUG_OUTPUT_STDOUT;
            writeToStdout(i_text);
         endsl;
 
         return;
 
      /END-FREE
      *
     P streamOut...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  This method is used to output log4rpg internal statements.
      *  Output goes to printer.
      *=========================================================================
     P writeToPrinter...
     P                 B
      *
     D writeToPrinter...
     D                 PI
     D  i_text                             const  like(LOG4RPG_formattedText_t)
      *
      *  Helper fields
     D startPos        S             10U 0 inz(1)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if i_text = '';
            return;
         endif;
 
         if not %open(LOG4RPG);
            system('OVRPRTF FILE(LOG4RPG) +
                    TOFILE(QSYS/QSYSPRT) OVRSCOPE(*CALLLVL)');
            open LOG4RPG;
         endif;
 
         dow   startPos > 0;
            g_printText = f_wordWrap(i_text
                                     : %len(g_printText)
                                     : startPos
                                     : cWORDWRAP_PARAGRAPH_TEXT);
            except printLine;
         enddo;
 
         return;
 
      /END-FREE
      *
     P writeToPrinter...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  This method is used to output log4rpg internal statements.
      *  Output goes to stdout.
      *=========================================================================
     P writeToStdout...
     P                 B
      *
     D writeToStdout...
     D                 PI
     D  i_text                             const  like(LOG4RPG_formattedText_t)
      *
      *  printf -- Print Formatted Characters
     D printf...
     D                 PR            10I 0 extproc('printf')
     D  i_fmtString                    *   value  options(*string)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         printf(i_text + cESC_NEW_LINE);
 
         return;
 
      /END-FREE
      *
     P writeToStdout...
     P                 E
      *
