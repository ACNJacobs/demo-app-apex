-- =============================================================================
-- i18n - Russian texts for SCAFF APP (app_id 100)
-- =============================================================================
set define off
begin
  HD_I18N_INSTALL.set_context;

  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.TITLE',    'ru', 'Заявка на материал');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.SUBTITLE', 'ru', 'Подать новую заявку на материал');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.TITLE',       'ru', 'Возврат');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.SUBTITLE',    'ru', 'Сообщить о возврате материала');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.TITLE',     'ru', 'Перемещение');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.SUBTITLE',  'ru', 'Переместить материал между объектами');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.AANVRAGEN.TITLE',    'ru', 'Мои заявки');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.AANVRAGEN.SUBTITLE', 'ru', 'Посмотреть мои отправленные заявки');

  HD_I18N_INSTALL.upsert('SCAFF.LANG.TITLE', 'ru', 'Язык');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.APPLY', 'ru', 'Применить язык');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.NL',    'ru', 'Нидерландский');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.EN',    'ru', 'Английский');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.FR',    'ru', 'Французский');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.DE',    'ru', 'Немецкий');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.PL',    'ru', 'Польский');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.RU',    'ru', 'Русский');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.AR',    'ru', 'Арабский');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.TR',    'ru', 'Турецкий');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.TITLE',    'ru', 'Инспекция');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.SUBTITLE', 'ru', 'Проверить материал или леса');

  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.AANHOUDEN',       'ru', 'Приостановить');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.AGAIN',           'ru', 'Новая заявка');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CANCEL',          'ru', 'Отмена');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CONTACT',         'ru', 'Контакт');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CONTACTGEGEVENS', 'ru', 'Контактные данные');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATE.TOOSOON',    'ru', 'Дата доставки должна быть минимум через 5 рабочих дней.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATE.WEEKEND',    'ru', 'Дата доставки не может приходиться на выходные.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATUM',           'ru', 'Дата');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.GSM',             'ru', 'Мобильный');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LADER',           'ru', 'Грузчик');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LEVERINGDETAILS', 'ru', 'Детали доставки');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.MINE',            'ru', 'Мои заявки');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.OPMERKING',       'ru', 'Примечание');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVE',            'ru', 'Сохранить');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVED',           'ru', 'Заявка сохранена.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVED.UPDATE',    'ru', 'Заявка обновлена.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.UUR',             'ru', 'Время');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.VERVOER',         'ru', 'Транспорт');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.WERFLEIDER',      'ru', 'Прораб');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.WHATNEXT',        'ru', 'Что вы хотите сделать дальше?');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE',          'ru', 'Удалить');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.CONFIRM',  'ru', 'Удалить эту заявку?');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.OK',       'ru', 'Заявка удалена.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EDIT',            'ru', 'Изменить');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EMPTY',           'ru', 'PO не найдены.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HEAD',            'ru', 'Выберите PO');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD',            'ru', 'Пауза');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD.OK',         'ru', 'Заявка приостановлена.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME',          'ru', 'Возобновить');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME.OK',       'ru', 'Заявка возобновлена.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.SEARCH',          'ru', 'Поиск...');
  HD_I18N_INSTALL.upsert('SCAFF.MY.HOLD',                 'ru', 'Приостановлено');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.CREATED',  'ru', 'Создано');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.ID',       'ru', '#');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.PRIORITY', 'ru', 'Приоритет');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.STATUS',   'ru', 'Статус');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.TITLE',    'ru', 'Тема');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.EMPTY',        'ru', 'Заявок пока нет.');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.BACK',                   'ru', 'Назад в меню');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.INPROGRESS.TEXT',        'ru', 'Эта страница в разработке.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.LADER.REQ',       'ru', 'Грузчик обязателен.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.SAVED',           'ru', 'Заявка на возврат сохранена.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.SAVED.UPDATE',    'ru', 'Заявка на возврат обновлена.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.VERVOER.REQ',     'ru', 'Транспорт обязателен.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL_PARTNER',   'ru', 'E-mail партнёра');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL.INVALID',   'ru', 'Введите корректный e-mail.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL.REQ',       'ru', 'E-mail партнёра обязателен.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.HEADER',          'ru', 'ПЕРЕМЕЩЕНИЕ МАТЕРИАЛА');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.SAVED',           'ru', 'Заявка на перемещение сохранена.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.SAVED.UPDATE',    'ru', 'Заявка на перемещение обновлена.');

  -- Form page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CONTACT',         'ru', 'LABEL_CONTACT');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.WERFLEIDER',      'ru', 'LABEL_WERFLEIDER');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.GSM',             'ru', 'LABEL_GSM');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DELIVERY_DATE',   'ru', 'LABEL_DELIVERY_DATE');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BAKKEN',          'ru', 'LABEL_BAKKEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.TRANSPORT',       'ru', 'LABEL_TRANSPORT');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LADER',           'ru', 'LABEL_LADER');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.UUR',             'ru', 'LABEL_UUR');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.AANHOUDEN',       'ru', 'LABEL_AANHOUDEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LAASTE',          'ru', 'LABEL_LAASTE');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.OPMERKING',       'ru', 'LABEL_OPMERKING');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BTN.SAVE',        'ru', 'LABEL_OPSLAAN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BTN.CANCEL',      'ru', 'LABEL_ANNULEREN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.PREFIX',          'ru', 'LABEL_PREFIX');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.SEARCH',          'ru', 'LABEL_SEARCH');

  -- List page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.PO',              'ru', 'LABEL_PO');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.KLANT',           'ru', 'LABEL_KLANT');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.STAD',            'ru', 'LABEL_STAD');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DATUM',           'ru', 'LABEL_DATUM');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.STATUS',          'ru', 'LABEL_STATUS');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EDIT',            'ru', 'LABEL_BEWERKEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD',            'ru', 'LABEL_AANHOUDEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME',          'ru', 'LABEL_HERSTARTEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE',          'ru', 'LABEL_VERWIJDEREN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.CONFIRM',  'ru', 'LABEL_BEVESTIGEN');

  -- Form page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LABEL_AANHOUDEN', 'ru', 'Приостановить');

  -- List page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.LABEL_AANHOUDEN', 'ru', 'Приостановить');

  commit;
end;
/
