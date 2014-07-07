      /IF NOT DEFINED(PLOG4RPG14)
      /DEFINE PLOG4RPG14
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PTYPES                        Private type definitions
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
     D cLOG4RPG_INT_DEBUG_QUIET...
     D                 C                   const(0)
     D cLOG4RPG_INT_DEBUG_OFF...
     D                 C                   const(1)
     D cLOG4RPG_INT_DEBUG_ON...
     D                 C                   const(2)
     D cLOG4RPG_INT_DEBUG_VERBOSE...
     D                 C                   const(3)
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Converts the string passed as argument to an integer debug mode.
     D DebugMode_toInt...
     D                 PR             5I 0
     D                                     extproc('LOG4RPG14+
     D                                     _DebugMode_toInt+
     D                                     ')
     D  i_debugMode                        const  like(LOG4RPG_debugMode_t  )
      *
      *  Converts the integer passed as argument to a string debug mode.
     D DebugMode_toString...
     D                 PR                         like(LOG4RPG_debugMode_t  )
     D                                     extproc('LOG4RPG14+
     D                                     _DebugMode_toString+
     D                                     ')
     D  i_debugMode                   5I 0 const
      *
      *  Tests, if the specified debug mode is valid (well known).
     D DebugMode_isValid...
     D                 PR              N
     D                                     extproc('LOG4RPG14+
     D                                     _DebugMode_isValid+
     D                                     ')
     D  i_debugMode                        const  like(LOG4RPG_debugMode_t  )
      *
      /ENDIF
