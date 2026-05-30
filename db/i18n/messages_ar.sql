-- =============================================================================
-- i18n - Arabic texts for SCAFF APP (app_id 100)
-- =============================================================================
set define off
begin
  HD_I18N_INSTALL.set_context;

  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.TITLE',    'ar', 'طلب مواد');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.SUBTITLE', 'ar', 'تقديم طلب مواد جديد');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.TITLE',       'ar', 'طلب إرجاع');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.SUBTITLE',    'ar', 'الإبلاغ عن إرجاع المواد');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.TITLE',     'ar', 'طلب نقل');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.SUBTITLE',  'ar', 'نقل المواد بين المواقع');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.AANVRAGEN.TITLE',    'ar', 'طلباتي');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.AANVRAGEN.SUBTITLE', 'ar', 'عرض الطلبات المقدمة');

  HD_I18N_INSTALL.upsert('SCAFF.LANG.TITLE', 'ar', 'اللغة');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.APPLY', 'ar', 'تطبيق اللغة');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.NL',    'ar', 'الهولندية');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.EN',    'ar', 'الإنجليزية');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.FR',    'ar', 'الفرنسية');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.DE',    'ar', 'الألمانية');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.PL',    'ar', 'البولندية');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.RU',    'ar', 'الروسية');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.AR',    'ar', 'العربية');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.TR',    'ar', 'التركية');

  commit;
end;
/
