      /IF NOT DEFINED(qJob_t    )
      /DEFINE qJob_t
      * ============================================================= *
      *   Qualified job name                                          *
      *===============================================================*
      *
     D qJob_t          DS                  qualified           based(pDummy)
     D  name                         10A
     D  user                         10A
     D  nbr                           6A
      *
      /ENDIF
