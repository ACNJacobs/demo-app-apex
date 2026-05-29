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

  -- Returns the date that is p_days_ahead business days (Mon-Fri) after p_from.
  -- Counts only weekdays; if p_from itself is a weekend it is skipped first.
  function next_business_day (p_from in date, p_days_ahead in pls_integer) return date;

  -- Y/N : is the given date a weekday (Mon-Fri).
  function is_business_day (p_d in date) return varchar2;

  -- Return-request mutations (mirror material-request).
  function can_edit_return    (p_return_id in number) return varchar2;
  function toggle_hold_return (p_return_id in number) return varchar2;
  function delete_return      (p_return_id in number) return number;

  -- Transfer-request mutations (mirror material-request).
  function can_edit_transfer    (p_transfer_id in number) return varchar2;
  function toggle_hold_transfer (p_transfer_id in number) return varchar2;
  function delete_transfer      (p_transfer_id in number) return number;
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

  function is_business_day (p_d in date) return varchar2
  is
    l_day varchar2(20);
  begin
    l_day := upper(trim(to_char(p_d, 'fmDAY', 'NLS_DATE_LANGUAGE=ENGLISH')));
    if l_day in ('SATURDAY','SUNDAY') then
      return 'N';
    end if;
    return 'Y';
  end is_business_day;

  function next_business_day (p_from in date, p_days_ahead in pls_integer) return date
  is
    l_d     date := trunc(p_from);
    l_left  pls_integer := greatest(nvl(p_days_ahead,0), 0);
  begin
    while l_left > 0 loop
      l_d := l_d + 1;
      if is_business_day(l_d) = 'Y' then
        l_left := l_left - 1;
      end if;
    end loop;
    return l_d;
  end next_business_day;

  function can_edit_return (p_return_id in number) return varchar2
  is
    l_owner varchar2(200);
    l_user  varchar2(200) := lower(v('APP_USER'));
  begin
    select lower(created_by) into l_owner
      from scaff_return_request
     where return_id = p_return_id;
    if l_owner = l_user or is_admin then
      return 'Y';
    end if;
    return 'N';
  exception
    when no_data_found then
      return 'N';
  end can_edit_return;

  function toggle_hold_return (p_return_id in number) return varchar2
  is
    l_new varchar2(1);
  begin
    if can_edit_return(p_return_id) = 'N' then
      return null;
    end if;
    update scaff_return_request
       set hold_flag = case when hold_flag = 'Y' then 'N' else 'Y' end
     where return_id = p_return_id
    returning hold_flag into l_new;
    commit;
    return l_new;
  end toggle_hold_return;

  function delete_return (p_return_id in number) return number
  is
  begin
    if can_edit_return(p_return_id) = 'N' then
      return 0;
    end if;
    delete from scaff_return_request where return_id = p_return_id;
    commit;
    return sql%rowcount;
  end delete_return;

  function can_edit_transfer (p_transfer_id in number) return varchar2
  is
    l_owner varchar2(200);
    l_user  varchar2(200) := lower(v('APP_USER'));
  begin
    select lower(created_by) into l_owner
      from scaff_transfer_request
     where transfer_id = p_transfer_id;
    if l_owner = l_user or is_admin then
      return 'Y';
    end if;
    return 'N';
  exception
    when no_data_found then
      return 'N';
  end can_edit_transfer;

  function toggle_hold_transfer (p_transfer_id in number) return varchar2
  is
    l_new varchar2(1);
  begin
    if can_edit_transfer(p_transfer_id) = 'N' then
      return null;
    end if;
    update scaff_transfer_request
       set hold_flag = case when hold_flag = 'Y' then 'N' else 'Y' end
     where transfer_id = p_transfer_id
    returning hold_flag into l_new;
    commit;
    return l_new;
  end toggle_hold_transfer;

  function delete_transfer (p_transfer_id in number) return number
  is
  begin
    if can_edit_transfer(p_transfer_id) = 'N' then
      return 0;
    end if;
    delete from scaff_transfer_request where transfer_id = p_transfer_id;
    commit;
    return sql%rowcount;
  end delete_transfer;

end PKG_SCAFF_REQ;
/

show errors package body PKG_SCAFF_REQ
