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

  commit;
end;
/
