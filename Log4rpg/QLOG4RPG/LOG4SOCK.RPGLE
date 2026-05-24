**free
//=====================================================================*
//  Module: LOG4RPG - Object: Socket Helper                            *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  14.11.2006                                              *
//  E-mail  :  thomas.raddatz@tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  Copyright (c) 1998,2001 Scott C. Klement                           *
//  All rights reserved.                                               *
//                                                                     *
//  Redistribution and use in source and binary forms, with or without *
//  modification, are permitted provided that the following conditions *
//  are met:                                                           *
//  1. Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in the
//     documentation and/or other materials provided with the distribution.

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
/copy QLOG4RPG,PLOG4SOCK

// -----------------------------------------
//  Type definitions
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,PTYPES Private type definitions
/copy QLOG4RPG,QUSRJOBI Retrieve Job information(QUSRJOBI) API

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

dcl-pr mask uns(10);
  i_FD like(socket_fd_t) const;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
//
// -----------------------------------------
//  Global fields
// -----------------------------------------
//
// -----------------------------------------
//  Program status data structure
// -----------------------------------------
//
//======================================================================================
//  RPG implementation of C macro: FD_SET
//  Set bit in file descriptor set.
//======================================================================================
dcl-proc FD_SET export;
  dcl-pi *n;
    i_FD     like(socket_fd_t) const;
    io_FDSet like(socket_fdSet_t);
  end-pi;

  //  Helper fields
  dcl-s x int(5);
  dcl-s FDSet uns(10) dim(7) based(pFDSet);
  // ---------------------------------------------------------

  pFDSet =%addr(io_FDSet);
  x = (i_FD / 32) + 1;
  FDSet(x) = %bitor(FDSet(x): mask(i_FD));

  return;


end-proc;

//======================================================================================
//  RPG implementation of C macro: FD_CLR
//  Clear bit in file descriptor set.
//======================================================================================
dcl-proc FD_CLR export;
  dcl-pi *n;
    i_FD     like(socket_fd_t) const;
    io_FDSet like(socket_fdSet_t);
  end-pi;

  //  Helper fields
  dcl-s x int(5);
  dcl-s FDSet uns(10) dim(7) based(pFDSet);
  // ---------------------------------------------------------

  pFDSet =%addr(io_FDSet);
  x = (i_FD / 32) + 1;
  FDSet(x) = %bitand(FDSet(x): %bitnot(mask(i_FD)));

  return;


end-proc;

//======================================================================================
//  RPG implementation of C macro: FD_ISSET
//  Test bit in file descriptor set.
//======================================================================================
dcl-proc FD_ISSET export;
  dcl-pi *n ind;
    i_FD    like(socket_fd_t) value;
    i_FDSet like(socket_fdSet_t) value;
  end-pi;

  //  Funktionswert
  dcl-s isSet ind inz(*off);

  //  Helper fields
  dcl-s x int(5);
  dcl-s FDSet uns(10) dim(7) based(pFDSet);
  // ---------------------------------------------------------

  pFDSet =%addr(i_FDSet);
  x = (i_FD / 32) + 1;
  isSet = %bitand(FDSet(x): mask(i_FD)) = mask(i_FD);

  return isSet;


end-proc;

//======================================================================================
//  RPG implementation of C macro: FD_ISSET
//  Initialize file descriptor set with x'00'.
//======================================================================================
dcl-proc FD_ZERO export;
  dcl-pi *n;
    io_FDSet like(socket_fdSet_t);
  end-pi;
  // ---------------------------------------------------------

  io_FDSet = *ALLx'00';

  return;


end-proc;

//===============================================================*
//  Returns the IP address of the 5250 client of the
//  specified job.
//===============================================================*
dcl-proc Job_getTcpIpAddr export;
  dcl-pi *n varchar(15);
    i_qJob likeds(LOG4RPG_qJob_t) options(*nopass) const;
  end-pi;

  //  Parameter positions
  dcl-c p_qJob 1;

  dcl-ds qJob likeds(i_qJob);

  dcl-ds jobi0600 qualified;
    jobType    char(1) pos(61);
    jobSubType char(1) pos(62);
    device     char(10) pos(127);
  end-ds;

  //  Retrieve Device Description (QDCRDEVD) API
  dcl-pr QDCRDEVD extpgm('QDCRDEVD');
    o_rcvVar    char(65535) options(*varsize);
    i_lenRcvVar int(10) const;
    i_format    char(8) const;
    i_devName   char(10) const;
    io_errCode  char(65535) options(*varsize);
  end-pr;

  dcl-ds devd0600 len(1024) qualified;
    tcpIpDotAddr char(15) pos(878);
  end-ds;

  dcl-ds errCode inz;
    bytPrv int(10);
    bytAvl int(10);
  end-ds;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (%parms() >= p_qJob);
    qJob = i_qJob;
  else;
    clear qJob;
    qJob.name = '*';
  endif;

  QUSRJOBI(jobi0600:%size(jobi0600):'JOBI0600':qJob:'':errCode);

  QDCRDEVD(devd0600:%size(devd0600):'DEVD0600':jobi0600.device:errCode);

  return %trim(devd0600.tcpIpDotAddr);


end-proc;

//======================================================================================
//  *** private ***
//  Calculate bit mask from file descriptor.
//======================================================================================
dcl-proc mask;
  dcl-pi *n uns(10);
    i_FD like(socket_fd_t) const;
  end-pi;

  //  Helper fields
  // ---------------------------------------------------------

  return %int(2 ** %rem(i_FD : 32));


end-proc;
