**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: Synchronisation                          *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  07.11.2008                                              *
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
/copy QLOG4RPG,PLOG4RPG97

// -----------------------------------------
//  Type definitions
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,CEELIB                        CEE-Procedures
/copy QBASICS1,PBASICS1                      Basic RPG Extensions

// -----------------------------------------
//  Private prototypes
// -----------------------------------------
//
// -----------------------------------------
//  Global constants
// -----------------------------------------
//
// -----------------------------------------
//  Global fields
// -----------------------------------------
dcl-s g_syncObjName char(21);

dcl-ds g_syncData len(64) qualified dtaara(g_syncObjName);
  jobName    char(28);
  reserved_4 char(4);
  alcTime    timestamp;
end-ds;

dcl-s g_isLogMode ind inz(*off);
dcl-s g_objectDesc varchar(50) inz;

// -----------------------------------------
//  Program status data structure
// -----------------------------------------
/define SDS_EXTENDED
/copy QLOG4RPG,SDS
/undefine SDS_EXTENDED

//=========================================================================
//  Enables or disables logging of sync lock holder.
//=========================================================================
dcl-proc Synchronisation_setLogMode export;
  dcl-pi *n;
    i_mode ind const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

g_isLogMode = i_mode;

return;


end-proc;

//=========================================================================
//  Sets the object description of the synchronisation object.
//=========================================================================
dcl-proc Synchronisation_setObjectDesc export;
  dcl-pi *n;
    i_text varchar(50) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

g_objectDesc = i_text;

return;


end-proc;

//=========================================================================
//  Start synchronisation by adding a lock on a given synchronisation
//  data area.
//=========================================================================
dcl-proc Synchronisation_start export;
  dcl-pi *n ind;
    i_dtaara char(10) const;
    i_lib    char(10) const;
    o_ticket likeds(LOG4RPG_syncTicket_t);
    o_msg    likeds(msg_t) options(*nopass: *omit);
  end-pi;

//  Return value
  dcl-s isStarted ind inz(*off);

//  Parameter positions
  dcl-c p_msg 4;

//  Optional parameter fields
  dcl-ds msg likeds(o_msg) inz;

//  Helper fields
  dcl-s isPresent int(10) inz;
  dcl-s cmd char(128) inz;
  dcl-ds rcvm0200 likeds(rcvm0200_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

clear o_ticket;
msg = f_newMsg(cMSG_ID_OK);

dou '1';

   if (not f_exist(i_dtaara: i_lib: '*DTAARA'));
      cmd = 'CRTDTAARA DTAARA(%LIB%/%DTAARA%) +
                       TYPE(*CHAR) LEN(%LEN%) +
                       TEXT(''' + g_objectDesc + ''')';
      cmd = f_replace('%LIB%'   : %trimR(i_lib)   : cmd);
      cmd = f_replace('%DTAARA%': %trimR(i_dtaara): cmd);
      cmd = f_replace('%LEN%'   : %char(%len(g_syncData)): cmd);
      f_execute(cmd: *omit: msg);
      if (msg.ID <> cMSG_ID_OK);
         leave;
      endif;
   endif;

   g_syncObjName = %trimR(i_lib) + '/' + %trimR(i_dtaara);

   monitor;
      in *lock g_syncData;
   on-error;
      rcvm0200 = f_rcvPgmMsg(cMsg_Escape: *omit: cMsg_Act_Old);
      msg = f_cvtRcvMsgToMsg(rcvm0200);
      leave;
   endmon;

   g_syncData.jobName = %trimR(%char(sds.nbr)) + '/' +
                        %trimR(sds.user)       + '/' +
                        %trimR(sds.job );
   g_syncData.alcTime = %timestamp();

   if (g_isLogMode);
      out *lock g_syncData;
   endif;

   o_ticket.jobName = g_syncData.jobName;
   o_ticket.alcTime = g_syncData.alcTime;
   isStarted = *on;
enddo;

if (msg.ID <> cMSG_ID_OK);
   msg.type = cMsg_Escape;
endif;

// Process optional/omissible message parameter
if (%parms() >= p_msg);
   CEETSTA(isPresent: p_msg: *omit);
   if (isPresent = 1);
      o_msg = msg;
   endif;
else;
   if (msg.ID <> cMSG_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return isStarted;


end-proc;

//=========================================================================
//  End synchronisation and release lock.
//=========================================================================
dcl-proc Synchronisation_end export;
  dcl-pi *n;
    io_ticket likeds(LOG4RPG_syncTicket_t);
    o_msg     likeds(msg_t) options(*nopass: *omit);
  end-pi;

//  Parameter positions
  dcl-c p_msg 2;

//  Optional parameter fields
  dcl-ds msg likeds(o_msg) inz;

//  Helper fields
  dcl-s isPresent int(10) inz;
  dcl-ds rcvm0200 likeds(rcvm0200_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

msg = f_newMsg(cMSG_ID_OK);

dou '1';

   monitor;
      if (g_isLogMode);
         in *lock g_syncData;
      else;
         unlock g_syncData;
      endif;
   on-error;
      rcvm0200 = f_rcvPgmMsg(cMsg_Escape: *omit: cMsg_Act_Old);
      msg = f_cvtRcvMsgToMsg(rcvm0200);
      leave;
   endmon;

   if (g_isLogMode);
      p_assert(io_ticket.jobName = g_syncData.jobName and
               io_ticket.alcTime = g_syncData.alcTime
               : 'Invalid ticket data when attempting +
                  to release sync lock');

      clear g_syncData;
      out g_syncData;
   endif;

   clear io_ticket;
enddo;

if (msg.ID <> cMSG_ID_OK);
   msg.type = cMsg_Escape;
endif;

// Process optional/omissible message parameter
if (%parms() >= p_msg);
   CEETSTA(isPresent: p_msg: *omit);
   if (isPresent = 1);
      o_msg = msg;
   endif;
else;
   if (msg.ID <> cMSG_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
   endif;
endif;

return;


end-proc;

