**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: Configurator                             *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  13.06.2006                                              *
//  E-mail  :  thomas.raddatz@tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  26.10.2006  Th.Raddatz    Introduced Filter to Log4rpg.            *
//                                                                     *
//  27.10.2006  Th.Raddatz    Fixed problem that properties were not   *
//                            found because auf case mismatch.         *
//                            Added feature to completely enable/      *
//                            disable Log4rpg. Logger_isLogging().     *
//                                                                     *
//  14.11.2006  Th.Raddatz    Fixed problem that appender 'defaultFile'*
//                            was not found when the default           *
//                            configuration was used.                  *
//                                                                     *
//  18.04.2008  Th.Raddatz    Added support to reload the configuration*
//                            data every n minutes:                    *
//                            Configurator_loadAndWatchProp...()       *
//                                                                     *
//  19.06.2008  Th.Raddatz    Added support for *SEARCH special value. *
//                                                                     *
//  20.06.2008  Th.Raddatz    Fixed problem that appenders, layouts    *
//                            and filters were not (re)configured when *
//                            reloading configuration data.            *
//                                                                     *
//  09.09.2008  Th.Raddatz    Changed call to Appender_setFilter()     *
//                            to pass a filter handle instead of a     *
//                            filter name.                             *
//                                                                     *
//  14.02.2014  Th.Raddatz    Now calling Repository_dumpHierarchy()   *
//                            for debugging purposes.                  *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//                                                                     *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) +                     *
//                              SRCMBR(&SM);                           *
//                                                                     *
//     >>COMPILE<<                                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TGTRLS(V7R3M0  );                                    *
//     >>END-COMPILE<<                                                 *
//                                                                     *
//     >>EXECUTE<<                                                     *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
/copy QLOG4RPG,H_SPEC
//=====================================================================*
//
// -----------------------------------------
//  Imported functions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG Public API Specification

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG08

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG Public interface & type definitions
/copy QLOG4RPG,PLOG4RPG01 Logger
/copy QLOG4RPG,PLOG4RPG10 LogLog

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,CLIB C-Library
/copy QBASICS1,PBASICS1 Basic RPG Extensions
/copy QIFS,PIFS IFS Stream file support

/copy QLOG4RPG,PLOG4RPG03 Appender
/copy QLOG4RPG,PLOG4RPG06 Property
/copy QLOG4RPG,PLOG4RPG07 Property List
/copy QLOG4RPG,PLOG4RPG10 LogLog
/copy QLOG4RPG,PLOG4RPG12 ClassLoader
/copy QLOG4RPG,PLOG4RPG13 Repository
/copy QLOG4RPG,PLOG4RPG14 DebugMode
/copy QLOG4RPG,PLOG4RPG15 DebugOutput
/copy QLOG4RPG,PLOG4RPG17 Filter
/copy QLOG4RPG,PLOG4RPG99 Helpers

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Configures LOG4RPG from a properties file.
dcl-pr loadPropertiesConfiguration ind;
  i_path     like(LOG4RPG_path_t) const;
  o_realPath like(LOG4RPG_path_t);
end-pr;

//  Configures log4rpg.
dcl-pr doConfigure;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
end-pr;

//  Configures the base system of log4rpg.
dcl-pr configureBaseSystem;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
end-pr;

//  Configures the internal log of Log4rpg.
dcl-pr configureInternalLog;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
end-pr;

//  Configures Log4rpg mode (enable/disable).
dcl-pr configureLog4rpgMode;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
end-pr;

//  Configures the root logger.
dcl-pr configureRootLogger;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
end-pr;

//  Configures a logger.
dcl-pr configureLoggers;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  Parse configuration data of the specified logger.
dcl-pr parseLogger;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_pLogger   like(LOG4RPG_hLogger_t) const;
  i_value     like(LOG4RPG_Property_value_t) const;
end-pr;

//  Parse appender configuration data.
dcl-pr parseAppender like(LOG4RPG_pAppender_t);
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_appName   like(LOG4RPG_appenderName_t) const;
end-pr;

//  Parse filter configuration data.
dcl-pr parseFilter like(LOG4RPG_pFilter_t);
  i_pPropList  like(LOG4RPG_pPropertyList_t) const;
  i_filterName like(LOG4RPG_filterName_t) const;
  i_pFilterMap like(BasicMap_handle_t) options(*nopass) const;
end-pr;

//  Parse layout configuration data.
dcl-pr parseLayout like(LOG4RPG_pLayout_t);
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_logName   like(LOG4RPG_loggerName_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  Disables the auto-reload feature.
dcl-pr AutoReload_disable;
end-pr;

//  Enables the auto-reload feature.
dcl-pr AutoReload_enable;
  i_url     like(url_t) const;
  i_minutes int(10) const;
  i_unit    char(10) const;
end-pr;

//  Updates the time the properties file was last modified.
dcl-pr AutoReload_updateLastModificationTime;
end-pr;

//  Sets the time the properties file has to be checked for changes.
dcl-pr AutoReload_setNextUpdateTime;
end-pr;

//  Initializes this module.
dcl-pr initializeModule;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cROOT_LOGGER_PREFIX 'log4rpg.rootlogger';
dcl-c cLOGGER_PREFIX 'log4rpg.logger.';

dcl-c cAPPENDER_PREFIX 'log4rpg.appender.';
dcl-c cLAYOUT_SUFFIX '.layout';

dcl-c cFILTER_PREFIX 'log4rpg.filter.';

dcl-c cFILTER_SUFFIX '.filter';
dcl-c cFILTER_NEXT_FILTER '.nextfilter';

dcl-c cPROPERTY_LOG4RPG 'log4rpg';

dcl-c cPROPERTY_DEBUG 'log4rpg.debug';

dcl-c cCOMPILER_MSECONDS '*MSECONDS';
dcl-c cCOMPILER_MSECONDS_SHORT '*MS';
dcl-c cCOMPILER_SECONDS '*SECONDS';
dcl-c cCOMPILER_SECONDS_SHORT '*S';
dcl-c cCOMPILER_MINUTES '*MINUTES';
dcl-c cCOMPILER_MINUTES_SHORT '*MN';
dcl-c cCOMPILER_HOURS '*HOURS';
dcl-c cCOMPILER_HOURS_SHORT '*H';

// -----------------------------------------
//  Global fields
// -----------------------------------------
dcl-s g_isInit ind inz(*off);

dcl-ds g_autoReload qualified;
  isAutoReload ind inz(*off);
  waitTime     int(10) inz;
  unit         char(10) inz;
  reloadURL    like(url_t) inz;
  nextUpd      timestamp inz;
  lastMod      timestamp inz;
  lastUpd      timestamp inz;
end-ds;

// -----------------------------------------
//  Program status data structure
// -----------------------------------------
/define SDS_EXTENDED
/copy QLOG4RPG,SDS
/undefine SDS_EXTENDED

//=========================================================================
//  Configures LOG4RPG using a default configuration.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   isConfigured  - Returns TRUE on succes, else FALSE.
//
//  Default configuration:
//   log4rpg.rootLogger=DEBUG, defaultFile
//   log4rpg.appender.defaultFile=DailyRollingFileAppender
//   log4rpg.appender.defaultFile.path=log4rpg.log
//   log4rpg.appender.defaultFile.datePattern=.yyyy-MM-dd
//   log4rpg.appender.defaultFile.layout=PatternLayout
//=========================================================================
dcl-proc Configurator_loadDefaultConfiguration export;
  dcl-pi *n ind;
  end-pi;

  //  Return value
  dcl-s isConfigured ind inz(*off);

  //  Helper fields
  dcl-ds property likeds(LOG4RPG_Property_t) inz;
  dcl-s pPropList like(LOG4RPG_pPropertyList_t) inz;
  dcl-ds msg likeds(msg_t) inz;

  //  Local constants
  dcl-c cDEFAULT_APPENDER 'defaultfile';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if not Logger_isLogging();
    return isConfigured;
  endif;

  initializeModule();

  AutoReload_disable();

  LogLog_debug('Loading default configuration ...');

  // Create property list for default configuration
  pPropList = PropertyList_new();

  // Add properties ...
  // ...  log4rpg.rootLogger=DEBUG, defaultFile
  property.key   = cROOT_LOGGER_PREFIX;
  property.value = 'DEBUG, ' + cDEFAULT_APPENDER;
  PropertyList_put(pPropList: property);

  // ...  log4rpg.appender.defaultFile=DailyRollingFileAppender
  property.key   = cAPPENDER_PREFIX + cDEFAULT_APPENDER;
  property.value = 'DailyRollingFileAppender';
  PropertyList_put(pPropList: property);

  // ...  log4rpg.appender.defaultFile.path=log4rpg.log
  property.key   = cAPPENDER_PREFIX + cDEFAULT_APPENDER + '.path';
  property.value = 'log4rpg.log';
  PropertyList_put(pPropList: property);

  // ...  log4rpg.appender.defaultFile.datePattern=.yyyy-MM-dd
  property.key   = cAPPENDER_PREFIX + cDEFAULT_APPENDER + '.datePattern';
  property.value = '.yyyy-MM-dd';
  PropertyList_put(pPropList: property);

  // ...  log4rpg.appender.defaultFile.layout=PatternLayout
  property.key   = cAPPENDER_PREFIX + cDEFAULT_APPENDER + '.layout';
  property.value = 'PatternLayout';
  PropertyList_put(pPropList: property);

  // Configure root and non-root loggers
  doConfigure(pPropList);

  // Free resources
  PropertyList_delete(pPropList);

  LogLog_debug('Finished loading default configuration.');
  LogLog_debug('LOG4RPG is configured, now.');

  isConfigured = *on;

  return isConfigured;


end-proc;

//=========================================================================
//  Configures LOG4RPG from a properties file.
//=========================================================================
//  Parameters:
//   i_path        - String URL that conatins the location where to
//                   load the properties from.
//
//  Returns:
//   isConfigured  - Returns TRUE on succes, else FALSE.
//
//  Samples:
//   Configurator_loadPropertiesConfiguration('file:log4rpg.properties')
//   Configurator_loadPropertiesConfiguration('mbr:QLOG4RPG.B_PROPS')
//=========================================================================
dcl-proc Configurator_loadPropertiesConfiguration export;
  dcl-pi *n ind;
    i_path like(LOG4RPG_path_t) const;
  end-pi;

  //  Return value
  dcl-s isConfigured ind inz(*off);

  //  Helper fields
  dcl-s realPath like(LOG4RPG_path_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if not Logger_isLogging();
    return isConfigured;
  endif;

  initializeModule();

  AutoReload_disable();

  if not loadPropertiesConfiguration(i_path: realPath);
    return isConfigured;
  endif;

  isConfigured = *on;

  return isConfigured;


end-proc;

//=========================================================================
//  Configures LOG4RPG from a properties file. Watches the properties
//  for changes and reloads the configuration on changes.
//=========================================================================
//  Parameters:
//   i_path        - String URL that conatins the location where to
//                   load the properties from.
//   i_waitTime    - Time to wait until going to check for changed
//                   configuration data. Default: 1
//   i_unit        - Unit of i_waitTime. Default: minutes
//
//  Returns:
//   isConfigured  - Returns TRUE on succes, else FALSE.
//=========================================================================
dcl-proc Configurator_loadAndWatchPropertiesConfiguration export;
  dcl-pi *n ind;
    i_path     like(LOG4RPG_path_t) const;
    i_waitTime int(10) options(*nopass) const;
    i_unit     char(10) options(*nopass) const;
  end-pi;

  //  Return value
  dcl-s isConfigured ind inz(*off);

  //  Parameter positions
  dcl-c p_waitTime 2;
  dcl-c p_unit 3;

  //  Field for optional parameters
  dcl-s waitTime like(i_waitTime) inz;
  dcl-s unit like(i_unit) inz;

  //  Helper fields
  dcl-s realPath like(LOG4RPG_path_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if not Logger_isLogging();
    return isConfigured;
  endif;

  initializeModule();

  // Get optional parameter values ...
  // ... waitTime
  if %parms() >= p_waitTime;
    waitTime = i_waitTime;
  else;
    waitTime = cLOG4RPG_CONFIGURATION_DEFAULT_RELOAD_DELAY;
  endif;

  // ... unit
  if %parms() >= p_unit;
    unit = i_unit;
  else;
    unit = cLOG4RPG_CONFIGURATION_DEFAULT_RELOAD_DELAY_UNIT;
  endif;

  if waitTime > 0;
    LogLog_debug('Setting reload time to ' +
                 %char(waitTime) + ' (' + unit + ').');
    AutoReload_enable(i_path: waitTime: unit);
  else;
    LogLog_debug('AUTO-RELOAD disabled. No reload interval specified.');
    AutoReload_disable();
  endif;

  if not loadPropertiesConfiguration(i_path: realPath);
    return isConfigured;
  endif;

  if (g_autoReload.isAutoReload = *on and i_path <> realPath);
    AutoReload_enable(realPath: waitTime: unit);
  endif;

  isConfigured = *on;

  return isConfigured;


end-proc;

//=========================================================================
//  If AUTO-UPDATE is enabled, this procedure checks for configuration
//  changes. It updates the configuration if needed.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   void
//=========================================================================
dcl-proc Configurator_checkAndReloadPropertiesConfiguration export;
  dcl-pi *n;
  end-pi;


  //  Helper fields
  dcl-s lastModOld like(g_autoReload.lastMod) inz;
  dcl-s realPath like(LOG4RPG_path_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if not g_autoReload.isAutoReload;
    return;
  endif;

  if g_autoreload.nextUpd > %timestamp();
    return;
  endif;

  AutoReload_setNextUpdateTime();

  lastModOld = g_autoReload.lastMod;
  AutoReload_updateLastModificationTime();

  if lastModOld = g_autoReload.lastMod;
    return;
  endif;

  Repository_prepareReload();
  loadPropertiesConfiguration(g_autoReload.reloadURL: realPath);

  return;


end-proc;

//=========================================================================
//  Clears all configuration data. All loggers and appenders are deleted.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   void
//=========================================================================
dcl-proc Configurator_clearConfiguration export;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if not Logger_isLogging();
    return;
  endif;

  LogLog_debug('Clearing configuration ...');

  AutoReload_disable();

  Repository_clear();

  LogLog_verbose('Configuration cleared.');

  return;


end-proc;

//=========================================================================
//  Returns *ON if automatic reloading of the configuration is
//  enabled, else *OFF.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   isAutoReload  - Returns *ON if auto-reload is enabled, else *OFF.
//=========================================================================
dcl-proc Configurator_isAutoReload export;
  dcl-pi *n ind;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return g_autoReload.isAutoReload;


end-proc;

//=========================================================================
//  *** Private ***
//  Configures LOG4RPG from a properties file.
//=========================================================================
dcl-proc loadPropertiesConfiguration;
  dcl-pi *n ind;
    i_path     like(LOG4RPG_path_t) const;
    o_realPath like(LOG4RPG_path_t);
  end-pi;

  //  Return value
  dcl-s isConfigured ind inz(*off);

  //  Helper fields
  dcl-s isLoaded ind inz(*off);
  dcl-s url like(url_t) inz;
  dcl-s pPropList like(LOG4RPG_pPropertyList_t) inz;
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LogLog_debug('Loading properties configuration ...');

  // Load configuration into property list
  url = URL_new(i_path);

  LogLog_debug(
     'Loading properties configuration from: ' +
      URL_toString(url) + ' ...');

  pPropList = PropertyList_new();
  isLoaded = PropertyList_loadFromUrl(pPropList: url);
  if not isLoaded;
    LogLog_warning('Could not read configuration file [' +
                    i_path  + '].');
    o_realPath = '';
    return isConfigured;
  endif;

  o_realPath = PropertyList_getUrl(pPropList);

  // Configure root and non-root loggers
  doConfigure(pPropList);

  // Free resources
  PropertyList_delete(pPropList);

  LogLog_debug('Finished loading properties configuration from: ' +
               URL_toString(url));
  LogLog_debug('LOG4RPG is configured, now.');

  isConfigured = *on;

  return isConfigured;


end-proc;

//=========================================================================
//  *** Private ***
//  Configures root and non-root loggers.
//=========================================================================
dcl-proc doConfigure;
  dcl-pi *n;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Configure base system of log4rpg
  configureBaseSystem(i_pPropList);
  if not Logger_isLogging();
    return;
  endif;

  // Configure root logger
  configureRootLogger(i_pPropList);

  // Configure non-root loggers
  configureLoggers(i_pPropList: cLOGGER_PREFIX);

  // Dump repository
  Repository_dumpHierarchy();


end-proc;

//=========================================================================
//  *** Private ***
//  Configures the base system of log4rpg.
//=========================================================================
dcl-proc configureBaseSystem;
  dcl-pi *n;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
  end-pi;

  //  Helper fields
  dcl-s value like(LOG4RPG_Property_value_t) inz;
  dcl-s pToken pointer inz;
  dcl-s debugMode like(LOG4RPG_debugMode_t) inz(cLOG4RPG_DEBUG_OFF);
  dcl-s output like(LOG4RPG_debugOutput_t) inz(cLOG4RPG_DEBUG_OUTPUT_PRINTER);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Enable/disable internal log
  configureInternalLog(i_pPropList);

  // Enable/disable Log4rpg
  configureLog4rpgMode(i_pPropList);

  return;


end-proc;

//=========================================================================
//  *** Private ***
//  Configures the internal log of Log4rpg.
//=========================================================================
dcl-proc configureInternalLog;
  dcl-pi *n;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
  end-pi;

  //  Helper fields
  dcl-s value like(LOG4RPG_Property_value_t) inz;
  dcl-s pToken pointer inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  dcl-s debugMode like(LOG4RPG_debugMode_t) inz(cLOG4RPG_DEBUG_OFF);
  dcl-s output like(LOG4RPG_debugOutput_t) inz(cLOG4RPG_DEBUG_OUTPUT_PRINTER);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  value = PropertyList_get(i_pPropList: cPROPERTY_DEBUG);
  if value = '';
    return;
  endif;

  // Get debug mode
  pToken = strtok(value: ',');
  if pToken <> *NULL;
    debugMode = %trim(%str(pToken));
  endif;

  // Get output
  pToken = strtok(*NULL: ',');
  if pToken <> *NULL;
    output = %trim(%str(pToken));
  endif;

  LogLog_setInternalDebugging(debugMode: output);

  return;


end-proc;

//=========================================================================
//  *** Private ***
//  Configures Log4rpg mode (enable/disable).
//=========================================================================
dcl-proc configureLog4rpgMode;
  dcl-pi *n;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
  end-pi;

  //  Helper fields
  dcl-s value varchar(32) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Enable/disable Log4rpg
  if PropertyList_containsKey(i_pPropList: cPROPERTY_LOG4RPG);
    value = f_lcase(PropertyList_get(i_pPropList: cPROPERTY_LOG4RPG));
    select;
    when (value = '1') or (value = 'true') or (value = 'on');
      Logger_setLogging(*on);
    when (value = '0') or (value = 'false') or (value = 'off');
      LogLog_debug('Log4rpg disabled. +
                    Stopped configuration procedure.');
      Logger_setLogging(*off);
      return;
    other;
      LogLog_warning('Invalid value specified for property ''' +
                      cPROPERTY_LOG4RPG + ''': ' + value);
    endsl;
  endif;

  return;


end-proc;

//=========================================================================
//  *** Private ***
//  Configures the root logger.
//=========================================================================
dcl-proc configureRootLogger;
  dcl-pi *n;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
  end-pi;

  //  Helper fields
  dcl-s value like(LOG4RPG_Property_value_t) inz;
  dcl-s pRootLogger like(LOG4RPG_hLogger_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  value = PropertyList_get(i_pPropList: cROOT_LOGGER_PREFIX);
  if value = '';
    LogLog_warning('Could not find root logger information. +
                    Is this OK?');
    return;
  endif;

  // Get rootLogger
  pRootLogger = Repository_getLogger(cROOT_LOGGER);

  // Parse root logger configuration data
  parseLogger(i_pPropList: pRootLogger: value);

  return;


end-proc;

//=========================================================================
//  *** Private ***
//  Configures a logger.
//=========================================================================
dcl-proc configureLoggers;
  dcl-pi *n;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

  //  Helper fields
  dcl-s logName like(LOG4RPG_loggerName_t) inz;
  dcl-ds property likeds(LOG4RPG_property_t) inz;
  dcl-s pLogger like(LOG4RPG_hLogger_t) inz;
  dcl-ds propIter likeds(LOG4RPG_PropertyListIterator_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  propIter = PropertyList_getIterator(i_pPropList);

  property = PropertyList_getFirst(propIter);

  dow property.key <> '';

    if f_startsWith(i_prefix: property.key) and
       %len(property.key) > %len(i_prefix);

      logName = %subst(property.key: %len(i_prefix) + 1);
      logName = translateLoggerName(logName);

      // Get logger from hierarchy  (add logger to hierarchy)
      pLogger = Repository_getLogger(logName);

      parseLogger(i_pPropList: pLogger: property.value);

    endif;

    property = PropertyList_getNext(propIter);
  enddo;

  return;


end-proc;

//=========================================================================
//  *** Private ***
//  Parse configuration data of the specified logger.
//=========================================================================
dcl-proc parseLogger;
  dcl-pi *n;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_pLogger   like(LOG4RPG_hLogger_t) const;
    i_value     like(LOG4RPG_Property_value_t) const;
  end-pi;

  //  Helper fields
  dcl-s pToken pointer inz;
  dcl-s pAppender like(LOG4RPG_pAppender_t) inz;
  dcl-s appName like(LOG4RPG_appenderName_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Get log level
  pToken = strtok(i_value: ',');
  if pToken <> *NULL;
    Logger_setLevel(i_pLogger: %str(pToken));
  endif;

  // Remove all existing appenders
  Logger_removeAllAppenders(i_pLogger);

  // Get & configure appenders
  pToken = strtok(*NULL: ',');
  dow pToken <> *NULL;
    appName = f_lcase(%trim(%str(pToken)));

    if not Repository_existAppender(appName);
      pAppender = parseAppender(i_pPropList: appName);
    else;
      pAppender = Repository_getAppender(appName);
    endif;

    if not Appender_isNull(pAppender);

      // Add appender to logger
      Logger_addAppender(i_pLogger: pAppender);
    endif;

    pToken = strtok(*NULL: ',');
  enddo;

  return;


end-proc;

//=========================================================================
//  *** Private ***
//  Parse appender configuration data.
//=========================================================================
dcl-proc parseAppender;
  dcl-pi *n like(LOG4RPG_pAppender_t);
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_appName   like(LOG4RPG_appenderName_t) const;
  end-pi;

  //  Return value
  dcl-s pAppender like(LOG4RPG_pAppender_t) inz;

  //  Helper fields
  dcl-s value like(LOG4RPG_Property_value_t) inz;
  dcl-s prefix like(LOG4RPG_prefix_t) inz;
  dcl-s pLayout like(LOG4RPG_pLayout_t) inz;
  dcl-s pFilter like(LOG4RPG_pFilter_t) inz;
  dcl-s filterName like(LOG4RPG_filterName_t) inz;
  dcl-s key like(LOG4RPG_property_key_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  prefix = cAPPENDER_PREFIX + i_appName;

  value = PropertyList_get(i_pPropList: prefix);
  if value = '';
    LogLog_warning('Could not find appender information for +
                    appender named [' + i_appName + ']');
    return pAppender;
  endif;

  pAppender = Appender_new(i_appName: value);
  if Appender_isNull(pAppender);
    LogLog_warning('Could not instantiate appender [' +
                    i_appName + ']');
    return pAppender;
  endif;

  Appender_setProperties(pAppender: i_pPropList: prefix + '.');

  // Parse layout if appender requires layout
  if Appender_requiresLayout(pAppender);
    pLayout = parseLayout(i_pPropList: i_appName
                                     : prefix + cLAYOUT_SUFFIX);
    if not Layout_isNull(pLayout);
      Appender_setLayout(pAppender: pLayout);
    endif;
  endif;

  // Parse filter if properties file specifies a filter for the appender
  key = cAPPENDER_PREFIX + i_appName + cFILTER_SUFFIX;
  if PropertyList_containsKey(i_pPropList: key);
    filterName = f_lcase(PropertyList_get(i_pPropList: key));
    if not Repository_existFilter(filterName);
      pFilter = parseFilter(i_pPropList: filterName);
    else;
      pFilter = Repository_getFilter(filterName);
    endif;

    // Attach filter to appender
    if not Filter_isNull(pFilter);
      Appender_setFilter(pAppender: pFilter);
    endif;
  endif;

  return pAppender;


end-proc;

//=========================================================================
//  *** Private ***
//  Parse filter configuration data.
//=========================================================================
dcl-proc parseFilter;
  dcl-pi *n like(LOG4RPG_pFilter_t);
    i_pPropList  like(LOG4RPG_pPropertyList_t) const;
    i_filterName like(LOG4RPG_filterName_t) const;
    i_pFilterMap like(BasicMap_handle_t) options(*nopass) const;
  end-pi;

  //  Return value
  dcl-s pFilter like(LOG4RPG_pFilter_t) inz;

  //  Parameter positions
  dcl-c p_pFilterMap 3;

  //  Fields for optional parameters
  dcl-s pFilterMap like(i_pFilterMap) inz;

  //  Helper fields
  dcl-s value like(LOG4RPG_Property_value_t) inz;
  dcl-s prefix like(LOG4RPG_prefix_t) inz;
  dcl-s pNextFilter like(LOG4RPG_pFilter_t) inz;
  dcl-s nextFilterName like(LOG4RPG_filterName_t) inz;
  dcl-s key like(LOG4RPG_property_key_t) inz;
  dcl-s isLocalFilterMap ind inz(*off);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  prefix = cFILTER_PREFIX + i_filterName;

  value = PropertyList_get(i_pPropList: prefix);
  if value = '';
    LogLog_warning('Could not find filter information for +
                    filter named [' + i_filterName + ']');
    return pFilter;
  endif;

  pFilter = Filter_new(i_filterName: value);
  if Filter_isNull(pFilter);
    LogLog_warning('Could not instantiate filter [' +
                    i_filterName + ']');
    return pFilter;
  endif;

  Filter_setProperties(pFilter: i_pPropList: prefix + '.');

  if %parms() >= p_pFilterMap;
    pFilterMap = i_pFilterMap;
    isLocalFilterMap = *off;
  else;
    pFilterMap = BasicMap_new();
    isLocalFilterMap = *on;
  endif;

  BasicMap_put(pFilterMap: i_filterName: '*');

  // Parse next filter if properties file specifies a next filter
  key = cFILTER_PREFIX + i_filterName + cFILTER_NEXT_FILTER;
  if PropertyList_containsKey(i_pPropList: key);
    nextFilterName = f_lcase(PropertyList_get(i_pPropList: key));
    if BasicMap_containsKey(pFilterMap: nextFilterName);
      LogLog_warning('Recursion detected for filter [' +
                      i_filterName + ']');
    else;
      if not Repository_existFilter(nextFilterName);
        pNextFilter = parseFilter(
                         i_pPropList: nextFilterName: pFilterMap);
      else;
        pNextFilter = Repository_getFilter(nextFilterName);
      endif;

      // Set next filter of filter
      if not Filter_isNull(pNextFilter);
        Filter_setNext(pFilter: pNextFilter);
      endif;
    endif;
  endif;

  if isLocalFilterMap;
    BasicMap_delete(pFilterMap);
  endif;

  return pFilter;


end-proc;

//=========================================================================
//  *** Private ***
//  Parse layout configuration data.
//=========================================================================
dcl-proc parseLayout;
  dcl-pi *n like(LOG4RPG_pLayout_t);
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_logName   like(LOG4RPG_loggerName_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

  //  Return value
  dcl-s pLayout like(LOG4RPG_pLayout_t) inz;

  //  Helper fields
  dcl-s value like(LOG4RPG_Property_value_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pLayout = Layout_null();

  value = PropertyList_get(i_pPropList: i_prefix);
  if value = '';
    LogLog_warning('Property [Layout] is missing for appender +
                    [' + i_logName + ']');
    return pLayout;
  endif;

  pLayout = Layout_new(value);
  if Layout_isNull(pLayout);
    LogLog_warning('Could not instantiate layout [' +
                    getProcedure(value) + ']');
    return pLayout;
  endif;

  Layout_setProperties(pLayout: i_pPropList: i_prefix + '.');

  return pLayout;


end-proc;

//=========================================================================
//  *** private ***
//  Disables the auto-reload feature.
//=========================================================================
dcl-proc AutoReload_disable;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_autoReload.isAutoReload = *off;
  g_autoReload.waitTime     = 0;
  g_autoReload.unit         = '*N';
  g_autoReload.reloadURL    = '';
  g_autoReload.nextUpd      = *loval;
  g_autoReload.lastMod      = *loval;

  LogLog_debug('AUTO-RELOAD feature disabled.');

  return;


end-proc;

//=========================================================================
//  *** private ***
//  Enables the auto-reload feature.
//=========================================================================
dcl-proc AutoReload_enable;
  dcl-pi *n;
    i_url  like(url_t) const;
    i_time int(10) const;
    i_unit char(10) const;
  end-pi;

  dcl-s protocol like(url_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  protocol = Url_getProtocol(i_url);
  if protocol <> 'file' and protocol <> 'mbr';
    AutoReload_disable();
    LogLog_error('Unsupported URL protocol. AUTO-RELOAD disabled.');
    return;
  endif;

  g_autoReload.isAutoReload = *on;
  g_autoReload.waitTime     = i_time;
  g_autoReload.reloadURL    = i_url;
  g_autoReload.unit         = i_unit;

  AutoReload_setNextUpdateTime();
  AutoReload_updateLastModificationTime();

  LogLog_debug('AUTO-RELOAD feature enabled.');
  LogLog_debug(' -> URL : ' + g_autoReload.reloadURL);
  LogLog_debug(' -> Wait: ' + %char(g_autoReload.waitTime));

  return;


end-proc;

//=========================================================================
//  *** private ***
//  Updates the time the properties file was last modified.
//=========================================================================
dcl-proc AutoReload_updateLastModificationTime;
  dcl-pi *n;
  end-pi;

  dcl-s protocol like(url_t) inz;

  dcl-ds mbr qualified;
    name char(10) inz;
    file char(10) inz;
    lib  char(10) inz;
  end-ds;

  dcl-ds mbrd0100 likeds(mbrd0100_t) inz;
  dcl-ds mbrd0200 likeds(mbrd0200_t) inz;

  dcl-ds lastChgDateAPI qualified;
    cymd char(7);
    hms  char(6);
  end-ds;

  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  g_autoReload.lastMod = *LOVAL;

  protocol = Url_getProtocol(g_autoReload.reloadURL);

  // Get time the object was last modified for a ...
  select;
  // ... file object
  when protocol = 'file';
    g_autoReload.lastMod = f_getIfsFileDataChgTime(
                              Url_getPath(g_autoReload.reloadURL): msg);
    if (msg.ID <> cMSG_ID_OK);
      return;
    endif;

  // ... member object
  when protocol = 'mbr';
    URL_getMbr(g_autoReload.reloadURL
               : mbr.file: mbr.lib: mbr.name);
    mbrd0100 = f_rtvMbrD(mbr.file: mbr.lib: mbr.name: 'MBRD0100': msg);
    if (msg.ID <> cMSG_ID_OK);
      return;
    endif;

    if mbrd0100.isSrcFile = '0';
      mbrd0200 = f_rtvMbrD(
                       mbr.file: mbr.lib: mbr.name: 'MBRD0200': *omit);
      lastChgDateAPI = mbrd0200.mbrChgDatTim;
    else;
      lastChgDateAPI = mbrd0100.chgDatTim;
    endif;

    monitor;
      g_autoReload.lastMod = %date(lastChgDateAPI.cymd: *CYMD0) +
                             %time(lastChgDateAPI.hms : *HMS0 );
    on-error;
    // Nothing to do here
    endmon;

  other;
  // Ignore any other protocol
  endsl;

  return;


end-proc;

//=========================================================================
//  *** private ***
//  Sets the time the properties file has to be checked for changes.
//=========================================================================
dcl-proc AutoReload_setNextUpdateTime;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  select;
  // milli-seconds
  when (g_autoReload.unit = cCOMPILER_MSECONDS or
        g_autoReload.unit = cCOMPILER_MSECONDS_SHORT);
    g_autoReload.nextUpd = %timestamp() +
                           %mseconds(g_autoReload.waitTime);
  // seconds
  when (g_autoReload.unit = cCOMPILER_SECONDS or
        g_autoReload.unit = cCOMPILER_SECONDS_SHORT);
    g_autoReload.nextUpd = %timestamp() +
                           %seconds(g_autoReload.waitTime);
  // minutes
  when (g_autoReload.unit = cCOMPILER_MINUTES or
        g_autoReload.unit = cCOMPILER_MINUTES_SHORT);
    g_autoReload.nextUpd = %timestamp() +
                           %minutes(g_autoReload.waitTime);
  // hours
  when (g_autoReload.unit = cCOMPILER_HOURS or
        g_autoReload.unit = cCOMPILER_HOURS_SHORT);
    g_autoReload.nextUpd = %timestamp() +
                           %hours(g_autoReload.waitTime);
  endsl;

  return;


end-proc;

//=========================================================================
//  *** private ***
//  Initializes this module.
//=========================================================================
dcl-proc initializeModule;
  dcl-pi *n;
  end-pi;

  //  Return value
  //
  //  Helper fields
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if g_isInit;
    return;
  endif;

  Loglog_verbose('Initializing module ' + sds.modContProc + '...');

  Repository_initialize();

  g_isInit = *on;

  return;


end-proc;
