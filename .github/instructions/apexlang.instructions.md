---
applyTo: "apex_app/**/*.apx"
description: "APEXlang syntax + editing + styling rules for .apx files"
---

# APEXlang Editing Rules

You are editing **APEXlang** source — the file-based representation of an Oracle APEX 26.1 application. These files are compiled and imported by SQLcl `apex import`.

## Authoritative Source

The official **Oracle APEXlang skill** (`oracle/skills/apex/apexlang`) is the source of truth for component types, property names, and valid property values. It ships routing metadata, a compiler-backed component catalog, templates, runtime helpers, SQLcl adapters, and validation tools. Install it locally with the SQLcl 26.1.2+ `skills` command. When unsure of a property name or an allowed value, consult that catalog — do NOT guess. The APEXlang compiler validates many values (notably `templateOptions`) and will reject invalid ones with confusing errors.

## Syntax Cheat Sheet

| Construct | Form |
|---|---|
| Component | `page 1 ( ... )`, `region scaff-app ( ... )`, `button SAVE ( ... )` |
| Property groups | `appearance { ... }`, `source { ... }`, `layout { ... }`, `security { ... }` |
| Property | `name: value` (camelCase keys) |
| Boolean | `true` / `false` (no quotes) |
| Multi-line code | enclosed in triple-backticks (sql / plsql fenced blocks) |
| Parent ref | `@/template-name` or `@parent-static-id` |
| Multi-value | `[ a, b, c ]` (single-element arrays may drop the brackets) |
| String with spaces | bare or quoted, depending on context — copy style from existing file |

References at a glance: `@name` = a component reference by static id; `@/name` = a built-in template/path reference; `:Pxx_ITEM` = session state; `&APP_ID.` / `#COLUMN#` = APEX substitution territory.

## Editing Rules

1. **Never rename a top-level static id** (e.g. `region scaff-app`) without checking incoming references. APEX uses static ids as anchors.
2. **Preserve indentation** — 4 spaces, consistent per file. The compiler is whitespace-tolerant but diffs are not.
3. **Always run validate** after editing: `pwsh scripts/apex-validate.ps1` (wraps `apex validate -input apex_app/scaff-app`).
4. **Don't edit `.apex/apexlang.json`** — internal compiler state.
5. **`deployments/default.json`** carries `{"app":{"id":100}}` — keep id stable.
6. **User-visible text** -> reference `SCAFF.*` messages from `shared-components/messages.apx`, not literal Dutch/English.
7. **PL/SQL inside `.apx`** -> keep it minimal. Delegate to packages in `db/packages/` and call from the `.apx`:
   ```
   source {
       plsqlFunctionBody: return PKG_SCAFF_UI.get_mobile_menu;
   }
   ```
8. **Templates** in this app:
   - `@/standard` — default
   - `@/blank-with-attributes` — for custom HTML regions
   - `@/blank-with-attributes-no-grid` — preferred for our scaff-menu (no grid wrapper)

## Styling — Use the Universal Theme, Not Hand-Rolled HTML

The goal is to lean on the theme's built-in styling instead of bespoke HTML/CSS. Prefer, in this order:

1. **Theme Roller + `templateOptions`** — the theme drives almost all visual variation through template options, not custom CSS.
2. **A region type that supplies its own formatting** — `cards`, badge list, etc. — instead of a hand-built HTML table.
3. **Static-file CSS** under `shared-components/static-files/`.
4. **Inline CSS** — last resort only.

### templateOptions

Combine multiple options as a multi-value array. The exact option keys are theme-specific and compiler-validated, so **copy them from a real export of this app or from the skill catalog — never invent class names**:

```
appearance {
    template: @/standard
    templateOptions: [ #DEFAULT#, <verified-option-key>, ... ]
}
```

Common areas you can drive via options (verify exact keys before use): region body padding, accent/colour variants, header visibility, scrollable body; button hot/primary, size, stretch, display-as-link.

### Region types with built-in formatting

- `cards` — for tile/list presentation with declarative layout, appearance, icon, badge, and media, instead of a hand-written HTML table.
- badge list — for statuses and counts.
- Fall back to a `dynamicContent` region returning an HTML `<table>` ONLY when no native type fits (see `scaff-mobile` skill, "Data-list Region Variant").

### Template Directives (client-side formatting)

In `cards` regions and Interactive Grids, use template directives for conditional/variable formatting instead of building UI logic in SQL or raw HTML. Supported directives: `if, elseif, else, endif, case, when, otherwise, endcase, loop, endloop`. This keeps SQL free of UI logic and avoids `!RAW` substitution (reduces XSS risk). Example inside a card title:

```
{if ?LAST_NAME/}&LAST_NAME., &FIRST_NAME.{else/}&FIRST_NAME.{endif/}
```

### Icons

Use Font APEX classes (`fa-...` / `a-Icon`) for icons in lists, buttons, and cards so they inherit theme colours and scale with the Theme Roller. Do NOT use inline `<i>` tags or Unicode/emoji glyphs.

## Component Reference Targets

- `pageTemplate: @/standard`
- `template: @/blank-with-attributes-no-grid`
- `region: @scaff-app` (inside a child component)

## When You Add a New Region

```
region <static-id> (
    name: <Display Name>
    type: <staticContent | dynamicContent | classicReport | cards | ...>
    source { ... }
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
- **Invented `templateOptions` / template / class values.** These are compiler-validated; an unverified value fails `validate` with misleading errors. Verify against a real export or the skill catalog.
- `classicReport` with `sqlQuery` property — the APEXlang parser rejects it. `classicReport` REQUIRES `source.tableName` + child `column { ... }` blocks + `appearance.template`. For ad-hoc SQL lists, use a `dynamicContent` region calling a PL/SQL function that returns an HTML `<table>` (see `scaff-mobile` skill, "Data-list Region Variant").
- Raw `&APP_ID.` / `&APP_SESSION.` / `&DEBUG.` tokens inside CLOB returned from a `dynamicContent` region — APEX does NOT substitute these post-render. Substitute in PL/SQL with `apex_application.g_flow_id`, `apex_application.g_instance`, `nvl(v('DEBUG'),'NO')` BEFORE `apex_util.prepare_url`.

## File Encoding

The APEXlang parser ACCEPTS ONLY LF line endings. Files created on Windows via tools default to CRLF and will fail validate with confusing `MISSING_REQUIRED_PROPERTY` errors on properties that are clearly present. After creating or editing any `.apx` file on Windows, normalise:

```powershell
$p='...\file.apx'; $c=[IO.File]::ReadAllText($p) -replace "`r`n","`n"; [IO.File]::WriteAllText($p,$c)
```

`scripts/apex-export.ps1` does this automatically after export. Manual creations need it explicitly.