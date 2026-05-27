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

  commit;
end;
/
