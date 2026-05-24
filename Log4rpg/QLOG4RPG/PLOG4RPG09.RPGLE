**free
/if NOT defined(PLOG4RPG09)
/define PLOG4RPG09

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PTYPES Private type definitions

// -----------------------------------------
//  Constants
// -----------------------------------------
dcl-c cLOG4RPG_PRIORITY_DEBUG 1;
dcl-c cLOG4RPG_PRIORITY_INFO 2;
dcl-c cLOG4RPG_PRIORITY_WARN 3;
dcl-c cLOG4RPG_PRIORITY_ERROR 4;
dcl-c cLOG4RPG_PRIORITY_FATAL 5;
dcl-c cLOG4RPG_PRIORITY_NONE 99;

// -----------------------------------------
//  Prototypes
// -----------------------------------------

//  Converts the string passed as argument to an integer level.
dcl-pr Level_toInt like(LOG4RPG_priority_t) extproc('LOG4RPG09_Level_toInt');
  i_level like(LOG4RPG_level_t) const;
end-pr;

//  Converts the integer passed as argument to a string level.
dcl-pr Level_toString like(LOG4RPG_level_t) extproc('LOG4RPG09_Level_toString');
  i_level like(LOG4RPG_priority_t) const;
end-pr;

/endif