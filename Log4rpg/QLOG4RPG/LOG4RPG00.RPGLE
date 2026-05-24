**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Stub                                             *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  08.02.2008                                              *
//  E-mail  :  thomas.raddatz@tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  13.06.2008  Th.Raddatz    Enhanced the Log4rpg stub module         *
//                            to optionally load the Log4rpg service   *
//                            program and forward procedure calls      *
//                            to it.                                   *
//                                                                     *
//  15.09.2008  Th.Raddatz    Added procedures:                        *
//                               Layout_new()                          *
//                               Layout_null()                         *
//                               Appender_new()                        *
//                               Appender_null()                       *
//                               Appender_setLayout()                  *
//                               Appender_setFilter()                  *
//                               Logger_addAppender()                  *
//                               Filter_new()                          *
//                               Filter_null()                         *
//                               Filter_setNext()                      *
//                                                                     *
//  24.03.2009  Th.Raddatz    Removed dependency to BASICS1.           *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//                                                                     *
//     >>CRTCMD<<  CRTRPGMOD   MODULE(&LI/&OB) +                       *
//                             SRCFILE(&SL/&SF) +                      *
//                             SRCMBR(&SM);                            *
//                                                                     *
//     >>COMPILE<<                                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TGTRLS(V7R3M0  );                                    *
//     >>END-COMPILE<<                                                 *
//                                                                     *
//     >>EXECUTE<<                                                     *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
ctl-opt nomain;
ctl-opt reqprexp(*require);
/undefine NO_DECEDIT
/copy QLOG4RPG,COPYRIGHT
//=====================================================================*
//
// ------------------------------------
//  MI procedures
// ------------------------------------

//  QSYSINC/MIH.MICOMMON: Requested Authority bitmasks and typedef
//                        The bitmasks are or'd together to give
//                        desired combinations
dcl-c AUTH_OBJ_CTRL x'8000';
dcl-c AUTH_OBJ_MGMT x'4000';
dcl-c AUTH_POINTER x'2000';
dcl-c AUTH_SPACE x'1000';
dcl-c AUTH_RETRIEVE x'0800';
dcl-c AUTH_INSERT x'0400';
dcl-c AUTH_DELETE x'0200';
dcl-c AUTH_UPDATE x'0100';
dcl-c AUTH_OWNER x'0080';
dcl-c AUTH_EXCLUDED x'0040';
dcl-c AUTH_LST_MGMT x'0020';
dcl-c AUTH_EXECUTE x'0010';
dcl-c AUTH_ALTER x'0008';
dcl-c AUTH_REF x'0004';
dcl-c AUTH_ALL x'FF1C';
dcl-c AUTH_NONE x'0000';

//  QSYSINC/MIH.MIOBJTYP:  MI Object Type
dcl-c MI_Program x'0201';
dcl-c MI_Library x'0401';
dcl-c MI_Usrspc x'1934';
dcl-c MI_Usrq x'0A02';
dcl-c MI_Usridx x'0E0A';
dcl-c WLI_ALRTBL x'0E09';
dcl-c WLI_AUTL x'1B01';
dcl-c WLI_BLKSF x'1E05';
dcl-c WLI_BNDDIR x'1937';
dcl-c WLI_CFGL x'0E0D';
dcl-c WLI_CHTFMT x'190D';
dcl-c WLI_CLD x'190B';
dcl-c WLI_CLS x'1904';
dcl-c WLI_CMD x'1905';
dcl-c WLI_CNNL x'1701';
dcl-c WLI_COSD x'1401';
dcl-c WLI_CRG x'192C';
dcl-c WLI_CRQD x'0E0F';
dcl-c WLI_CSI x'1935';
dcl-c WLI_CSPMAP x'1922';
dcl-c WLI_CSPTBL x'1923';
dcl-c WLI_CTLD x'1201';
dcl-c WLI_DDIR x'1F02';
dcl-c WLI_DEVD x'1001';
dcl-c WLI_DIR x'0C01';
dcl-c WLI_DOC x'190E';
dcl-c WLI_DSTMF x'1F01';
dcl-c WLI_DTAARA x'190A';
dcl-c WLI_DTADCT x'1920';
dcl-c WLI_DTAQ x'0A01';
dcl-c WLI_EDTD x'1908';
dcl-c WLI_EXITRG x'1913';
dcl-c WLI_FCT x'0E04';
dcl-c WLI_FILE x'1901';
dcl-c WLI_FLR x'1912';
dcl-c WLI_FNTRSC x'1926';
dcl-c WLI_FNTTBL x'192B';
dcl-c WLI_FORMDF x'1928';
dcl-c WLI_FTR x'0E0B';
dcl-c WLI_GSS x'190C';
dcl-c WLI_IGCDCT x'0E06';
dcl-c WLI_IGCSRT x'191A';
dcl-c WLI_IGCTBL x'1910';
dcl-c WLI_IPXD x'191E';
dcl-c WLI_JOBD x'1903';
dcl-c WLI_JOBQ x'0E01';
dcl-c WLI_JOBSCD x'0E0C';
dcl-c WLI_JRN x'0901';
dcl-c WLI_JRNRCV x'0701';
dcl-c WLI_LIB x'0401';
dcl-c WLI_LIND x'1101';
dcl-c WLI_LOCALE x'1921';
dcl-c WLI_MEDDFN x'191C';
dcl-c WLI_MENU x'1916';
dcl-c WLI_MGTCOL x'192D';
dcl-c WLI_MODD x'1501';
dcl-c WLI_MODULE x'0301';
dcl-c WLI_MSGF x'0E03';
dcl-c WLI_MSGQ x'1902';
dcl-c WLI_M36 x'1E04';
dcl-c WLI_M36CFG x'1924';
dcl-c WLI_NODL x'0E0E';
dcl-c WLI_NTBD x'1914';
dcl-c WLI_NWID x'1601';
dcl-c WLI_NWSD x'1D01';
dcl-c WLI_NODGRP x'192A';
dcl-c WLI_OOPOOL x'2002';
dcl-c WLI_OUTQ x'0E02';
dcl-c WLI_OVL x'1929';
dcl-c WLI_PAGDFN x'1936';
dcl-c WLI_PAGSEG x'1927';
dcl-c WLI_PDG x'1930';
dcl-c WLI_PGM x'0201';
dcl-c WLI_PNLGRP x'1915';
dcl-c WLI_PRDAVL x'1933';
dcl-c WLI_PRDDFN x'191B';
dcl-c WLI_PRDLOD x'191D';
dcl-c WLI_PSFCFG x'1925';
dcl-c WLI_QMFORM x'1932';
dcl-c WLI_QMQRY x'1931';
dcl-c WLI_QRYDFN x'1911';
dcl-c WLI_RCT x'0E08';
dcl-c WLI_S36 x'1919';
dcl-c WLI_SBSD x'1909';
dcl-c WLI_SCHIDX x'0E07';
dcl-c WLI_SOCKET x'1E03';
dcl-c WLI_SOMOBJ x'2001';
dcl-c WLI_SPADCT x'1C01';
dcl-c WLI_SQLPKG x'0202';
dcl-c WLI_SQLUDT x'191F';
dcl-c WLI_SRVPGM x'0203';
dcl-c WLI_SSND x'0E05';
dcl-c WLI_STMF x'1E01';
dcl-c WLI_SVRSTG x'1917';
dcl-c WLI_SYMLNK x'1E02';
dcl-c WLI_TBL x'1906';
dcl-c WLI_USRPRF x'0801';
dcl-c WLI_USRIDX x'0E0A';
dcl-c WLI_USRQ x'0A02';
dcl-c WLI_USRSPC x'1934';
dcl-c WLI_VLDL x'0E10';
dcl-c WLI_WSCST x'1938';

//  Activate Bound Program, Returned value: Activation mark
dcl-pr QleActBndPgm int(10) extproc('QleActBndPgm');
  i_pgmPtr    pointer(*proc) const;
  i_actMark   int(10) options(*omit) const;
  i_actInf    char(32767) options(*omit: *varsize) const;
  i_actInfLen int(10) options(*omit) const;
  io_errCode  char(32767) options(*omit: *varsize);
end-pr;

//  Type definitions
dcl-ds actInf_t qualified template;
  bytRet     int(10);
  bytAvl     int(10);
  reserved_1 char(8);
  actGrpMark int(10);
  actMark    int(10);
  reserved_2 char(7);
  flags      char(1);
  reserved_3 char(16);
end-ds;

//  Get Export, Returned value: Exported item - PTR(OPN)
dcl-pr QleGetExp pointer extproc('QleGetExp');
  i_actMark    int(10) options(*omit) const;
  i_expNum     int(10) options(*omit) const;
  i_expNameLen int(10) options(*omit) const;
  i_expName    char(32767) options(*omit: *varsize) const;
  o_pExpItem   pointer(*proc) options(*omit);
  o_expItmType int(10) options(*omit);
  io_errCode   char(32767) options(*omit: *varsize);
end-pr;

//  Resolve System Pointer (RSLVSP)
dcl-pr rslvsp pointer(*proc) extproc('rslvsp');
  i_objtype uns(5) value;
  i_obj     pointer options(*string) value;
  i_lib     pointer options(*string) value;
  i_auth    uns(5) value;
end-pr;

// ------------------------------------
//  Type Definitions
// ------------------------------------

dcl-ds actSrvPgm_t qualified template;
  procptr pointer(*proc);
  actMark int(10);
  name    char(10);
  lib     char(10);
end-ds;

dcl-ds actProc_t qualified template;
  procptr pointer(*proc);
  actMark int(10);
  name    varchar(256);
  srvPgm  char(10);
  lib     char(10);
end-ds;

//  API error code
dcl-ds errCode_t qualified template;
  bytPrv     int(10);
  bytAvl     int(10);
  excID      char(7);
  reserved_1 char(1);
  excDta     char(256);
end-ds;

// ------------------------------------
//  Imported prototypes
// ------------------------------------

/copy QLOG4RPG,PLOG4RPG

// ------------------------------------
//  Exported prototypes
// ------------------------------------
/copy QLOG4RPG,PLOG4RPG00 Logger Stub

// ------------------------------------
//  Internal prototypes
// ------------------------------------
dcl-pr getProcPtrByName pointer(*proc);
  i_proc      char(256) const;
  i_actSrvPgm likeds(actSrvPgm_t) const;
end-pr;

dcl-pr activateSrvPgm likeds(actSrvPgm_t);
  i_srvPgm char(10) const;
  i_lib    char(10) options(*nopass: *omit) const;
end-pr;

dcl-pr setStubOfs extproc(g_procptr.setStubOfs);
  i_stubOfs int(3) const;
end-pr;

// ------------------------------------
//  Global fields & constants
// ------------------------------------

dcl-s g_isLoaded ind inz(*off);

dcl-ds g_procptr qualified;
  setStubOfs                          pointer(*proc);
  setLogging                          pointer(*proc);
  isLogging                           pointer(*proc);
  getRootLogger                       pointer(*proc);
  getLogger                           pointer(*proc);
  debug                               pointer(*proc);
  debugMsg                            pointer(*proc);
  isDebugEnabled                      pointer(*proc);
  info                                pointer(*proc);
  infoMsg                             pointer(*proc);
  isInfoEnabled                       pointer(*proc);
  warn                                pointer(*proc);
  warnMsg                             pointer(*proc);
  isWarnEnabled                       pointer(*proc);
  error                               pointer(*proc);
  errorMsg                            pointer(*proc);
  isErrorEnabled                      pointer(*proc);
  fatal                               pointer(*proc);
  fatalMsg                            pointer(*proc);
  isFatalEnabled                      pointer(*proc);
  forcedLog                           pointer(*proc);
  forcedLogMsg                        pointer(*proc);
  getName                             pointer(*proc);
  isNull                              pointer(*proc);
  null                                pointer(*proc);
  setLevel                            pointer(*proc);
  setInternalDebugging                pointer(*proc);
  getInternalDebugMode                pointer(*proc);
  getInternalDebugOutput              pointer(*proc);
  loadDefaultConfiguration            pointer(*proc);
  loadPropertiesConfiguration         pointer(*proc);
  loadAndWatchPropertiesConfiguration pointer(*proc);
  clearConfiguration                  pointer(*proc);
  Layout_new                          pointer(*proc);
  Layout_null                         pointer(*proc);
  Appender_new                        pointer(*proc);
  Appender_null                       pointer(*proc);
  Appender_setLayout                  pointer(*proc);
  Appender_setFilter                  pointer(*proc);
  Logger_addAppender                  pointer(*proc);
  Filter_new                          pointer(*proc);
  Filter_null                         pointer(*proc);
  Filter_setNext                      pointer(*proc);
end-ds;

//=========================================================================
//  Loads the LOG4RPG service program and forwards all requests to it.
//=========================================================================
dcl-proc LoggerStub_loadSrvPgm export;
  dcl-pi *n;
  end-pi;

  //  Helper fields
  dcl-s x int(10) inz;
  dcl-ds actSrvPgm likeds(actSrvPgm_t) static inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  for x = 1 to 2;
    if (actSrvPgm.procptr = *NULL);
      actSrvPgm = activateSrvPgm('LOG4RPG': '*LIBL');
      if (actSrvPgm.procptr <> *NULL);
        g_procptr.setStubOfs =
           getProcPtrByName(
              'LOG4RPG01_setStubOfs Internal Use Only'
              : actSrvPgm);
      else;
        return;
      endif;
    endif;

    monitor;
      setStubOfs(1);
      leave;
    on-error;
      actSrvPgm.procptr = *NULL;
    endmon;
  endfor;

  g_procptr.setLogging =
     getProcPtrByName('LOG4RPG01_Logger_setLogging' : actSrvPgm);
  g_procptr.isLogging  =
     getProcPtrByName('LOG4RPG01_Logger_isLogging'  : actSrvPgm);

  g_procptr.getRootLogger =
     getProcPtrByName('LOG4RPG01_Logger_getRootLogger': actSrvPgm);
  g_procptr.getLogger     =
     getProcPtrByName('LOG4RPG01_Logger_getLogger'    : actSrvPgm);

  g_procptr.debug    =
     getProcPtrByName('LOG4RPG01_Logger_debug'    : actSrvPgm);
  g_procptr.debugMsg =
     getProcPtrByName('LOG4RPG01_Logger_debugMsg' : actSrvPgm);
  g_procptr.isDebugEnabled =
     getProcPtrByName('LOG4RPG01_Logger_isDebugEnabled' : actSrvPgm);

  g_procptr.info     =
     getProcPtrByName('LOG4RPG01_Logger_info'     : actSrvPgm);
  g_procptr.infoMsg  =
     getProcPtrByName('LOG4RPG01_Logger_infoMsg'  : actSrvPgm);
  g_procptr.isInfoEnabled =
     getProcPtrByName('LOG4RPG01_Logger_isInfoEnabled' : actSrvPgm);

  g_procptr.warn     =
     getProcPtrByName('LOG4RPG01_Logger_warn'     : actSrvPgm);
  g_procptr.warnMsg  =
     getProcPtrByName('LOG4RPG01_Logger_warnMsg'  : actSrvPgm);
  g_procptr.isWarnEnabled =
     getProcPtrByName('LOG4RPG01_Logger_isWarnEnabled' : actSrvPgm);

  g_procptr.error    =
     getProcPtrByName('LOG4RPG01_Logger_error'    : actSrvPgm);
  g_procptr.errorMsg =
     getProcPtrByName('LOG4RPG01_Logger_errorMsg' : actSrvPgm);
  g_procptr.isErrorEnabled =
     getProcPtrByName('LOG4RPG01_Logger_isErrorEnabled' : actSrvPgm);

  g_procptr.fatal    =
     getProcPtrByName('LOG4RPG01_Logger_fatal'    : actSrvPgm);
  g_procptr.fatalMsg =
     getProcPtrByName('LOG4RPG01_Logger_fatalMsg' : actSrvPgm);
  g_procptr.isFatalEnabled =
     getProcPtrByName('LOG4RPG01_Logger_isFatalEnabled' : actSrvPgm);

  g_procptr.forcedLog    =
     getProcPtrByName('LOG4RPG01_Logger_forcedLog'    : actSrvPgm);
  g_procptr.forcedLogMsg =
     getProcPtrByName('LOG4RPG01_Logger_forcedLogMsg' : actSrvPgm);

  g_procptr.getName      =
     getProcPtrByName('LOG4RPG01_Logger_getName'      : actSrvPgm);

  g_procptr.isNull =
     getProcPtrByName('LOG4RPG01_Logger_isNull' : actSrvPgm);
  g_procptr.null   =
     getProcPtrByName('LOG4RPG01_Logger_null'   : actSrvPgm);

  g_procptr.setLevel =
     getProcPtrByName('LOG4RPG01_Logger_setLevel' : actSrvPgm);

  g_procptr.setInternalDebugging =
     getProcPtrByName(
        'LOG4RPG01_Logger_setInternalDebugging'
        : actSrvPgm);
  g_procptr.getInternalDebugMode =
     getProcPtrByName(
        'LOG4RPG01_Logger_getInternalDebugMode'
        : actSrvPgm);
  g_procptr.getInternalDebugOutput =
     getProcPtrByName(
        'LOG4RPG01_Logger_getInternalDebugOutput'
        : actSrvPgm);

  g_procptr.loadDefaultConfiguration =
     getProcPtrByName(
        'LOG4RPG08_Configurator_loadDefaultConfiguration'
        : actSrvPgm);
  g_procptr.loadPropertiesConfiguration =
     getProcPtrByName(
        'LOG4RPG08_Configurator_loadPropertiesConfiguration'
        : actSrvPgm);
  g_procptr.loadAndWatchPropertiesConfiguration =
     getProcPtrByName(
        'LOG4RPG08_Configurator_loadAndWatchPropertiesConfiguration'
        : actSrvPgm);
  g_procptr.clearConfiguration =
     getProcPtrByName(
        'LOG4RPG08_Configurator_clearConfiguration'
        : actSrvPgm);
  g_procptr.Layout_new =
     getProcPtrByName(
        'LOG4RPG11_Layout_new'
        : actSrvPgm);
  g_procptr.Layout_null =
     getProcPtrByName(
        'LOG4RPG11_Layout_null'
        : actSrvPgm);
  g_procptr.Appender_new =
     getProcPtrByName(
        'LOG4RPG03_Appender_new'
        : actSrvPgm);
  g_procptr.Appender_null =
     getProcPtrByName(
        'LOG4RPG03_Appender_null'
        : actSrvPgm);
  g_procptr.Appender_setLayout =
     getProcPtrByName(
        'LOG4RPG03_Appender_setLayout'
        : actSrvPgm);
  g_procptr.Appender_setFilter =
     getProcPtrByName(
        'LOG4RPG03_Appender_setFilter'
        : actSrvPgm);
  g_procptr.Logger_addAppender =
     getProcPtrByName(
        'LOG4RPG01_Logger_addAppender'
        : actSrvPgm);
  g_procptr.Filter_new =
     getProcPtrByName(
        'LOG4RPG17_Filter_new'
        : actSrvPgm);
  g_procptr.Filter_null =
     getProcPtrByName(
        'LOG4RPG17_Filter_null'
        : actSrvPgm);
  g_procptr.Filter_setNext =
     getProcPtrByName(
        'LOG4RPG17_Filter_setNext'
        : actSrvPgm);

  g_isLoaded = *on ;

  return;


end-proc;

//=========================================================================
//  Enables / Disables LOG4RPG.
//=========================================================================
dcl-proc Logger_setLogging export;
  dcl-pi *n ind;
    i_isLogging ind const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *off ;
  endif;

  return Impl_Logger_setLogging(i_isLogging);


end-proc;

//=========================================================================
//  Returns *on  if logging is enabled.
//=========================================================================
dcl-proc Logger_isLogging export;
  dcl-pi *n ind;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *off ;
  endif;

  return Impl_Logger_isLogging();


end-proc;

//=========================================================================
//  Returns the root logger.
//=========================================================================
dcl-proc Logger_getRootLogger export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *NULL;
  endif;

  return Impl_Logger_getRootLogger();


end-proc;

//=========================================================================
//  Returns a new logger named as the specified name.
//=========================================================================
dcl-proc Logger_getLogger export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
    i_logName like(LOG4RPG_loggerName_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *NULL;
  endif;

  return Impl_Logger_getLogger(i_logName);


end-proc;

//=========================================================================
//  Logs a DEBUG statement.
//=========================================================================
dcl-proc Logger_debug export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_text    like(LOG4RPG_text_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Logger_debug(i_hLogger: i_text);

  return;


end-proc;

//=========================================================================
//  Logs a DEBUG message.
//=========================================================================
dcl-proc Logger_debugMsg export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_msg     likeds(LOG4RPG_msg_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Logger_debugMsg(i_hLogger: i_msg);

  return;


end-proc;

//=========================================================================
//  Returns *on  if 'DEBUG' log events are logged.
//=========================================================================
dcl-proc Logger_isDebugEnabled export;
  dcl-pi *n ind;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *off ;
  endif;

  return Impl_Logger_isDebugEnabled(i_hLogger);


end-proc;

//=========================================================================
//  Logs an INFO statement.
//=========================================================================
dcl-proc Logger_info export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_text    like(LOG4RPG_text_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Logger_info(i_hLogger: i_text);

  return;


end-proc;

//=========================================================================
//  Logs an INFO message.
//=========================================================================
dcl-proc Logger_infoMsg export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_msg     likeds(LOG4RPG_msg_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Logger_infoMsg(i_hLogger: i_msg);

  return;


end-proc;

//=========================================================================
//  Returns *on  if 'INFO' log events are logged.
//  (Including DEBUG log events)
//=========================================================================
dcl-proc Logger_isInfoEnabled export;
  dcl-pi *n ind;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *off ;
  endif;

  return Impl_Logger_isInfoEnabled(i_hLogger);


end-proc;

//=========================================================================
//  Logs a WARN statement.
//=========================================================================
dcl-proc Logger_warn export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_text    like(LOG4RPG_text_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Logger_warn(i_hLogger: i_text);

  return;


end-proc;

//=========================================================================
//  Logs a WARN message.
//=========================================================================
dcl-proc Logger_warnMsg export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_msg     likeds(LOG4RPG_msg_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Logger_warnMsg(i_hLogger: i_msg);

  return;


end-proc;

//=========================================================================
//  Returns *on  if 'WARN' log events are logged.
//  (Including INFO and DEBUG log events)
//=========================================================================
dcl-proc Logger_isWarnEnabled export;
  dcl-pi *n ind;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *off ;
  endif;

  return Impl_Logger_isWarnEnabled(i_hLogger);


end-proc;

//=========================================================================
//  Logs an ERROR statement.
//=========================================================================
dcl-proc Logger_error export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_text    like(LOG4RPG_text_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Logger_error(i_hLogger: i_text);

  return;


end-proc;

//=========================================================================
//  Logs an ERROR message.
//=========================================================================
dcl-proc Logger_errorMsg export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_msg     likeds(LOG4RPG_msg_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Logger_errorMsg(i_hLogger: i_msg);

  return;


end-proc;

//=========================================================================
//  Returns *on  if 'ERROR' log events are logged.
//  (Including WARN, INFO and DEBUG log events)
//=========================================================================
dcl-proc Logger_isErrorEnabled export;
  dcl-pi *n ind;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *off ;
  endif;

  return Impl_Logger_isErrorEnabled(i_hLogger);


end-proc;

//=========================================================================
//  Logs a FATAL error statement.
//=========================================================================
dcl-proc Logger_fatal export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_text    like(LOG4RPG_text_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Logger_fatal(i_hLogger: i_text);

  return;


end-proc;

//=========================================================================
//  Logs a FATAL error message.
//=========================================================================
dcl-proc Logger_fatalMsg export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_msg     likeds(LOG4RPG_msg_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Logger_fatalMsg(i_hLogger: i_msg);

  return;


end-proc;

//=========================================================================
//  Returns *on  if 'FATAL' log events are logged.
//  (Including ERROR, WARN, INFO and DEBUG log events)
//=========================================================================
dcl-proc Logger_isFatalEnabled export;
  dcl-pi *n ind;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *off ;
  endif;

  return Impl_Logger_isFatalEnabled(i_hLogger);


end-proc;

//=========================================================================
//  Logs the specified statement without further checking.
//=========================================================================
dcl-proc Logger_forcedLog export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_level   like(LOG4RPG_level_t) const;
    i_text    like(LOG4RPG_text_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Logger_forcedLog(i_hLogger: i_level: i_text);

  return;


end-proc;

//=========================================================================
//  Logs the specified message without further checking.
//=========================================================================
dcl-proc Logger_forcedLogMsg export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_level   like(LOG4RPG_level_t) const;
    i_msg     likeds(LOG4RPG_msg_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Logger_forcedLogMsg(i_hLogger: i_level: i_msg);

  return;


end-proc;

//=========================================================================
//  Returns the name of the specified logger.          .
//=========================================================================
dcl-proc Logger_getName export;
  dcl-pi *n like(LOG4RPG_loggerName_t);
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return '';
  endif;

  return Impl_Logger_getName(i_hLogger);


end-proc;

//=========================================================================
//  Returns *on  if the specified logger handle is NULL.
//=========================================================================
dcl-proc Logger_isNull export;
  dcl-pi *n ind;
    i_hLogger like(LOG4RPG_hLogger_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *on ;
  endif;

  return Impl_Logger_isNull(i_hLogger);


end-proc;

//=========================================================================
//  Returns a NULL handle.
//=========================================================================
dcl-proc Logger_null export;
  dcl-pi *n like(LOG4RPG_hLogger_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *NULL;
  endif;

  return Impl_Logger_null();


end-proc;

//=========================================================================
//  Sets the logging level of the specified logger.
//=========================================================================
dcl-proc Logger_setLevel export;
  dcl-pi *n;
    i_hLogger like(LOG4RPG_hLogger_t) const;
    i_level   like(LOG4RPG_level_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Logger_setLevel(i_hLogger: i_level);

  return;


end-proc;

//=========================================================================
//  Allows to enable/disable log4rpg internal logging.
//=========================================================================
dcl-proc Logger_setInternalDebugging export;
  dcl-pi *n;
    i_debugMode like(LOG4RPG_debugMode_t) const;
    i_output    like(LOG4RPG_debugOutput_t) options(*nopass) const;
  end-pi;

  //  Parameter positions
  dcl-c p_output 2;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  if (%parms() >= p_output);
    Impl_Logger_setInternalDebugging(i_debugMode: i_output);
  else;
    Impl_Logger_setInternalDebugging(i_debugMode);
  endif;

  return;


end-proc;

//=========================================================================
//  Returns the internal debug mode.
//=========================================================================
dcl-proc Logger_getInternalDebugMode export;
  dcl-pi *n like(LOG4RPG_debugMode_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return '';
  endif;

  return Impl_Logger_getInternalDebugMode();


end-proc;

//=========================================================================
//  Returns the target for internal log events.
//=========================================================================
dcl-proc Logger_getInternalDebugOutput export;
  dcl-pi *n like(LOG4RPG_debugOutput_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return '';
  endif;

  return Impl_Logger_getInternalDebugOutput();


end-proc;

//=========================================================================
//  Configures LOG4RPG using a default configuration.
//=========================================================================
dcl-proc Configurator_loadDefaultConfiguration export;
  dcl-pi *n ind;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *off ;
  endif;

  return Impl_Configurator_loadDefaultConfiguration();


end-proc;

//=========================================================================
//  Configures LOG4RPG from a properties file.
//=========================================================================
dcl-proc Configurator_loadPropertiesConfiguration export;
  dcl-pi *n ind;
    i_path like(LOG4RPG_path_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *off ;
  endif;

  return Impl_Configurator_loadPropertiesConfiguration(i_path);


end-proc;

//=========================================================================
//  Configures LOG4RPG from a properties file. Watches the properties
//  file for changes and reloads the configuration on changes.
//=========================================================================
dcl-proc Configurator_loadAndWatchPropertiesConfiguration export;
  dcl-pi *n ind;
    i_path        like(LOG4RPG_path_t) const;
    i_waitMinutes int(10) options(*nopass) const;
    i_unit        char(10) options(*nopass) const;
  end-pi;

  //  Parameter positions
  dcl-c p_waitMinutes 2;
  dcl-c p_unit 3;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *off ;
  endif;

  select;
  when %parms() >= p_unit;         // 3 Parameters
    return Impl_Configurator_loadAndWatchPropertiesConfiguration(
                                         i_path: i_waitMinutes: i_unit);
  when %parms() >= p_waitMinutes;  // 2 parameters
    return Impl_Configurator_loadAndWatchPropertiesConfiguration(
                                         i_path: i_waitMinutes);
  other;
    return Impl_Configurator_loadAndWatchPropertiesConfiguration(
                                         i_path);
  endsl;


end-proc;

//=========================================================================
//  Clears all configuration data.
//=========================================================================
dcl-proc Configurator_clearConfiguration export;
  dcl-pi *n;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Configurator_clearConfiguration();

  return;


end-proc;

//=========================================================================
//  Creates a new layout.
//=========================================================================
dcl-proc Layout_new export;
  dcl-pi *n like(LOG4RPG_pLayout_t);
    i_layoutImpl  like(LOG4RPG_implClass_t) const;
    i_pPropString pointer options(*nopass: *omit: *string) const;
  end-pi;

  //  Parameter positions
  dcl-c p_pPropString 2;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *NULL;
  endif;

  if (%parms() >= p_pPropString);
    return Impl_Layout_new(i_layoutImpl: i_pPropString);
  else;
    return Impl_Layout_new(i_layoutImpl);
  endif;


end-proc;

//=========================================================================
//  Returns a NULL layout.
//=========================================================================
dcl-proc Layout_null export;
  dcl-pi *n like(LOG4RPG_pLayout_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *NULL;
  endif;

  return Impl_Layout_null();


end-proc;

//=========================================================================
//  Creates a new appender.
//=========================================================================
dcl-proc Appender_new export;
  dcl-pi *n like(LOG4RPG_pAppender_t);
    i_appName     like(LOG4RPG_appenderName_t) const;
    i_appImpl     like(LOG4RPG_implClass_t) const;
    i_pPropString pointer options(*nopass: *omit: *string) const;
  end-pi;

  //  Parameter positions
  dcl-c p_pPropString 3;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *NULL;
  endif;

  if (%parms() >= p_pPropString);
    return Impl_Appender_new(i_appName: i_appImpl: i_pPropString);
  else;
    return Impl_Appender_new(i_appName: i_appImpl);
  endif;


end-proc;

//=========================================================================
//  Returns a NULL appender.
//=========================================================================
dcl-proc Appender_null export;
  dcl-pi *n like(LOG4RPG_pAppender_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *NULL;
  endif;

  return Impl_Appender_null();


end-proc;

//=========================================================================
//  Sets the layout for the specified appender.
//=========================================================================
dcl-proc Appender_setLayout export;
  dcl-pi *n ind;
    i_pAppender like(LOG4RPG_pAppender_t) const;
    i_pLayout   like(LOG4RPG_pLayout_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *off ;
  endif;

  return Impl_Appender_setLayout(i_pAppender: i_pLayout);


end-proc;

//=========================================================================
//  Sets the filter for the specified appender.
//=========================================================================
dcl-proc Appender_setFilter export;
  dcl-pi *n ind;
    i_pAppender like(LOG4RPG_pAppender_t) const;
    i_pFilter   like(LOG4RPG_pFilter_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *off ;
  endif;

  return Impl_Appender_setFilter(i_pAppender: i_pFilter);


end-proc;

//=========================================================================
//  Sets the filter for the specified appender.
//=========================================================================
dcl-proc Logger_addAppender export;
  dcl-pi *n;
    i_hLogger   like(LOG4RPG_hLogger_t) const;
    i_hAppender like(LOG4RPG_pAppender_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Logger_addAppender(i_hLogger: i_hAppender);

  return;


end-proc;

//=========================================================================
//  Creates a new filter.
//=========================================================================
dcl-proc Filter_new export;
  dcl-pi *n like(LOG4RPG_pFilter_t);
    i_fltName     like(LOG4RPG_filterName_t) const;
    i_fltImpl     like(LOG4RPG_implClass_t) const;
    i_pPropString pointer options(*nopass: *omit: *string) const;
  end-pi;

  //  Parameter positions
  dcl-c p_pPropString 3;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *NULL;
  endif;

  if (%parms() >= p_pPropString);
    return Impl_Filter_new(i_fltName: i_fltImpl: i_pPropString);
  else;
    return Impl_Filter_new(i_fltName: i_fltImpl);
  endif;


end-proc;

//=========================================================================
//  Returns a NULL filter.
//=========================================================================
dcl-proc Filter_null export;
  dcl-pi *n like(LOG4RPG_pFilter_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return *NULL;
  endif;

  return Impl_Filter_null();


end-proc;

//=========================================================================
//  Sets the next filter of the filter chain.
//=========================================================================
dcl-proc Filter_setNext export;
  dcl-pi *n;
    i_pFilter     like(LOG4RPG_pFilter_t) const;
    i_pNextFilter like(LOG4RPG_pFilter_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (not g_isLoaded);
    return;
  endif;

  Impl_Filter_setNext(i_pFilter: i_pNextFilter);

  return;


end-proc;

//=========================================================================
//  *** private ***
//  Activates a service program.
//=========================================================================
//  Parameters:
//   i_srvPgm      - The name of the service program.
//   i_lib         - The library that contains the service program.
//                   Default:        *LIBL
//   o_msg         - The API error message.
//
//  Returns:
//   actSrvPgm     - Returns a structure that contains the
//                   system pointer to the service program and
//                   the activation mark.
//=========================================================================

dcl-proc activateSrvPgm export;
  dcl-pi *n likeds(actSrvPgm_t);
    i_srvPgm char(10) const;
    i_lib    char(10) options(*nopass: *omit) const;
  end-pi;

  //  Return value
  dcl-ds actSrvPgm likeds(actSrvPgm_t) inz;

  //  Parameter positions
  dcl-c p_lib 2;

  //  Optional parameter fields
  dcl-s lib like(i_lib) inz;

  //  Local fields
  dcl-s actMark like(actInf_t.actMark) inz;
  dcl-s pSrvPgm pointer(*proc) inz;
  dcl-ds actInf likeds(actInf_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Initialize return value
  clear actSrvPgm;

  // Process optional parameter values ...
  // ... i_lib
  if (%parms() >= p_lib and %addr(i_lib) <> *NULL);
    lib = i_lib;
  else;
    lib = '*LIBL';
  endif;

  // Get system pointer
  monitor;
    pSrvPgm = rslvsp(WLI_SRVPGM: i_srvPgm: lib: AUTH_OBJ_MGMT);
  on-error;
    pSrvPgm = *NULL;
  endmon;

  // Actiate service program
  if (pSrvPgm <> *NULL);
    clear errCode;
    errCode.bytPrv = %size(errCode);
    QleActBndPgm(pSrvPgm: actMark: actInf: %size(actInf): errCode);

    if (errCode.bytAvl <> 0);
      pSrvPgm = *NULL;
    endif;
  endif;

  if (pSrvPgm <> *NULL);
    actSrvPgm.procptr = pSrvPgm;
    actSrvPgm.actMark = actMark;
    actSrvPgm.name    = i_srvPgm;
    actSrvPgm.lib     = lib;
  endif;

  return actSrvPgm;


end-proc;

//=========================================================================
//  *** private ***
//  Gets a procedure pointer by name.
//=========================================================================
//  Parameters:
//   i_srvPgm      - The name of the service program.
//   i_lib         - The library that contains the service program.
//                   Default:        *LIBL
//   i_proc        - The name of the procedure.
//   o_msg         - The API error message.
//
//  Returns:
//   procptr       - Returns a pointer to the procedure on success
//                   else *NULL.
//=========================================================================

dcl-proc getProcPtrByName;
  dcl-pi *n pointer(*proc);
    i_proc      char(256) const;
    i_actSrvPgm likeds(actSrvPgm_t) const;
  end-pi;

  //  Return value
  dcl-ds actProc likeds(actProc_t) inz;

  //  Local fields
  dcl-s typeExpItem int(10) inz;
  dcl-s pExpItem pointer(*proc) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Initialize return value
  clear actProc;

  // Get procedure pointer by name
  clear errCode;
  errCode.bytPrv = %size(errCode);
  QleGetExp(i_actSrvPgm.actMark: *omit: %len(%trimR(i_proc))
            : %trimR(i_proc): pExpItem: typeExpItem: errCode);
  if (errCode.bytAvl <> 0);
    pExpItem = *NULL;
  endif;

  if (pExpItem <> *NULL);
    actproc.procptr = pExpItem;
    actproc.actMark = i_actSrvPgm.actMark;
    actproc.name    = i_proc;
    actproc.srvPgm  = i_actSrvPgm.name;
    actproc.lib     = i_actSrvPgm.lib;
  endif;

  return actproc.procptr;


end-proc;
