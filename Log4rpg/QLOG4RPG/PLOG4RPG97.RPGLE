**FREE
/IF NOT DEFINED(PLOG4RPG97)
/DEFINE PLOG4RPG97
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/COPY QLOG4RPG,PTYPES
/COPY QLOG4RPG,PLOG4RPG06                   Property
//
dcl-ds LOG4RPG_syncTicket_t
       qualified           based(pDummy);
  jobName         char(28);
  alcTime         timestamp;
end-ds;
//
// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
//
//  Enables or disables logging of sync lock holder.
dcl-pr Synchronisation_setLogMode
       extproc('LOG4RPG97+
       _Synchronisation_setLogMode+
       ');
  i_mode          ind const;
end-pr;
//
//  Sets the object description of the synchronisation object.
dcl-pr Synchronisation_setObjectDesc
       extproc('LOG4RPG97+
       _Synchronisation_setObjectDesc+
       ');
  i_text          varchar(50) const;
end-pr;
//
//  Start synchronisation by adding a lock on a given synchronisation
//  data area.
dcl-pr Synchronisation_start
       ind
       extproc('LOG4RPG97+
       _Synchronisation_start+
       ');
  i_dtaara        char(10) const;
  i_lib           char(10) const;
  o_ticket        likeds(LOG4RPG_syncTicket_t );
o_msg           likeds(msg_t )
     options(*nopass: *omit);
end-pr;
//
//  End synchronisation and release lock.
dcl-pr Synchronisation_end
       extproc('LOG4RPG97+
       _Synchronisation_end+
       ');
  io_ticket       likeds(LOG4RPG_syncTicket_t );
o_msg           likeds(msg_t )
     options(*nopass: *omit);
end-pr;
//
/ENDIF
