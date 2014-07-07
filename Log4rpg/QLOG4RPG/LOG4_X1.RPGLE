      *=====================================================================*
      *  Sample: Loads config from mbr:LOG4_X1P1                            *
      *=====================================================================*
      *  This sample program loads the configuration data from member       *
      *  QLOG4RPG.LOG4_X1P1.                                                *
      *  The program writes some log events to file 'log4_x1p1.log'         *
      *  in the user's current directory. Usually it is the user's home     *
      *  directory. Please verify that appending log entries to file        *
      *  'log4_x1p1.log' in the current directory does not harm your        *
      *  system. You may use WRKLNK 'log4_x1p1.log' to check where the      *
      *  output goes.                                                       *
      *                                                                     *
      *  Caution: The log events will be added to 'log4_x1.log'             *
      *           without warning.                                          *
      *                                                                     *
      *=====================================================================*
      * >>PRE-COMPILER<<                                                    *
      *                                                                     *
      *   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *
      *                           SRCFILE(&SL/&SF) +                        *
      *                           SRCMBR(&SM);                              *
      *                                                                     *
      *   >>COMPILE<<                                                       *
      *     >>PARM<< TRUNCNBR(*NO);                                         *
      *     >>PARM<< DBGVIEW(*LIST);                                        *
      *   >>END-COMPILE<<                                                   *
      *                                                                     *
      *   >>EXECUTE<<                                                       *
      *                                                                     *
      *   >>CMD<<    CRTPGM       PGM(&LI/LOG4_X1PGM) +                     *
      *                           MODULE(&LI/&OB          +                 *
      *                                          ) +                        *
      *                           BNDSRVPGM(*LIBL/BASICS1      +            *
      *                                     *LIBL/IFS          +            *
      *                                     *LIBL/LOG4RPG )    +            *
      *                           BNDDIR(*LIBL/QC2LE) +                     *
      *                           DETAIL(*BASIC) +                          *
      *                           ACTGRP(*NEW);                             *
      *                                                                     *
      * >>END-PRE-COMPILER<<                                                *
      *=====================================================================*
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
     H EXTBININT(*YES)
      *=====================================================================*
      *
      * ------------------------------------
      *  Type definitions
      * ------------------------------------
      *
      * ------------------------------------
      *  External Prototypes
      * ------------------------------------
      /COPY QBASICS1,PBASICS1                      SrvPgm: Basics 1
      /COPY QLOG4RPG,PLOG4RPG                      Log4rpg
      *
      * ------------------------------------
      *  Global Fields
      * ------------------------------------
      *
      * ------------------------------------
      *  Globale Konstanten
      * ------------------------------------
      *
      * ------------------------------------
      *  Prototypes
      * ------------------------------------
      *
     D PGM_ENTRY_POINT...
     D                 PR                  extpgm('LOG4_X1')
     D gi_properties                 32A   const  options(*nopass)
      *
     D main...
     D                 PR
     D i_properties                  32A   value  varying
      *
      *=====================================================================*
      *  Program Entry Point
      *=====================================================================*
     D PGM_ENTRY_POINT...
     D                 PI
     D gi_properties                 32A   const  options(*nopass)
      *
      /FREE
 
         if %parms() >= 1;
            main(%trim(gi_properties));
         else;
            main('mbr:QLOG4RPG.LOG4_X1P1');
         endif;
 
         *inlr = *on;
 
         return;
 
      /END-FREE
      *
      *=====================================================================*
      *  Main procedure
      *=====================================================================*
     P main...
     P                 B
      *
     D main...
     D                 PI
     D i_properties                  32A   value  varying
      *
      *  Helper fields
     D hLog1           S                   like(LOG4RPG_hLogger_t         ) inz
     D hLog2           S                   like(LOG4RPG_hLogger_t         ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Control block
         dou 1=1;
 
            Configurator_loadPropertiesConfiguration(i_properties);
 
            hLog1 = Logger_getRootLogger();
            hLog2 = Logger_getLogger('de.tools400');
 
            Logger_debug(hLog1: 'Testnachricht 1.1');
            Logger_debug(hLog1: 'Testnachricht 1.1.1 + Dies ist eine sehr +
                                 lange Nachricht. Sie muss daher bei einem +
                                 Print Appender über mehrere Zeilen gedruckt +
                                 werden.');
            Logger_debug(hLog1: 'Testnachricht 1.2');
            Logger_debug(hLog1: 'Testnachricht 1.3');
            Logger_debug(hLog1: 'Testnachricht 1.4');
            Logger_debug(hLog1: 'Testnachricht 1.5');
            Logger_debug(hLog1: 'Testnachricht 1.6');
 
            Logger_info(hLog2: 'Hello World (de.tools400)');
            Logger_debug(hLog2: 'Hello World (de.tools400)');
            Logger_warn(hLog2: 'Hello World (de.tools400)');
            Logger_error(hLog2: 'Hello World (de.tools400)');
            Logger_fatal(hLog2: 'Hello World (de.tools400)');
 
         enddo;
 
         return;
 
      /END-FREE
      *
     P main...
     P                 E
      *
