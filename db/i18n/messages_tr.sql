-- =============================================================================
-- i18n - Turkish texts for SCAFF APP (app_id 100)
-- =============================================================================
set define off
begin
  HD_I18N_INSTALL.set_context;

  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.TITLE',    'tr', 'Malzeme talebi');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.SUBTITLE', 'tr', 'Yeni malzeme talebi gönder');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.TITLE',       'tr', 'İade talebi');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.SUBTITLE',    'tr', 'Malzeme iadesi bildir');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.TITLE',     'tr', 'Transfer talebi');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.SUBTITLE',  'tr', 'Malzemeyi konumlar arasında taşı');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.AANVRAGEN.TITLE',    'tr', 'Taleplerim');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.AANVRAGEN.SUBTITLE', 'tr', 'Gönderilen taleplerimi görüntüle');

  HD_I18N_INSTALL.upsert('SCAFF.LANG.TITLE', 'tr', 'Dil');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.APPLY', 'tr', 'Dili uygula');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.NL',    'tr', 'Felemenkçe');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.EN',    'tr', 'İngilizce');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.FR',    'tr', 'Fransızca');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.DE',    'tr', 'Almanca');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.PL',    'tr', 'Lehçe');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.RU',    'tr', 'Rusça');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.AR',    'tr', 'Arapça');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.TR',    'tr', 'Türkçe');

  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.TITLE',    'tr', 'Denetim');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.SUBTITLE', 'tr', 'Malzeme veya iskele denetimi');

  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.AANHOUDEN',       'tr', 'Beklet');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.AGAIN',           'tr', 'Yeni talep');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CANCEL',          'tr', 'İptal');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CONTACT',         'tr', 'İletişim');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CONTACTGEGEVENS', 'tr', 'İletişim bilgileri');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATE.TOOSOON',    'tr', 'Teslim tarihi en az 5 iş günü ileride olmalıdır.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATE.WEEKEND',    'tr', 'Teslim tarihi hafta sonuna denk gelemez.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATUM',           'tr', 'Tarih');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.GSM',             'tr', 'Mobil');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LADER',           'tr', 'Yükleyici');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LEVERINGDETAILS', 'tr', 'Teslimat detayları');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.MINE',            'tr', 'Taleplerimi gör');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.OPMERKING',       'tr', 'Not');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVE',            'tr', 'Kaydet');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVED',           'tr', 'Talep kaydedildi.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVED.UPDATE',    'tr', 'Talep güncellendi.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.UUR',             'tr', 'Saat');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.VERVOER',         'tr', 'Taşıma');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.WERFLEIDER',      'tr', 'Şantiye şefi');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.WHATNEXT',        'tr', 'Şimdi ne yapmak istersiniz?');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE',          'tr', 'Sil');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.CONFIRM',  'tr', 'Bu talep silinsin mi?');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.OK',       'tr', 'Talep silindi.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EDIT',            'tr', 'Düzenle');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EMPTY',           'tr', 'PO bulunamadı.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HEAD',            'tr', 'PO seçin');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD',            'tr', 'Duraklat');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD.OK',         'tr', 'Talep bekletildi.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME',          'tr', 'Devam et');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME.OK',       'tr', 'Talep tekrar etkin.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.SEARCH',          'tr', 'Ara...');
  HD_I18N_INSTALL.upsert('SCAFF.MY.HOLD',                 'tr', 'Beklemede');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.CREATED',  'tr', 'Oluşturuldu');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.ID',       'tr', '#');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.PRIORITY', 'tr', 'Öncelik');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.STATUS',   'tr', 'Durum');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.TITLE',    'tr', 'Konu');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.EMPTY',        'tr', 'Henüz talep yok.');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.BACK',                   'tr', 'Menüye dön');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.INPROGRESS.TEXT',        'tr', 'Bu sayfa yapım aşamasında.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.LADER.REQ',       'tr', 'Yükleyici zorunludur.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.SAVED',           'tr', 'İade talebi kaydedildi.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.SAVED.UPDATE',    'tr', 'İade talebi güncellendi.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.VERVOER.REQ',     'tr', 'Taşıma zorunludur.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL_PARTNER',   'tr', 'Partner e-posta');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL.INVALID',   'tr', 'Geçerli bir e-posta girin.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL.REQ',       'tr', 'Partner e-posta zorunludur.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.HEADER',          'tr', 'MALZEME TRANSFERİ');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.SAVED',           'tr', 'Transfer talebi kaydedildi.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.SAVED.UPDATE',    'tr', 'Transfer talebi güncellendi.');

  -- Form page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DELIVERY_DATE',   'tr', 'Teslim tarihi');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BAKKEN',          'tr', '# Sepet');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.TRANSPORT',       'tr', 'Nakliye yapıldı');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LAASTE',          'tr', 'Son iade?');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BTN.SAVE',        'tr', 'Kaydet');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.BTN.CANCEL',      'tr', 'İptal');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.PREFIX',          'tr', 'LABEL_PREFIX');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.SEARCH',          'tr', 'LABEL_SEARCH');

  -- List page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.PO',              'tr', 'LABEL_PO');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.KLANT',           'tr', 'LABEL_KLANT');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.STAD',            'tr', 'LABEL_STAD');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DATUM',           'tr', 'LABEL_DATUM');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.STATUS',          'tr', 'LABEL_STATUS');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EDIT',            'tr', 'LABEL_BEWERKEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD',            'tr', 'LABEL_AANHOUDEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME',          'tr', 'LABEL_HERSTARTEN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE',          'tr', 'LABEL_VERWIJDEREN');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.CONFIRM',  'tr', 'LABEL_BEVESTIGEN');

  -- Form page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LABEL_AANHOUDEN', 'tr', 'Beklet');

  -- List page labels
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.LABEL_AANHOUDEN', 'tr', 'Beklet');

  commit;
end;
/
