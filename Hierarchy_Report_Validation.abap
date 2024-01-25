*&---------------------------------------------------------------------*
*& Include          ZISSUE_HIERARCHY_VALIDATION
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form getdata
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM getdata.
**********************************************************************
*************Fetching Purchase Order Header data *********************
**********************************************************************
  SELECT ebeln, bukrs, aedat, ernam, lifnr, bedat, ekorg, ekgrp
  INTO TABLE @lt_ekko
  FROM ekko
  WHERE ebeln IN @s_ebeln.

**********************************************************************
*************Fetching Purchase Order Items Data***********************
**********************************************************************
  IF lt_ekko[] IS NOT INITIAL.
    SELECT ebeln,ebelp,matnr,werks
      INTO TABLE @lt_ekpo
      FROM ekpo
      FOR ALL ENTRIES IN @lt_ekko
      WHERE ebeln = @lt_ekko-ebeln.
  ENDIF.

**********************************************************************
********************Fetching Vendor Data******************************
**********************************************************************
  IF lt_ekpo[] IS NOT INITIAL.
    SELECT lifnr,land1,name1,ort01
      INTO TABLE @lt_lfa1
      FROM lfa1
      FOR ALL ENTRIES IN @lt_ekko
      WHERE lifnr = @lt_ekko-lifnr.
  ENDIF.


****Looping Purchase Order Header Data.
  LOOP AT lt_ekko INTO DATA(wa_ekko).
    gwa_ekko-ebeln = wa_ekko-ebeln.
    gwa_ekko-bukrs = wa_ekko-bukrs.
    gwa_ekko-aedat = wa_ekko-aedat.
    gwa_ekko-ernam = wa_ekko-ernam.
    gwa_ekko-lifnr = wa_ekko-lifnr.
    gwa_ekko-bedat = wa_ekko-bedat.
    gwa_ekko-ekorg = wa_ekko-ekorg.
    gwa_ekko-ekgrp = wa_ekko-ekgrp.

****appending record level PO data to Internal table.
    APPEND gwa_ekko TO gt_ekko.

****Clearing Work areas.
    CLEAR: wa_ekko, gwa_ekko.

  ENDLOOP.
***************End loop.*****************

****check Loop has executed atleast Once.
  IF sy-subrc = 0.

****Local Decleration.
    DATA: lt_fcat  TYPE TABLE OF slis_fieldcat_alv,
          lv_count TYPE i VALUE 0.

****Field Catalogue for Purcahse Order Header Data.
    ADD 1 TO lv_count.
    APPEND VALUE #( col_pos = lv_count fieldname = 'EBELN' seltext_m = 'PO Document number' key = 'X') TO lt_fcat.
    ADD 1 TO lv_count.
    APPEND VALUE #( col_pos = lv_count fieldname = 'BUKRS' seltext_m = 'Comapnt code') TO lt_fcat.
    ADD 1 TO lv_count.
    APPEND VALUE #( col_pos = lv_count fieldname = 'AEDAT' seltext_m = 'Created On') TO lt_fcat.
    ADD 1 TO lv_count.
    APPEND VALUE #( col_pos = lv_count fieldname = 'ERNAM' seltext_m = 'Created By') TO lt_fcat.
    ADD 1 TO lv_count.
    APPEND VALUE #( col_pos = lv_count fieldname = 'LIFNR' seltext_m = 'Vendor Number') TO lt_fcat.
    ADD 1 TO lv_count.
    APPEND VALUE #( col_pos = lv_count fieldname = 'BEDAT' seltext_m = 'PO Date') TO lt_fcat.
    ADD 1 TO lv_count.
    APPEND VALUE #( col_pos = lv_count fieldname = 'EKORG' seltext_m = 'Purchase Org.') TO lt_fcat.
    ADD 1 TO lv_count.
    APPEND VALUE #( col_pos = lv_count fieldname = 'EKGRP' seltext_m = 'Purchase Group') TO lt_fcat.

****Calling ALV Grid for Purchase Order data.
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program      = sy-repid
        i_callback_user_command = 'UCOMM'
        i_callback_top_of_page  = 'TOP_OF_PAGE_PO_HEADER'
        it_fieldcat             = lt_fcat
      TABLES
        t_outtab                = gt_ekko
      EXCEPTIONS
        program_error           = 1
        OTHERS                  = 2.

  ENDIF.

ENDFORM.

********************************************************************
*****Usercommand for picking PO Header, which fetches PO Lines******
********************************************************************
FORM ucomm USING action LIKE sy-ucomm
                         index TYPE slis_selfield.

****Check whether User command function key.
  IF action EQ '&IC1'.

****Reading PO document Number into Work area.
    READ TABLE gt_ekko INTO DATA(wa_ucom_ekko) INDEX index-tabindex.
    IF sy-subrc = 0.
      wa_ekko = wa_ucom_ekko.
****Looping PO Line Item Data, by picking Purchase Document Number from EKKO.
      LOOP AT lt_ekpo INTO DATA(wa_ekpo) WHERE ebeln = wa_ucom_ekko-ebeln.
        gwa_ekpo-ebeln = wa_ekpo-ebeln.
        gwa_ekpo-ebelp = wa_ekpo-ebelp.
        gwa_ekpo-matnr = wa_ekpo-matnr.
        gwa_ekpo-werks = wa_ekpo-werks.

****appending Record level data to Internal table.
        APPEND gwa_ekpo TO gt_ekpo.

****Clearing work areas.
        CLEAR:wa_ekpo,gwa_ekpo.
      ENDLOOP.

      IF sy-subrc = 0.
****Field Catalogue for Purchase Order Line Items.
        DATA: lt_fcat1  TYPE TABLE OF slis_fieldcat_alv,
              lv_count1 TYPE i VALUE 0.

        ADD 1 TO lv_count1.
        APPEND VALUE #( col_pos = lv_count1 fieldname = 'EBELN' tabname = 'LT_HEAD' seltext_m = 'PO Document number' key = 'X') TO lt_fcat1.
        ADD 1 TO lv_count1.
        APPEND VALUE #( col_pos = lv_count1 fieldname = 'BUKRS' tabname = 'LT_HEAD' seltext_m = 'Comapany code') TO lt_fcat1.
        ADD 1 TO lv_count1.
        APPEND VALUE #( col_pos = lv_count1 fieldname = 'AEDAT' tabname = 'LT_HEAD' seltext_m = 'PO Change Date') TO lt_fcat1.
        ADD 1 TO lv_count1.
        APPEND VALUE #( col_pos = lv_count1 fieldname = 'ERNAM' tabname = 'LT_HEAD' seltext_m = 'Created By') TO lt_fcat1.
        ADD 1 TO lv_count1.
        APPEND VALUE #( col_pos = lv_count1 fieldname = 'LIFNR' tabname = 'LT_HEAD' seltext_m = 'Vendor Id') TO lt_fcat1.
        ADD 1 TO lv_count1.
        APPEND VALUE #( col_pos = lv_count1 fieldname = 'BEDAT' tabname = 'LT_HEAD' seltext_m = 'Document Daate') TO lt_fcat1.
        ADD 1 TO lv_count1.
        APPEND VALUE #( col_pos = lv_count1 fieldname = 'EKORG' tabname = 'LT_HEAD' seltext_m = 'Purchase Org.') TO lt_fcat1.
        ADD 1 TO lv_count1.
        APPEND VALUE #( col_pos = lv_count1 fieldname = 'EKGRP' tabname = 'LT_HEAD' seltext_m = 'Purchase Group') TO lt_fcat1.
        ADD 1 TO lv_count1.
        APPEND VALUE #( col_pos = lv_count1 fieldname = 'EBELN' tabname = 'LT_ITEM' seltext_m = 'PO Document number') TO lt_fcat1.
        ADD 1 TO lv_count1.
        APPEND VALUE #( col_pos = lv_count1 fieldname = 'EBELP' tabname = 'LT_ITEM' seltext_m = 'PO Item number') TO lt_fcat1.
        ADD 1 TO lv_count1.
        APPEND VALUE #( col_pos = lv_count1 fieldname = 'MATNR' tabname = 'LT_ITEM' seltext_m = 'Material Number') TO lt_fcat1.
        ADD 1 TO lv_count1.
        APPEND VALUE #( col_pos = lv_count1 fieldname = 'WERKS' tabname = 'LT_ITEM' seltext_m = 'Plant') TO lt_fcat1.


****Key Information.
        DATA: wa_keyinfo TYPE slis_keyinfo_alv.
        wa_keyinfo-header01 = 'EBELN'.
        wa_keyinfo-item01 = 'EBELN'.

****Get Events.
        DATA: lt_events TYPE TABLE OF slis_alv_event.

        CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
          EXPORTING
            i_list_type     = 1
          IMPORTING
            et_events       = lt_events
          EXCEPTIONS
            list_type_wrong = 1
            OTHERS          = 2.

        IF sy-subrc EQ 0.
          READ TABLE lt_events INTO DATA(wa_events) INDEX 3.
          IF sy-subrc = 0.
            wa_events-form = 'TOP_OF_PAGE'.
            MODIFY lt_events FROM wa_events INDEX 3.
            CLEAR: wa_events.
          ENDIF.

        ENDIF.


****Calling Interactive Hierarchy Report.
        DATA: lt_head TYPE TABLE OF slis_tabname,
              lt_item TYPE TABLE OF slis_tabname.


        APPEND wa_ucom_ekko TO gtab_ekko.

        IF lt_fcat1 IS NOT INITIAL.
          CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
            EXPORTING
              i_callback_program      = sy-repid
              i_callback_user_command = 'UCOMM1'
              it_fieldcat             = lt_fcat1
              i_tabname_header        = 'LT_HEAD'
              i_tabname_item          = 'LT_ITEM'
              is_keyinfo              = wa_keyinfo
              it_events               = lt_events
            TABLES
              t_outtab_header         = gtab_ekko
              t_outtab_item           = gt_ekpo
            EXCEPTIONS
              program_error           = 1
              OTHERS                  = 2.

          IF sy-subrc EQ 0 AND rb_1 EQ abap_true.

            gv_path = 'Desktop\PO-Report.xls'.
            gv_ftype = 'DAT'.
            PERFORM gui_download USING gv_path gv_ftype.
            CLEAR:gv_path,gv_ftype.

          ELSEIF sy-subrc EQ 0 AND rb_2 EQ abap_true.
            gv_path = 'Desktop\PO-Report.txt'.
            gv_ftype = 'ASC'.
            PERFORM gui_download USING gv_path gv_ftype.
            CLEAR:gv_path,gv_ftype.

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    CLEAR: wa_ucom_ekko.
  ENDIF.
ENDFORM.

*******************************************************************
*****Usercommand for picking PO Number, which fetches Invoice******
*******************************************************************
FORM ucomm1 USING action1 LIKE sy-ucomm
                         index1 TYPE slis_selfield.

  IF action1 EQ '&IC1'.

****Read Vendor Id from PO Header tale.
    READ TABLE gtab_ekko INTO DATA(wa_ucom_ekko1) INDEX index1-tabindex.
    IF sy-subrc EQ 0 AND wa_ucom_ekko1-lifnr IS NOT INITIAL.
      wa_ekko = wa_ucom_ekko1.
****Looping on PO Header to pick Vendor Id for Vendor data.
      LOOP AT lt_lfa1 INTO DATA(wa_vendor) WHERE lifnr = wa_ucom_ekko1-lifnr.
        gwa_lfa1-lifnr = wa_vendor-lifnr.
        gwa_lfa1-land1 = wa_vendor-land1.
        gwa_lfa1-name1 = wa_vendor-name1.
        gwa_lfa1-ort01 = wa_vendor-ort01.

****Appending record level vendor data to Internal table.
        APPEND gwa_lfa1 TO gt_lfa1.

****Clearing Internal tables and Work area.
        CLEAR: wa_vendor,gwa_lfa1.
      ENDLOOP.

****On successfull Execution of Loop statement.
      IF sy-subrc = 0.

****Field Catalogue for Vendor Report.
        DATA: lt_fcat2  TYPE TABLE OF slis_fieldcat_alv,
              lv_count2 TYPE i VALUE 0.


        ADD 1 TO lv_count2.
        APPEND VALUE #( col_pos = lv_count2 fieldname = 'LIFNR' seltext_m = 'Vendor Number' key = 'X') TO lt_fcat2.
        ADD 1 TO lv_count2.
        APPEND VALUE #( col_pos = lv_count2 fieldname = 'LAND1' seltext_m = 'Country Code') TO lt_fcat2.
        ADD 1 TO lv_count2.
        APPEND VALUE #( col_pos = lv_count2 fieldname = 'NAME1' seltext_m = 'Vendor Name') TO lt_fcat2.
        ADD 1 TO lv_count2.
        APPEND VALUE #( col_pos = lv_count2 fieldname = 'ORT01' seltext_m = 'Vendor City') TO lt_fcat2.

        CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
          EXPORTING
            i_callback_program     = sy-repid
            i_callback_top_of_page = 'TOP_OF_PAGE_VENDOR'
            it_fieldcat            = lt_fcat2
          TABLES
            t_outtab               = gt_lfa1
          EXCEPTIONS
            program_error          = 1
            OTHERS                 = 2.

****Check what type of file has to be downloaded.
        IF sy-subrc EQ 0 AND rb_1 EQ abap_true.

          gv_path = 'Desktop\Vendor_Report.xls'.
          gv_ftype = 'DAT'.
          PERFORM gui_download_vendor USING gv_path gv_ftype.
          CLEAR:gv_path,gv_ftype.

        ELSEIF sy-subrc EQ 0 AND rb_2 EQ abap_true.
          gv_path = 'Desktop\Vendor_Report.txt'.
          gv_ftype = 'ASC'.
          PERFORM gui_download_vendor USING gv_path gv_ftype.
          CLEAR:gv_path,gv_ftype.

        ENDIF.


      ENDIF.
    ELSEIF sy-subrc EQ 0 AND wa_ucom_ekko1-lifnr IS INITIAL.
      DATA: lv_msg TYPE string.
      lv_msg = |No Vendor-Id Picked for PO number: | & |{ wa_ucom_ekko1-ebeln }| & |. Choose PO Number which has Vendor-Id to navigate to Vendor Report.|.
      MESSAGE lv_msg TYPE 'I'.
      CLEAR: lv_msg.
    ENDIF.
  ENDIF.

ENDFORM.


*******************************************************************
******Top Of Page For Interactive - ALV Report for PO Header*******
*******************************************************************
FORM top_of_page_po_header.
****Local Decleration.
  DATA: lt_header TYPE TABLE OF slis_listheader,
        wa_header TYPE slis_listheader.

****Heading for Header.
  wa_header-typ = 'H'.
  wa_header-info = 'Purchase Order Header Details'.
  APPEND wa_header TO lt_header.

****Report Type in Heading.
  wa_header-typ = 'S'.
  wa_header-key = 'Report Type: '.
  wa_header-info = |Interactive - ALV Report|.
  APPEND wa_header TO lt_header.

****Username in Heading.
  wa_header-typ = 'S'.
  wa_header-key = 'Username: '.
  wa_header-info = sy-uname.
  APPEND wa_header TO lt_header.

****Report Created date in Heading.
  wa_header-typ = 'S'.
  wa_header-key = 'Date: '.

  DATA(lv_year) = sy-datum+0(4).
  DATA(lv_month) = sy-datum+4(2).
  DATA(lv_day) = sy-datum+6(2).

  wa_header-info = |{ lv_day }| & |/| & |{ lv_month }| & |/| & |{ lv_year }|.
  APPEND wa_header TO lt_header.

  CLEAR: lv_year,lv_month,lv_day.

****Calling Commentry write for Heading and Logo.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_header
      i_logo             = 'POLOGO'.

ENDFORM.



*******************************************************************
****Event Call For Interactive - Hierarchy Report for PO Header****
*******************************************************************
FORM top_of_page.

****Local Decleration.
  DATA: lt_comlist TYPE TABLE OF slis_listheader,
        wa_comlist TYPE slis_listheader.

****Purchase Order Items Heading for Hierarchy Report.
  wa_comlist-typ = 'H'.
  wa_comlist-info = 'Purchase Order Item Details'.
  APPEND wa_comlist TO lt_comlist.

****Clearing work area.
  CLEAR:wa_comlist.

****PO Number.
  wa_comlist-typ = 'S'.
  wa_comlist-key = 'Purchse Order Number: '.
  wa_comlist-info = wa_ekko-ebeln.
  APPEND wa_comlist TO lt_comlist.

****Clearing work area.
  CLEAR:wa_comlist.

****Username for Hierarchy report.
  wa_comlist-typ = 'S'.
  wa_comlist-key = 'Username: '.
  wa_comlist-info = sy-uname.
  APPEND wa_comlist TO lt_comlist.

****Clearing work area.
  CLEAR:wa_comlist.

****Report Date for Hierarchy report.
  wa_comlist-typ = 'S'.
  wa_comlist-key = 'Date: '.
  DATA(lv_year) = sy-datum+0(4).
  DATA(lv_month) = sy-datum+4(2).
  DATA(lv_day) = sy-datum+6(2).

  wa_comlist-info = |{ lv_day }| & |/| & |{ lv_month }| & |/| & |{ lv_year }|.
  APPEND wa_comlist TO lt_comlist.

****Clearing work area and variables.
  CLEAR: lv_year,lv_month,lv_day,wa_comlist.

****Calling Commentr write for Heading and Logo for Interactive - Hierarchy Report.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_comlist
      i_logo             = 'POILOGO'. "Doesn't work for Hierarchy report.

****Clearing work area.
  IF sy-subrc = 0.
    CLEAR:  wa_ekko.
  ENDIF.

ENDFORM.

*******************************************************************
*******Top Of Page For Interactive - ALV Report for Vendor ID******
*******************************************************************
FORM top_of_page_vendor.

  DATA:lt_comvend TYPE TABLE OF slis_listheader,
       wa_comvend TYPE slis_listheader.

****Heading for ALV report.
  wa_comvend-typ = 'H'.
  wa_comvend-info = 'Vendor Details'.

  APPEND wa_comvend TO lt_comvend.
****Clearing work area and variables.
  CLEAR:wa_comvend.

****PO Number for ALV report.
  wa_comvend-typ = 'S'.
  wa_comvend-key = 'Purchase Order Number: '.
  wa_comvend-info = wa_ekko-ebeln.

  APPEND wa_comvend TO lt_comvend.
****Clearing work area and variables.
  CLEAR:wa_comvend.

****Vendor ID for ALV report.
  wa_comvend-typ = 'S'.
  wa_comvend-key = 'Vendor Number: '.
  wa_comvend-info = wa_ekko-lifnr.

  APPEND wa_comvend TO lt_comvend.
****Clearing work area and variables.
  CLEAR:wa_comvend.

****Creation Date for ALV report.
  wa_comvend-typ = 'S'.
  wa_comvend-key = 'Date: '.
  DATA(lv_year) = sy-datum+0(4).
  DATA(lv_month) = sy-datum+4(2).
  DATA(lv_day) = sy-datum+6(2).

  wa_comvend-info = |{ lv_day }| & |/| & |{ lv_month }| & |/| & |{ lv_year }|.
  APPEND wa_comvend TO lt_comvend.

****Clearing work area and variables.
  CLEAR: wa_comvend, lv_day,lv_month,lv_year.

****Calling Commentr write for Heading and Logo for ALV Report.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_comvend
      i_logo             = 'VENDOR'.

****Clearing work area.
  IF sy-subrc = 0.
    CLEAR:wa_ekko.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form gui_download for Purchase Order Item Details.
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GV_PATH
*&      --> GV_FTYPE
*&---------------------------------------------------------------------*
FORM gui_download  USING    p_gv_path
                            p_gv_ftype.

****Header for Downloaded file.
  gt_po_fields =  VALUE #( ( name = 'EBELN' )
                  ( name = 'EBELP' )
                  ( name = 'MATNR' )
                  ( name = 'WERKS' ) ).


****Call Function for Downloading Purchase order Report.
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = p_gv_path
      filetype                = p_gv_ftype
    TABLES
      data_tab                = gt_ekpo
      fieldnames              = gt_po_fields
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.

****Success message upon downloaded successfully.
  IF sy-subrc EQ 0.
    MESSAGE 'Purchase Order file downloaded' TYPE 'S'.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form gui_download_vendor
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GV_PATH
*&      --> GV_FTYPE
*&---------------------------------------------------------------------*
FORM gui_download_vendor  USING    p_gv_path
                                   p_gv_ftype.

****Header for Downloaded file.
  gt_ve_fields =  VALUE #( ( name = 'LIFNR' )
                  ( name = 'LAND1' )
                  ( name = 'NAME1' )
                  ( name = 'ORT01' ) ).

****Call function for Vendor Data Report.
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = p_gv_path
      filetype                = p_gv_ftype
      header                  = '00'
    TABLES
      data_tab                = gt_lfa1
      fieldnames              = gt_ve_fields
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.

****Success message upon downloaded successfully.
  IF sy-subrc EQ 0.
    MESSAGE 'Vendor Report file downloaded.' TYPE 'S'.
  ENDIF.

ENDFORM.
