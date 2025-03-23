      /IF NOT DEFINED(PTYPES)
      /DEFINE PTYPES
      *
      * =========================================
      *  Defines internal used type templates
      * =========================================
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /DEFINE TYPES_ONLY
      /COPY QLOG4RPG,PLOG4RPG                      Public API Specification
      /COPY QLOG4RPG,PLOG4RPG04                    AppenderList
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
     D cROOT_LOGGER...
     D                 C                   'root'
      *
      /IF NOT DEFINED(cTrue)
      /DEFINE cTrue
     D cTrue           C                   *on
      /ENDIF
      *
      /IF NOT DEFINED(cFalse)
      /DEFINE cFalse
     D cFalse          C                   *off
      /ENDIF
      *
      * -----------------------------------------
      *  Internal type definitions
      * -----------------------------------------
      *
     D LOG4RPG_formattedText_t...
     D                 S           4096A   varying template
      *
     D LOG4RPG_footer_t...
     D                 S                   like(LOG4RPG_header_t)
     D                                     template
      *
     D LOG4RPG_header_t...
     D                 S           4096A   varying template
      *
     D LOG4RPG_logger_t...
     D                 DS                  qualified template
     D  node                         10I 0
     D  pParent                        *
     D  name                               like(LOG4RPG_loggerName_t    )
     D  priority                           like(LOG4RPG_priority_t      )
     D  pAppenderList                      like(LOG4RPG_pAppenderList_t )
     D  pChildren                          like(BasicList_handle_t      )
      *
     D LOG4RPG_priority_t...
     D                 S             10I 0 template
      *
     D LOG4RPG_procedure_t...
     D                 S            128A   varying template
      *
     D LOG4RPG_qJob_t  DS                  qualified template
     D  name                         10A
     D  user                         10A
     D  nbr                           6A                                          *
      *
      /ENDIF
