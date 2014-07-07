      /IF NOT DEFINED(msg_t     )
      /DEFINE msg_t
      * ============================================================= *
      *   Message structure                                           *
      * ============================================================= *
      *
     D msg_t           DS                  qualified           based(pDummy)
      /if defined(*V5R3M0)
     D  ID                                 likeds(msgID_t)
      /else
     D  ID                            7A
      /endif
     D  data                        512A
     D  type                         10A
     D  file                         10A
     D  lib                          10A
      *
      /if defined(*V5R3M0)
     D msgID_t         DS                  qualified           based(pDummy)
     D  prefix                        3A
     D  nbr                           4S 0
      /endif
      *
      /ENDIF
