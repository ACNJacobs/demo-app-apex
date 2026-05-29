-- =============================================================================
-- i18n — English texts for SCAFF APP (app_id 100)
-- =============================================================================
set define off
begin
  HD_I18N_INSTALL.set_context;

  -- Mobile menu cards
  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.TITLE',    'en', 'Material request');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.SUBTITLE', 'en', 'Submit a new material request');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.TITLE',       'en', 'Return request');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.SUBTITLE',    'en', 'Report material return');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.TITLE',     'en', 'Transfer request');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.SUBTITLE',  'en', 'Move material between locations');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.TITLE',    'en', 'Inspection');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.SUBTITLE', 'en', 'Inspect material or scaffold');

  -- Language selector
  HD_I18N_INSTALL.upsert('SCAFF.LANG.TITLE', 'en', 'Language');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.APPLY', 'en', 'Apply language');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.NL',    'en', 'Nederlands');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.EN',    'en', 'English');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.FR',    'en', 'French');

  commit;
end;
/
