      *=====================================================================*
      *  Module: LOG4RPG - Object: Socket Helper                            *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  14.11.2006                                              *
      *  E-mail  :  thomas.raddatz@tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  Copyright (c) 1998,2001 Scott C. Klement                           *
      *  All rights reserved.                                               *
      *                                                                     *
      *  Redistribution and use in source and binary forms, with or without *
      *  modification, are permitted provided that the following conditions *
      *  are met:                                                           *
      *  1. Redistributions of source code must retain the above copyright
      *     notice, this list of conditions and the following disclaimer.
      *  2. Redistributions in binary form must reproduce the above copyright
      *     notice, this list of conditions and the following disclaimer in the
      *     documentation and/or other materials provided with the distribution.
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
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
      /COPY QLOG4RPG,PLOG4SOCK
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,PTYPES                        Private type definitions
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
     D mask...
     D                 PR            10U 0
     D  i_FD                               const  like(socket_fd_t   )
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Program status data structure
      * -----------------------------------------
      *
      *======================================================================================
    R *  RPG implementation of C macro: FD_SET
      *  Set bit in file descriptor set.
      *======================================================================================
     P FD_SET...
     P                 B                   export
      *
     D FD_SET...
     D                 PI
     D i_FD                                const  like(socket_fd_t   )
     D io_FDSet                                   like(socket_fdSet_t)
      *
      *  Helper fields
     D x               S              5I 0
     D FDSet           S             10U 0 dim(7) based(pFDSet)
      * ---------------------------------------------------------
      /FREE
 
         pFDSet =%addr(io_FDSet);
         x = (i_FD / 32) + 1;
         FDSet(x) = %bitor(FDSet(x): mask(i_FD));
 
         return;
 
      /END-FREE
      *
     P FD_SET...
     P                 E
      *
      *======================================================================================
    R *  RPG implementation of C macro: FD_CLR
      *  Clear bit in file descriptor set.
      *======================================================================================
     P FD_CLR...
     P                 B                   export
      *
     D FD_CLR...
     D                 PI
     D i_FD                                const  like(socket_fd_t   )
     D io_FDSet                                   like(socket_fdSet_t)
      *
      *  Helper fields
     D x               S              5I 0
     D FDSet           S             10U 0 dim(7) based(pFDSet)
      * ---------------------------------------------------------
      /FREE
 
         pFDSet =%addr(io_FDSet);
         x = (i_FD / 32) + 1;
         FDSet(x) = %bitand(FDSet(x): %bitnot(mask(i_FD)));
 
         return;
 
      /END-FREE
      *
     P FD_CLR...
     P                 E
      *
      *======================================================================================
    R *  RPG implementation of C macro: FD_ISSET
      *  Test bit in file descriptor set.
      *======================================================================================
     P FD_ISSET...
     P                 B                   export
      *
     D FD_ISSET...
     D                 PI              N
     D i_FD                                value  like(socket_fd_t   )
     D i_FDSet                             value  like(socket_fdSet_t)
      *
      *  Funktionswert
     D isSet           S               N   inz(cFalse)
      *
      *  Helper fields
     D x               S              5I 0
     D FDSet           S             10U 0 dim(7) based(pFDSet)
      * ---------------------------------------------------------
      /FREE
 
         pFDSet =%addr(i_FDSet);
         x = (i_FD / 32) + 1;
         isSet = %bitand(FDSet(x): mask(i_FD)) = mask(i_FD);
 
         return isSet;
 
      /END-FREE
      *
     P FD_ISSET...
     P                 E
      *
      *======================================================================================
    R *  RPG implementation of C macro: FD_ISSET
      *  Initialize file descriptor set with x'00'.
      *======================================================================================
     P FD_ZERO...
     P                 B                   export
      *
     D FD_ZERO...
     D                 PI
     D io_FDSet                                   like(socket_fdSet_t)
      * ---------------------------------------------------------
      /FREE
 
         io_FDSet = *ALLx'00';
 
         return;
 
      /END-FREE
      *
     P FD_ZERO...
     P                 E
      *
      *===============================================================*
      *  Returns the IP address of the 5250 client of the
      *  specified job.
      *===============================================================*
     P Job_getTcpIpAddr...
     P                 B                   export
      *
     D Job_getTcpIpAddr...
     D                 PI            15A          varying
     D  i_qJob                             const  likeds(qJob_t   )
     D                                            options(*nopass)
      *
      *  Parameter positions
     D p_qJob          C                   1
      *
      *  Retrieve Job Information (QUSRJOBI) API
     D QUSRJOBI...
     D                 PR                  extpgm('QUSRJOBI')
     D  o_rcvVar                  65535A          options(*varsize)
     D  i_rcvVarLen                  10I 0 const
     D  i_format                      8A   const
     D  i_qJob                       26A   const
     D  i_intJobID                   16A   const
     D  io_errCode                65535A          options(*nopass: *varsize)    OptGrp 1
     D  i_resPrfStat                  1A   const  options(*nopass)              OptGrp 2
      *
     D qJob            DS                  likeds(i_qJob   )
      *
     D jobi0600        DS                  qualified
     D  jobType               61     61A
     D  jobSubType            62     62A
     D  device               127    136A
      *
      *  Retrieve Device Description (QDCRDEVD) API
     D QDCRDEVD...
     D                 PR                         extpgm('QDCRDEVD')
     D  o_rcvVar                  65535A          options(*varsize)
     D  i_lenRcvVar                  10I 0 const
     D  i_format                      8A   const
     D  i_devName                    10A   const
     D  io_errCode                65535A          options(*varsize)
      *
     D devd0600        DS          1024    qualified
     D  tcpIpDotAddr         878    892A
      *
     D errCode         DS                  inz
     D  bytPrv                       10I 0
     D  bytAvl                       10I 0
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (%parms() >= p_qJob);
            qJob = i_qJob;
         else;
            clear qJob;
            qJob.name = '*';
         endif;
 
         QUSRJOBI(jobi0600:%size(jobi0600):'JOBI0600':qJob:'':errCode);
 
         QDCRDEVD(devd0600:%size(devd0600):'DEVD0600':jobi0600.device:errCode);
 
         return %trim(devd0600.tcpIpDotAddr);
 
      /END-FREE
      *
     P Job_getTcpIpAddr...
     P                 E
      *
      *======================================================================================
    R *  *** private ***
      *  Calculate bit mask from file descriptor.
      *======================================================================================
     P mask...
     P                 B
      *
     D mask...
     D                 PI            10U 0
     D  i_FD                               const  like(socket_fd_t   )
      *
      *  Helper fields
      * ---------------------------------------------------------
      /FREE
 
         return %int(2 ** %rem(i_FD : 32));
 
      /END-FREE
      *
     P mask...
     P                 E
      *
