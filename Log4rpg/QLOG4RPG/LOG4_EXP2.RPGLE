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

  dcl-s hRootLogger like(LOG4RPG_hLogger_t);
  dcl-s hChildLogger1 like(LOG4RPG_hLogger_t);
  dcl-s hSubLogger1 like(LOG4RPG_hLogger_t);
  dcl-s hSubLogger2 like(LOG4RPG_hLogger_t);

  // Enable internal debug log for the configuration steps
  // before property 'log4rpg.debug' is set to 'off, printer'.
  Logger_setInternalDebugging(cLOG4RPG_DEBUG_ON: cLOG4RPG_DEBUG_OUTPUT_PRINTER);

  Configurator_loadPropertiesConfiguration('mbr:LOG4RPGDVP/QLOG4RPG(LOG4_X1P2)');

  hRootLogger = Logger_getRootLogger();
  hChildLogger1 = Logger_getLogger('de.tools400');
  hSubLogger1 = Logger_getLogger('de.tools400.sub1');
  hSubLogger2 = Logger_getLogger('de.tools400.sub2');

  // The root logger is configured with log level DEBUG.
  // Therefore it must log messages of the following types:
  //   DEBUG, INFO, WARN, ERROR and FATAL
  Logger_debug(hRootLogger: 'Debug message');
  Logger_debug(hRootLogger: 'Debug message (long). This is a very long +
                             message that must be printed by the +
                             DailyRollingPrintAppender using multiple lines.');
  Logger_info(hRootLogger: 'Info message');
  Logger_warn(hRootLogger: 'Warning message');
  Logger_error(hRootLogger: 'Error message');
  Logger_fatal(hRootLogger: 'Fatal error message');

  // The 'de.tools400' child logger is configured with log level INFO.
  // Therefore it only logs messages of the following types:
  //   INFO, WARN, ERROR, and FATAL
  // DEBUG messages are not appended to the log.
  Logger_debug(hChildLogger1: 'Debug message, not logged (de.tools400)');
  Logger_info(hChildLogger1: 'Debug message (de.tools400)');
  Logger_warn(hChildLogger1: 'Warning message (de.tools400)');
  Logger_error(hChildLogger1: 'Error message (de.tools400)');
  Logger_fatal(hChildLogger1: 'Fatal error message (de.tools400)');

  // The 'de.tools400.sub11' logger inherits its properties from
  // the de.tools400' logger. Hence DEBUG messages are not logged.
  Logger_debug(hSubLogger1: 'Debug message, not logged (de.tools400.sub1)');
  Logger_info(hSubLogger1: 'Info message (de.tools400.sub1)');

  // The 'de.tools400.sub2' logger inherits its properties from
  // the de.tools400' logger, but the log level is overridden programmatically.
  Logger_setLevel(hSubLogger2: cLOG4RPG_LEVEL_DEBUG);
  Logger_debug(hSubLogger2: 'Debug message, now logged (de.tools400.sub2)');
  Logger_info(hSubLogger2: 'Info message (de.tools400.sub2)');

  // The log level can be changed at any time.
  // The log level of logger 'de.tools400.sub2' could also be set
  // in the configuration file like this:
  //   log4rpg.logger.de.tools400.sub2=DEBUG

end-proc;
