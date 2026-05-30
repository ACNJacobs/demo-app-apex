-- =============================================================================
-- i18n - German texts for SCAFF APP (app_id 100)
-- =============================================================================
set define off
begin
  HD_I18N_INSTALL.set_context;

  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.TITLE',    'de', 'Materialanforderung');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.SUBTITLE', 'de', 'Neue Materialanforderung einreichen');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.TITLE',       'de', 'Rücksendung');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.SUBTITLE',    'de', 'Materialrücksendung melden');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.TITLE',     'de', 'Transferanforderung');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.SUBTITLE',  'de', 'Material zwischen Standorten verschieben');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.AANVRAGEN.TITLE',    'de', 'Meine Anfragen');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.AANVRAGEN.SUBTITLE', 'de', 'Meine eingereichten Anfragen ansehen');

  HD_I18N_INSTALL.upsert('SCAFF.LANG.TITLE', 'de', 'Sprache');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.APPLY', 'de', 'Sprache übernehmen');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.NL',    'de', 'Niederländisch');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.EN',    'de', 'Englisch');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.FR',    'de', 'Französisch');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.DE',    'de', 'Deutsch');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.PL',    'de', 'Polnisch');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.RU',    'de', 'Russisch');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.AR',    'de', 'Arabisch');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.TR',    'de', 'Türkisch');

  commit;
end;
/
