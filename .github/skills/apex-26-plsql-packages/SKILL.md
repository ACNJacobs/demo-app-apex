---
name: apex-26-plsql-packages
description: PL/SQL package, procedure, and function creation patterns for Oracle APEX 26.1 apps in this workspace. Use whenever the user wants to create, modify, or debug a PL/SQL package, view, procedure, or function that supports an APEX app.
---

# APEX 26.1 PL/SQL Package Patterns (generic)

## When to invoke

User says any of:
- "maak een package"
- "nieuwe procedure / functie"
- "view aanmaken"
- "database logica toevoegen"
- "API package bouwen"
- ANY request to create or modify PL/SQL database objects for APEX

## Naming Conventions

| Kind | Pattern | Example |
|---|---|---|
| UI helper package | `PKG_<APP>_UI` | `PKG_SCAFF_UI` |
| CSS helper package | `HD_<APP>_UI_PKG` | `HD_MOBILE_UI_PKG` |
| Business logic | `PKG_<APP>_<DOMAIN>` | `PKG_SCAFF_REQUESTS` |
| Install helper | `HD_<APP>_INSTALL` | `HD_I18N_INSTALL` |
| Driver view | `V_<APP>_<PURPOSE>` | `V_MOBILE_MENU` |

Replace `<APP>` with the app prefix from the overlay skill (e.g. `SCAFF`, `INSPECT`).

## Package Template

```sql
-- File: db/packages/pkg_<app>_<domain>.sql

prompt -- Installing PKG_<APP>_<DOMAIN>

set define off

-- Specification
CREATE OR REPLACE PACKAGE pkg_<app>_<domain> AS

    -- Public constants
    c_status_open     constant varchar2(20) := 'OPEN';
    c_status_closed   constant varchar2(20) := 'CLOSED';

    -- Public functions
    function get_list return clob;
    function get_detail(p_id in number) return clob;

    -- Public procedures
    procedure create_request(
        p_project_id  in number,
        p_description in varchar2,
        p_created_by  in varchar2 default v('APP_USER'),
        p_request_id  out number
    );

    procedure update_status(
        p_request_id in number,
        p_new_status in varchar2,
        p_changed_by in varchar2 default v('APP_USER')
    );

END pkg_<app>_<domain>;
/

-- Body
CREATE OR REPLACE PACKAGE BODY pkg_<app>_<domain> AS

    function get_list return clob is
        l_out clob;
        l_home varchar2(4000);
    begin
        dbms_lob.createtemporary(l_out, true);

        -- Build home link with proper substitution
        l_home := apex_util.prepare_url(
            'f?p='||apex_application.g_flow_id||':1:'||apex_application.g_instance);

        apex_string.push(l_out, '<style>'||hd_<app>_ui_pkg.get_css||'</style>');
        apex_string.push(l_out, '<div class="<app>-list">');

        for r in (
            select id, title, status, created_at
              from <app>_requests
             where lower(coalesce(created_by,'x')) = lower(v('APP_USER'))
             order by created_at desc
             fetch first 50 rows only
        ) loop
            apex_string.push(l_out,
                '<div class="<app>-list__row">'
                || '<span class="<app>-pill <app>-pill--'|| apex_escape.html(r.status) ||'">'
                || apex_escape.html(r.status) ||'</span> '
                || apex_escape.html(r.title)
                || '</div>');
        end loop;

        apex_string.push(l_out, '</div>');
        apex_string.push(l_out, '<a class="<app>-back" href="'|| l_home ||'">&larr; Home</a>');

        return l_out;
    end get_list;

    function get_detail(p_id in number) return clob is
        l_out clob;
        l_rec <app>_requests%rowtype;
    begin
        select * into l_rec from <app>_requests where id = p_id;

        dbms_lob.createtemporary(l_out, true);
        apex_string.push(l_out, '<div class="<app>-detail">');
        apex_string.push(l_out, '<h2>'|| apex_escape.html(l_rec.title) ||'</h2>');
        apex_string.push(l_out, '<p>Status: '|| apex_escape.html(l_rec.status) ||'</p>');
        apex_string.push(l_out, '</div>');

        return l_out;
    end get_detail;

    procedure create_request(
        p_project_id  in number,
        p_description in varchar2,
        p_created_by  in varchar2 default v('APP_USER'),
        p_request_id  out number
    ) is
    begin
        insert into <app>_requests (project_id, description, created_by, status, created_at)
        values (p_project_id, p_description, p_created_by, c_status_open, sysdate)
        returning id into p_request_id;

        apex_debug.message('Created request %s by %s', p_request_id, p_created_by);
    end create_request;

    procedure update_status(
        p_request_id in number,
        p_new_status in varchar2,
        p_changed_by in varchar2 default v('APP_USER')
    ) is
    begin
        update <app>_requests
           set status = p_new_status,
               updated_by = p_changed_by,
               updated_at = sysdate
         where id = p_request_id;

        if sql%rowcount = 0 then
            raise_application_error(-20001, 'Request not found: '|| p_request_id);
        end if;
    end update_status;

END pkg_<app>_<domain>;
/

-- Verify
SELECT object_name, status
  FROM user_objects
 WHERE object_name = 'PKG_<APP>_<DOMAIN>'
   AND object_type IN ('PACKAGE', 'PACKAGE BODY');

set define on
```

## View Template

```sql
-- File: db/views/v_<app>_<purpose>.sql

prompt -- Installing V_<APP>_<PURPOSE>

CREATE OR REPLACE VIEW v_<app>_<purpose> AS
SELECT 1 AS card_id,
       10 AS display_sequence,
       '<APP>.MENU.HOME.TITLE'    AS card_title_key,
       '<APP>.MENU.HOME.SUBTITLE' AS card_subtitle_key,
       'fa-home'                  AS card_icon,
       'f?p=&APP_ID.:10:&APP_SESSION.::&DEBUG.:::' AS card_link,
       'mobile-card mobile-card--home' AS card_class
  FROM dual
UNION ALL
SELECT 2, 20, '<APP>.MENU.NEW.TITLE', '<APP>.MENU.NEW.SUBTITLE',
       'fa-plus', 'f?p=&APP_ID.:20:&APP_SESSION.::&DEBUG.:::',
       'mobile-card mobile-card--new' FROM dual;

-- Verify
SELECT view_name FROM user_views WHERE view_name = 'V_<APP>_<PURPOSE>';
```

## Key Patterns

### HTML Generation
- Always return `CLOB` (not `VARCHAR2`) — content exceeds 32 KB easily.
- Always escape user content: `apex_escape.html(...)`.
- Always substitute `&APP_ID.` / `&APP_SESSION.` / `&DEBUG.` in PL/SQL before output.
- Use `apex_util.prepare_url(...)` for all hrefs.

### Session State
- `v('APP_USER')` — current APEX user.
- `v('APP_SESSION')` — session ID.
- `apex_application.g_flow_id` — app ID.
- `apex_application.g_instance` — session instance.

### Error Handling
- Use `apex_error.add_error()` for user-friendly validation errors.
- Use `raise_application_error()` for unexpected / system errors.
- Use `apex_debug.message()` for runtime logging (never `DBMS_OUTPUT.PUT_LINE`).

### Security
- Always filter by `APP_USER` or use APEX authorization schemes.
- Never trust client-side values for security decisions.
- Use bind variables in all SQL (prevents SQL injection).

## Installation

Add to `build_helpdesk.sql` (or app-specific build script) in dependency order:
1. Views
2. Install helpers
3. Messages
4. UI packages
5. Business logic packages

## Rules

- ✅ One file per package (spec + body together for small packages).
- ✅ Always `CREATE OR REPLACE` — idempotent.
- ✅ End with verify query showing compile status.
- ✅ Use `set define off` / `set define on` around the package to prevent `&` substitution issues.
- ❌ Never hardcode schema names — use synonyms or `current_schema`.
- ❌ Never use `DBMS_OUTPUT.PUT_LINE` in production code.
- ❌ Never use `EXECUTE IMMEDIATE` with user input without bind variables.

## Verification

```sql
-- Compile status
SELECT object_name, object_type, status, last_ddl_time
  FROM user_objects
 WHERE object_type IN ('PACKAGE', 'PACKAGE BODY', 'VIEW', 'PROCEDURE', 'FUNCTION')
 ORDER BY object_type, object_name;

-- Source lines
SELECT line, text
  FROM user_source
 WHERE name = 'PKG_<APP>_<DOMAIN>'
   AND type = 'PACKAGE BODY'
 ORDER BY line;
```
