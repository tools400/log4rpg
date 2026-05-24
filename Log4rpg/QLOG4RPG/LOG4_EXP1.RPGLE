**free
//=====================================================================
// Copy the configuration member to the IFS like this:
//   CPY OBJ('/QSYS.LIB/LOG4RPGDVP.LIB/QLOG4RPG.FILE/LOG4_X1P1.MBR')
//   TOOBJ('/home/raddatz/log4_x1P1.properties') TOCCSID(1252)
//   DTAFMT(*TEXT)
// Change the call to Configurator_loadPropertiesConfiguration(), so
// that it specifies the correct location of log4_x1P1.properties.
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
  gi_config char(64) options(*nopass) const;
end-pr;

dcl-proc main;
  dcl-pi *n;
    gi_config char(64) options(*nopass) const;
  end-pi;

  dcl-s config like(gi_config);

  dcl-s hLogger like(LOG4RPG_hLogger_t);

  if (%parms() >= %parmnum(gi_config));
    config = %subst(gi_config: 1: %scan(' ': gi_config));
  else;
    config = 'mbr:LOG4RPGDVP/QLOG4RPG(LOG4_X1P1)';
  endif;

  // Enable internal debug log for the configuration steps
  // before property 'log4rpg.debug' is set to 'off, printer'.
  Logger_setInternalDebugging(cLOG4RPG_DEBUG_ON: cLOG4RPG_DEBUG_OUTPUT_PRINTER);

  Configurator_loadPropertiesConfiguration('file:/home/raddatz/log4_x1P1.properties');

  hLogger = Logger_getLogger('de.tools400');

  Logger_info(hLogger: 'Hello World');
  Logger_debug(hLogger: 'Not logged, due to level=INFO');

end-proc;