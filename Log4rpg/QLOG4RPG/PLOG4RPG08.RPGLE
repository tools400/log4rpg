      /IF NOT DEFINED(PLOG4RPG08)
      /DEFINE PLOG4RPG08
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PTYPES
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *    Refer to: PLOG4RPG
      *
      *  Returns *ON if automatic reloading of the
      *  configuration is enabled, else *OFF.
     D Configurator_isAutoReload...
     D                 PR              N
     D                                     extproc('LOG4RPG08+
     D                                     _Configurator_isAutoReload+
     D                                     ')
      *
      *  Checks for connfiguration changes and reloads
      *  the configuration data if necessary.
     D Configurator_checkAndReloadPropertiesConfiguration...
     D                 PR
     D                                     extproc('LOG4RPG08+
     D                                     _Configurator_checkAndReload+
     D                                     PropertiesConfiguration+
     D                                     ')
      *
      /ENDIF
