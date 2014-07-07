      /IF NOT DEFINED(H_SPEC)
      /DEFINE H_SPEC
      *
      /IF NOT DEFINED(UNIT_TEST)
     H NOMAIN
      /ENDIF
      *  Standard H-Specs
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO ) TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
     H EXTBININT(*YES)
     H CCSID(*CHAR: *JOBRUN)
      *
      /ENDIF
