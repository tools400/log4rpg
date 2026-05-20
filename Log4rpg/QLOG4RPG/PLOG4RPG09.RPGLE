**FREE
/IF NOT DEFINED(PLOG4RPG09)
/DEFINE PLOG4RPG09
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/COPY QLOG4RPG,PTYPES                        Private type definitions
//
// -----------------------------------------
//  Constants
// -----------------------------------------
dcl-c cLOG4RPG_PRIORITY_DEBUG
      const(1);
dcl-c cLOG4RPG_PRIORITY_INFO
      const(2);
dcl-c cLOG4RPG_PRIORITY_WARN
      const(3);
dcl-c cLOG4RPG_PRIORITY_ERROR
      const(4);
dcl-c cLOG4RPG_PRIORITY_FATAL
      const(5);
dcl-c cLOG4RPG_PRIORITY_NONE
      const(99);
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
//
//  Converts the string passed as argument to an integer level.
dcl-pr Level_toInt
       like(LOG4RPG_priority_t    )
       extproc('LOG4RPG09+
       _Level_toInt+
       ');
  i_level         const  like(LOG4RPG_level_t       );
end-pr;
//
//  Converts the integer passed as argument to a string level.
dcl-pr Level_toString
       like(LOG4RPG_level_t       )
       extproc('LOG4RPG09+
       _Level_toString+
       ');
  i_level         const  like(LOG4RPG_priority_t    );
end-pr;
//
/ENDIF
