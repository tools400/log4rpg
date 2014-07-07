      /IF NOT DEFINED(PLOG4RPG15)
      /DEFINE PLOG4RPG15
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PTYPES                        Private type definitions
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
     D cLOG4RPG_INT_DEBUG_OUTPUT_PRINTER...
     D                 C                   const(1)
     D cLOG4RPG_INT_DEBUG_OUTPUT_STDOUT...
     D                 C                   const(2)
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Converts the string passed as argument to an integer debug output.
     D DebugOutput_toInt...
     D                 PR             5I 0
     D                                     extproc('LOG4RPG15+
     D                                     _DebugOutput_toInt+
     D                                     ')
     D  i_debugOutput                      const  like(LOG4RPG_debugOutput_t)
      *
      *  Converts the integer passed as argument to a string debug output.
     D DebugOutput_toString...
     D                 PR                         like(LOG4RPG_debugOutput_t)
     D                                     extproc('LOG4RPG15+
     D                                     _DebugOutput_toString+
     D                                     ')
     D  i_debugOutput                 5I 0 const
      *
      *  Tests, if the specified debug output is valid (well known).
     D DebugOutput_isValid...
     D                 PR              N
     D                                     extproc('LOG4RPG15+
     D                                     _DebugOutput_isValid+
     D                                     ')
     D  i_debugOutput                      const  like(LOG4RPG_debugOutput_t)
      *
      /ENDIF
