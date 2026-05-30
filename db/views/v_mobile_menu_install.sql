-- =============================================================================
-- V_MOBILE_MENU  —  Mobiel startscherm voor SCAFF APP
-- =============================================================================
-- Gebruikt door APEX Cards region op (toekomstige) mobile home page.
-- Kolommen zijn afgestemd op standaard APEX Cards bindings.
-- =============================================================================
create or replace view V_MOBILE_MENU
( CARD_ID
, DISPLAY_SEQUENCE
, TITLE_KEY
, SUBTITLE_KEY
, CARD_ICON
, CARD_ICON_COLOR
, CARD_LINK
, CARD_CSS_CLASSES
) as
select 1                                          as card_id
     , 10                                         as display_sequence
     , 'SCAFF.MENU.MATERIAAL.TITLE'               as title_key
     , 'SCAFF.MENU.MATERIAAL.SUBTITLE'            as subtitle_key
     , 'fa-robot'                                 as card_icon
     , 'altrad-red'                               as card_icon_color
     , 'f?p=100:10::::::' as card_link
     , 'mobile-card mobile-card--materiaal'       as card_css_classes
  from dual
union all
select 2
     , 20
     , 'SCAFF.MENU.RETOUR.TITLE'
     , 'SCAFF.MENU.RETOUR.SUBTITLE'
     , 'fa-undo'
     , 'altrad-red'
     , 'f?p=100:20::::::'
     , 'mobile-card mobile-card--retour'
  from dual
union all
select 3
     , 30
     , 'SCAFF.MENU.TRANSFER.TITLE'
     , 'SCAFF.MENU.TRANSFER.SUBTITLE'
     , 'fa-truck'
     , 'altrad-red'
     , 'f?p=100:30::::::'
     , 'mobile-card mobile-card--transfer'
  from dual
union all
select 4
     , 40
     , 'SCAFF.MENU.AANVRAGEN.TITLE'
     , 'SCAFF.MENU.AANVRAGEN.SUBTITLE'
     , 'fa-list-check'
     , 'altrad-red'
     , 'f?p=100:50::::::'
     , 'mobile-card mobile-card--aanvragen'
  from dual
;

comment on table  V_MOBILE_MENU                  is 'Mobiel startmenu — 3 cards. Titels via apex_lang text messages.';
comment on column V_MOBILE_MENU.CARD_ID          is 'Stabiele ID (1=Materiaal, 2=Retour, 3=Transfer, 4=Aanvragen).';
comment on column V_MOBILE_MENU.DISPLAY_SEQUENCE is 'Sorteervolgorde.';
comment on column V_MOBILE_MENU.TITLE_KEY        is 'APEX text message key voor card title.';
comment on column V_MOBILE_MENU.SUBTITLE_KEY     is 'APEX text message key voor card subtitle.';
comment on column V_MOBILE_MENU.CARD_ICON        is 'Font APEX icon class.';
comment on column V_MOBILE_MENU.CARD_ICON_COLOR  is 'CSS klasse voor icon kleur (altrad-red).';
comment on column V_MOBILE_MENU.CARD_LINK        is 'APEX f?p= link.';
comment on column V_MOBILE_MENU.CARD_CSS_CLASSES is 'Extra CSS classes voor card.';