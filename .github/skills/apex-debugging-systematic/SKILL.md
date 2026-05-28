---
name: apex-debugging-systematic
description: Systematic protocol for debugging Oracle APEX runtime issues — Session State alignment, Dynamic Action / AJAX triage, upload/import cycle testing. Use BEFORE blindly editing pages, packages, or processes when a user reports "the page doesn't work / button does nothing / dynamic action fails / upload broke / data didn't save". Distilled from oracle-apex-ai-skills.
---

# APEX Debugging — Systematic Protocol

When a user reports an APEX runtime issue, do NOT immediately edit pages or recompile packages. Walk the protocol first. Most APEX bugs are environment-misalignment or unchecked AJAX dependencies, not actual code defects.

## 1. Session State Alignment (the #1 cause of "it doesn't work")

Confirm all surfaces point to the same app and environment BEFORE assuming code is wrong:

- Page Designer (which app id, which page?)
- Runtime application session (open in browser; check `f?p` URL)
- Session State viewer (Builder → Session)
- SQLcl/MCP connection (which schema/PDB?)
- The exported `.apx` you're reading (same app id?)
- Current DEV/TEST/PROD environment (this workspace = DEV)

**Rule**: do NOT assume a package recompile or Page Designer save reached the runtime path until the runtime session proves it. After a change, hard-refresh (Ctrl+Shift+R) and re-check Session State values.

## 2. Dynamic Action / AJAX Triage Checklist

Run through ALL of these — most "DA doesn't fire" issues are #3 or #4:

1. **Triggering event** — right event type (Change vs Click)? Right selection type (jQuery vs Item)?
2. **Affected Elements** — does the target selector match a real DOM element on this page?
3. **Client-side Condition** — evaluating to true at fire time? (test in browser console)
4. **True/False action order** — execute in order; later actions see DOM state from earlier ones
5. **Wait for Result** — must be ON when a later action depends on AJAX completion. Default OFF causes silent ordering bugs.
6. **AJAX callback / page process** — returns valid JSON in expected shape? Check Network tab.
7. **JSON shape** — log the actual response BEFORE changing UI code; assumption of shape is usually wrong

## 3. Upload / Import / Wizard Cycle Test

For any flow that touches a file or staging table, test the FULL cycle, not just the happy path:

1. Upload / select file
2. Validate step — does it surface warnings + errors?
3. Review screen — is row count and preview correct?
4. Import / confirm
5. Inspect staging + history tables (e.g. `apex_application_temp_files`, custom `*_STAGING`)
6. Test a known failure file (wrong columns, oversized)
7. Test rollback / reversal if the flow supports it
8. Re-upload the same file — duplicate handling?

## 4. PL/SQL post-change validation (mandatory after any package edit)

```sql
-- did it compile clean?
select object_name, object_type, status
  from user_objects
 where object_name in ('PKG_X','PKG_Y')
 order by object_type, object_name;

-- if any INVALID:
select name, type, line, position, text
  from user_errors
 where name in ('PKG_X','PKG_Y')
 order by name, type, sequence;
```

Don't move on until status = `VALID` for everything you touched.

## 5. Standard APEX runtime checks

| Check | Where |
|---|---|
| Item values | Builder → Session State |
| Process / branch trace | Builder → Debug → View Debug |
| JS errors | Browser DevTools → Console |
| Network calls | Browser DevTools → Network (filter "wwv_flow.ajax") |
| Auth/user context | `select v('APP_USER'), v('APP_ID'), v('APP_SESSION') from dual;` |
| Workspace alias / app id | URL `f?p=<id>:<page>:<session>` |

## 6. Common categories — quick triage

| Symptom | Most likely cause |
|---|---|
| Button does nothing | DA wrong event/selector; or Client-side Condition false |
| Form save "succeeds" but no data | Process condition; or wrong process point (After Submit vs Validations) |
| Item value not visible to process | Page Item not in Session State (Storage = Per Request) |
| Page renders blank | Region condition; or PL/SQL error swallowed by region template |
| AJAX returns 500 | Page process raised; check `wwv_flow.ajax` response body |
| "Application not found" on a link | Unsubstituted `&APP_ID.` — see `apex-26-patterns` gotcha #1 |
| Login refused without reason | ADMIN account expired — see `apex-26-patterns` gotcha #6 |

## Hard rules

- ❌ Don't edit code before reproducing in the runtime session.
- ❌ Don't claim "fixed" without a hard refresh + new session state check.
- ✅ Always check `user_errors` after package compile.
- ✅ Always inspect the JSON response, don't guess the shape.
- ✅ Always test the full cycle for upload/import flows, including the failure path.
