**free
//=====================================================================
// Change the call to Configurator_loadPropertiesConfiguration(), so
// that it specifies the correct location of member LOG4_X1P1.
//=====================================================================
//   >>PRE-COMPILER<<
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +
//                              SRCFILE(&SL/&SF) SRCMBR(&SM);
//     >>COMPILE<<
//       >>PARM<< TRUNCNBR(*NO);
//       >>PARM<< DBGVIEW(*LIST);
//       >>PARM<< OPTION(*EVENTF);
//     >>END-COMPILE<<
//     >>EXECUTE<<
//     >>CMD<<     CRTPGM  PGM(&LI/&OB) +
//                         MODULE(&LI/&OB) +
//                         ACTGRP(*NEW) +
//                         BNDSRVPGM(*LIBL/LOG4RPG) +
//                         DETAIL(*BASIC);
//   >>END-PRE-COMPILER<<
//=====================================================================

ctl-opt main(main);

/include QLOG4RPG,PLOG4RPG

dcl-pr main extpgm('LOG4_EXP1');
end-pr;

dcl-proc main;
  dcl-pi *n;
  end-pi;

  dcl-s hLogger like(LOG4RPG_hLogger_t);
  dcl-s hLayout like(LOG4RPG_pLayout_t);
  dcl-s hAppender like(LOG4RPG_pAppender_t);

  // Enable internal debug log for the configuration steps
  // before property 'log4rpg.debug' is set to 'off, printer'.
  Logger_setInternalDebugging(cLOG4RPG_DEBUG_ON: cLOG4RPG_DEBUG_OUTPUT_PRINTER);

  Configurator_clearConfiguration();

  hLayout = Layout_new('*LIBL/LOG4RPG(PatternLayout)'
                     : 'conversionPattern=%z [%-5p] %L/%P(%M).%F (%S) %m%n;');

  hAppender = Appender_new('appender'
                         : '*LIBL/LOG4RPG(DailyRollingFileAppender)'
                         : 'path=/home/raddatz/log4_x1p0.log;ccsid=1208');
  Appender_setLayout(hAppender: hLayout);

  // Configure the root logger
  Logger_addAppender(hLogger: hAppender);
  Logger_addAppender(Logger_getRootLogger(): hAppender);
  Logger_setLevel(Logger_getRootLogger(): cLOG4RPG_LEVEL_DEBUG);

  // Configure the 'de.tools400' logger
  hLogger = Logger_getLogger('de.tools400');
  Logger_setLevel(hLogger: cLOG4RPG_LEVEL_INFO);

  // Send some log meesages to the log file
  Logger_info(hLogger: 'Hello World');
  Logger_debug(hLogger: 'Not logged, due to level=INFO');

  Logger_debug(Logger_getRootLogger()
             : 'Append to the log file, +
                because the log level of the root logger is set to DEBUG');

end-proc;