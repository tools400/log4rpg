**FREE
/IF NOT DEFINED(PLOG4RPG10)
/DEFINE PLOG4RPG10
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/COPY QLOG4RPG,PTYPES                        Internal type definitions
//
// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
//
//  Allows to enable/disable log4rpg internal logging.
dcl-pr LogLog_setInternalDebugging
       extproc('LOG4RPG10+
       _LogLog_setInternalDebugging+
       ');
  i_debugMode     const  like(LOG4RPG_debugMode_t  );
  i_output        const  like(LOG4RPG_debugOutput_t)
       options(*nopass);
end-pr;
//
//  Returns the internal debug mode.
dcl-pr LogLog_getInternalDebugMode
       like(LOG4RPG_debugMode_t  )
       extproc('LOG4RPG10+
       _LogLog_getInternalDebugMode+
       ');
end-pr;
//
//  Returns the target for internal log events.
dcl-pr LogLog_getInternalDebugOutput
       like(LOG4RPG_debugOutput_t)
       extproc('LOG4RPG10+
       _LogLog_getInternalDebugOutput+
       ');
end-pr;
//
//  This method is used to output log4rpg internal debug
//  statements.
dcl-pr LogLog_debug
       extproc('LOG4RPG10+
       _LogLog_debug+
       ');
  i_text          const  like(LOG4RPG_text_t    );
end-pr;
//
//  This method is used to output log4rpg internal debug
//  messages.
dcl-pr LogLog_debugMsg
       extproc('LOG4RPG10+
       _LogLog_debugMsg+
       ');
  i_msg           const  likeds(msg_t           );
end-pr;
//
//  This method is used to output log4rpg internal error
//  statements.
dcl-pr LogLog_error
       extproc('LOG4RPG10+
       _LogLog_error+
       ');
  i_text          const  like(LOG4RPG_text_t    );
end-pr;
//
//  This method is used to output log4rpg internal error
//  messages.
dcl-pr LogLog_errorMsg
       extproc('LOG4RPG10+
       _LogLog_errorMsg+
       ');
  i_msg           const  likeds(msg_t           );
end-pr;
//
//  This method is used to output log4rpg internal warning
//  statements.
dcl-pr LogLog_warning
       extproc('LOG4RPG10+
       _LogLog_warning+
       ');
  i_text          const  like(LOG4RPG_text_t    );
end-pr;
//
//  This method is used to output log4rpg internal warning
//  messages.
dcl-pr LogLog_warningMsg
       extproc('LOG4RPG10+
       _LogLog_warningMsg+
       ');
  i_msg           const  likeds(msg_t           );
end-pr;
//
//  This method is used to output log4rpg internal verbose
//  statements.
dcl-pr LogLog_verbose
       extproc('LOG4RPG10+
       _LogLog_verbose+
       ');
  i_text          const  like(LOG4RPG_text_t    );
end-pr;
//
//  This method is used to output log4rpg internal verbose
//  messages.
dcl-pr LogLog_verboseMsg
       extproc('LOG4RPG10+
       _LogLog_verboseMsg+
       ');
  i_msg           const  likeds(msg_t           );
end-pr;
//
/ENDIF
