**FREE
/IF NOT DEFINED(PLOG4RPG08)
/DEFINE PLOG4RPG08
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/COPY QLOG4RPG,PTYPES
//
// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
//    Refer to: PLOG4RPG
//
//  Returns *ON if automatic reloading of the
//  configuration is enabled, else *OFF.
dcl-pr Configurator_isAutoReload
       ind
       extproc('LOG4RPG08+
       _Configurator_isAutoReload+
       ');
end-pr;
//
//  Checks for connfiguration changes and reloads
//  the configuration data if necessary.
dcl-pr Configurator_checkAndReloadPropertiesConfiguration
       extproc('LOG4RPG08+
       _Configurator_checkAndReload+
       PropertiesConfiguration+
       ');
end-pr;
//
/ENDIF
