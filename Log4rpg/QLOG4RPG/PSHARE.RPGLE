      /IF NOT DEFINED(PSHARE)
      /DEFINE PSHARE
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG                      Public interface & type definitions
      /COPY QLOG4RPG,PLOG4RPG06                    Property
      /COPY QLOG4RPG,PLOG4RPG07                    PropertyList
      /COPY QLOG4RPG,PLOG4RPG03                    Appender
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
      /COPY QLOG4RPG,PLOG4RPG11                    Layout
      /COPY QLOG4RPG,PLOG4RPG16                    LogEvent
      /COPY QLOG4RPG,PLOG4RPG17                    Filter
      /COPY QLOG4RPG,PLOG4RPG99                    Helper
      *
      * -----------------------------------------
      *   Type definitions shared with
      *   appenders & layouts
      * -----------------------------------------
      *
     D LOG4RPG_prefix_t...
     D                 S            128A   varying                 based(pDummy)
      *
      /ENDIF
