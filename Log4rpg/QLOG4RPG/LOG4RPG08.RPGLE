      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: Configurator                             *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  13.06.2006                                              *
      *  E-mail  :  thomas.raddatz@tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  26.10.2006  Th.Raddatz    Introduced Filter to Log4rpg.            *
      *                                                                     *
      *  27.10.2006  Th.Raddatz    Fixed problem that properties were not   *
      *                            found because auf case mismatch.         *
      *                            Added feature to completely enable/      *
      *                            disable Log4rpg. Logger_isLogging().     *
      *                                                                     *
      *  14.11.2006  Th.Raddatz    Fixed problem that appender 'defaultFile'*
      *                            was not found when the default           *
      *                            configuration was used.                  *
      *                                                                     *
      *  18.04.2008  Th.Raddatz    Added support to reload the configuration*
      *                            data every n minutes:                    *
      *                            Configurator_loadAndWatchProp...()       *
      *                                                                     *
      *  19.06.2008  Th.Raddatz    Added support for *SEARCH special value. *
      *                                                                     *
      *  20.06.2008  Th.Raddatz    Fixed problem that appenders, layouts    *
      *                            and filters were not (re)configured when *
      *                            reloading configuration data.            *
      *                                                                     *
      *  09.09.2008  Th.Raddatz    Changed call to Appender_setFilter()     *
      *                            to pass a filter handle instead of a     *
      *                            filter name.                             *
      *                                                                     *
      *  14.02.2014  Th.Raddatz    Now calling Repository_dumpHierarchy()   *
      *                            for debugging purposes.                  *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< TGTRLS(V6R1M0  );                                    *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /COPY QLOG4RPG,H_SPEC
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG08
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG                      Public interface & type definitions
      /COPY QLOG4RPG,PLOG4RPG01                    Logger
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,CLIB                          C-Library
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      /COPY QIFS,PIFS                              IFS Stream file support
      *
      /COPY QLOG4RPG,PLOG4RPG03                    Appender
      /COPY QLOG4RPG,PLOG4RPG06                    Property
      /COPY QLOG4RPG,PLOG4RPG07                    Property List
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
      /COPY QLOG4RPG,PLOG4RPG12                    ClassLoader
      /COPY QLOG4RPG,PLOG4RPG13                    Repository
      /COPY QLOG4RPG,PLOG4RPG14                    DebugMode
      /COPY QLOG4RPG,PLOG4RPG15                    DebugOutput
      /COPY QLOG4RPG,PLOG4RPG17                    Filter
      /COPY QLOG4RPG,PLOG4RPG99                    Helpers
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Configures LOG4RPG from a properties file.
     D loadPropertiesConfiguration...
     D                 PR              N
     D  i_path                             const  like(LOG4RPG_path_t   )
     D  o_realPath                                like(LOG4RPG_path_t   )
      *
      *  Configures log4rpg.
     D doConfigure...
     D                 PR
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Configures the base system of log4rpg.
     D configureBaseSystem...
     D                 PR
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Configures the internal log of Log4rpg.
     D configureInternalLog...
     D                 PR
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Configures Log4rpg mode (enable/disable).
     D configureLog4rpgMode...
     D                 PR
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Configures the root logger.
     D configureRootLogger...
     D                 PR
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Configures a logger.
     D configureLoggers...
     D                 PR
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Parse configuration data of the specified logger.
     D parseLogger...
     D                 PR
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_pLogger                          const  like(LOG4RPG_hLogger_t       )
     D  i_value                            const  like(LOG4RPG_Property_value_t)
      *
      *  Parse appender configuration data.
     D parseAppender...
     D                 PR                         like(LOG4RPG_pAppender_t     )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
      *
      *  Parse filter configuration data.
     D parseFilter...
     D                 PR                         like(LOG4RPG_pFilter_t       )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_filterName                       const  like(LOG4RPG_filterName_t    )
     D  i_pFilterMap                       const  like(BasicMap_handle_t       )
     D                                            options(*nopass)
      *
      *  Parse layout configuration data.
     D parseLayout...
     D                 PR                         like(LOG4RPG_pLayout_t       )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_logName                          const  like(LOG4RPG_loggerName_t    )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Disables the auto-reload feature.
     D AutoReload_disable...
     D                 PR
      *
      *  Enables the auto-reload feature.
     D AutoReload_enable...
     D                 PR
     D  i_url                              const  like(url_t )
     D  i_minutes                    10I 0 const
     D  i_unit                       10A   const
      *
      *  Updates the time the properties file was last modified.
     D AutoReload_updateLastModificationTime...
     D                 PR
      *
      *  Sets the time the properties file has to be checked for changes.
     D AutoReload_setNextUpdateTime...
     D                 PR
      *
      *  Initializes this module.
     D initializeModule...
     D                 PR
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cROOT_LOGGER_PREFIX...
     D                 C                   const('log4rpg.rootlogger')
     D cLOGGER_PREFIX...
     D                 C                   const('log4rpg.logger.')
      *
     D cAPPENDER_PREFIX...
     D                 C                   const('log4rpg.appender.')
     D cLAYOUT_SUFFIX...
     D                 C                   const('.layout')
      *
     D cFILTER_PREFIX...
     D                 C                   const('log4rpg.filter.')
      *
     D cFILTER_SUFFIX...
     D                 C                   const('.filter')
     D cFILTER_NEXT_FILTER...
     D                 C                   const('.nextfilter')
      *
     D cPROPERTY_LOG4RPG...
     D                 C                   const('log4rpg')
      *
     D cPROPERTY_DEBUG...
     D                 C                   const('log4rpg.debug')
      *
     D cCOMPILER_MSECONDS...
     D                 C                   const('*MSECONDS')
     D cCOMPILER_MSECONDS_SHORT...
     D                 C                   const('*MS')
     D cCOMPILER_SECONDS...
     D                 C                   const('*SECONDS')
     D cCOMPILER_SECONDS_SHORT...
     D                 C                   const('*S')
     D cCOMPILER_MINUTES...
     D                 C                   const('*MINUTES')
     D cCOMPILER_MINUTES_SHORT...
     D                 C                   const('*MN')
     D cCOMPILER_HOURS...
     D                 C                   const('*HOURS')
     D cCOMPILER_HOURS_SHORT...
     D                 C                   const('*H')
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
     D g_isInit        S               N   inz(cFalse)
      *
     D g_autoReload    DS                  qualified
     D  isAutoReload                   N   inz(cFalse)
     D  waitTime                     10I 0 inz
     D  unit                         10A   inz
     D  reloadURL                          like(url_t ) inz
     D  nextUpd                        Z   inz
     D  lastMod                        Z   inz
     D  lastUpd                        Z   inz
      *
      * -----------------------------------------
      *  Program status data structure
      * -----------------------------------------
      /DEFINE SDS_EXTENDED
      /COPY QLOG4RPG,SDS
      /UNDEFINE SDS_EXTENDED
      *
      *=========================================================================
      *  Configures LOG4RPG using a default configuration.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   isConfigured  - Returns TRUE on succes, else FALSE.
      *
      *  Default configuration:
      *   log4rpg.rootLogger=DEBUG, defaultFile
      *   log4rpg.appender.defaultFile=DailyRollingFileAppender
      *   log4rpg.appender.defaultFile.path=log4rpg.log
      *   log4rpg.appender.defaultFile.datePattern=.yyyy-MM-dd
      *   log4rpg.appender.defaultFile.layout=PatternLayout
      *=========================================================================
     P Configurator_loadDefaultConfiguration...
     P                 B                   export
      *
     D Configurator_loadDefaultConfiguration...
     D                 PI              N
      *
      *  Return value
     D isConfigured    S               N   inz(cFalse)
      *
      *  Helper fields
     D property        DS                  likeds(LOG4RPG_Property_t    ) inz
     D pPropList       S                   like(LOG4RPG_pPropertyList_t ) inz
     D msg             DS                  likeds(msg_t                 ) inz
      *
      *  Local constants
     D cDEFAULT_APPENDER...
     D                 C                   const('defaultfile')
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
         isConfigured = cTrue;
 
         return isConfigured;
 
      /END-FREE
      *
     P Configurator_loadDefaultConfiguration...
     P                 E
      *
      *=========================================================================
      *  Configures LOG4RPG from a properties file.
      *=========================================================================
      *  Parameters:
      *   i_path        - String URL that conatins the location where to
      *                   load the properties from.
      *
      *  Returns:
      *   isConfigured  - Returns TRUE on succes, else FALSE.
      *
      *  Samples:
      *   Configurator_loadPropertiesConfiguration('file:log4rpg.properties')
      *   Configurator_loadPropertiesConfiguration('mbr:QLOG4RPG.B_PROPS')
      *=========================================================================
     P Configurator_loadPropertiesConfiguration...
     P                 B                   export
      *
     D Configurator_loadPropertiesConfiguration...
     D                 PI              N
     D  i_path                             const  like(LOG4RPG_path_t   )
      *
      *  Return value
     D isConfigured    S               N   inz(cFalse)
      *
      *  Helper fields
     D realPath        S                   like(LOG4RPG_path_t          ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if not Logger_isLogging();
            return isConfigured;
         endif;
 
         initializeModule();
 
         AutoReload_disable();
 
         if not loadPropertiesConfiguration(i_path: realPath);
            return isConfigured;
         endif;
 
         isConfigured = cTrue;
 
         return isConfigured;
 
      /END-FREE
      *
     P Configurator_loadPropertiesConfiguration...
     P                 E
      *
      *=========================================================================
      *  Configures LOG4RPG from a properties file. Watches the properties
      *  for changes and reloads the configuration on changes.
      *=========================================================================
      *  Parameters:
      *   i_path        - String URL that conatins the location where to
      *                   load the properties from.
      *   i_waitTime    - Time to wait until going to check for changed
      *                   configuration data. Default: 1
      *   i_unit        - Unit of i_waitTime. Default: minutes
      *
      *  Returns:
      *   isConfigured  - Returns TRUE on succes, else FALSE.
      *=========================================================================
     P Configurator_loadAndWatchPropertiesConfiguration...
     P                 B                   export
      *
     D Configurator_loadAndWatchPropertiesConfiguration...
     D                 PI              N
     D  i_path                             const  like(LOG4RPG_path_t   )
     D  i_waitTime                   10I 0 const  options(*nopass)
     D  i_unit                       10A   const  options(*nopass)
      *
      *  Return value
     D isConfigured    S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_waitTime      C                   const(2)
     D p_unit          C                   const(3)
      *
      *  Field for optional parameters
     D waitTime        S                   like(i_waitTime  ) inz
     D unit            S                   like(i_unit      ) inz
      *
      *  Helper fields
     D realPath        S                   like(LOG4RPG_path_t          ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
         if (g_autoReload.isAutoReload = cTrue and i_path <> realPath);
            AutoReload_enable(realPath: waitTime: unit);
         endif;
 
         isConfigured = cTrue;
 
         return isConfigured;
 
      /END-FREE
      *
     P Configurator_loadAndWatchPropertiesConfiguration...
     P                 E
      *
      *=========================================================================
      *  If AUTO-UPDATE is enabled, this procedure checks for configuration
      *  changes. It updates the configuration if needed.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   void
      *=========================================================================
     P Configurator_checkAndReloadPropertiesConfiguration...
     P                 B                   export
      *
     D Configurator_checkAndReloadPropertiesConfiguration...
     D                 PI
      *
      *
      *  Helper fields
     D lastModOld      S                   like(g_autoReload.lastMod) inz
     D realPath        S                   like(LOG4RPG_path_t          ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P Configurator_checkAndReloadPropertiesConfiguration...
     P                 E
      *
      *=========================================================================
      *  Clears all configuration data. All loggers and appenders are deleted.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   void
      *=========================================================================
     P Configurator_clearConfiguration...
     P                 B                   export
      *
     D Configurator_clearConfiguration...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if not Logger_isLogging();
            return;
         endif;
 
         LogLog_debug('Clearing configuration ...');
 
         AutoReload_disable();
 
         Repository_clear();
 
         LogLog_verbose('Configuration cleared.');
 
         return;
 
      /END-FREE
      *
     P Configurator_clearConfiguration...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if automatic reloading of the configuration is
      *  enabled, else cFalse.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   isAutoReload  - Returns cTrue if auto-reload is enabled, else cFalse.
      *=========================================================================
     P Configurator_isAutoReload...
     P                 B                   export
      *
     D Configurator_isAutoReload...
     D                 PI              N
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return g_autoReload.isAutoReload;
 
      /END-FREE
      *
     P Configurator_isAutoReload...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Configures LOG4RPG from a properties file.
      *=========================================================================
     P loadPropertiesConfiguration...
     P                 B
      *
     D loadPropertiesConfiguration...
     D                 PI              N
     D  i_path                             const  like(LOG4RPG_path_t   )
     D  o_realPath                                like(LOG4RPG_path_t   )
      *
      *  Return value
     D isConfigured    S               N   inz(cFalse)
      *
      *  Helper fields
     D isLoaded        S               N   inz(cFalse)
     D url             S                   like(url_t                   ) inz
     D pPropList       S                   like(LOG4RPG_pPropertyList_t ) inz
     D msg             DS                  likeds(msg_t                 ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
         isConfigured = cTrue;
 
         return isConfigured;
 
      /END-FREE
      *
     P loadPropertiesConfiguration...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Configures root and non-root loggers.
      *=========================================================================
     P doConfigure...
     P                 B
      *
     D doConfigure...
     D                 PI
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P doConfigure...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Configures the base system of log4rpg.
      *=========================================================================
     P configureBaseSystem...
     P                 B
      *
     D configureBaseSystem...
     D                 PI
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Helper fields
     D value           S                   like(LOG4RPG_Property_value_t) inz
     D pToken          S               *   inz
     D debugMode       S                   like(LOG4RPG_debugMode_t  )
     D                                     inz(cLOG4RPG_DEBUG_OFF)
     D output          S                   like(LOG4RPG_debugOutput_t)
     D                                     inz(cLOG4RPG_DEBUG_OUTPUT_PRINTER)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Enable/disable internal log
         configureInternalLog(i_pPropList);
 
         // Enable/disable Log4rpg
         configureLog4rpgMode(i_pPropList);
 
         return;
 
      /END-FREE
      *
     P configureBaseSystem...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Configures the internal log of Log4rpg.
      *=========================================================================
     P configureInternalLog...
     P                 B
      *
     D configureInternalLog...
     D                 PI
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Helper fields
     D value           S                   like(LOG4RPG_Property_value_t) inz
     D pToken          S               *   inz
     D debugMode       S                   like(LOG4RPG_debugMode_t  )
     D                                     inz(cLOG4RPG_DEBUG_OFF)
     D output          S                   like(LOG4RPG_debugOutput_t)
     D                                     inz(cLOG4RPG_DEBUG_OUTPUT_PRINTER)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P configureInternalLog...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Configures Log4rpg mode (enable/disable).
      *=========================================================================
     P configureLog4rpgMode...
     P                 B
      *
     D configureLog4rpgMode...
     D                 PI
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Helper fields
     D value           S             32A   varying                        inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Enable/disable Log4rpg
         if PropertyList_containsKey(i_pPropList: cPROPERTY_LOG4RPG);
            value = f_lcase(PropertyList_get(i_pPropList: cPROPERTY_LOG4RPG));
            select;
            when (value = '1') or (value = 'true') or (value = 'on');
               Logger_setLogging(cTrue);
            when (value = '0') or (value = 'false') or (value = 'off');
               LogLog_debug('Log4rpg disabled. +
                             Stopped configuration procedure.');
               Logger_setLogging(cFalse);
               return;
            other;
               LogLog_warning('Invalid value specified for property ''' +
                               cPROPERTY_LOG4RPG + ''': ' + value);
            endsl;
         endif;
 
         return;
 
      /END-FREE
      *
     P configureLog4rpgMode...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Configures the root logger.
      *=========================================================================
     P configureRootLogger...
     P                 B
      *
     D configureRootLogger...
     D                 PI
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
      *
      *  Helper fields
     D value           S                   like(LOG4RPG_Property_value_t) inz
     D pRootLogger     S                   like(LOG4RPG_hLogger_t       ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P configureRootLogger...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Configures a logger.
      *=========================================================================
     P configureLoggers...
     P                 B
      *
     D configureLoggers...
     D                 PI
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Helper fields
     D logName         S                   like(LOG4RPG_loggerName_t) inz
     D property        DS                  likeds(LOG4RPG_property_t) inz
     D pLogger         S                   like(LOG4RPG_hLogger_t   ) inz
     D propIter        DS                  likeds(LOG4RPG_Property...
     D                                                    ListIterator_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P configureLoggers...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Parse configuration data of the specified logger.
      *=========================================================================
     P parseLogger...
     P                 B
      *
     D parseLogger...
     D                 PI
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_pLogger                          const  like(LOG4RPG_hLogger_t       )
     D  i_value                            const  like(LOG4RPG_Property_value_t)
      *
      *  Helper fields
     D pToken          S               *                                  inz
     D pAppender       S                   like(LOG4RPG_pAppender_t     ) inz
     D appName         S                   like(LOG4RPG_appenderName_t  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P parseLogger...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Parse appender configuration data.
      *=========================================================================
     P parseAppender...
     P                 B
      *
     D parseAppender...
     D                 PI                         like(LOG4RPG_pAppender_t     )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
      *
      *  Return value
     D pAppender       S                   like(LOG4RPG_pAppender_t     ) inz
      *
      *  Helper fields
     D value           S                   like(LOG4RPG_Property_value_t) inz
     D prefix          S                   like(LOG4RPG_prefix_t        ) inz
     D pLayout         S                   like(LOG4RPG_pLayout_t       ) inz
     D pFilter         S                   like(LOG4RPG_pFilter_t       ) inz
     D filterName      S                   like(LOG4RPG_filterName_t    ) inz
     D key             S                   like(LOG4RPG_property_key_t  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P parseAppender...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Parse filter configuration data.
      *=========================================================================
     P parseFilter...
     P                 B
      *
     D parseFilter...
     D                 PI                         like(LOG4RPG_pFilter_t       )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_filterName                       const  like(LOG4RPG_filterName_t    )
     D  i_pFilterMap                       const  like(BasicMap_handle_t       )
     D                                            options(*nopass)
      *
      *  Return value
     D pFilter         S                   like(LOG4RPG_pFilter_t       ) inz
      *
      *  Parameter positions
     D p_pFilterMap    C                   const(3)
      *
      *  Fields for optional parameters
     D pFilterMap      S                   like(i_pFilterMap   ) inz
      *
      *  Helper fields
     D value           S                   like(LOG4RPG_Property_value_t) inz
     D prefix          S                   like(LOG4RPG_prefix_t        ) inz
     D pNextFilter     S                   like(LOG4RPG_pFilter_t       ) inz
     D nextFilterName  S                   like(LOG4RPG_filterName_t    ) inz
     D key             S                   like(LOG4RPG_property_key_t  ) inz
     D isLocalFilterMap...
     D                 S               N   inz(cFalse)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
            isLocalFilterMap = cFalse;
         else;
            pFilterMap = BasicMap_new();
            isLocalFilterMap = cTrue;
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
 
      /END-FREE
      *
     P parseFilter...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Parse layout configuration data.
      *=========================================================================
     P parseLayout...
     P                 B
      *
     D parseLayout...
     D                 PI                         like(LOG4RPG_pLayout_t       )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_logName                          const  like(LOG4RPG_loggerName_t    )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Return value
     D pLayout         S                   like(LOG4RPG_pLayout_t       ) inz
      *
      *  Helper fields
     D value           S                   like(LOG4RPG_Property_value_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P parseLayout...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Disables the auto-reload feature.
      *=========================================================================
     P AutoReload_disable...
     P                 B
      *
     D AutoReload_disable...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         g_autoReload.isAutoReload = cFalse;
         g_autoReload.waitTime     = 0;
         g_autoReload.unit         = '*N';
         g_autoReload.reloadURL    = '';
         g_autoReload.nextUpd      = *loval;
         g_autoReload.lastMod      = *loval;
 
         LogLog_debug('AUTO-RELOAD feature disabled.');
 
         return;
 
      /END-FREE
      *
     P AutoReload_disable...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Enables the auto-reload feature.
      *=========================================================================
     P AutoReload_enable...
     P                 B
      *
     D AutoReload_enable...
     D                 PI
     D  i_url                              const  like(url_t )
     D  i_time                       10I 0 const
     D  i_unit                       10A   const
      *
     D protocol        S                   like(url_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         protocol = Url_getProtocol(i_url);
         if protocol <> 'file' and protocol <> 'mbr';
            AutoReload_disable();
            LogLog_error('Unsupported URL protocol. AUTO-RELOAD disabled.');
            return;
         endif;
 
         g_autoReload.isAutoReload = cTrue;
         g_autoReload.waitTime     = i_time;
         g_autoReload.reloadURL    = i_url;
         g_autoReload.unit         = i_unit;
 
         AutoReload_setNextUpdateTime();
         AutoReload_updateLastModificationTime();
 
         LogLog_debug('AUTO-RELOAD feature enabled.');
         LogLog_debug(' -> URL : ' + g_autoReload.reloadURL);
         LogLog_debug(' -> Wait: ' + %char(g_autoReload.waitTime));
 
         return;
 
      /END-FREE
      *
     P AutoReload_enable...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Updates the time the properties file was last modified.
      *=========================================================================
     P AutoReload_updateLastModificationTime...
     P                 B
      *
     D AutoReload_updateLastModificationTime...
     D                 PI
      *
     D protocol        S                   like(url_t ) inz
      *
     D mbr             DS                  qualified
     D  name                         10A   inz
     D  file                         10A   inz
     D  lib                          10A   inz
      *
     D mbrd0100        DS                  likeds(mbrd0100_t  ) inz
     D mbrd0200        DS                  likeds(mbrd0200_t  ) inz
      *
     D lastChgDateAPI  DS                  qualified
     D  cymd                   1      7A
     D  hms                    8     13A
      *
     D msg             DS                  likeds(msg_t       ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P AutoReload_updateLastModificationTime...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Sets the time the properties file has to be checked for changes.
      *=========================================================================
     P AutoReload_setNextUpdateTime...
     P                 B
      *
     D AutoReload_setNextUpdateTime...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P AutoReload_setNextUpdateTime...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Initializes this module.
      *=========================================================================
     P initializeModule...
     P                 B
      *
     D initializeModule...
     D                 PI
      *
      *  Return value
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if g_isInit;
            return;
         endif;
 
         Loglog_verbose('Initializing module ' + sds.modContProc + '...');
 
         Repository_initialize();
 
         g_isInit = cTrue;
 
         return;
 
      /END-FREE
      *
     P initializeModule...
     P                 E
      *
