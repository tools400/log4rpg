/* --------------------------------------------------------------- */
/* LST4RPG    - SCRIPT MEMBER                                      */
/* Use commands  xmlgenINC (generate text for install pgm)         */
/*               xmlgenMBR (to define source members               */
/*               xmlgenCMD (execute qcmdexc at run time            */
/* Put &TOLIB where you want user selected lib at run time.        */
   DCL &TOLIB *CHAR 10
/* --------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)

             XMLGENCND  XMSG('Use *LIBL at runtime? (L_YES, L_NO)') +
                          XVALUES(L_YES L_NO) XVAR(&USELIBL)

             XMLGENCND  XMSG('Create sample programs? (YES, NO)') +
                          XVALUES(YES NO) XVAR(&CRTTSTPGM)

             XMLGENSET  XVAR(&SRCFILE) XVALUE(QLOG4RPG)

/* ---------------------------------- */
/*  Deploy source member              */
/* ---------------------------------- */
             XMLGENMBR  XMBR(A_INSTALL  ) XMBRATR(TXT  ) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_README   ) XMBRATR(TXT  ) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(BIND       ) XMBRATR(CLLE ) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CEELIB     ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CLIB       ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CLIB2      ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COMPILE    ) XMBRATR(CLLE ) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COPYRIGHT  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDINFDS    ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDJOBI0600 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDMSG      ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDQJOB     ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(H_SPEC    ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4_PROPS) XMBRATR(PROPS) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4_X1   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4_X1P1 ) XMBRATR(PROPS) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4_X1P2 ) XMBRATR(PROPS) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4_X1P3 ) XMBRATR(PROPS) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4_X1P4 ) XMBRATR(PROPS) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4_X1P5 ) XMBRATR(PROPS) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4_X1P6 ) XMBRATR(PROPS) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4_X1P7 ) XMBRATR(PROPS) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4_X2   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4HTMLAY) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4PROFLT) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RLFAPP) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG   ) XMBRATR(MAKSRV) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPGS  ) XMBRATR(MAKSRV) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG00 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG01 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG02 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG03 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG04 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG07 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG08 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG09 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG10 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG11 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG12 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG13 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG14 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG15 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG16 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG17 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG18 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG50 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG51 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG52 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG60 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG61 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG62 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG97 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG98 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4RPG99 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4SCKAPP) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4SHBAPC) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4SHBAPP) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LOG4SOCK  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(OPNLSTAPIS) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PAPPENDER ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PFILTER   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLAYOUT   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG00) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG01) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG02) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG03) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG04) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG06) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG07) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG08) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG09) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG10) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG11) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG12) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG13) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG14) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG15) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG16) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG17) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG18) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG50) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG51) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG52) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG60) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG61) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG62) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG97) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG98) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4RPG99) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLOG4SOCK ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PSHARE    ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PTYPES    ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(SDS       ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLOG4RPG  ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLOG4RPG  ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

/* ---------------------------------- */
/*  Create objects                    */
/* ---------------------------------- */
             XMLGENCMD  XCMD(CRTBNDCL PGM(&TOLIB/A_INSTALL) +
                          SRCFILE(&TOLIB/&SRCFILE) SRCMBR(*PGM) +
                          DFTACTGRP(*NO) ACTGRP(*NEW) +
                          DBGVIEW(*LIST)) XDLTSPLF(A_INSTALL)

             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_INSTALL) +
                             PARM('&TGTRLS' '&SRCFILE' '&TOLIB' '&USELIBL' '&CRTTSTPGM'))
             XMLGENCMD  XCMD(DLTPGM PGM(&TOLIB/A_INSTALL))

