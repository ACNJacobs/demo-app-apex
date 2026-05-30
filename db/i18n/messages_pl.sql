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

  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.TITLE',    'pl', 'Inspekcja');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.SUBTITLE', 'pl', 'Skontroluj materiał lub rusztowanie');

  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.AANHOUDEN',       'pl', 'Wstrzymaj');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.AGAIN',           'pl', 'Nowe zgłoszenie');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CANCEL',          'pl', 'Anuluj');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CONTACT',         'pl', 'Kontakt');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CONTACTGEGEVENS', 'pl', 'Dane kontaktowe');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATE.TOOSOON',    'pl', 'Data dostawy musi być co najmniej 5 dni roboczych w przyszłości.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATE.WEEKEND',    'pl', 'Data dostawy nie może przypadać na weekend.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATUM',           'pl', 'Data');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.GSM',             'pl', 'Telefon');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LADER',           'pl', 'Załadowca');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LEVERINGDETAILS', 'pl', 'Szczegóły dostawy');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.MINE',            'pl', 'Zobacz moje zgłoszenia');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.OPMERKING',       'pl', 'Uwaga');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVE',            'pl', 'Zapisz');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVED',           'pl', 'Zgłoszenie zapisane.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVED.UPDATE',    'pl', 'Zgłoszenie zaktualizowane.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.UUR',             'pl', 'Godzina');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.VERVOER',         'pl', 'Transport');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.WERFLEIDER',      'pl', 'Kierownik budowy');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.WHATNEXT',        'pl', 'Co chcesz teraz zrobić?');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE',          'pl', 'Usuń');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.CONFIRM',  'pl', 'Usunąć to zgłoszenie?');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.OK',       'pl', 'Zgłoszenie usunięte.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EDIT',            'pl', 'Edytuj');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EMPTY',           'pl', 'Brak zamówień PO.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HEAD',            'pl', 'Wybierz PO');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD',            'pl', 'Pauza');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD.OK',         'pl', 'Zgłoszenie wstrzymane.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME',          'pl', 'Wznów');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME.OK',       'pl', 'Zgłoszenie wznowione.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.SEARCH',          'pl', 'Szukaj...');
  HD_I18N_INSTALL.upsert('SCAFF.MY.HOLD',                 'pl', 'Wstrzymane');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.CREATED',  'pl', 'Utworzono');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.ID',       'pl', '#');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.PRIORITY', 'pl', 'Priorytet');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.STATUS',   'pl', 'Status');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.TITLE',    'pl', 'Temat');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.EMPTY',        'pl', 'Brak zgłoszeń.');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.BACK',                   'pl', 'Powrót do menu');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.INPROGRESS.TEXT',        'pl', 'Ta strona jest w budowie.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.LADER.REQ',       'pl', 'Załadowca jest wymagany.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.SAVED',           'pl', 'Zgłoszenie zwrotu zapisane.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.SAVED.UPDATE',    'pl', 'Zgłoszenie zwrotu zaktualizowane.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.VERVOER.REQ',     'pl', 'Transport jest wymagany.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL_PARTNER',   'pl', 'E-mail partnera');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL.INVALID',   'pl', 'Wprowadź prawidłowy adres e-mail.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL.REQ',       'pl', 'E-mail partnera jest wymagany.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.HEADER',          'pl', 'PRZENIESIENIE MATERIAŁU');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.SAVED',           'pl', 'Zgłoszenie przeniesienia zapisane.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.SAVED.UPDATE',    'pl', 'Zgłoszenie przeniesienia zaktualizowane.');

  -- Form page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DELIVERY_DATE',   'pl', 'Data dostawy');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BAKKEN',          'pl', '# Pojemników');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.TRANSPORT',       'pl', 'Transport już wykonany');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LAASTE',          'pl', 'Ostatni zwrót?');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BTN.SAVE',        'pl', 'Zapisz');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BTN.CANCEL',      'pl', 'Anuluj');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.PREFIX',          'pl', 'LABEL_PREFIX');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.SEARCH',          'pl', 'LABEL_SEARCH');

  -- List page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.PO',              'pl', 'LABEL_PO');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.KLANT',           'pl', 'LABEL_KLANT');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.STAD',            'pl', 'LABEL_STAD');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DATUM',           'pl', 'LABEL_DATUM');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.STATUS',          'pl', 'LABEL_STATUS');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EDIT',            'pl', 'LABEL_BEWERKEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD',            'pl', 'LABEL_AANHOUDEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME',          'pl', 'LABEL_HERSTARTEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE',          'pl', 'LABEL_VERWIJDEREN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.CONFIRM',  'pl', 'LABEL_BEVESTIGEN');

  -- Form page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LABEL_AANHOUDEN', 'pl', 'Wstrzymaj');

  -- List page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.LABEL_AANHOUDEN', 'pl', 'Wstrzymaj');

  commit;
end;
/
