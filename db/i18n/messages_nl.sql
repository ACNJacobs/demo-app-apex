-- =============================================================================
-- i18n — Nederlandse teksten voor SCAFF APP (app_id 100)
-- =============================================================================
-- Convention: SCAFF.<MODULE>.<ELEMENT>.<KIND>
-- Run: @db/i18n/_install_helper.sql  (eenmalig)
--      @db/i18n/messages_nl.sql
-- =============================================================================
set define off
begin
  HD_I18N_INSTALL.set_context;

  -- Mobile menu cards
  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.TITLE',    'nl', 'Materiaal aanvraag');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.SUBTITLE', 'nl', 'Nieuwe materiaalaanvraag indienen');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.TITLE',       'nl', 'Retour aanvraag');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.SUBTITLE',    'nl', 'Materiaal retour melden');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.TITLE',     'nl', 'Transfer aanvraag');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.SUBTITLE',  'nl', 'Materiaal verplaatsen tussen locaties');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.TITLE',    'nl', 'Inspectie');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.SUBTITLE', 'nl', 'Materiaal of steiger inspecteren');

  -- Language selector
  HD_I18N_INSTALL.upsert('SCAFF.LANG.TITLE', 'nl', 'Taal');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.APPLY', 'nl', 'Taal toepassen');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.NL',    'nl', 'Nederlands');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.EN',    'nl', 'Engels');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.FR',    'nl', 'Frans');

  commit;
end;
/
