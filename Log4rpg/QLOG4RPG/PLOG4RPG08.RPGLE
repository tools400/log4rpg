**free
/if NOT defined(PLOG4RPG08)
/define PLOG4RPG08

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PTYPES

// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
//    Refer to: PLOG4RPG

//  Returns *ON if automatic reloading of the
//  configuration is enabled, else *OFF.
dcl-pr Configurator_isAutoReload ind extproc('LOG4RPG08_Configurator_isAutoReload');
end-pr;

//  Checks for connfiguration changes and reloads
//  the configuration data if necessary.
dcl-pr Configurator_checkAndReloadPropertiesConfiguration
  extproc('LOG4RPG08_Configurator_checkAndReloadPropertiesConfiguratio+
  n');
end-pr;

/endif