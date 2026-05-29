-- =============================================================================
-- PKG_SCAFF_REQ  —  Material request mutations (edit / hold / delete)
-- =============================================================================
set define off

create or replace package PKG_SCAFF_REQ
as
  -- Returns Y/N indicating whether current APP_USER may mutate p_request_id.
  function can_edit (p_request_id in number) return varchar2;

  -- Toggle hold_flag for the given request. Returns the NEW flag ('Y'/'N').
  function toggle_hold (p_request_id in number) return varchar2;

  -- Delete a request. Returns 1 if deleted, 0 if not found / not allowed.
  function delete_request (p_request_id in number) return number;
end PKG_SCAFF_REQ;
/

create or replace package body PKG_SCAFF_REQ
as
  function is_admin return boolean
  is
    l_user varchar2(200) := lower(v('APP_USER'));
  begin
    return l_user in ('admin','app_data','nobody','apex_public_user');
  end is_admin;

  function can_edit (p_request_id in number) return varchar2
  is
    l_owner varchar2(200);
    l_user  varchar2(200) := lower(v('APP_USER'));
  begin
    select lower(created_by) into l_owner
      from scaff_material_request
     where request_id = p_request_id;
    if l_owner = l_user or is_admin then
      return 'Y';
    end if;
    return 'N';
  exception
    when no_data_found then
      return 'N';
  end can_edit;

  function toggle_hold (p_request_id in number) return varchar2
  is
    l_new varchar2(1);
  begin
    if can_edit(p_request_id) = 'N' then
      return null;
    end if;
    update scaff_material_request
       set hold_flag = case when hold_flag = 'Y' then 'N' else 'Y' end
     where request_id = p_request_id
    returning hold_flag into l_new;
    commit;
    return l_new;
  end toggle_hold;

  function delete_request (p_request_id in number) return number
  is
  begin
    if can_edit(p_request_id) = 'N' then
      return 0;
    end if;
    delete from scaff_material_request where request_id = p_request_id;
    commit;
    return sql%rowcount;
  end delete_request;

end PKG_SCAFF_REQ;
/

show errors package body PKG_SCAFF_REQ
