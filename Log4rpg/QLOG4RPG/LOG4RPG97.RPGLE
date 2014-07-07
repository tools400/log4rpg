      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: Synchronisation                          *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  07.11.2008                                              *
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
      /COPY QLOG4RPG,PLOG4RPG97
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,CEELIB                        CEE-Procedures
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
     D g_syncObjName   S             21A
      *
     D g_syncData      DS            64    qualified dtaara(*VAR:g_syncObjName)
     D  jobName                      28A
     D  reserved_4                    4A
     D  alcTime                        Z
      *
     D g_isLogMode     S               N   inz(cFalse)
     D g_objectDesc    S             50A   varying inz
      *
      * -----------------------------------------
      *  Program status data structure
      * -----------------------------------------
      /DEFINE SDS_EXTENDED
      /COPY QLOG4RPG,SDS
      /UNDEFINE SDS_EXTENDED
      *
      *=========================================================================
      *  Enables or disables logging of sync lock holder.
      *=========================================================================
     P Synchronisation_setLogMode...
     P                 B                   export
      *
     D Synchronisation_setLogMode...
     D                 PI
     D  i_mode                         N   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         g_isLogMode = i_mode;
 
         return;
 
      /END-FREE
      *
     P Synchronisation_setLogMode...
     P                 E
      *
      *=========================================================================
      *  Sets the object description of the synchronisation object.
      *=========================================================================
     P Synchronisation_setObjectDesc...
     P                 B                   export
      *
     D Synchronisation_setObjectDesc...
     D                 PI
     D  i_text                       50A   const  varying
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         g_objectDesc = i_text;
 
         return;
 
      /END-FREE
      *
     P Synchronisation_setObjectDesc...
     P                 E
      *
      *=========================================================================
      *  Start synchronisation by adding a lock on a given synchronisation
      *  data area.
      *=========================================================================
     P Synchronisation_start...
     P                 B                   export
      *
     D Synchronisation_start...
     D                 PI              N
     D  i_dtaara                     10A   const
     D  i_lib                        10A   const
     D  o_ticket                                  likeds(LOG4RPG_syncTicket_t )
     D  o_msg                                     likeds(msg_t )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D isStarted       S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_msg           C                   const(4)
      *
      *  Optional parameter fields
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
     D cmd             S            128A   inz
     D rcvm0200        DS                  likeds(rcvm0200_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
            isStarted = cTrue;
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
 
      /END-FREE
      *
     P Synchronisation_start...
     P                 E
      *
      *=========================================================================
      *  End synchronisation and release lock.
      *=========================================================================
     P Synchronisation_end...
     P                 B                   export
      *
     D Synchronisation_end...
     D                 PI
     D  io_ticket                                 likeds(LOG4RPG_syncTicket_t )
     D  o_msg                                     likeds(msg_t )
     D                                            options(*nopass: *omit)
      *
      *  Parameter positions
     D p_msg           C                   const(2)
      *
      *  Optional parameter fields
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
     D rcvm0200        DS                  likeds(rcvm0200_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P Synchronisation_end...
     P                 E
      *
