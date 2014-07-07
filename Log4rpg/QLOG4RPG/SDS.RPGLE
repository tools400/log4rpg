 DEF  /IF NOT DEFINED(SDS)
 DEF  /DEFINE SDS
      *
     D sds            SDS                  qualified
     D  pgmName                1     10A
     D  pgmStat               11     15S 0
     D  prevStat              16     20S 0
     D  lastSeq               21     28A
     D  lastSubr              29     36A
     D  nbrParm               37     39S 0
     D  excType               40     42A
     D  excNbr                43     46A
     D  miInstruction         47     50A
     D  workArea              51     80A
 DEF  /IF DEFINED(SDS_EXTENDED)
     D  pgmLib                81     90A
     D  excData               91    170A
     D  rnx9001Exc           171    174A
     D  lastFileLong         175    184A
     D  unused_1             185    190A
     D  datFmt               191    198A
     D  year                 199    200S 0
     D  lastFileShort        201    208A
     D  fileStat             209    243A
     D  job                  244    253A
     D  user                 254    263A
     D  nbr                  264    269S 0
     D  startDate            270    275S 0
     D  runDate              276    281S 0
     D  runTime              282    287S 0
     D  compDate             288    293A
     D  compTime             294    299A
     D  compLevel            300    303A
     D  srcFile              304    313A
     D  srcLib               314    323A
     D  srcMbr               324    333A
     D  pgmContProc          334    343A
     D  modContProc          344    353A
     D  unused_2             354    429A
 DEF  /ENDIF
 DEF  /ENDIF
