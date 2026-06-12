---
name: apex-26-buttons
description: Button styling, templates, colors, and behavior patterns for Oracle APEX 26.1. Use whenever the user wants to change button color, style, template, hot/danger/primary state, add a button, or modify button appearance in any APEX app.
---

# APEX 26.1 Button Patterns (generic)

## Button Templates

| Template | Use case |
|---|---|
| `@/text` | Plain text button, no border/background |
| `@/text-with-icon` | Text + FontAwesome icon |
| `@/icon` | Icon-only button |
| `@/standard` | Default bordered button |
| `t-Button--hot` | Primary action (red in Altrad theme) |

## Button Properties in APEXlang

```
button <code> (
    label: &MSG.KEY.LABEL.
    action: submitPage | redirect | definedByDynamicAction
    buttonTemplate: @/text | @/text-with-icon | @/icon
    hot: true | false
    style: primary | danger | warning | success | default
    icon: fa-plus | fa-save | fa-trash | fa-arrow-left | …
    layout { sequence: 10, slot: body }
)
```

## Color / Style Mapping

| `style` | CSS class injected | Typical use |
|---|---|---|
| `primary` | `t-Button--primary` | Main action (save, submit) |
| `danger` | `t-Button--danger` | Destructive (delete, cancel) |
| `warning` | `t-Button--warning` | Caution (reset, revert) |
| `success` | `t-Button--success` | Positive (approve, confirm) |
| `default` | none | Neutral action |

> `hot: true` adds `t-Button--hot` which in the Altrad theme maps to primary red (`#E2001A`).

## Changing Button Color — Quick Reference

### Option A: Change `style` property
```
button submit (
    label: Opslaan
    action: submitPage
    buttonTemplate: @/text
    style: primary        ← change this
    hot: true
)
```

### Option B: Custom CSS override (app-wide)
Add to `shared-components/static-files/css/altrad-benelux-modern.css`:
```css
/* Make all hot buttons dark red instead of primary red */
.t-Button--hot {
    background-color: #B30015 !important;
    border-color: #B30015 !important;
}
```

### Option C: Per-button CSS class
```
button submit (
    label: Opslaan
    cssClasses: my-custom-btn   ← add custom class
    action: submitPage
)
```
Then in CSS:
```css
.my-custom-btn {
    background-color: #E2001A !important;
    color: white !important;
    border-radius: 0 !important;
}
```

## JavaScript Button Manipulation

When buttons are rendered dynamically and you need to style them after load:
```javascript
// Make all hot buttons square (no border-radius)
document.querySelectorAll('button.t-Button--hot').forEach(function(b){
    b.style.borderRadius = '0';
});

// Style non-hot buttons differently
document.querySelectorAll('button.t-Button:not(.t-Button--hot)').forEach(function(b){
    b.style.backgroundColor = '#FCE6E9';
    b.style.color = '#B30015';
});
```

## Button Positioning

| Slot | Location |
|---|---|
| `slot: body` | Inside region body |
| `slot: close` | Dialog close button area |
| `slot: create` | IG toolbar create button |
| `slot: save` | IG toolbar save button |
| `slot: delete` | IG toolbar delete button |

## Rules

- ✅ Use `hot: true` for the primary action on a page (max 1 per page).
- ✅ Use `style: danger` for destructive actions (delete, cancel, remove).
- ✅ Use `buttonTemplate: @/text` for mobile-first apps — cleaner look.
- ❌ Don't use `style: primary` AND `hot: true` together — redundant.
- ❌ Don't hardcode button labels — use `apex_lang.message('APP.BUTTON.SAVE.LABEL')`.

## Verification

After import, check button rendering:
```sql
select page_id, button_name, button_template, button_is_hot, button_style
  from apex_application_buttons
 where application_id = <id>
 order by page_id, button_sequence;
```
