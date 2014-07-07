      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: Helper                                   *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  13.06.2006                                              *
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
      *  08.11.2008  Th.Raddatz    Added procedure: getObject()             *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
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
      /COPY QLOG4RPG,H_SPEC
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG99
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cOBJ_NAME_START_COMMENT_CHARS...
     D                 C                   ' ;!'
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Program status data structure
      * -----------------------------------------
      /DEFINE SDS_EXTENDED
      /COPY QLOG4RPG,SDS
      /UNDEFINE SDS_EXTENDED
      *
      *=========================================================================
      *  Retrieves the qualified name of the service program from the
      *  string that specifies the service program and the procedure prefix.
      *=========================================================================
      *  Example:   *LIBL/LOG4RPG(DailyRollingFileAppender)
      *             *LIBL/LOG4RPG.DailyRollingFileAppender
      *=========================================================================
     P getSrvPgm...
     P                 B                   export
      *
     D getSrvPgm...
     D                 PI                         likeds(qObj_t      )
     D  i_value                            const  like(LOG4RPG_Property_value_t)
      *
      *  Return value
     D srvPgm          DS                  likeds(qObj_t   ) inz
      *
      *  Helper fields
     D x               S             10I 0                 inz
     D value           S                   like(i_value  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P getSrvPgm...
     P                 E
      *
      *=========================================================================
      *  Retrieves the procedure prefix from the string that specifies
      *  the service program and the procedure prefix.
      *=========================================================================
      *  Example:   *LIBL/LOG4RPG(DailyRollingFileAppender)
      *             *LIBL/LOG4RPG.DailyRollingFileAppender
      *=========================================================================
     P getProcedure...
     P                 B                   export
      *
     D getProcedure...
     D                 PI                         like(LOG4RPG_procedure_t     )
     D  i_value                            const  like(LOG4RPG_Property_value_t)
      *
      *  Return value
     D procedure       S                   like(LOG4RPG_procedure_t  ) inz
      *
      *  Helper fields
     D start           S             10I 0                 inz
     D length          S             10I 0                 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P getProcedure...
     P                 E
      *
      *=========================================================================
      *  Returns the qualified object name from a string that specifies
      *  an object.
      *=========================================================================
      *  Example:   *LIBL/LOG4RPG   -->   qObj.name = 'LOG4RPG'
      *                                   qObj.lib  = '*LIBL'
      *=========================================================================
     P getObject...
     P                 B                   export
      *
     D getObject...
     D                 PI                         likeds(qObj_t      )
     D  i_value                            const  like(LOG4RPG_Property_value_t)
      *
      *  Return value
     D qObj            DS                  likeds(qObj_t   ) inz
      *
      *  Helper fields
     D x               S             10I 0                 inz
     D y               S             10I 0                 inz
     D value           S                   like(i_value  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P getObject...
     P                 E
      *
      *=========================================================================
      *  Returns the name of the procedure that called LOG4RPG.
      *=========================================================================
     P getCallingProcedure...
     P                 B                   export
      *
     D getCallingProcedure...
     D                 PI                         likeds(LOG4RPG_caller_t)
      *
      *  Return value
     D caller          DS                  likeds(LOG4RPG_caller_t) inz
      *
      *  Helper fields
     D x               S             10I 0 inz
     D y               S             10I 0 inz
     D memSize         S             10I 0 inz
     D me              DS                  likeds(qObj_t)
      *
      *  Retrieve Call Stack (QWVRCSTK) API
     D QWVRCSTK...
     D                 PR                         extpgm('QWVRCSTK')
     D  o_rcvVar                  32767A          options(*varsize)
     D  i_rcvVarLen                  10I 0 const
     D  i_format                      8A   const
     D  i_job                     32767A   const  options(*varsize)
     D  i_jobFormat                   8A   const
     D  io_errCode                32767A          options(*varsize)
      *
     D errCode         DS                  likeds(errCode_t) inz
      *
     D jidf0100        DS                  qualified   inz
     D  job                          10A
     D  user                         10A
     D  nbr                           6A
     D  intJobID                     16A
     D  reserved_1                    2A
     D  thdInd                       10I 0
     D  thdID                         8A
      *
     D cstk0100        DS                  qualified   based(pCstk0100)
     D  bytRet                       10I 0
     D  bytAvl                       10I 0
     D  numStkE                      10I 0
     D  ofsStkEInf                   10I 0
     D  numStkERet                   10I 0
     D  thdID                         8A
     D  infStat                       1A
      *
     D stackE          DS                  qualified   based(pStackE  )
     D  length                       10I 0
     D  disStmtID                    10I 0
     D  numStmtID                    10I 0
     D  disProcName                  10I 0
     D  lenProcName                  10I 0
     D  reqLevel                     10I 0
     D  pgmName                      10A
     D  pgmLibName                   10A
     D  MIInstNbr                    10I 0
     D  modName                      10A
     D  modLibName                   10A
     D  ctlBdy                        1A
     D  reserved_1                    3A
     D  actGrpNbr                    10U 0
     D  actGrpName                   10A
      *
     D stmtID          S             10A               based(pStmtID  )
      *
     D procName        S            256A               based(pProcName)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P getCallingProcedure...
     P                 E
      *
      *===============================================================*
      *  Translates charcaters of the logger name.
      *===============================================================*
     P translateLoggerName...
     P                 B                   export
      *
     D translateLoggerName...
     D                 PI                         like(LOG4RPG_loggerName_t)
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return %xlate('/\': '..': f_lcase(i_logName));
 
      /END-FREE
      *
     P translateLoggerName...
     P                 E
      *
