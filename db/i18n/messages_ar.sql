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

  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.TITLE',    'ar', 'فحص');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.SUBTITLE', 'ar', 'فحص المواد أو السقالات');

  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.AANHOUDEN',       'ar', 'تعليق');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.AGAIN',           'ar', 'طلب جديد');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CANCEL',          'ar', 'إلغاء');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CONTACT',         'ar', 'اتصال');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CONTACTGEGEVENS', 'ar', 'بيانات الاتصال');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATE.TOOSOON',    'ar', 'يجب أن يكون تاريخ التسليم بعد 5 أيام عمل على الأقل.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATE.WEEKEND',    'ar', 'لا يمكن أن يقع تاريخ التسليم في عطلة نهاية الأسبوع.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATUM',           'ar', 'التاريخ');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.GSM',             'ar', 'الجوال');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LADER',           'ar', 'المُحَمِّل');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LEVERINGDETAILS', 'ar', 'تفاصيل التسليم');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.MINE',            'ar', 'عرض طلباتي');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.OPMERKING',       'ar', 'ملاحظة');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVE',            'ar', 'حفظ');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVED',           'ar', 'تم حفظ الطلب.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVED.UPDATE',    'ar', 'تم تحديث الطلب.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.UUR',             'ar', 'الساعة');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.VERVOER',         'ar', 'النقل');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.WERFLEIDER',      'ar', 'مدير الموقع');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.WHATNEXT',        'ar', 'ماذا تريد أن تفعل بعد ذلك؟');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE',          'ar', 'حذف');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.CONFIRM',  'ar', 'هل تريد حذف هذا الطلب؟');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.OK',       'ar', 'تم حذف الطلب.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EDIT',            'ar', 'تعديل');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EMPTY',           'ar', 'لا توجد أوامر شراء.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HEAD',            'ar', 'اختر أمر الشراء');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD',            'ar', 'إيقاف مؤقت');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD.OK',         'ar', 'تم تعليق الطلب.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME',          'ar', 'استئناف');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME.OK',       'ar', 'تم استئناف الطلب.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.SEARCH',          'ar', 'بحث...');
  HD_I18N_INSTALL.upsert('SCAFF.MY.HOLD',                 'ar', 'معلق');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.CREATED',  'ar', 'تاريخ الإنشاء');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.ID',       'ar', '#');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.PRIORITY', 'ar', 'الأولوية');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.STATUS',   'ar', 'الحالة');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.TITLE',    'ar', 'الموضوع');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.EMPTY',        'ar', 'لا توجد طلبات بعد.');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.BACK',                   'ar', 'العودة إلى القائمة');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.INPROGRESS.TEXT',        'ar', 'هذه الصفحة قيد الإنشاء.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.LADER.REQ',       'ar', 'المُحَمِّل مطلوب.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.SAVED',           'ar', 'تم حفظ طلب الإرجاع.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.SAVED.UPDATE',    'ar', 'تم تحديث طلب الإرجاع.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.VERVOER.REQ',     'ar', 'النقل مطلوب.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL_PARTNER',   'ar', 'البريد الإلكتروني للشريك');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL.INVALID',   'ar', 'يرجى إدخال بريد إلكتروني صالح.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL.REQ',       'ar', 'البريد الإلكتروني للشريك مطلوب.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.HEADER',          'ar', 'نقل المواد');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.SAVED',           'ar', 'تم حفظ طلب النقل.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.SAVED.UPDATE',    'ar', 'تم تحديث طلب النقل.');

  commit;
end;
/
