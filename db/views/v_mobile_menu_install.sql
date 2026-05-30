set define off
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
select 1, 10, 'SCAFF.MENU.MATERIAAL.TITLE', 'SCAFF.MENU.MATERIAAL.SUBTITLE',
       'fa-robot', 'altrad-red',
       'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::',
       'mobile-card mobile-card--materiaal'
  from dual
union all
select 2, 20, 'SCAFF.MENU.RETOUR.TITLE', 'SCAFF.MENU.RETOUR.SUBTITLE',
       'fa-undo', 'altrad-red',
       'f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::',
       'mobile-card mobile-card--retour'
  from dual
union all
select 3, 30, 'SCAFF.MENU.TRANSFER.TITLE', 'SCAFF.MENU.TRANSFER.SUBTITLE',
       'fa-truck', 'altrad-red',
       'f?p=&APP_ID.:30:&APP_SESSION.::&DEBUG.:::',
       'mobile-card mobile-card--transfer'
  from dual
union all
select 4, 40, 'SCAFF.MENU.AANVRAGEN.TITLE', 'SCAFF.MENU.AANVRAGEN.SUBTITLE',
       'fa-list-check', 'altrad-red',
       'f?p=&APP_ID.:50:&APP_SESSION.::&DEBUG.:::',
       'mobile-card mobile-card--aanvragen'
  from dual
;
exit
