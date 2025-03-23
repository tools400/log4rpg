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

  // Enable internal debug log for the configuration steps
  // before property 'log4rpg.debug' is set to 'off, printer'.
  Logger_setInternalDebugging(cLOG4RPG_DEBUG_ON: cLOG4RPG_DEBUG_OUTPUT_PRINTER);

  Configurator_loadPropertiesConfiguration('mbr:LOG4RPGDVP/QLOG4RPG(LOG4_X1P1)');

  hLogger = Logger_getLogger('de.tools400');

  Logger_info(hLogger: 'Hello World');
  Logger_debug(hLogger: 'Not logged, due to level=INFO');

end-proc;
