**FREE
/IF NOT DEFINED(PLOG4RPG98)
/DEFINE PLOG4RPG98
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/COPY QLOG4RPG,PTYPES
//
// -----------------------------------------
//  Constants
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
//
//  Converts a given property to a file-size-value.
dcl-pr OptionConverter_toFileSize
       int(20)
       extproc('LOG4RPG98+
       _OptionConverter_toFileSize+
       ');
  i_value         value  like(LOG4RPG_Property_value_t);
  i_default       int(20) value;
end-pr;
//
//  Converts a given property to a RPG boolean value.
dcl-pr OptionConverter_toBoolean
       ind
       extproc('LOG4RPG98+
       _OptionConverter_toBoolean+
       ');
  i_value         value  like(LOG4RPG_Property_value_t);
  i_default       ind value;
end-pr;
//
//  Converts a given property to a RPG integer value.
dcl-pr OptionConverter_toInt
       int(10)
       extproc('LOG4RPG98+
       _OptionConverter_toInt+
       ');
  i_value         value  like(LOG4RPG_Property_value_t);
  i_default       int(10) value;
end-pr;
//
/ENDIF
