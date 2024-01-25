*&---------------------------------------------------------------------*
*& Include          ZISSUE_HIERARCHY_DD
*&---------------------------------------------------------------------*

TABLES: ekko.

TYPES: BEGIN OF ty_ekko,
         ebeln TYPE ebeln,
         bukrs TYPE bukrs,
         aedat TYPE erdat,
         ernam TYPE ernam,
         lifnr TYPE lifnr,
         bedat TYPE bedat,
         ekorg TYPE ekorg,
         ekgrp TYPE ekgrp,
       END OF ty_ekko,

       BEGIN OF ty_ekpo,
         ebeln TYPE ebeln,
         ebelp TYPE ebelp,
         matnr TYPE matnr,
         werks TYPE ewerk,
       END OF ty_ekpo,

       BEGIN OF ty_lfa1,
         lifnr TYPE lifnr,
         land1 TYPE land1_gp,
         name1 TYPE name1_gp,
         ort01 TYPE ort01_gp,
       END OF ty_lfa1,

       BEGIN OF ty_fields,
         name(10) TYPE c,
       END OF ty_fields.


DATA: gt_ekko      TYPE TABLE OF ty_ekko,
      gt_ekpo      TYPE TABLE OF ty_ekpo,
      gtab_ekko    TYPE TABLE OF ty_ekko,
      gt_lfa1      TYPE TABLE OF ty_lfa1,
      lt_ekko      TYPE TABLE OF ty_ekko,
      lt_ekpo      TYPE TABLE OF ty_ekpo,
      lt_lfa1      TYPE TABLE OF ty_lfa1,
      gt_po_fields TYPE TABLE OF ty_fields,
      gt_ve_fields TYPE TABLE OF ty_fields,
      gwa_ekko     TYPE ty_ekko,
      gwa_ekpo     TYPE ty_ekpo,
      gwa_lfa1     TYPE ty_lfa1,
      wa_ekko      TYPE ty_ekko,
      gv_path      TYPE string,
      gv_ftype     TYPE char10.
