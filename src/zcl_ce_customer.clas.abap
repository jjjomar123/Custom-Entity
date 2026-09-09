CLASS zcl_ce_customer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_ce_customer IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    DATA: lt_customer_data TYPE STANDARD TABLE OF zi_ce_customer.

    IF io_request->is_data_requested( ).

      " Get the requested fields
      DATA(lt_requested_fields) = io_request->get_requested_elements( ).

      DATA(lv_top)     = io_request->get_paging( )->get_page_size( ).
      IF lv_top <= 0. lv_top = 1. ENDIF.

      DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).

      DATA(lt_sort)    = io_request->get_sort_elements( ).

      DATA : lv_orderby TYPE string.
      LOOP AT lt_sort INTO DATA(ls_sort).
        IF ls_sort-descending = abap_true.
          lv_orderby = |{ lv_orderby } { ls_sort-element_name } DESCENDING |.
        ELSE.
          lv_orderby = |{ lv_orderby } { ls_sort-element_name } ASCENDING |.
        ENDIF.
      ENDLOOP.
      IF lv_orderby IS INITIAL.
        lv_orderby = 'CUSTOMERID'.
      ENDIF.

      DATA(lv_conditions) =  io_request->get_filter( )->get_as_sql_string( ).

*    Total number of records
      IF io_request->is_total_numb_of_rec_requested( ).

        IF lv_conditions IS INITIAL.

          SELECT COUNT( * )
            FROM /dmo/customer
            INTO @DATA(lv_records).

        ELSE.

          SELECT COUNT( * )
            FROM /DMO/I_Customer
            WHERE (lv_conditions)
            INTO @lv_records.

        ENDIF.
      endif.

      " Select: no alias for the main view (to keep filter simple), aliases only for joined texts
      IF lv_conditions IS INITIAL.
        SELECT FROM /DMO/I_Customer
               INNER JOIN I_Country     AS Country ON /DMO/I_Customer~CountryCode = Country~Country
               INNER JOIN I_CountryText AS CText   ON Country~Country = CText~Country
                                                  AND CText~Language = @sy-langu
               FIELDS
                 /DMO/I_Customer~CustomerID,
                 /DMO/I_Customer~FirstName,
                 /DMO/I_Customer~LastName,
                 concat_with_space( /DMO/I_Customer~FirstName, /DMO/I_Customer~LastName, 1 ) AS FullName,
                 /DMO/I_Customer~Street,
                 /DMO/I_Customer~PostalCode,
                 /DMO/I_Customer~City,
                 CText~CountryName AS Country,
                 /DMO/I_Customer~PhoneNumber,
                 /DMO/I_Customer~EmailAddress
          ORDER BY (lv_orderby)
          INTO CORRESPONDING FIELDS OF TABLE @lt_customer_data
          UP TO @lv_top ROWS OFFSET @lv_skip.
      ELSE.
        SELECT FROM /DMO/I_Customer
               INNER JOIN I_Country     AS Country ON /DMO/I_Customer~CountryCode = Country~Country
               INNER JOIN I_CountryText AS CText   ON Country~Country = CText~Country
                                                  AND CText~Language = @sy-langu
               FIELDS
                 /DMO/I_Customer~CustomerID,
                 /DMO/I_Customer~FirstName,
                 /DMO/I_Customer~LastName,
                 concat_with_space( /DMO/I_Customer~FirstName, /DMO/I_Customer~LastName, 1 ) AS FullName,
                 /DMO/I_Customer~Street,
                 /DMO/I_Customer~PostalCode,
                 /DMO/I_Customer~City,
                 CText~CountryName AS Country,
                 /DMO/I_Customer~PhoneNumber,
                 /DMO/I_Customer~EmailAddress
          WHERE (lv_conditions)               " only when not initial
          ORDER BY (lv_orderby)
          INTO CORRESPONDING FIELDS OF TABLE @lt_customer_data
          UP TO @lv_top ROWS OFFSET @lv_skip.
      ENDIF.

      io_response->set_total_number_of_records( lv_records ).
      io_response->set_data( lt_customer_data ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
