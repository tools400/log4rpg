      /IF NOT DEFINED(PTYPES)
      /DEFINE PTYPES
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      *
      /COPY QLOG4RPG,PLOG4RPG01                    Logger
      /COPY QLOG4RPG,PLOG4RPG04                    AppenderList
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
     D cROOT_LOGGER...
     D                 C                   const('root')
      *
      /IF NOT DEFINED(cTrue)
      /DEFINE cTrue
     D cTrue           C                   const(*on )
      /ENDIF
      *
      /IF NOT DEFINED(cFalse)
      /DEFINE cFalse
     D cFalse          C                   const(*off)
      /ENDIF
      *
      * -----------------------------------------
      *  Internal type definitions
      * -----------------------------------------
      *
     D LOG4RPG_logger_t...
     D                 DS                  qualified               based(pDummy)
     D  node                         10I 0
     D  pParent                        *
     D  name                               like(LOG4RPG_loggerName_t    )
     D  priority                           like(LOG4RPG_priority_t      )
     D  pAppenderList                      like(LOG4RPG_pAppenderList_t )
     D  pChildren                          like(BasicList_handle_t      )
      *
     D LOG4RPG_procedure_t...
     D                 S            128A   varying                 based(pDummy)
      *
      /ENDIF
