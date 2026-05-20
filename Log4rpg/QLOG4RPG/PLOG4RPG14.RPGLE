**FREE
/IF NOT DEFINED(PLOG4RPG14)
/DEFINE PLOG4RPG14
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/COPY QLOG4RPG,PTYPES                        Private type definitions
//
// -----------------------------------------
//  Constants
// -----------------------------------------
dcl-c cLOG4RPG_INT_DEBUG_QUIET
      const(0);
dcl-c cLOG4RPG_INT_DEBUG_OFF
      const(1);
dcl-c cLOG4RPG_INT_DEBUG_ON
      const(2);
dcl-c cLOG4RPG_INT_DEBUG_VERBOSE
      const(3);
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
//
//  Converts the string passed as argument to an integer debug mode.
dcl-pr DebugMode_toInt
       int(5)
       extproc('LOG4RPG14+
       _DebugMode_toInt+
       ');
  i_debugMode     const  like(LOG4RPG_debugMode_t  );
end-pr;
//
//  Converts the integer passed as argument to a string debug mode.
dcl-pr DebugMode_toString
       like(LOG4RPG_debugMode_t  )
       extproc('LOG4RPG14+
       _DebugMode_toString+
       ');
  i_debugMode     int(5) const;
end-pr;
//
//  Tests, if the specified debug mode is valid (well known).
dcl-pr DebugMode_isValid
       ind
       extproc('LOG4RPG14+
       _DebugMode_isValid+
       ');
  i_debugMode     const  like(LOG4RPG_debugMode_t  );
end-pr;
//
/ENDIF
