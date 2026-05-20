**free
/if NOT DEFINED(PTYPES)
/define PTYPES

// =========================================
//  Defines internal used type templates
// =========================================
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/define TYPES_ONLY
/copy QLOG4RPG,PLOG4RPG                      Public API Specification
/copy QLOG4RPG,PLOG4RPG04                    AppenderList

// -----------------------------------------
//  Constants
// -----------------------------------------
dcl-c cROOT_LOGGER 'root';

// @deprecated, use *on instead
/if NOT DEFINED(cTrue)
/define cTrue
dcl-c cTrue *on;
/endif

// @deprecated, use *off instead
/if NOT DEFINED(cFalse)
/define cFalse
dcl-c cFalse *off;
/endif

// -----------------------------------------
//  Internal type definitions
// -----------------------------------------

dcl-s LOG4RPG_formattedText_t varchar(4096) template;

dcl-s LOG4RPG_footer_t like(LOG4RPG_header_t) template;

dcl-s LOG4RPG_header_t varchar(4096) template;

dcl-ds LOG4RPG_logger_t qualified template;
  node          int(10);
  pParent       pointer;
  name          like(LOG4RPG_loggerName_t);
  priority      like(LOG4RPG_priority_t);
  pAppenderList like(LOG4RPG_pAppenderList_t);
  pChildren     like(BasicList_handle_t);
end-ds;

dcl-s LOG4RPG_priority_t int(10) template;

dcl-s LOG4RPG_procedure_t varchar(128) template;

dcl-ds LOG4RPG_qJob_t qualified template;
  name char(10);
  user char(10);
  nbr  char(6); //   *
end-ds;

/endif
