      /IF NOT DEFINED(PLOG4RPG00)
      /DEFINE PLOG4RPG00
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      *
      *  Loads the LOG4RPG service program and forwards all requests to it.
     D LoggerStub_loadSrvPgm...
     D                 PR
     D                                     extproc('LOG4RPG00+
     D                                     _LoggerStub_loadSrvPgm+
     D                                     ')
      *
      /ENDIF
