---
name: apex-26-interactive-grids
description: Interactive Grid (IG) patterns for Oracle APEX 26.1 — columns, toolbars, validations, row handling, and save behavior. Use whenever the user wants to create, modify, or troubleshoot an Interactive Grid region in any APEX app.
---

# APEX 26.1 Interactive Grid Patterns (generic)

## When to use Interactive Grid

Use IG when the user needs:
- Inline editing of multiple rows
- Add / delete rows directly in the grid
- Column-level validations
- Search/filter per column
- Master-detail with row selection

Avoid IG for simple read-only lists — use `classicReport` or `dynamicContent` instead.

## APEXlang IG Structure

```
region <code> (
    type: interactiveGrid
    template: @/standard
    source {
        sqlQuery: |
            select id, name, status, created_at
              from my_table
             where project_id = :P10_PROJECT_ID
    }
    columns {
        column ID (
            type: hidden
            primaryKey: true
        )
        column NAME (
            type: text
            heading: &MSG.APP.COL.NAME.LABEL.
            required: true
            validation {
                type: notNull
                message: &MSG.APP.VAL.NAME.REQUIRED.
            }
        )
        column STATUS (
            type: selectList
            heading: &MSG.APP.COL.STATUS.LABEL.
            lov {
                sqlQuery: select display d, value r from my_status_lov
            }
        )
        column CREATED_AT (
            type: datePicker
            heading: &MSG.APP.COL.DATE.LABEL.
            formatMask: DD-MM-YYYY
            readOnly: true
        )
    }
    toolbar {
        button create (
            action: addRow
            label: &MSG.APP.BUTTON.ADD.LABEL.
            buttonTemplate: @/text
            hot: true
            layout { slot: create }
        )
        button save (
            action: save
            label: &MSG.APP.BUTTON.SAVE.LABEL.
            buttonTemplate: @/text
            layout { slot: save }
        )
        button delete (
            action: deleteRow
            label: &MSG.APP.BUTTON.DELETE.LABEL.
            buttonTemplate: @/text
            style: danger
            layout { slot: delete }
        )
    }
    edit {
        enabled: true
        operations: add, update, delete
    }
    pagination {
        type: scroll
        pageSize: 50
    }
)
```

## Column Types

| Type | Use for |
|---|---|
| `text` | Short strings |
| `textarea` | Long text |
| `number` | Numeric values |
| `datePicker` | Dates |
| `selectList` | Dropdown from LOV |
| `popupLov` | Searchable dropdown |
| `checkbox` | Boolean flags |
| `hidden` | Primary key / technical fields |
| `display` | Read-only display |

## IG Toolbar Buttons

| Slot | Action | Typical label |
|---|---|---|
| `create` | `addRow` | "Nieuw" / "Add" |
| `save` | `save` | "Opslaan" / "Save" |
| `delete` | `deleteRow` | "Verwijderen" / "Delete" |
| `reset` | `reset` | "Herstellen" / "Reset" |

## Validations

### Column-level (inline)
```
column EMAIL (
    type: text
    validation {
        type: regexp
        expression: '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
        message: &MSG.APP.VAL.EMAIL.INVALID.
    }
)
```

### Row-level (PL/SQL)
Add a page process after IG save:
```sql
for i in 1..apex_application.g_f01.count loop
    if apex_application.g_f02(i) is null then
        apex_error.add_error(
            p_message => apex_lang.message('APP.VAL.NAME.REQUIRED'),
            p_display_location => apex_error.c_inline_with_field_and_notification,
            p_page_item_name => 'IG_NAME');
    end if;
end loop;
```

## Master-Detail Pattern

Master page (P10) has IG with `rowSelection: single`. Detail page (P11) receives selected ID via item `P11_MASTER_ID`.

```
region master_ig (
    type: interactiveGrid
    rowSelection: single
    columns {
        column ID ( primaryKey: true )
        column NAME ( type: text )
    }
    link {
        target: page 11
        items: P11_MASTER_ID = #ID#
    }
)
```

## Common Pitfalls

| Issue | Cause | Fix |
|---|---|---|
| "No data found" after save | Missing `returning` clause in source | Add `returning id into :ID` |
| Toolbar buttons not visible | Wrong `slot` value | Use `create`, `save`, `delete` |
| Validation not firing | `edit.enabled: false` | Set `edit.enabled: true` |
| Date format wrong | Missing `formatMask` | Add `formatMask: DD-MM-YYYY` |
| Primary key not hidden | `type: hidden` missing | Hide technical columns |

## Verification

```sql
select region_name, source_type, edit_operations
  from apex_application_page_regions
 where application_id = <id>
   and source_type = 'Interactive Grid';
```
