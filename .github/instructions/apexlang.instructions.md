---
applyTo: "apex_app/**/*.apx"
description: "APEXlang syntax + editing rules for .apx files"
---

# APEXlang Editing Rules

You are editing **APEXlang** source — the file-based representation of an Oracle APEX 26.1 application. These files are compiled and imported by SQLcl `apex import`.

## Syntax Cheat Sheet

| Construct | Form |
|---|---|
| Component | `page 1 ( … )`, `region scaff-app ( … )`, `button SAVE ( … )` |
| Property groups | `appearance { … }`, `source { … }`, `layout { … }`, `security { … }` |
| Property | `name: value` (camelCase keys) |
| Boolean | `true` / `false` (no quotes) |
| Multi-line code | enclosed in triple-backticks |
| Parent ref | `@/template-name` or `@parent-static-id` |
| Multi-value | `[ a, b, c ]` |
| String with spaces | bare or quoted, depending on context — copy style from existing file |

## Editing Rules

1. **Never rename a top-level static id** (e.g. `region scaff-app`) without checking incoming references. APEX uses static ids as anchors.
2. **Preserve indentation** — 4 spaces, consistent per file. The compiler is whitespace-tolerant but diffs are not.
3. **Always run validate** after editing: `pwsh scripts/apex-validate.ps1` (wraps `apex validate -input apex_app/scaff-app`).
4. **Don't edit `.apex/apexlang.json`** — internal compiler state.
5. **`deployments/default.json`** carries `{"app":{"id":100}}` — keep id stable.
6. **User-visible text** → reference `SCAFF.*` messages from `shared-components/messages.apx`, not literal Dutch/English.
7. **PL/SQL inside `.apx`** → keep it minimal. Delegate to packages in `db/packages/` and call from the `.apx`:
   ```
   source {
       plsqlFunctionBody: return PKG_SCAFF_UI.get_mobile_menu;
   }
   ```
8. **Templates** in this app:
   - `@/standard` — default
   - `@/blank-with-attributes` — for custom HTML regions
   - `@/blank-with-attributes-no-grid` — preferred for our scaff-menu (no grid wrapper)

## Component Reference Targets

- `pageTemplate: @/standard`
- `template: @/blank-with-attributes-no-grid`
- `region: @scaff-app` (inside a child component)

## When You Add a New Region

```
region <static-id> (
    name: <Display Name>
    type: <staticContent | dynamicContent | classicReport | …>
    source { … }
    layout {
        sequence: 10
        slot: body
    }
    appearance {
        template: @/blank-with-attributes-no-grid
        templateOptions: #DEFAULT#
    }
)
```

## Forbidden

- Inline credentials, connection strings, hostnames.
- Hardcoded user-visible Dutch/English strings — use messages.
- Direct references to `wwv_flow_*` internal tables.
- `classicReport` with `sqlQuery` property — the APEXlang parser rejects it. `classicReport` REQUIRES `source.tableName` + child `column { … }` blocks + `appearance.template`. For ad-hoc SQL lists, use a `dynamicContent` region calling a PL/SQL function that returns an HTML `<table>` (see `scaff-mobile` skill, "Data-list Region Variant").
- Raw `&APP_ID.` / `&APP_SESSION.` / `&DEBUG.` tokens inside CLOB returned from a `dynamicContent` region — APEX does NOT substitute these post-render. Substitute in PL/SQL with `apex_application.g_flow_id`, `apex_application.g_instance`, `nvl(v('DEBUG'),'NO')` BEFORE `apex_util.prepare_url`.

## File Encoding

The APEXlang parser ACCEPTS ONLY LF line endings. Files created on Windows via tools default to CRLF and will fail validate with confusing `MISSING_REQUIRED_PROPERTY` errors on properties that are clearly present. After creating or editing any `.apx` file on Windows, normalise:

```powershell
$p='...\file.apx'; $c=[IO.File]::ReadAllText($p) -replace "`r`n","`n"; [IO.File]::WriteAllText($p,$c)
```

`scripts/apex-export.ps1` does this automatically after export. Manual creations need it explicitly.
