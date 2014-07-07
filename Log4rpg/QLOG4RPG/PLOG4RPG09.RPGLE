      /IF NOT DEFINED(PLOG4RPG09)
      /DEFINE PLOG4RPG09
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PTYPES                        Private type definitions
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
     D cLOG4RPG_PRIORITY_DEBUG...
     D                 C                   const(1)
     D cLOG4RPG_PRIORITY_INFO...
     D                 C                   const(2)
     D cLOG4RPG_PRIORITY_WARN...
     D                 C                   const(3)
     D cLOG4RPG_PRIORITY_ERROR...
     D                 C                   const(4)
     D cLOG4RPG_PRIORITY_FATAL...
     D                 C                   const(5)
     D cLOG4RPG_PRIORITY_NONE...
     D                 C                   const(99)
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      *
      *  Converts the string passed as argument to an integer level.
     D Level_toInt...
     D                 PR                         like(LOG4RPG_priority_t    )
     D                                     extproc('LOG4RPG09+
     D                                     _Level_toInt+
     D                                     ')
     D  i_level                            const  like(LOG4RPG_level_t       )
      *
      *  Converts the integer passed as argument to a string level.
     D Level_toString...
     D                 PR                         like(LOG4RPG_level_t       )
     D                                     extproc('LOG4RPG09+
     D                                     _Level_toString+
     D                                     ')
     D  i_level                            const  like(LOG4RPG_priority_t    )
      *
      /ENDIF
