      /IF NOT DEFINED(PLOG4RPG98)
      /DEFINE PLOG4RPG98
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PTYPES
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Converts a given property to a file-size-value.
     D OptionConverter_toFileSize...
     D                 PR            20I 0
     D                                     extproc('LOG4RPG98+
     D                                     _OptionConverter_toFileSize+
     D                                     ')
     D  i_value                            value  like(LOG4RPG_Property_value_t)
     D  i_default                    20I 0 value
      *
      *  Converts a given property to a RPG boolean value.
     D OptionConverter_toBoolean...
     D                 PR              N
     D                                     extproc('LOG4RPG98+
     D                                     _OptionConverter_toBoolean+
     D                                     ')
     D  i_value                            value  like(LOG4RPG_Property_value_t)
     D  i_default                      N   value
      *
      *  Converts a given property to a RPG integer value.
     D OptionConverter_toInt...
     D                 PR            10I 0
     D                                     extproc('LOG4RPG98+
     D                                     _OptionConverter_toInt+
     D                                     ')
     D  i_value                            value  like(LOG4RPG_Property_value_t)
     D  i_default                    10I 0 value
      *
      /ENDIF
