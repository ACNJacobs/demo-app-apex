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

  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.TITLE',    'de', 'Inspektion');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.SUBTITLE', 'de', 'Material oder Gerüst inspizieren');

  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.AANHOUDEN',       'de', 'Anhalten');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.AGAIN',           'de', 'Neue Anfrage');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CANCEL',          'de', 'Abbrechen');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CONTACT',         'de', 'Kontakt');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CONTACTGEGEVENS', 'de', 'Kontaktdaten');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATE.TOOSOON',    'de', 'Das Lieferdatum muss mindestens 5 Werktage in der Zukunft liegen.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATE.WEEKEND',    'de', 'Das Lieferdatum darf nicht auf ein Wochenende fallen.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATUM',           'de', 'Datum');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.GSM',             'de', 'Mobil');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LADER',           'de', 'Verlader');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LEVERINGDETAILS', 'de', 'Lieferdetails');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.MINE',            'de', 'Meine Anfragen ansehen');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.OPMERKING',       'de', 'Bemerkung');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVE',            'de', 'Speichern');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVED',           'de', 'Anfrage gespeichert.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVED.UPDATE',    'de', 'Anfrage aktualisiert.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.UUR',             'de', 'Uhrzeit');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.VERVOER',         'de', 'Transport');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.WERFLEIDER',      'de', 'Bauleiter');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.WHATNEXT',        'de', 'Was möchten Sie als Nächstes tun?');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE',          'de', 'Löschen');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.CONFIRM',  'de', 'Diese Anfrage löschen?');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.OK',       'de', 'Anfrage gelöscht.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EDIT',            'de', 'Bearbeiten');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EMPTY',           'de', 'Keine PO gefunden.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HEAD',            'de', 'PO auswählen');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD',            'de', 'Pause');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD.OK',         'de', 'Anfrage angehalten.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME',          'de', 'Fortsetzen');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME.OK',       'de', 'Anfrage reaktiviert.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.SEARCH',          'de', 'Suchen...');
  HD_I18N_INSTALL.upsert('SCAFF.MY.HOLD',                 'de', 'Angehalten');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.CREATED',  'de', 'Erstellt');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.ID',       'de', '#');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.PRIORITY', 'de', 'Priorität');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.STATUS',   'de', 'Status');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.TITLE',    'de', 'Betreff');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.EMPTY',        'de', 'Noch keine Anfragen.');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.BACK',                   'de', 'Zurück zum Menü');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.INPROGRESS.TEXT',        'de', 'Diese Seite wird gerade erstellt.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.LADER.REQ',       'de', 'Verlader ist erforderlich.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.SAVED',           'de', 'Rücksendung gespeichert.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.SAVED.UPDATE',    'de', 'Rücksendung aktualisiert.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.VERVOER.REQ',     'de', 'Transport ist erforderlich.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL_PARTNER',   'de', 'E-Mail des Partners');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL.INVALID',   'de', 'Bitte geben Sie eine gültige E-Mail-Adresse ein.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL.REQ',       'de', 'E-Mail des Partners ist erforderlich.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.HEADER',          'de', 'MATERIALTRANSFER');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.SAVED',           'de', 'Transferanfrage gespeichert.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.SAVED.UPDATE',    'de', 'Transferanfrage aktualisiert.');

  -- Form page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DELIVERY_DATE',   'de', 'Lieferdatum');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BAKKEN',          'de', '# Behälter');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.TRANSPORT',       'de', 'Transport bereits durchgeführt');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LAASTE',          'de', 'Letzte Rückgabe?');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BTN.SAVE',        'de', 'Speichern');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BTN.CANCEL',      'de', 'Abbrechen');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.PREFIX',          'de', 'LABEL_PREFIX');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.SEARCH',          'de', 'LABEL_SEARCH');

  -- List page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.PO',              'de', 'LABEL_PO');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.KLANT',           'de', 'LABEL_KLANT');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.STAD',            'de', 'LABEL_STAD');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DATUM',           'de', 'LABEL_DATUM');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.STATUS',          'de', 'LABEL_STATUS');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EDIT',            'de', 'LABEL_BEWERKEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD',            'de', 'LABEL_AANHOUDEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME',          'de', 'LABEL_HERSTARTEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE',          'de', 'LABEL_VERWIJDEREN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.CONFIRM',  'de', 'LABEL_BEVESTIGEN');

  -- Form page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LABEL_AANHOUDEN', 'de', 'Pausieren');

  -- List page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.LABEL_AANHOUDEN', 'de', 'Pausieren');

  commit;
end;
/
