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

  -- Form page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CONTACT',         'nl', 'Contactpersoon');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.WERFLEIDER',      'nl', 'Werfleider');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.GSM',             'nl', 'GSM');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DELIVERY_DATE',   'nl', 'Leverdatum');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BAKKEN',          'nl', '# Bakken');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.TRANSPORT',       'nl', 'Transport reeds uitgevoerd');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LADER',           'nl', 'Lader');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.UUR',             'nl', 'Uur');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.AANHOUDEN',       'nl', 'Aanhouden');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LAASTE',          'nl', 'Laatste retour?');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.OPMERKING',       'nl', 'Opmerking');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BTN.SAVE',        'nl', 'Opslaan');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BTN.CANCEL',      'nl', 'Annuleren');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.PREFIX',          'nl', 'LABEL_PREFIX');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.SEARCH',          'nl', 'LABEL_SEARCH');

  -- List page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.PO',              'nl', 'LABEL_PO');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.KLANT',           'nl', 'LABEL_KLANT');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.STAD',            'nl', 'LABEL_STAD');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DATUM',           'nl', 'LABEL_DATUM');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.STATUS',          'nl', 'LABEL_STATUS');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EDIT',            'nl', 'LABEL_BEWERKEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD',            'nl', 'LABEL_AANHOUDEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME',          'nl', 'LABEL_HERSTARTEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE',          'nl', 'LABEL_VERWIJDEREN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.CONFIRM',  'nl', 'LABEL_BEVESTIGEN');

  -- Form page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LABEL_AANHOUDEN', 'nl', 'Aanhouden');

  -- List page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.LABEL_AANHOUDEN', 'nl', 'Aanhouden');

  commit;
end;
/
