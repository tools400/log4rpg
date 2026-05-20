**free
/if not defined(SDS)
/define SDS

dcl-ds sds qualified psds;
  pgmName       char(10) pos(1);
  pgmStat       zoned(5) pos(11);
  prevStat      zoned(5) pos(16);
  lastSeq       char(8) pos(21);
  lastSubr      char(8) pos(29);
  nbrParm       zoned(3) pos(37);
  excType       char(3) pos(40);
  excNbr        char(4) pos(43);
  miInstruction char(4) pos(47);
  workArea      char(30) pos(51);
/if defined(SDS_EXTENDED)
  pgmLib        char(10) pos(81);
  excData       char(80) pos(91);
  rnx9001Exc    char(4) pos(171);
  lastFileLong  char(10) pos(175);
  unused_1      char(6) pos(185);
  datFmt        char(8) pos(191);
  year          zoned(2: 0) pos(199);
  lastFileShort char(8) pos(201);
  fileStat      char(35) pos(209);
  job           char(10) pos(244);
  user          char(10) pos(254);
  nbr           zoned(6: 0) pos(264);
  startDate     zoned(6: 0) pos(270);
  runDate       zoned(6: 0) pos(276);
  runTime       zoned(6: 0) pos(282);
  compDate      char(6) pos(288);
  compTime      char(10) pos(294);
  compLevel     char(4) pos(300);
  srcFile       char(10) pos(304);
  srcLib        char(10) pos(314);
  srcMbr        char(10) pos(324);
  pgmContProc   char(10) pos(334);
  modContProc   char(10) pos(344);
  sourceID1     int(5) pos(354);
  sourceID2     int(5) pos(356);
  currUser      char(10) pos(358);
  extErrCode    int(10) pos(368);
  xmlElem_INTO  int(20) pos(372); // Since 5.4
  intJobID      char(16) pos(380); // Since 7.3
  sysName       char(6) pos(396);
  unused        char(50) pos(404);
/endif
end-ds;
/endif
