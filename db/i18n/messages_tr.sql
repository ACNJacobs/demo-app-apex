-- =============================================================================
-- i18n - Turkish texts for SCAFF APP (app_id 100)
-- =============================================================================
set define off
begin
  HD_I18N_INSTALL.set_context;

  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.TITLE',    'tr', 'Malzeme talebi');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.SUBTITLE', 'tr', 'Yeni malzeme talebi gönder');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.TITLE',       'tr', 'İade talebi');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.SUBTITLE',    'tr', 'Malzeme iadesi bildir');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.TITLE',     'tr', 'Transfer talebi');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.SUBTITLE',  'tr', 'Malzemeyi konumlar arasında taşı');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.AANVRAGEN.TITLE',    'tr', 'Taleplerim');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.AANVRAGEN.SUBTITLE', 'tr', 'Gönderilen taleplerimi görüntüle');

  HD_I18N_INSTALL.upsert('SCAFF.LANG.TITLE', 'tr', 'Dil');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.APPLY', 'tr', 'Dili uygula');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.NL',    'tr', 'Felemenkçe');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.EN',    'tr', 'İngilizce');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.FR',    'tr', 'Fransızca');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.DE',    'tr', 'Almanca');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.PL',    'tr', 'Lehçe');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.RU',    'tr', 'Rusça');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.AR',    'tr', 'Arapça');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.TR',    'tr', 'Türkçe');

  commit;
end;
/
