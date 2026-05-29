-- =============================================================================
-- i18n - French texts for SCAFF APP (app_id 100)
-- =============================================================================
set define off
begin
  HD_I18N_INSTALL.set_context;

  HD_I18N_INSTALL.upsert('SCAFF.MENU.AANVRAGEN.SUBTITLE', 'fr', 'Voir mes demandes soumises');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.AANVRAGEN.TITLE', 'fr', 'Mes demandes');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.SUBTITLE', 'fr', 'Inspecter le materiel ou l''echafaudage');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.INSPECTIE.TITLE', 'fr', 'Inspection');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.SUBTITLE', 'fr', 'Soumettre une nouvelle demande de materiel');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.MATERIAAL.TITLE', 'fr', 'Demande de materiel');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.SUBTITLE', 'fr', 'Signaler un retour de materiel');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.RETOUR.TITLE', 'fr', 'Demande de retour');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.SUBTITLE', 'fr', 'Deplacer le materiel entre les sites');
  HD_I18N_INSTALL.upsert('SCAFF.MENU.TRANSFER.TITLE', 'fr', 'Demande de transfert');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.AANHOUDEN', 'fr', 'Mettre en attente');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.AGAIN', 'fr', 'Nouvelle demande');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CANCEL', 'fr', 'Annuler');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CONTACT', 'fr', 'Contact');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.CONTACTGEGEVENS', 'fr', 'Coordonnees');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATE.TOOSOON', 'fr', 'La date de livraison doit etre au moins a 5 jours ouvrables dans le futur.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATE.WEEKEND', 'fr', 'La date de livraison ne peut pas tomber le week-end.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.DATUM', 'fr', 'Date');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.GSM', 'fr', 'Mobile');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LADER', 'fr', 'Chargeur');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.LEVERINGDETAILS', 'fr', 'Details de livraison');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.MINE', 'fr', 'Voir mes demandes');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.OPMERKING', 'fr', 'Remarque');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVE', 'fr', 'Enregistrer');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVED', 'fr', 'Demande enregistree.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.SAVED.UPDATE', 'fr', 'Demande mise a jour.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.UUR', 'fr', 'Heure');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.VERVOER', 'fr', 'Transport');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.WERFLEIDER', 'fr', 'Chef de chantier');
  HD_I18N_INSTALL.upsert('SCAFF.MR.FORM.WHATNEXT', 'fr', 'Que voulez-vous faire ensuite ?');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE', 'fr', 'Supprimer');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.CONFIRM', 'fr', 'Supprimer cette demande ?');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.DELETE.OK', 'fr', 'Demande supprimee.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EDIT', 'fr', 'Modifier');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.EMPTY', 'fr', 'Aucun PO trouve.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HEAD', 'fr', 'Selectionner un PO');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD', 'fr', 'Pause');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.HOLD.OK', 'fr', 'Demande mise en attente.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME', 'fr', 'Reprendre');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.RESUME.OK', 'fr', 'Demande reactivee.');
  HD_I18N_INSTALL.upsert('SCAFF.MR.LIST.SEARCH', 'fr', 'Rechercher...');
  HD_I18N_INSTALL.upsert('SCAFF.MY.HOLD', 'fr', 'En attente');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.CREATED', 'fr', 'Cree');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.ID', 'fr', '#');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.PRIORITY', 'fr', 'Priorite');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.STATUS', 'fr', 'Statut');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.COL.TITLE', 'fr', 'Sujet');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.AANVRAGEN.EMPTY', 'fr', 'Aucune demande pour le moment.');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.BACK', 'fr', 'Retour au menu');
  HD_I18N_INSTALL.upsert('SCAFF.PAGE.INPROGRESS.TEXT', 'fr', 'Cette page est en cours de construction.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.LADER.REQ', 'fr', 'Le chargeur est obligatoire.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.SAVED', 'fr', 'Demande de retour enregistree.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.SAVED.UPDATE', 'fr', 'Demande de retour mise a jour.');
  HD_I18N_INSTALL.upsert('SCAFF.RR.FORM.VERVOER.REQ', 'fr', 'Le transport est obligatoire.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL_PARTNER', 'fr', 'E-mail du partenaire');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL.INVALID', 'fr', 'Veuillez saisir une adresse e-mail valide.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.EMAIL.REQ', 'fr', 'L''e-mail du partenaire est obligatoire.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.HEADER', 'fr', 'TRANSFERT DE MATERIEL');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.SAVED', 'fr', 'Demande de transfert enregistree.');
  HD_I18N_INSTALL.upsert('SCAFF.TR.FORM.SAVED.UPDATE', 'fr', 'Demande de transfert mise a jour.');

  HD_I18N_INSTALL.upsert('SCAFF.LANG.TITLE', 'fr', 'Langue');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.APPLY', 'fr', 'Appliquer la langue');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.NL', 'fr', 'Neerlandais');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.EN', 'fr', 'Anglais');
  HD_I18N_INSTALL.upsert('SCAFF.LANG.FR', 'fr', 'Francais');

  commit;
end;
/
