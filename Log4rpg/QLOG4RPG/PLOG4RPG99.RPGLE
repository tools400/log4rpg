      /IF NOT DEFINED(PLOG4RPG99)
      /DEFINE PLOG4RPG99
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PTYPES
      /COPY QLOG4RPG,PLOG4RPG06                   Property
      *
     D LOG4RPG_caller_t...
     D                 DS                  qualified           based(pDummy)
     D  pgm                                likeds(qObj_t)
     D  module                             likeds(qObj_t)
     D  procedure                   128A   varying
     D  stmtID                       10A
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Retrieves the qualified name of a service program from
      *  a property value.
     D getSrvPgm...
     D                 PR                         likeds(qObj_t      )
     D                                     extproc('LOG4RPG99+
     D                                     _getSrvPgm+
     D                                     ')
     D  i_value                            const  like(LOG4RPG_Property_value_t)
      *
      *  Retrieves the procedure prefix from a property value.
     D getProcedure...
     D                 PR                         like(LOG4RPG_procedure_t     )
     D                                     extproc('LOG4RPG99+
     D                                     _getProcedure+
     D                                     ')
     D  i_value                            const  like(LOG4RPG_Property_value_t)
      *
      *  Returns the qualified object name from a string that specifies
      *  an object.
     D getObject...
     D                 PR                         likeds(qObj_t      )
     D                                     extproc('LOG4RPG99+
     D                                     _getObject+
     D                                     ')
     D  i_value                            const  like(LOG4RPG_Property_value_t)
      *
      *  Returns the name of the procedure that called LOG4RPG.
     D getCallingProcedure...
     D                 PR                         likeds(LOG4RPG_caller_t)
     D                                     extproc('LOG4RPG99+
     D                                     _getCallingProcedure+
     D                                     ')
      *
      *  Translates charcaters of the logger name.
     D translateLoggerName...
     D                 PR                         like(LOG4RPG_loggerName_t)
     D                                     extproc('LOG4RPG99+
     D                                     _translateLoggerName+
     D                                     ')
     D  i_logName                          const  like(LOG4RPG_loggerName_t)
      *
      *  Returns cTrue, if the given object name is valid, else cFalse.
     D isValidObjectName...
     D                 PR              N
     D                                     extproc('LOG4RPG99+
     D                                     _isValidObjectName+
     D                                     ')
     D  i_name                       10A   const  varying
     D  o_pos                        10I 0        options(*nopass)
      *
      /ENDIF
