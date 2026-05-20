**FREE
/IF NOT DEFINED(PLOG4RPG18)
/DEFINE PLOG4RPG18
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/COPY QLOG4RPG,PLOG4RPG17                    Filter
//
dcl-s LOG4RPG_pFilterList_t
      pointer based(pDummy);
//
dcl-ds LOG4RPG_FilterListIterator_t
       qualified               based(pDummy);
  pFltList        like(LOG4RPG_pFilterList_t );
  lastFlt         int(10);
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
//  Creates a new filter list.
dcl-pr FilterList_new
       like(LOG4RPG_pFilterList_t )
       extproc('LOG4RPG18+
       _FilterList_new+
       ');
end-pr;
//
//  Returns the number of entries in a given filter list.
dcl-pr FilterList_getNumE
       int(10)
       extproc('LOG4RPG18+
       _FilterList_NumE+
       ');
  i_pFltList      const  like(LOG4RPG_pFilterList_t );
end-pr;
//
//  Adds an filter to a given filter list.
dcl-pr FilterList_put
       int(10)
       extproc('LOG4RPG18+
       _FilterList_put+
       ');
  i_pFltList      const  like(LOG4RPG_pFilterList_t );
  i_pFilter       const  like(LOG4RPG_pFilter_t     );
end-pr;
//
//  Removes the specified filter from the given filter list.
dcl-pr FilterList_remove
       int(10)
       extproc('LOG4RPG18+
       _FilterList_remove+
       ');
  i_pFltList      const  like(LOG4RPG_pFilterList_t );
  i_fltName       const  like(LOG4RPG_filterName_t  );
end-pr;
//
//  Returns the filter that matches the specified name.
dcl-pr FilterList_get
       like(LOG4RPG_pFilter_t     )
       extproc('LOG4RPG18+
       _FilterList_get+
       ');
  i_pFltList      const  like(LOG4RPG_pFilterList_t );
  i_fltName       const  like(LOG4RPG_filterName_t  );
end-pr;
//
//  Tests, if the filter list contains the specified filter.
dcl-pr FilterList_exist
       ind
       extproc('LOG4RPG18+
       _FilterList_exist+
       ');
  i_pFltList      const  like(LOG4RPG_pFilterList_t );
  i_fltName       const  like(LOG4RPG_filterName_t  );
end-pr;
//
//  Returns an iterator for the specified filter list.
dcl-ds FilterList_getIterator...
       PR                  likeds(LOG4RPG_Filter
ListIterator_t   )
extproc('LOG4RPG18+
_FilterList_getIterator+
');
i_pFltList      const  like(LOG4RPG_pFilterList_t );
end-ds;
//
//  Returns the first filter of the specified filter list.
dcl-pr FilterList_getFirst
       like(LOG4RPG_pFilter_t     )
       extproc('LOG4RPG18+
       _FilterList_getFirst+
       ');
  io_fltIter      likeds(LOG4RPG_Filter...
ListIterator_t);
end-pr;
//
//  Returns the next filter of the specified filter list.
dcl-pr FilterList_getNext
       like(LOG4RPG_pFilter_t     )
       extproc('LOG4RPG18+
       _FilterList_getNext+
       ');
  io_fltIter      likeds(LOG4RPG_Filter...
ListIterator_t);
end-pr;
//
//  Deletes a given filter list.
dcl-pr FilterList_delete
       ind
       extproc('LOG4RPG18+
       _FilterList_delete+
       ');
  io_pFltList     like(LOG4RPG_pFilterList_t );
end-pr;
//
//  Test the specified filter list object for a NULL value.
dcl-pr FilterList_isNull
       ind
       extproc('LOG4RPG18+
       _FilterList_isNull+
       ');
  i_pFltList      const  like(LOG4RPG_pFilterList_t );
end-pr;
//
//  Returns a NULL filter list.
dcl-pr FilterList_null
       like(LOG4RPG_pFilterList_t )
       extproc('LOG4RPG18+
       _FilterList_null+
       ');
end-pr;
//
/ENDIF
