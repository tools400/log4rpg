**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: Helper                                   *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  13.06.2006                                              *
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
//  08.11.2008  Th.Raddatz    Added procedure: getObject()             *
//                                                                     *
//  23.03.20025 Th.Raddatz    Added procedures:                        *
//                             - rslvMbrName                           *
//                             - rslvLibName                           *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//                                                                     *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) +                     *
//                              SRCMBR(&SM);                           *
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
/copy QLOG4RPG,H_SPEC
//=====================================================================*
//
// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG99

// -----------------------------------------
//  Type definitions
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QBASICS1,PBASICS1                      Basic RPG Extensions
/copy QBASICS1,BASICS1R0                     SrvPgm: Basic Routines - Declarations        cpyb
/copy QLOG4RPG,PLOG4RPG10                    LogLog

// -----------------------------------------
//  Private prototypes
// -----------------------------------------
//
// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cOBJ_NAME_START_COMMENT_CHARS ' ;!';

// -----------------------------------------
//  Global fields
// -----------------------------------------
//
// -----------------------------------------
//  Program status data structure
// -----------------------------------------
/define SDS_EXTENDED
/copy QLOG4RPG,SDS
/undefine SDS_EXTENDED

//=========================================================================
//  Retrieves the qualified name of the service program from the
//  string that specifies the service program and the procedure prefix.
//=========================================================================
//  Example:   *LIBL/LOG4RPG(DailyRollingFileAppender)
//             *LIBL/LOG4RPG.DailyRollingFileAppender
//=========================================================================
dcl-proc getSrvPgm export;
  dcl-pi *n likeds(qObj_t);
    i_value like(LOG4RPG_Property_value_t) const;
  end-pi;

//  Return value
  dcl-ds srvPgm likeds(qObj_t) inz;

//  Helper fields
  dcl-s x int(10) inz;
  dcl-s value like(i_value) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

value = i_value;

// Get library name ...
x = %scan('/': value);
if x > 1;
   srvPgm.lib = %subst(value: 1: x - 1);
   if %len(value) > x;
      value = %subst(value: x + 1);
   endif;
else;
   srvPgm.lib = '*LIBL';
endif;

// Get service program name ...
x = %scan('(': value);
if x > 1;
   srvPgm.name = %subst(value: 1: x - 1);
else;
   srvPgm.name = sds.pgmContProc;
endif;

return srvPgm;


end-proc;

//=========================================================================
//  Retrieves the procedure prefix from the string that specifies
//  the service program and the procedure prefix.
//=========================================================================
//  Example:   *LIBL/LOG4RPG(DailyRollingFileAppender)
//             *LIBL/LOG4RPG.DailyRollingFileAppender
//=========================================================================
dcl-proc getProcedure export;
  dcl-pi *n like(LOG4RPG_procedure_t);
    i_value like(LOG4RPG_Property_value_t) const;
  end-pi;

//  Return value
  dcl-s procedure like(LOG4RPG_procedure_t) inz;

//  Helper fields
  dcl-s start int(10) inz;
  dcl-s length int(10) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Get procedure prefix ...
start = %scan('(': i_value);
if start > 0 and start < %len(i_value);
   start  = start + 1;
   length = %scan(')': i_value: start);
   if length > 0;
      length = length - start;
   endif;
else;
   start  = 1;
   length = %len(i_value);
endif;

if length > 0;
   procedure = %subst(i_value: start: length);
else;
   procedure = '';
endif;

return procedure;


end-proc;

//=========================================================================
//  Returns the qualified object name from a string that specifies
//  an object.
//=========================================================================
//  Example:   *LIBL/LOG4RPG   -->   qObj.name = 'LOG4RPG'
//                                   qObj.lib  = '*LIBL'
//=========================================================================
dcl-proc getObject export;
  dcl-pi *n likeds(qObj_t);
    i_value like(LOG4RPG_Property_value_t) const;
  end-pi;

//  Return value
  dcl-ds qObj likeds(qObj_t) inz;

//  Helper fields
  dcl-s x int(10) inz;
  dcl-s y int(10) inz;
  dcl-s value like(i_value) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

value = %trimR(i_value);

x = %scan('/': value);
if (x = 0);
   qObj.name = value;
else;
   if (x > 1);
      qObj.lib = %subst(value: 1: x-1);
   endif;
   if (x < %len(value));
      qObj.name = %subst(value: x+1);
   endif;
endif;

// Remove trailing comments from object name e.g.:
//    QGPL/QRPGLESRC; a comment
//    QGPL/QRPGLESRC  # a comment
//    QGPL/QRPGLESRC  ! a comment
for x = 1 to %len(qObj.name);
   y = %scan(%subst(qObj.name: x: 1): cOBJ_NAME_START_COMMENT_CHARS);
   if (y <> 0);
      if (x = 1);
         qObj.name = '';
      else;
         qObj.Name = %subst(qObj.name: 1: x-1);
      endif;
   endif;
endfor;

return qObj;


end-proc;

//=========================================================================
//  Returns the name of the procedure that called LOG4RPG.
//=========================================================================
dcl-proc getCallingProcedure export;
  dcl-pi *n likeds(LOG4RPG_caller_t);
  end-pi;

//  Return value
  dcl-ds caller likeds(LOG4RPG_caller_t) inz;

//  Helper fields
  dcl-s x int(10) inz;
  dcl-s y int(10) inz;
  dcl-s memSize int(10) inz;
  dcl-ds me likeds(qObj_t);

//  Retrieve Call Stack (QWVRCSTK) API
  dcl-pr QWVRCSTK extpgm('QWVRCSTK');
    o_rcvVar    char(32767) options(*varsize);
    i_rcvVarLen int(10) const;
    i_format    char(8) const;
    i_job       char(32767) options(*varsize) const;
    i_jobFormat char(8) const;
    io_errCode  char(32767) options(*varsize);
  end-pr;

  dcl-ds errCode likeds(errCode_t) inz;

  dcl-ds jidf0100 qualified inz;
    job        char(10);
    user       char(10);
    nbr        char(6);
    intJobID   char(16);
    reserved_1 char(2);
    thdInd     int(10);
    thdID      char(8);
  end-ds;

  dcl-ds cstk0100 qualified based(pCstk0100);
    bytRet     int(10);
    bytAvl     int(10);
    numStkE    int(10);
    ofsStkEInf int(10);
    numStkERet int(10);
    thdID      char(8);
    infStat    char(1);
  end-ds;

  dcl-ds stackE qualified based(pStackE);
    length      int(10);
    disStmtID   int(10);
    numStmtID   int(10);
    disProcName int(10);
    lenProcName int(10);
    reqLevel    int(10);
    pgmName     char(10);
    pgmLibName  char(10);
    MIInstNbr   int(10);
    modName     char(10);
    modLibName  char(10);
    ctlBdy      char(1);
    reserved_1  char(3);
    actGrpNbr   uns(10);
    actGrpName  char(10);
  end-ds;

  dcl-s stmtID char(10) based(pStmtID);

  dcl-s procName char(256) based(pProcName);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Materialize call stack
clear errCode;
clear jidf0100;
jidf0100.job        = '*';
jidf0100.user       = '';
jidf0100.nbr        = '';
jidf0100.intJobID   = '';
jidf0100.reserved_1 = *ALLx'00';
jidf0100.thdInd     = 1;
jidf0100.thdID      = *ALLx'00';

// Check, how much memory we need.
// Get an initial buffer of 4k.
// Actually we should need about 2300 byte.
memSize = 4096;
pCstk0100 = %alloc(memsize);
QWVRCSTK(cstk0100: memSize: 'CSTK0100': jidf0100: 'JIDF0100': errCode);

// Call API again, providing enough memory for it
if cstk0100.bytRet < cstk0100.bytAvl;
   memSize = cstk0100.bytAvl;
   pCstk0100 = %realloc(pCstk0100: memSize);
   QWVRCSTK(cstk0100:memSize:'CSTK0100':jidf0100:'JIDF0100':errCode);
   LogLog_debug('*** Performance problem encountered: +
                 Needed to reallocate memory to get +
                 full stack information.');
endif;

// Spin through the call stack entries searching for the caller
clear me;
clear caller;
for x = 1 to cstk0100.numStkE;
   if x = 1;
      pStackE = pCstk0100 + cstk0100.ofsStkEInf;
   else;
      pStackE = pStackE + stackE.length;
   endif;

   pStmtID   = pStackE + stackE.disStmtID;
   pProcName = pStackE + stackE.disProcName;

   if (stackE.pgmName = sds.pgmContProc) and
      (stackE.pgmLibName = sds.pgmLib  );
      me.name        = stackE.pgmName;
      me.lib         = stackE.pgmLibName;
   else;
      if (me.name <> '') and (me.name <> stackE.pgmName);
         caller.pgm.name    = stackE.pgmName;
         caller.pgm.lib     = stackE.pgmLibName;
         caller.module.name = stackE.modName;
         caller.module.lib  = stackE.modLibName;
         caller.procedure   = %subst(procName: 1: stackE.lenProcName);
         caller.stmtID      = %trim(stmtID);
         y = %check('0': caller.stmtID);
         if y > 0;
            caller.stmtID = %subst(caller.stmtID: y);
         endif;
         leave;
      endif;
   endif;
endfor;

dealloc(N) pCstk0100;

return caller;


end-proc;

//===============================================================*
//  Translates charcaters of the logger name.
//===============================================================*
dcl-proc translateLoggerName export;
  dcl-pi *n like(LOG4RPG_loggerName_t);
    i_logName like(LOG4RPG_loggerName_t) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return %xlate('/\': '..': f_lcase(i_logName));


end-proc;

//===============================================================*
//  Resolve library name.
//===============================================================*
dcl-proc rslvLibName export;
  dcl-pi *n char(10);
    i_obj     char(10) const;
    i_lib     char(10) const;
    i_objType char(10) const;
  end-pi;

  dcl-ds qObj likeds(qObj_t) inz;
  dcl-ds objd0100 likeds(objd0100_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (not f_startsWith('*': i_lib));
   return i_lib;
endif;

clear qObj;
qObj.name = i_obj;
qObj.lib = i_lib;

clear errCode;
errCode.bytPrv = %size(errCode);
QUSROBJD(objd0100: %size(objd0100): 'OBJD0100'
         : qObj: i_objType: errCode);

if (errCode.bytAvl = 0);
   return objd0100.rtnLib;
else;
   return i_lib;
endif;


end-proc;

//===============================================================*
//  Resolve member name.
//===============================================================*
dcl-proc rslvMbrName export;
  dcl-pi *n char(10);
    i_file char(10) const;
    i_lib  char(10) const;
    i_mbr  char(10) const;
  end-pi;

  dcl-s mbr char(10);

  dcl-ds qFile likeds(qObj_t) inz;
  dcl-ds mbrd0100 likeds(mbrd0100_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (not f_startsWith('*': i_mbr));
   return i_mbr;
endif;

clear qFile;
qFile.name = i_file;
qFile.lib = i_lib;

clear errCode;
errCode.bytPrv = %size(errCode);
QUSRMBRD(mbrd0100: %size(mbrd0100): 'MBRD0100'
         : qFile: i_mbr: '0': errCode);

if (errCode.bytAvl = 0);
   return mbrd0100.mbr;
else;
   return i_mbr;
endif;


end-proc;

