---
name: apex-26-calculations
description: Computations, validations, and formula patterns for Oracle APEX 26.1 — page/item computations, validations, dynamic actions, and PL/SQL expressions. Use whenever the user wants to add calculations, formulas, validations, or computed fields in any APEX app.
---

# APEX 26.1 Calculations & Validations (generic)

## When to invoke

User says any of:
- "bereken veld X op basis van Y"
- "voeg een validatie toe"
- "formule voor totaalprijs"
- "compute total / sum / count"
- "dynamisch veld updaten"
- "check of email geldig is"
- ANY request involving formulas, math, or field validation

## Computation Types

### 1. Page Item Computation (static)
Set item value when page loads:
```
computation <code> (
    item: P10_TOTAL
    type: staticAssignment
    value: 0
    point: beforeHeader
)
```

### 2. SQL Query Computation
```
computation <code> (
    item: P10_PROJECT_NAME
    type: sqlQuery
    sqlQuery: select name from projects where id = :P10_PROJECT_ID
    point: afterHeader
)
```

### 3. PL/SQL Expression Computation
```
computation <code> (
    item: P10_TOTAL
    type: plsqlExpression
    plsqlExpression: :P10_QUANTITY * :P10_UNIT_PRICE
    point: afterSubmit
)
```

### 4. Function Body Computation
```
computation <code> (
    item: P10_FULL_NAME
    type: plsqlFunctionBody
    plsqlFunctionBody: |
        declare
            l_first varchar2(100);
            l_last  varchar2(100);
        begin
            select first_name, last_name into l_first, l_last
              from employees where id = :P10_EMP_ID;
            return l_first || ' ' || l_last;
        end;
    point: afterHeader
)
```

## Validation Patterns

### Not Null
```
validation <code> (
    item: P10_EMAIL
    type: notNull
    message: &MSG.APP.VAL.EMAIL.REQUIRED.
    alwaysExecute: true
)
```

### Regular Expression
```
validation <code> (
    item: P10_EMAIL
    type: regexp
    expression: '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    message: &MSG.APP.VAL.EMAIL.INVALID.
)
```

### PL/SQL Expression
```
validation <code> (
    item: P10_END_DATE
    type: plsqlExpression
    plsqlExpression: :P10_END_DATE >= :P10_START_DATE
    message: &MSG.APP.VAL.DATE.RANGE.
)
```

### Function Body (complex logic)
```
validation <code> (
    type: plsqlFunctionBody
    plsqlFunctionBody: |
        declare
            l_count number;
        begin
            select count(*) into l_count
              from bookings
             where room_id = :P10_ROOM_ID
               and booking_date = :P10_DATE;
            return l_count = 0;
        end;
    message: &MSG.APP.VAL.ROOM.BOOKED.
)
```

## Dynamic Action — Client-Side Calculation

Update a field without page submit:
```
dynamicAction calc-total (
    event: change
    selectionType: item
    item: P10_QUANTITY,P10_UNIT_PRICE
    trueActions {
        action: setValue
        setValue {
            item: P10_TOTAL
            value: plsqlExpression
            plsqlExpression: :P10_QUANTITY * :P10_UNIT_PRICE
        }
    }
)
```

## JavaScript Client-Side Calculation

For instant feedback without server round-trip:
```javascript
// Execute on page load + on change
function calculateTotal() {
    var qty = parseFloat($v('P10_QUANTITY')) || 0;
    var price = parseFloat($v('P10_UNIT_PRICE')) || 0;
    var total = qty * price;
    $s('P10_TOTAL', total.toFixed(2));
}

// Bind to events
$('#P10_QUANTITY, #P10_UNIT_PRICE').on('change', calculateTotal);
calculateTotal(); // initial
```

## Common Formulas

| Formula | PL/SQL Expression |
|---|---|
| Sum | `:P10_A + :P10_B + :P10_C` |
| Product | `:P10_QTY * :P10_PRICE` |
| Percentage | `:P10_AMOUNT * :P10_PERCENT / 100` |
| Date difference | `:P10_END_DATE - :P10_START_DATE` |
| VAT calculation | `:P10_NET * (1 + :P10_VAT_RATE/100)` |
| String concat | `:P10_FIRST || ' ' || :P10_LAST` |

## Computation Points

| Point | When it runs |
|---|---|
| `onNewInstance` | Once per session |
| `beforeHeader` | Before page header |
| `afterHeader` | After page header |
| `beforeRegions` | Before regions render |
| `afterRegions` | After regions render |
| `beforeFooter` | Before footer |
| `afterFooter` | After footer |
| `onSubmit` | When page is submitted |
| `afterSubmit` | After page submit processing |

## Rules

- ✅ Always use `apex_lang.message()` for validation messages.
- ✅ Use client-side JS for instant feedback; server-side for data integrity.
- ✅ Bind numbers with `parseFloat()` or `parseInt()` in JS to avoid string concatenation.
- ❌ Never compute sensitive values (prices, discounts) only client-side — always validate server-side.
- ❌ Don't use `to_char` in PL/SQL expressions for numeric items — APEX handles conversion.

## Verification

```sql
-- Computations
select page_id, computation_name, computation_item, computation_type
  from apex_application_page_comp
 where application_id = <id>
 order by page_id, computation_point;

-- Validations
select page_id, validation_name, validation_type, associated_item
  from apex_application_page_val
 where application_id = <id>
 order by page_id, validation_sequence;
```
