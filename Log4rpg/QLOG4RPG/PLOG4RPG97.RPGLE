      /IF NOT DEFINED(PLOG4RPG97)
      /DEFINE PLOG4RPG97
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PTYPES
      /COPY QLOG4RPG,PLOG4RPG06                   Property
      *
     D LOG4RPG_syncTicket_t...
     D                 DS                  qualified           based(pDummy)
     D  jobName                      28A
     D  alcTime                        Z
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Enables or disables logging of sync lock holder.
     D Synchronisation_setLogMode...
     D                 PR
     D                                     extproc('LOG4RPG97+
     D                                     _Synchronisation_setLogMode+
     D                                     ')
     D  i_mode                         N   const
      *
      *  Sets the object description of the synchronisation object.
     D Synchronisation_setObjectDesc...
     D                 PR
     D                                     extproc('LOG4RPG97+
     D                                     _Synchronisation_setObjectDesc+
     D                                     ')
     D  i_text                       50A   const  varying
      *
      *  Start synchronisation by adding a lock on a given synchronisation
      *  data area.
     D Synchronisation_start...
     D                 PR              N
     D                                     extproc('LOG4RPG97+
     D                                     _Synchronisation_start+
     D                                     ')
     D  i_dtaara                     10A   const
     D  i_lib                        10A   const
     D  o_ticket                                  likeds(LOG4RPG_syncTicket_t )
     D  o_msg                                     likeds(msg_t )
     D                                            options(*nopass: *omit)
      *
      *  End synchronisation and release lock.
     D Synchronisation_end...
     D                 PR
     D                                     extproc('LOG4RPG97+
     D                                     _Synchronisation_end+
     D                                     ')
     D  io_ticket                                 likeds(LOG4RPG_syncTicket_t )
     D  o_msg                                     likeds(msg_t )
     D                                            options(*nopass: *omit)
      *
      /ENDIF
