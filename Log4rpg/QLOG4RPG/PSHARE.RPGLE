**free
/if NOT defined(PSHARE)
/define PSHARE

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG Public interface & type definitions
/copy QLOG4RPG,PLOG4RPG03 Appender
/copy QLOG4RPG,PLOG4RPG06 Property
/copy QLOG4RPG,PLOG4RPG07 PropertyList
/copy QLOG4RPG,PLOG4RPG10 LogLog
/copy QLOG4RPG,PLOG4RPG11 Layout
/copy QLOG4RPG,PLOG4RPG16 LogEvent
/copy QLOG4RPG,PLOG4RPG17 Filter
/copy QLOG4RPG,PLOG4RPG99 Helper

/copy QBASICS1,PBASICS1

// -----------------------------------------
//   Type definitions shared with
//   appenders & layouts
// -----------------------------------------

dcl-s LOG4RPG_prefix_t varchar(128) based(pDummy);

/endif