**free
//=====================================================================
//  Sample: Loads config from mbr:LOG4_X1P1
//=====================================================================
//  This sample program loads the configuration data from member
//  QLOG4RPG.LOG4_X1P1.
//  The program writes some log events to file 'log4_x1p1.log'
//  in the user's current directory. Usually it is the user's home
//  directory. Please verify that appending log entries to file
//  'log4_x1p1.log' in the current directory does not harm your
//  system. You may use WRKLNK 'log4_x1p1.log' to check where the
//  output goes.
//
//  Caution: The log events will be added to 'log4_x1.log'
//           without warning.
//
//=====================================================================
// >>PRE-COMPILER<<
//   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +
//                           SRCFILE(&SL/&SF) SRCMBR(&SM);
//
//   >>COMPILE<<
//     >>PARM<< TRUNCNBR(*NO);
//     >>PARM<< DBGVIEW(*LIST);
//     >>PARM<< OPTION(*EVENTF);
//   >>END-COMPILE<<
//   >>EXECUTE<<
//   >>CMD<<    CRTPGM       PGM(&LI/&OB) +
//                           MODULE(&LI/&OB) +
//                           BNDSRVPGM(*LIBL/BASICS1  +
//                                     *LIBL/IFS      +
//                                     *LIBL/LOG4RPG) +
//                           BNDDIR(*LIBL/QC2LE) +
//                           DETAIL(*BASIC) +
//                           ACTGRP(*NEW);
// >>END-PRE-COMPILER<<
//=====================================================================
ctl-opt main(PGM_ENTRY_POINT);
ctl-opt debug option(*srcstmt: *nodebugio);
ctl-opt decedit('0,') datedit(*dmy.) datfmt(*iso) timfmt(*iso);
ctl-opt expropts(*resdecpos) extbinint(*yes);
//=====================================================================*
//
// ------------------------------------
//  Type definitions
// ------------------------------------
//
// ------------------------------------
//  External Prototypes
// ------------------------------------
/COPY QBASICS1,PBASICS1                      SrvPgm: Basics 1
/COPY QLOG4RPG,PLOG4RPG                      Log4rpg
//
// ------------------------------------
//  Global Fields
// ------------------------------------
//
// ------------------------------------
//  Globale Konstanten
// ------------------------------------
//
// ------------------------------------
//  Prototypes
// ------------------------------------
//
dcl-pr PGM_ENTRY_POINT extpgm('LOG4_EXP4');
  gi_config char(64) options(*nopass) const;
end-pr;

//=====================================================================*
//  Program Entry Point
//=====================================================================*
dcl-proc PGM_ENTRY_POINT;
  dcl-pi *n;
    gi_config char(64) options(*nopass) const;
  end-pi;

   if (%parms() >= %parmnum(gi_config));
     main(%subst(gi_config: 1: %scan(' ': gi_config)));
   else;
     main('mbr:QLOG4RPG.LOG4_X1P1');
   endif;

end-proc;

//=====================================================================*
//  Main procedure
//=====================================================================*
dcl-proc main;
  dcl-pi *n;
    i_config varchar(32) value;
  end-pi;

  //  Helper fields
  dcl-s hLog1 like(LOG4RPG_hLogger_t);
  dcl-s hLog2 like(LOG4RPG_hLogger_t);

  dcl-s x int(10) inz(10000);
  dcl-s startTime timestamp;
  dcl-s endTime timestamp;
  dcl-s mSecs int(20);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Configurator_loadPropertiesConfiguration(i_config);

  hLog1 = Logger_getRootLogger();
  hLog2 = Logger_getLogger('de.tools400');

  Logger_debug(hLog1: 'This example demonstrates how long it takes to execute +
                       a debug statement for ' + %char(x) + ' times.');
  Logger_debug(hLog1: 'The ''de.tools400'' logger is configured for INFO +
                       messages and hence no output is expected by this logger.');
  Logger_debug(hLog1: 'Starting speed test ...');

  startTime = %timestamp();

  dow (x > 0);
    // Does not show up in the log.
    Logger_debug(hLog2: '*** Speed test running ***');
    x = x - 1;
  enddo;

  endTime = %timestamp();
  mSecs = %diff(endTime: startTime: *MSECONDS);

  Logger_debug(hLog1: '... finished speed test.');
  Logger_debug(hLog1: 'Time elapsed: ' + %char(mSecs));

end-proc;
