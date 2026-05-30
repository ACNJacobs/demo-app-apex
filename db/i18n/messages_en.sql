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

  -- Form page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CONTACT',         'en', 'Contact');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.WERFLEIDER',      'en', 'Site manager');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.GSM',             'en', 'Mobile');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DELIVERY_DATE',   'en', 'Delivery date');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BAKKEN',          'en', '# Crates');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.TRANSPORT',       'en', 'Transport already done');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LADER',           'en', 'Loader');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.UUR',             'en', 'Hour');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.AANHOUDEN',       'en', 'Hold');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LAASTE',          'en', 'Last return?');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.OPMERKING',       'en', 'Remark');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BTN.SAVE',        'en', 'Save');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BTN.CANCEL',      'en', 'Cancel');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.PREFIX',          'en', 'Prefix');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.SEARCH',          'en', 'Search');

  -- List page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.PO',              'en', 'PO');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.KLANT',           'en', 'Customer');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.STAD',            'en', 'City');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DATUM',           'en', 'Date');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.STATUS',          'en', 'Status');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EDIT',            'en', 'Edit');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD',            'en', 'Hold');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME',          'en', 'Resume');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE',          'en', 'Delete');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.CONFIRM',  'en', 'Confirm delete?');

  commit;
end;
/
