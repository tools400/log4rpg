**FREE
/IF NOT DEFINED(PLOG4RPG99)
/DEFINE PLOG4RPG99
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/COPY QLOG4RPG,PTYPES
/COPY QLOG4RPG,PLOG4RPG06                   Property
//
dcl-ds LOG4RPG_caller_t
       qualified           based(pDummy);
  pgm             likeds(qObj_t);
module          likeds(qObj_t);
procedure       varchar(128);
stmtID          char(10);
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
//  Retrieves the qualified name of a service program from
//  a property value.
dcl-pr getSrvPgm
       likeds(qObj_t      )
extproc('LOG4RPG99+
_getSrvPgm+
');
i_value         const  like(LOG4RPG_Property_value_t);
end-pr;
//
//  Retrieves the procedure prefix from a property value.
dcl-pr getProcedure
       like(LOG4RPG_procedure_t     )
       extproc('LOG4RPG99+
       _getProcedure+
       ');
  i_value         const  like(LOG4RPG_Property_value_t);
end-pr;
//
//  Returns the qualified object name from a string that specifies
//  an object.
dcl-pr getObject
       likeds(qObj_t      )
extproc('LOG4RPG99+
_getObject+
');
i_value         const  like(LOG4RPG_Property_value_t);
end-pr;
//
//  Returns the name of the procedure that called LOG4RPG.
dcl-pr getCallingProcedure
       likeds(LOG4RPG_caller_t)
extproc('LOG4RPG99+
_getCallingProcedure+
');
end-pr;
//
//  Translates charcaters of the logger name.
dcl-pr translateLoggerName
       like(LOG4RPG_loggerName_t)
       extproc('LOG4RPG99+
       _translateLoggerName+
       ');
  i_logName       const  like(LOG4RPG_loggerName_t);
end-pr;
//
//  Returns *ON if the given object name is valid, else *OFF.
dcl-pr isValidObjectName
       ind
       extproc('LOG4RPG99+
       _isValidObjectName+
       ');
  i_name          varchar(10) const;
  o_pos           int(10) options(*nopass);
end-pr;
//
//  Resolves the library name.
dcl-pr rslvLibName
       char(10)
       extproc('LOG4RPG99+
       _rslvLibName+
       ');
  i_obj           char(10) const;
  i_lib           char(10) const;
  i_objType       char(10) const;
end-pr;
//
//  Resolve member name.
dcl-pr rslvMbrName
       char(10)
       extproc('LOG4RPG99+
       _rslvMbrName+
       ');
  i_file          char(10) const;
  i_lib           char(10) const;
  i_mbr           char(10) const;
end-pr;
//
/ENDIF
