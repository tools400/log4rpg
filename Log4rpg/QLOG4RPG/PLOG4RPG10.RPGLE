**free
/if NOT defined(PLOG4RPG10)
/define PLOG4RPG10

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PTYPES Internal type definitions

// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------

//  Allows to enable/disable log4rpg internal logging.
dcl-pr LogLog_setInternalDebugging extproc('LOG4RPG10_LogLog_setInternalDebugging');
  i_debugMode like(LOG4RPG_debugMode_t) const;
  i_output    like(LOG4RPG_debugOutput_t) options(*nopass) const;
end-pr;

//  Returns the internal debug mode.
dcl-pr LogLog_getInternalDebugMode like(LOG4RPG_debugMode_t)
  extproc('LOG4RPG10_LogLog_getInternalDebugMode');
end-pr;

//  Returns the target for internal log events.
dcl-pr LogLog_getInternalDebugOutput like(LOG4RPG_debugOutput_t)
  extproc('LOG4RPG10_LogLog_getInternalDebugOutput');
end-pr;

//  This method is used to output log4rpg internal debug
//  statements.
dcl-pr LogLog_debug extproc('LOG4RPG10_LogLog_debug');
  i_text like(LOG4RPG_text_t) const;
end-pr;

//  This method is used to output log4rpg internal debug
//  messages.
dcl-pr LogLog_debugMsg extproc('LOG4RPG10_LogLog_debugMsg');
  i_msg likeds(msg_t) const;
end-pr;

//  This method is used to output log4rpg internal error
//  statements.
dcl-pr LogLog_error extproc('LOG4RPG10_LogLog_error');
  i_text like(LOG4RPG_text_t) const;
end-pr;

//  This method is used to output log4rpg internal error
//  messages.
dcl-pr LogLog_errorMsg extproc('LOG4RPG10_LogLog_errorMsg');
  i_msg likeds(msg_t) const;
end-pr;

//  This method is used to output log4rpg internal warning
//  statements.
dcl-pr LogLog_warning extproc('LOG4RPG10_LogLog_warning');
  i_text like(LOG4RPG_text_t) const;
end-pr;

//  This method is used to output log4rpg internal warning
//  messages.
dcl-pr LogLog_warningMsg extproc('LOG4RPG10_LogLog_warningMsg');
  i_msg likeds(msg_t) const;
end-pr;

//  This method is used to output log4rpg internal verbose
//  statements.
dcl-pr LogLog_verbose extproc('LOG4RPG10_LogLog_verbose');
  i_text like(LOG4RPG_text_t) const;
end-pr;

//  This method is used to output log4rpg internal verbose
//  messages.
dcl-pr LogLog_verboseMsg extproc('LOG4RPG10_LogLog_verboseMsg');
  i_msg likeds(msg_t) const;
end-pr;

/endif