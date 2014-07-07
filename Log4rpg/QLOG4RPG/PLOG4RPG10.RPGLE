      /IF NOT DEFINED(PLOG4RPG10)
      /DEFINE PLOG4RPG10
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PTYPES                        Internal type definitions
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Allows to enable/disable log4rpg internal logging.
     D LogLog_setInternalDebugging...
     D                 PR
     D                                     extproc('LOG4RPG10+
     D                                     _LogLog_setInternalDebugging+
     D                                     ')
     D  i_debugMode                        const  like(LOG4RPG_debugMode_t  )
     D  i_output                           const  like(LOG4RPG_debugOutput_t)
     D                                            options(*nopass)
      *
      *  Returns the internal debug mode.
     D LogLog_getInternalDebugMode...
     D                 PR                         like(LOG4RPG_debugMode_t  )
     D                                     extproc('LOG4RPG10+
     D                                     _LogLog_getInternalDebugMode+
     D                                     ')
      *
      *  Returns the target for internal log events.
     D LogLog_getInternalDebugOutput...
     D                 PR                         like(LOG4RPG_debugOutput_t)
     D                                     extproc('LOG4RPG10+
     D                                     _LogLog_getInternalDebugOutput+
     D                                     ')
      *
      *  This method is used to output log4rpg internal debug
      *  statements.
     D LogLog_debug...
     D                 PR
     D                                     extproc('LOG4RPG10+
     D                                     _LogLog_debug+
     D                                     ')
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  This method is used to output log4rpg internal debug
      *  messages.
     D LogLog_debugMsg...
     D                 PR
     D                                     extproc('LOG4RPG10+
     D                                     _LogLog_debugMsg+
     D                                     ')
     D  i_msg                              const  likeds(msg_t           )
      *
      *  This method is used to output log4rpg internal error
      *  statements.
     D LogLog_error...
     D                 PR
     D                                     extproc('LOG4RPG10+
     D                                     _LogLog_error+
     D                                     ')
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  This method is used to output log4rpg internal error
      *  messages.
     D LogLog_errorMsg...
     D                 PR
     D                                     extproc('LOG4RPG10+
     D                                     _LogLog_errorMsg+
     D                                     ')
     D  i_msg                              const  likeds(msg_t           )
      *
      *  This method is used to output log4rpg internal warning
      *  statements.
     D LogLog_warning...
     D                 PR
     D                                     extproc('LOG4RPG10+
     D                                     _LogLog_warning+
     D                                     ')
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  This method is used to output log4rpg internal warning
      *  messages.
     D LogLog_warningMsg...
     D                 PR
     D                                     extproc('LOG4RPG10+
     D                                     _LogLog_warningMsg+
     D                                     ')
     D  i_msg                              const  likeds(msg_t           )
      *
      *  This method is used to output log4rpg internal verbose
      *  statements.
     D LogLog_verbose...
     D                 PR
     D                                     extproc('LOG4RPG10+
     D                                     _LogLog_verbose+
     D                                     ')
     D  i_text                             const  like(LOG4RPG_text_t    )
      *
      *  This method is used to output log4rpg internal verbose
      *  messages.
     D LogLog_verboseMsg...
     D                 PR
     D                                     extproc('LOG4RPG10+
     D                                     _LogLog_verboseMsg+
     D                                     ')
     D  i_msg                              const  likeds(msg_t           )
      *
      /ENDIF
