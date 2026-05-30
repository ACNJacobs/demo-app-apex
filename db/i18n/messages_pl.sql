-- =============================================================================
-- i18n - Polish texts for SCAFF APP (app_id 100)
-- =============================================================================
set define off
begin
  HD_I18N_INSTALL.set_context;

  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.TITLE',    'pl', 'Zamówienie materiału');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.SUBTITLE', 'pl', 'Złóż nowe zamówienie materiału');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.TITLE',       'pl', 'Zwrot');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.SUBTITLE',    'pl', 'Zgłoś zwrot materiału');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.TITLE',     'pl', 'Przeniesienie');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.SUBTITLE',  'pl', 'Przenieś materiał między lokalizacjami');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.AANVRAGEN.TITLE',    'pl', 'Moje zgłoszenia');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.AANVRAGEN.SUBTITLE', 'pl', 'Zobacz moje przesłane zgłoszenia');

  HD_I18N_INSTALL.upsert('SCAFF.LANG.TITLE', 'pl', 'Język');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.APPLY', 'pl', 'Zastosuj język');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.NL',    'pl', 'Niderlandzki');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.EN',    'pl', 'Angielski');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.FR',    'pl', 'Francuski');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.DE',    'pl', 'Niemiecki');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.PL',    'pl', 'Polski');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.RU',    'pl', 'Rosyjski');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.AR',    'pl', 'Arabski');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.TR',    'pl', 'Turecki');

  commit;
end;
/
