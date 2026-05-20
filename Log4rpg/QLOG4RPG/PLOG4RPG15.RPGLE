**FREE
/IF NOT DEFINED(PLOG4RPG15)
/DEFINE PLOG4RPG15
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/COPY QLOG4RPG,PTYPES                        Private type definitions
//
// -----------------------------------------
//  Constants
// -----------------------------------------
dcl-c cLOG4RPG_INT_DEBUG_OUTPUT_PRINTER
      const(1);
dcl-c cLOG4RPG_INT_DEBUG_OUTPUT_STDOUT
      const(2);
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
//
//  Converts the string passed as argument to an integer debug output.
dcl-pr DebugOutput_toInt
       int(5)
       extproc('LOG4RPG15+
       _DebugOutput_toInt+
       ');
  i_debugOutput   const  like(LOG4RPG_debugOutput_t);
end-pr;
//
//  Converts the integer passed as argument to a string debug output.
dcl-pr DebugOutput_toString
       like(LOG4RPG_debugOutput_t)
       extproc('LOG4RPG15+
       _DebugOutput_toString+
       ');
  i_debugOutput   int(5) const;
end-pr;
//
//  Tests, if the specified debug output is valid (well known).
dcl-pr DebugOutput_isValid
       ind
       extproc('LOG4RPG15+
       _DebugOutput_isValid+
       ');
  i_debugOutput   const  like(LOG4RPG_debugOutput_t);
end-pr;
//
/ENDIF
