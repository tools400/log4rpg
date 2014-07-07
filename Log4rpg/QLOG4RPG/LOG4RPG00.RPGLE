      *=====================================================================*
      *  SrvPgm: LOG4RPG - Stub                                             *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  08.02.2008                                              *
      *  E-mail  :  thomas.raddatz@tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  13.06.2008  Th.Raddatz    Enhanced the Log4rpg stub module         *
      *                            to optionally load the Log4rpg service   *
      *                            program and forward procedure calls      *
      *                            to it.                                   *
      *                                                                     *
      *  15.09.2008  Th.Raddatz    Added procedures:                        *
      *                               Layout_new()                          *
      *                               Layout_null()                         *
      *                               Appender_new()                        *
      *                               Appender_null()                       *
      *                               Appender_setLayout()                  *
      *                               Appender_setFilter()                  *
      *                               Logger_addAppender()                  *
      *                               Filter_new()                          *
      *                               Filter_null()                         *
      *                               Filter_setNext()                      *
      *                                                                     *
      *  24.03.2009  Th.Raddatz    Removed dependency to BASICS1.           *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD   MODULE(&LI/&OB) +                       *
      *                             SRCFILE(&SL/&SF) +                      *
      *                             SRCMBR(&SM);                            *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< TGTRLS(V6R1M0  );                                    *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
 CPY H NOMAIN
      /UNDEFINE NO_DECEDIT
      /COPY QLOG4RPG,COPYRIGHT
      *=====================================================================*
      *
      * ------------------------------------
      *  MI procedures
      * ------------------------------------
      *
      *  QSYSINC/MIH.MICOMMON: Requested Authority bitmasks and typedef
      *                        The bitmasks are or'd together to give
      *                        desired combinations
     D AUTH_OBJ_CTRL   C                   const(x'8000')
     D AUTH_OBJ_MGMT   C                   const(x'4000')
     D AUTH_POINTER    C                   const(x'2000')
     D AUTH_SPACE      C                   const(x'1000')
     D AUTH_RETRIEVE   C                   const(x'0800')
     D AUTH_INSERT     C                   const(x'0400')
     D AUTH_DELETE     C                   const(x'0200')
     D AUTH_UPDATE     C                   const(x'0100')
     D AUTH_OWNER      C                   const(x'0080')
     D AUTH_EXCLUDED   C                   const(x'0040')
     D AUTH_LST_MGMT   C                   const(x'0020')
     D AUTH_EXECUTE    C                   const(x'0010')
     D AUTH_ALTER      C                   const(x'0008')
     D AUTH_REF        C                   const(x'0004')
     D AUTH_ALL        C                   const(x'FF1C')
     D AUTH_NONE       C                   const(x'0000')
      *
      *  QSYSINC/MIH.MIOBJTYP:  MI Object Type
     D MI_Program      C                   const(x'0201')
     D MI_Library      C                   const(x'0401')
     D MI_Usrspc       C                   const(x'1934')
     D MI_Usrq         C                   const(x'0A02')
     D MI_Usridx       C                   const(x'0E0A')
     D WLI_ALRTBL      C                   const(x'0E09')
     D WLI_AUTL        C                   const(x'1B01')
     D WLI_BLKSF       C                   const(x'1E05')
     D WLI_BNDDIR      C                   const(x'1937')
     D WLI_CFGL        C                   const(x'0E0D')
     D WLI_CHTFMT      C                   const(x'190D')
     D WLI_CLD         C                   const(x'190B')
     D WLI_CLS         C                   const(x'1904')
     D WLI_CMD         C                   const(x'1905')
     D WLI_CNNL        C                   const(x'1701')
     D WLI_COSD        C                   const(x'1401')
     D WLI_CRG         C                   const(x'192C')
     D WLI_CRQD        C                   const(x'0E0F')
     D WLI_CSI         C                   const(x'1935')
     D WLI_CSPMAP      C                   const(x'1922')
     D WLI_CSPTBL      C                   const(x'1923')
     D WLI_CTLD        C                   const(x'1201')
     D WLI_DDIR        C                   const(x'1F02')
     D WLI_DEVD        C                   const(x'1001')
     D WLI_DIR         C                   const(x'0C01')
     D WLI_DOC         C                   const(x'190E')
     D WLI_DSTMF       C                   const(x'1F01')
     D WLI_DTAARA      C                   const(x'190A')
     D WLI_DTADCT      C                   const(x'1920')
     D WLI_DTAQ        C                   const(x'0A01')
     D WLI_EDTD        C                   const(x'1908')
     D WLI_EXITRG      C                   const(x'1913')
     D WLI_FCT         C                   const(x'0E04')
     D WLI_FILE        C                   const(x'1901')
     D WLI_FLR         C                   const(x'1912')
     D WLI_FNTRSC      C                   const(x'1926')
     D WLI_FNTTBL      C                   const(x'192B')
     D WLI_FORMDF      C                   const(x'1928')
     D WLI_FTR         C                   const(x'0E0B')
     D WLI_GSS         C                   const(x'190C')
     D WLI_IGCDCT      C                   const(x'0E06')
     D WLI_IGCSRT      C                   const(x'191A')
     D WLI_IGCTBL      C                   const(x'1910')
     D WLI_IPXD        C                   const(x'191E')
     D WLI_JOBD        C                   const(x'1903')
     D WLI_JOBQ        C                   const(x'0E01')
     D WLI_JOBSCD      C                   const(x'0E0C')
     D WLI_JRN         C                   const(x'0901')
     D WLI_JRNRCV      C                   const(x'0701')
     D WLI_LIB         C                   const(x'0401')
     D WLI_LIND        C                   const(x'1101')
     D WLI_LOCALE      C                   const(x'1921')
     D WLI_MEDDFN      C                   const(x'191C')
     D WLI_MENU        C                   const(x'1916')
     D WLI_MGTCOL      C                   const(x'192D')
     D WLI_MODD        C                   const(x'1501')
     D WLI_MODULE      C                   const(x'0301')
     D WLI_MSGF        C                   const(x'0E03')
     D WLI_MSGQ        C                   const(x'1902')
     D WLI_M36         C                   const(x'1E04')
     D WLI_M36CFG      C                   const(x'1924')
     D WLI_NODL        C                   const(x'0E0E')
     D WLI_NTBD        C                   const(x'1914')
     D WLI_NWID        C                   const(x'1601')
     D WLI_NWSD        C                   const(x'1D01')
     D WLI_NODGRP      C                   const(x'192A')
     D WLI_OOPOOL      C                   const(x'2002')
     D WLI_OUTQ        C                   const(x'0E02')
     D WLI_OVL         C                   const(x'1929')
     D WLI_PAGDFN      C                   const(x'1936')
     D WLI_PAGSEG      C                   const(x'1927')
     D WLI_PDG         C                   const(x'1930')
     D WLI_PGM         C                   const(x'0201')
     D WLI_PNLGRP      C                   const(x'1915')
     D WLI_PRDAVL      C                   const(x'1933')
     D WLI_PRDDFN      C                   const(x'191B')
     D WLI_PRDLOD      C                   const(x'191D')
     D WLI_PSFCFG      C                   const(x'1925')
     D WLI_QMFORM      C                   const(x'1932')
     D WLI_QMQRY       C                   const(x'1931')
     D WLI_QRYDFN      C                   const(x'1911')
     D WLI_RCT         C                   const(x'0E08')
     D WLI_S36         C                   const(x'1919')
     D WLI_SBSD        C                   const(x'1909')
     D WLI_SCHIDX      C                   const(x'0E07')
     D WLI_SOCKET      C                   const(x'1E03')
     D WLI_SOMOBJ      C                   const(x'2001')
     D WLI_SPADCT      C                   const(x'1C01')
     D WLI_SQLPKG      C                   const(x'0202')
     D WLI_SQLUDT      C                   const(x'191F')
     D WLI_SRVPGM      C                   const(x'0203')
     D WLI_SSND        C                   const(x'0E05')
     D WLI_STMF        C                   const(x'1E01')
     D WLI_SVRSTG      C                   const(x'1917')
     D WLI_SYMLNK      C                   const(x'1E02')
     D WLI_TBL         C                   const(x'1906')
     D WLI_USRPRF      C                   const(x'0801')
     D WLI_USRIDX      C                   const(x'0E0A')
     D WLI_USRQ        C                   const(x'0A02')
     D WLI_USRSPC      C                   const(x'1934')
     D WLI_VLDL        C                   const(x'0E10')
     D WLI_WSCST       C                   const(x'1938')
      *
      *  Activate Bound Program, Returned value: Activation mark
     D QleActBndPgm    PR            10I 0 extproc('QleActBndPgm')
     D  i_pgmPtr                       *   const   procptr
     D  i_actMark                    10I 0 const   options(*omit)
     D  i_actInf                  32767A   const   options(*omit: *varsize)
     D  i_actInfLen                  10I 0 const   options(*omit)
     D  io_errCode                32767A           options(*omit: *varsize)
      *
      *  Type definitions
     D actInf_t        DS                  qualified      based(pDummy)
     D  bytRet                 1      4I 0
     D  bytAvl                 5      8I 0
     D  reserved_1             9     16A
     D  actGrpMark            17     20I 0
     D  actMark               21     24I 0
     D  reserved_2            25     31A
     D  flags                 32     32A
     D  reserved_3            33     48A
      *
      *  Get Export, Returned value: Exported item - PTR(OPN)
     D QleGetExp       PR              *   extproc('QleGetExp')
     D  i_actMark                    10I 0 const   options(*omit)
     D  i_expNum                     10I 0 const   options(*omit)
     D  i_expNameLen                 10I 0 const   options(*omit)
     D  i_expName                 32767A   const   options(*omit: *varsize)
     D  o_pExpItem                     *           options(*omit) procptr
     D  o_expItmType                 10I 0         options(*omit)
     D  io_errCode                32767A           options(*omit: *varsize)
      *
      *  Resolve System Pointer (RSLVSP)
     D rslvsp...
     D                 PR              *   extproc('rslvsp') procptr
     D  i_objtype                     5U 0 value
     D  i_obj                          *   value   options(*string)
     D  i_lib                          *   value   options(*string)
     D  i_auth                        5U 0 value
      *
      * ------------------------------------
      *  Type Definitions
      * ------------------------------------
      *
     D actSrvPgm_t     DS                  qualified      based(pDummy)
     D  procptr                        *   procptr
     D  actMark                      10I 0
     D  name                         10A
     D  lib                          10A
      *
     D actProc_t       DS                  qualified      based(pDummy)
     D  procptr                        *   procptr
     D  actMark                      10I 0
     D  name                        256A   varying
     D  srvPgm                       10A
     D  lib                          10A
      *
     D errCode_t       DS                  qualified           based(pDummy)
     D  bytPrv                       10I 0
     D  bytAvl                       10I 0
     D  excID                         7A
     D  reserved_1                    1A
     D  excDta                      256A
      *
      * ------------------------------------
      *  Imported prototypes
      * ------------------------------------
      /DEFINE LOGGER_STUB
      /COPY QLOG4RPG,PLOG4RPG
      *
      /UNDEFINE PLOG4RPG
      /UNDEFINE LOGGER_STUB
      /COPY QLOG4RPG,PLOG4RPG
      *
      * ------------------------------------
      *  Exported prototypes
      * ------------------------------------
      /DEFINE LOGGER_STUB
      /COPY QLOG4RPG,PLOG4RPG00                    Logger Stub
      *
      * ------------------------------------
      *  Internal prototypes
      * ------------------------------------
     D getProcPtrByName...
     D                 PR              *   procptr
     D  i_proc                      256A   const
     D  i_actSrvPgm                        const  likeds(actSrvPgm_t)
      *
     D activateSrvPgm...
     D                 PR                         likeds(actSrvPgm_t )
     D  i_srvPgm                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
      *
     D setStubOfs...
     D                 PR
     D                                     extproc(
     D                                     g_procptr.setStubOfs
     D                                     )
     D  i_stubOfs                     3I 0 const
      *
      * ------------------------------------
      *  Global fields & constants
      * ------------------------------------
      *
     D g_isLoaded      S               N   inz(cFalse)
      *
     D g_procptr       DS                  qualified
     D  setStubOfs                     *   procptr
     D  setLogging                     *   procptr
     D  isLogging                      *   procptr
     D  getRootLogger                  *   procptr
     D  getLogger                      *   procptr
     D  debug                          *   procptr
     D  debugMsg                       *   procptr
     D  isDebugEnabled...
     D                                 *   procptr
     D  info                           *   procptr
     D  infoMsg                        *   procptr
     D  isInfoEnabled                  *   procptr
     D  warn                           *   procptr
     D  warnMsg                        *   procptr
     D  isWarnEnabled                  *   procptr
     D  error                          *   procptr
     D  errorMsg                       *   procptr
     D  isErrorEnabled...
     D                                 *   procptr
     D  fatal                          *   procptr
     D  fatalMsg                       *   procptr
     D  isFatalEnabled...
     D                                 *   procptr
     D  forcedLog                      *   procptr
     D  forcedLogMsg                   *   procptr
     D  getName                        *   procptr
     D  isNull                         *   procptr
     D  null                           *   procptr
     D  setLevel                       *   procptr
     D  setInternalDebugging...
     D                                 *   procptr
     D  getInternalDebugMode...
     D                                 *   procptr
     D  getInternalDebugOutput...
     D                                 *   procptr
     D  loadDefaultConfiguration...
     D                                 *   procptr
     D  loadPropertiesConfiguration...
     D                                 *   procptr
     D  loadAndWatchPropertiesConfiguration...
     D                                 *   procptr
     D  clearConfiguration...
     D                                 *   procptr
     D  Layout_new...
     D                                 *   procptr
     D  Layout_null...
     D                                 *   procptr
     D  Appender_new...
     D                                 *   procptr
     D  Appender_null...
     D                                 *   procptr
     D  Appender_setLayout...
     D                                 *   procptr
     D  Appender_setFilter...
     D                                 *   procptr
     D  Logger_addAppender...
     D                                 *   procptr
     D  Filter_new...
     D                                 *   procptr
     D  Filter_null...
     D                                 *   procptr
     D  Filter_setNext...
     D                                 *   procptr
      *
      *=========================================================================
      *  Loads the LOG4RPG service program and forwards all requests to it.
      *=========================================================================
     P LoggerStub_loadSrvPgm...
     P                 B                   export
      *
     D LoggerStub_loadSrvPgm...
     D                 PI
      *
      *  Helper fields
     D x               S             10I 0 inz
     D actSrvPgm       DS                  likeds(actSrvPgm_t ) static inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
         g_isLoaded = cTrue;
 
         return;
 
      /END-FREE
      *
     P LoggerStub_loadSrvPgm...
     P                 E
      *
      *=========================================================================
      *  Enables / Disables LOG4RPG.
      *=========================================================================
     P Logger_setLogging...
     P                 B                   export
      *
     D Logger_setLogging...
     D                 PI              N
     D  i_isLogging                    N   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return cFalse;
         endif;
 
         return Impl_Logger_setLogging(i_isLogging);
 
      /END-FREE
      *
     P Logger_setLogging...
     P                 E
      *
      *=========================================================================
      *  Returns cTRUE if logging is enabled.
      *=========================================================================
     P Logger_isLogging...
     P                 B                   export
      *
     D Logger_isLogging...
     D                 PI              N
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return cFalse;
         endif;
 
         return Impl_Logger_isLogging();
 
      /END-FREE
      *
     P Logger_isLogging...
     P                 E
      *
      *=========================================================================
      *  Returns the root logger.
      *=========================================================================
     P Logger_getRootLogger...
     P                 B                   export
      *
     D Logger_getRootLogger...
     D                 PI                         like(LOG4RPG_hLogger_t   )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return *NULL;
         endif;
 
         return Impl_Logger_getRootLogger();
 
      /END-FREE
      *
     P Logger_getRootLogger...
     P                 E
      *
      *=========================================================================
      *  Returns a new logger named as the specified name.
      *=========================================================================
     P Logger_getLogger...
     P                 B                   export
      *
     D Logger_getLogger...
     D                 PI                         like(LOG4RPG_hLogger_t   )
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return *NULL;
         endif;
 
         return Impl_Logger_getLogger(i_logName);
 
      /END-FREE
      *
     P Logger_getLogger...
     P                 E
      *
      *=========================================================================
      *  Logs a DEBUG statement.
      *=========================================================================
     P Logger_debug...
     P                 B                   export
      *
     D Logger_debug...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_text                             const  like(LOG4RPG_text_t    )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Logger_debug(i_hLogger: i_text);
 
         return;
 
      /END-FREE
      *
     P Logger_debug...
     P                 E
      *
      *=========================================================================
      *  Logs a DEBUG message.
      *=========================================================================
     P Logger_debugMsg...
     P                 B                   export
      *
     D Logger_debugMsg...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Logger_debugMsg(i_hLogger: i_msg);
 
         return;
 
      /END-FREE
      *
     P Logger_debugMsg...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if 'DEBUG' log events are logged.
      *=========================================================================
     P Logger_isDebugEnabled...
     P                 B                   export
      *
     D Logger_isDebugEnabled...
     D                 PI              N
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return cFalse;
         endif;
 
         return Impl_Logger_isDebugEnabled(i_hLogger);
 
      /END-FREE
      *
     P Logger_isDebugEnabled...
     P                 E
      *
      *=========================================================================
      *  Logs an INFO statement.
      *=========================================================================
     P Logger_info...
     P                 B                   export
      *
     D Logger_info...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_text                             const  like(LOG4RPG_text_t    )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Logger_info(i_hLogger: i_text);
 
         return;
 
      /END-FREE
      *
     P Logger_info...
     P                 E
      *
      *=========================================================================
      *  Logs an INFO message.
      *=========================================================================
     P Logger_infoMsg...
     P                 B                   export
      *
     D Logger_infoMsg...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Logger_infoMsg(i_hLogger: i_msg);
 
         return;
 
      /END-FREE
      *
     P Logger_infoMsg...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if 'INFO' log events are logged.
      *  (Including DEBUG log events)
      *=========================================================================
     P Logger_isInfoEnabled...
     P                 B                   export
      *
     D Logger_isInfoEnabled...
     D                 PI              N
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return cFalse;
         endif;
 
         return Impl_Logger_isInfoEnabled(i_hLogger);
 
      /END-FREE
      *
     P Logger_isInfoEnabled...
     P                 E
      *
      *=========================================================================
      *  Logs a WARN statement.
      *=========================================================================
     P Logger_warn...
     P                 B                   export
      *
     D Logger_warn...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_text                             const  like(LOG4RPG_text_t    )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Logger_warn(i_hLogger: i_text);
 
         return;
 
      /END-FREE
      *
     P Logger_warn...
     P                 E
      *
      *=========================================================================
      *  Logs a WARN message.
      *=========================================================================
     P Logger_warnMsg...
     P                 B                   export
      *
     D Logger_warnMsg...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Logger_warnMsg(i_hLogger: i_msg);
 
         return;
 
      /END-FREE
      *
     P Logger_warnMsg...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if 'WARN' log events are logged.
      *  (Including INFO and DEBUG log events)
      *=========================================================================
     P Logger_isWarnEnabled...
     P                 B                   export
      *
     D Logger_isWarnEnabled...
     D                 PI              N
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return cFalse;
         endif;
 
         return Impl_Logger_isWarnEnabled(i_hLogger);
 
      /END-FREE
      *
     P Logger_isWarnEnabled...
     P                 E
      *
      *=========================================================================
      *  Logs an ERROR statement.
      *=========================================================================
     P Logger_error...
     P                 B                   export
      *
     D Logger_error...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_text                             const  like(LOG4RPG_text_t    )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Logger_error(i_hLogger: i_text);
 
         return;
 
      /END-FREE
      *
     P Logger_error...
     P                 E
      *
      *=========================================================================
      *  Logs an ERROR message.
      *=========================================================================
     P Logger_errorMsg...
     P                 B                   export
      *
     D Logger_errorMsg...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Logger_errorMsg(i_hLogger: i_msg);
 
         return;
 
      /END-FREE
      *
     P Logger_errorMsg...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if 'ERROR' log events are logged.
      *  (Including WARN, INFO and DEBUG log events)
      *=========================================================================
     P Logger_isErrorEnabled...
     P                 B                   export
      *
     D Logger_isErrorEnabled...
     D                 PI              N
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return cFalse;
         endif;
 
         return Impl_Logger_isErrorEnabled(i_hLogger);
 
      /END-FREE
      *
     P Logger_isErrorEnabled...
     P                 E
      *
      *=========================================================================
      *  Logs a FATAL error statement.
      *=========================================================================
     P Logger_fatal...
     P                 B                   export
      *
     D Logger_fatal...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_text                             const  like(LOG4RPG_text_t    )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Logger_fatal(i_hLogger: i_text);
 
         return;
 
      /END-FREE
      *
     P Logger_fatal...
     P                 E
      *
      *=========================================================================
      *  Logs a FATAL error message.
      *=========================================================================
     P Logger_fatalMsg...
     P                 B                   export
      *
     D Logger_fatalMsg...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Logger_fatalMsg(i_hLogger: i_msg);
 
         return;
 
      /END-FREE
      *
     P Logger_fatalMsg...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if 'FATAL' log events are logged.
      *  (Including ERROR, WARN, INFO and DEBUG log events)
      *=========================================================================
     P Logger_isFatalEnabled...
     P                 B                   export
      *
     D Logger_isFatalEnabled...
     D                 PI              N
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return cFalse;
         endif;
 
         return Impl_Logger_isFatalEnabled(i_hLogger);
 
      /END-FREE
      *
     P Logger_isFatalEnabled...
     P                 E
      *
      *=========================================================================
      *  Logs the specified statement without further checking.
      *=========================================================================
     P Logger_forcedLog...
     P                 B                   export
      *
     D Logger_forcedLog...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_level                            const  like(LOG4RPG_level_t   )
     D  i_text                             const  like(LOG4RPG_text_t    )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Logger_forcedLog(i_hLogger: i_level: i_text);
 
         return;
 
      /END-FREE
      *
     P Logger_forcedLog...
     P                 E
      *
      *=========================================================================
      *  Logs the specified message without further checking.
      *=========================================================================
     P Logger_forcedLogMsg...
     P                 B                   export
      *
     D Logger_forcedLogMsg...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_level                            const  like(LOG4RPG_level_t   )
     D  i_msg                              const  likeds(LOG4RPG_msg_t   )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Logger_forcedLogMsg(i_hLogger: i_level: i_msg);
 
         return;
 
      /END-FREE
      *
     P Logger_forcedLogMsg...
     P                 E
      *
      *=========================================================================
      *  Returns the name of the specified logger.          .
      *=========================================================================
     P Logger_getName...
     P                 B                   export
      *
     D Logger_getName...
     D                 PI                         like(LOG4RPG_loggerName_t)
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t   )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return '';
         endif;
 
         return Impl_Logger_getName(i_hLogger);
 
      /END-FREE
      *
     P Logger_getName...
     P                 E
      *
      *=========================================================================
      *  Returns cTRUE if the specified logger handle is NULL.
      *=========================================================================
     P Logger_isNull...
     P                 B                   export
      *
     D Logger_isNull...
     D                 PI              N
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return cTrue;
         endif;
 
         return Impl_Logger_isNull(i_hLogger);
 
      /END-FREE
      *
     P Logger_isNull...
     P                 E
      *
      *=========================================================================
      *  Returns a NULL handle.
      *=========================================================================
     P Logger_null...
     P                 B                   export
      *
     D Logger_null...
     D                 PI                         like(LOG4RPG_hLogger_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return *NULL;
         endif;
 
         return Impl_Logger_null();
 
      /END-FREE
      *
     P Logger_null...
     P                 E
      *
      *=========================================================================
      *  Sets the logging level of the specified logger.
      *=========================================================================
     P Logger_setLevel...
     P                 B                   export
      *
     D Logger_setLevel...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t )
     D  i_level                            const  like(LOG4RPG_level_t   )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Logger_setLevel(i_hLogger: i_level);
 
         return;
 
      /END-FREE
      *
     P Logger_setLevel...
     P                 E
      *
      *=========================================================================
      *  Allows to enable/disable log4rpg internal logging.
      *=========================================================================
     P Logger_setInternalDebugging...
     P                 B                   export
      *
     D Logger_setInternalDebugging...
     D                 PI
     D  i_debugMode                        const  like(LOG4RPG_debugMode_t  )
     D  i_output                           const  like(LOG4RPG_debugOutput_t)
     D                                            options(*nopass)
      *
      *  Parameter positions
     D p_output        C                   2
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         if (%parms() >= p_output);
            Impl_Logger_setInternalDebugging(i_debugMode: i_output);
         else;
            Impl_Logger_setInternalDebugging(i_debugMode);
         endif;
 
         return;
 
      /END-FREE
      *
     P Logger_setInternalDebugging...
     P                 E
      *
      *=========================================================================
      *  Returns the internal debug mode.
      *=========================================================================
     P Logger_getInternalDebugMode...
     P                 B                   export
      *
     D Logger_getInternalDebugMode...
     D                 PI                         like(LOG4RPG_debugMode_t  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return '';
         endif;
 
         return Impl_Logger_getInternalDebugMode();
 
      /END-FREE
      *
     P Logger_getInternalDebugMode...
     P                 E
      *
      *=========================================================================
      *  Returns the target for internal log events.
      *=========================================================================
     P Logger_getInternalDebugOutput...
     P                 B                   export
      *
     D Logger_getInternalDebugOutput...
     D                 PI                         like(LOG4RPG_debugOutput_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return '';
         endif;
 
         return Impl_Logger_getInternalDebugOutput();
 
      /END-FREE
      *
     P Logger_getInternalDebugOutput...
     P                 E
      *
      *=========================================================================
      *  Configures LOG4RPG using a default configuration.
      *=========================================================================
     P Configurator_loadDefaultConfiguration...
     P                 B                   export
      *
     D Configurator_loadDefaultConfiguration...
     D                 PI              N
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return cFalse;
         endif;
 
         return Impl_Configurator_loadDefaultConfiguration();
 
      /END-FREE
      *
     P Configurator_loadDefaultConfiguration...
     P                 E
      *
      *=========================================================================
      *  Configures LOG4RPG from a properties file.
      *=========================================================================
     P Configurator_loadPropertiesConfiguration...
     P                 B                   export
      *
     D Configurator_loadPropertiesConfiguration...
     D                 PI              N
     D  i_path                             const  like(LOG4RPG_path_t   )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return cFalse;
         endif;
 
         return Impl_Configurator_loadPropertiesConfiguration(i_path);
 
      /END-FREE
      *
     P Configurator_loadPropertiesConfiguration...
     P                 E
      *
      *=========================================================================
      *  Configures LOG4RPG from a properties file. Watches the properties
      *  file for changes and reloads the configuration on changes.
      *=========================================================================
     P Configurator_loadAndWatchPropertiesConfiguration...
     P                 B                   export
      *
     D Configurator_loadAndWatchPropertiesConfiguration...
     D                 PI              N
     D  i_path                             const  like(LOG4RPG_path_t   )
     D  i_waitMinutes                10I 0 const  options(*nopass)
     D  i_unit                       10A   const  options(*nopass)
      *
      *  Parameter positions
     D p_waitMinutes   C                   2
     D p_unit          C                   3
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return cFalse;
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
 
      /END-FREE
      *
     P Configurator_loadAndWatchPropertiesConfiguration...
     P                 E
      *
      *=========================================================================
      *  Clears all configuration data.
      *=========================================================================
     P Configurator_clearConfiguration...
     P                 B                   export
      *
     D Configurator_clearConfiguration...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Configurator_clearConfiguration();
 
         return;
 
      /END-FREE
      *
     P Configurator_clearConfiguration...
     P                 E
      *
      *=========================================================================
      *  Creates a new layout.
      *=========================================================================
     P Layout_new...
     P                 B                   export
      *
     D Layout_new...
     D                 PI                         like(LOG4RPG_pLayout_t       )
     D  i_layoutImpl                       const  like(LOG4RPG_implClass_t     )
     D  i_pPropString                  *   const  options(*nopass:
     D                                                    *omit  : *string)
      *
      *  Parameter positions
     D p_pPropString   C                   2
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return *NULL;
         endif;
 
         if (%parms() >= p_pPropString);
            return Impl_Layout_new(i_layoutImpl: i_pPropString);
         else;
            return Impl_Layout_new(i_layoutImpl);
         endif;
 
      /END-FREE
      *
     P Layout_new...
     P                 E
      *
      *=========================================================================
      *  Returns a NULL layout.
      *=========================================================================
     P Layout_null...
     P                 B                   export
      *
     D Layout_null...
     D                 PI                         like(LOG4RPG_pLayout_t       )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return *NULL;
         endif;
 
         return Impl_Layout_null();
 
      /END-FREE
      *
     P Layout_null...
     P                 E
      *
      *=========================================================================
      *  Creates a new appender.
      *=========================================================================
     P Appender_new...
     P                 B                   export
      *
     D Appender_new...
     D                 PI                         like(LOG4RPG_pAppender_t     )
     D  i_appName                          const  like(LOG4RPG_appenderName_t  )
     D  i_appImpl                          const  like(LOG4RPG_implClass_t     )
     D  i_pPropString                  *   const  options(*nopass:
     D                                                    *omit  : *string)
      *
      *  Parameter positions
     D p_pPropString   C                   3
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return *NULL;
         endif;
 
         if (%parms() >= p_pPropString);
            return Impl_Appender_new(i_appName: i_appImpl: i_pPropString);
         else;
            return Impl_Appender_new(i_appName: i_appImpl);
         endif;
 
      /END-FREE
      *
     P Appender_new...
     P                 E
      *
      *=========================================================================
      *  Returns a NULL appender.
      *=========================================================================
     P Appender_null...
     P                 B                   export
      *
     D Appender_null...
     D                 PI                         like(LOG4RPG_pAppender_t     )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return *NULL;
         endif;
 
         return Impl_Appender_null();
 
      /END-FREE
      *
     P Appender_null...
     P                 E
      *
      *=========================================================================
      *  Sets the layout for the specified appender.
      *=========================================================================
     P Appender_setLayout...
     P                 B                   export
      *
     D Appender_setLayout...
     D                 PI              N
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
     D  i_pLayout                          const  like(LOG4RPG_pLayout_t       )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return cFalse;
         endif;
 
         return Impl_Appender_setLayout(i_pAppender: i_pLayout);
 
      /END-FREE
      *
     P Appender_setLayout...
     P                 E
      *
      *=========================================================================
      *  Sets the filter for the specified appender.
      *=========================================================================
     P Appender_setFilter...
     P                 B                   export
      *
     D Appender_setFilter...
     D                 PI              N
     D  i_pAppender                        const  like(LOG4RPG_pAppender_t     )
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t       )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return cFalse;
         endif;
 
         return Impl_Appender_setFilter(i_pAppender: i_pFilter);
 
      /END-FREE
      *
     P Appender_setFilter...
     P                 E
      *
      *=========================================================================
      *  Sets the filter for the specified appender.
      *=========================================================================
     P Logger_addAppender...
     P                 B                   export
      *
     D Logger_addAppender...
     D                 PI
     D  i_hLogger                          const  like(LOG4RPG_hLogger_t       )
     D  i_hAppender                        const  like(LOG4RPG_pAppender_t     )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Logger_addAppender(i_hLogger: i_hAppender);
 
         return;
 
      /END-FREE
      *
     P Logger_addAppender...
     P                 E
      *
      *=========================================================================
      *  Creates a new filter.
      *=========================================================================
     P Filter_new...
     P                 B                   export
      *
     D Filter_new...
     D                 PI                         like(LOG4RPG_pFilter_t       )
     D  i_fltName                          const  like(LOG4RPG_filterName_t    )
     D  i_fltImpl                          const  like(LOG4RPG_implClass_t     )
     D  i_pPropString                  *   const  options(*nopass:
     D                                                    *omit  : *string)
      *
      *  Parameter positions
     D p_pPropString   C                   3
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return *NULL;
         endif;
 
         if (%parms() >= p_pPropString);
            return Impl_Filter_new(i_fltName: i_fltImpl: i_pPropString);
         else;
            return Impl_Filter_new(i_fltName: i_fltImpl);
         endif;
 
      /END-FREE
      *
     P Filter_new...
     P                 E
      *
      *=========================================================================
      *  Returns a NULL filter.
      *=========================================================================
     P Filter_null...
     P                 B                   export
      *
     D Filter_null...
     D                 PI                         like(LOG4RPG_pFilter_t       )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return *NULL;
         endif;
 
         return Impl_Filter_null();
 
      /END-FREE
      *
     P Filter_null...
     P                 E
      *
      *=========================================================================
      *  Sets the next filter of the filter chain.
      *=========================================================================
     P Filter_setNext...
     P                 B                   export
      *
     D Filter_setNext...
     D                 PI
     D  i_pFilter                          const  like(LOG4RPG_pFilter_t     )
     D  i_pNextFilter                      const  like(LOG4RPG_pFilter_t     )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (not g_isLoaded);
            return;
         endif;
 
         Impl_Filter_setNext(i_pFilter: i_pNextFilter);
 
         return;
 
      /END-FREE
      *
     P Filter_setNext...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Activates a service program.
      *=========================================================================
      *  Parameters:
      *   i_srvPgm      - The name of the service program.
      *   i_lib         - The library that contains the service program.
      *                   Default:        *LIBL
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   actSrvPgm     - Returns a structure that contains the
      *                   system pointer to the service program and
      *                   the activation mark.
      *=========================================================================
      *
     P activateSrvPgm...
     P                 B                   export
      *
     D activateSrvPgm...
     D                 PI                         likeds(actSrvPgm_t )
     D  i_srvPgm                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
      *
      *  Return value
     D actSrvPgm       DS                  likeds(actSrvPgm_t ) inz
      *
      *  Parameter positions
     D p_lib           C                   const(2)
      *
      *  Optional parameter fields
     D lib             S                   like(i_lib       ) inz
      *
      *  Local fields
     D actMark         S                   like(actInf_t.actMark ) inz
     D pSrvPgm         S               *   inz  procptr
     D actInf          DS                  likeds(actInf_t       ) inz
     D errCode         DS                  likeds(errCode_t      ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P activateSrvPgm...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Gets a procedure pointer by name.
      *=========================================================================
      *  Parameters:
      *   i_srvPgm      - The name of the service program.
      *   i_lib         - The library that contains the service program.
      *                   Default:        *LIBL
      *   i_proc        - The name of the procedure.
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   procptr       - Returns a pointer to the procedure on success
      *                   else *NULL.
      *=========================================================================
      *
     P getProcPtrByName...
     P                 B
      *
     D getProcPtrByName...
     D                 PI              *   procptr
     D  i_proc                      256A   const
     D  i_actSrvPgm                        const  likeds(actSrvPgm_t)
      *
      *  Return value
     D actProc         DS                  likeds(actProc_t ) inz
      *
      *  Local fields
     D typeExpItem     S             10I 0 inz
     D pExpItem        S               *   inz  procptr
     D errCode         DS                  likeds(errCode_t      ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P getProcPtrByName...
     P                 E
      *
