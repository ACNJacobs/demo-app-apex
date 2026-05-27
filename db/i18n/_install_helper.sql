-- =============================================================================
-- i18n install helper — voert messages.csv-achtige PL/SQL upsert uit
-- =============================================================================
-- Gebruik:
--   exec hd_i18n_install.set_context;
--   exec hd_i18n_install.upsert('SCAFF.MENU.MATERIAAL.TITLE','nl','Materiaal aanvraag');
--
-- Vereist: APEX_DEV workspace, app_id 100.
-- =============================================================================
create or replace package HD_I18N_INSTALL
authid current_user
as
  c_workspace constant varchar2(30) := 'APEX_DEV';
  c_app_id    constant number       := 100;

  procedure set_context;

  procedure upsert(
    p_name in varchar2,
    p_lang in varchar2,
    p_text in varchar2
  );
end HD_I18N_INSTALL;
/

create or replace package body HD_I18N_INSTALL
as

  procedure set_context
  is
  begin
    apex_util.set_workspace(p_workspace => c_workspace);
    apex_application_install.set_application_id(c_app_id);
  end set_context;

  procedure upsert(
    p_name in varchar2,
    p_lang in varchar2,
    p_text in varchar2
  )
  is
    l_id number;
  begin
    -- bestaande regel zoeken
    begin
      select translation_entry_id
        into l_id
        from apex_application_translations
       where application_id = c_app_id
         and static_id      = p_name
         and language_code  = p_lang;
    exception
      when no_data_found then
        l_id := null;
    end;

    if l_id is null then
      apex_lang.create_message(
        p_application_id => c_app_id,
        p_name           => p_name,
        p_language       => p_lang,
        p_message_text   => p_text
      );
    else
      apex_lang.update_message(
        p_id           => l_id,
        p_message_text => p_text
      );
    end if;
  end upsert;

end HD_I18N_INSTALL;
/
