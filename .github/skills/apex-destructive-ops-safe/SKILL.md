---
name: apex-destructive-ops-safe
description: Mandatory pre-flight checklist for ANY destructive operation in the Oracle DB / APEX dictionary — DROP, DELETE, UPDATE without WHERE, TRUNCATE, REVOKE, DBMS_SCHEDULER kill, APEX import that replaces app, schema rename. Use BEFORE running any DDL/DML that cannot be trivially undone. Distilled from oracle-apex-ai-skills + this project's lessons.
---

# Destructive Operations — Pre-flight Checklist

ALL of the following before pressing enter on a destructive statement. If any check fails, STOP and surface to the user.

## 1. Classify the operation

| Class | Examples | Default |
|---|---|---|
| **Reversible** | `INSERT`, `UPDATE` of single row by PK, `ALTER … ADD COLUMN`, `CREATE OR REPLACE PACKAGE` | proceed if validated |
| **Reversible only with backup** | `UPDATE` many rows, `DELETE` rows, `TRUNCATE`, `ALTER … DROP COLUMN`, `DROP INDEX` | require user OK + show row count |
| **Hard destructive** | `DROP TABLE/VIEW/PACKAGE`, `DROP USER CASCADE`, schema rename, APEX `apex import` overwriting app, `REVOKE`, `kill session`, deleting a workspace | require explicit user confirmation in plain words |

## 2. Pre-flight checks for DML

Before any `UPDATE`/`DELETE`:

```sql
-- 1. Identify affected rows
select count(*) as rows_to_change
  from <table>
 where <same WHERE you will use in UPDATE/DELETE>;

-- 2. Sample 5
select *
  from <table>
 where <same WHERE>
 fetch first 5 rows only;

-- 3. Run the statement WITHOUT commit
update/delete … ;       -- no semicolon-newline-slash autocommit
-- 4. Verify
select count(*) as rows_after from <table> where <same WHERE>;
-- 5. Commit OR rollback
commit;   -- only after user confirms count is correct
```

Never blanket `UPDATE table SET col = X;` without WHERE — always answer "how many rows" first.

## 3. Pre-flight checks for DDL

Before `DROP`/`ALTER ... DROP`:

```sql
-- owner check (don't drop SYS / APEX_ / SYSAUX objects by accident)
select owner, object_type, status from all_objects where object_name='<NAME>';

-- dependencies
select * from user_dependencies where referenced_name = '<NAME>';
-- or
select * from all_dependencies where referenced_name = '<NAME>' and referenced_owner = '<OWNER>';
```

Prefer `ALTER ... MODIFY` over `DROP + CREATE` whenever possible. Prefer `CREATE OR REPLACE` over `DROP + CREATE` for packages/views.

## 4. APEX-specific destructive ops

| Op | Risk | Required check |
|---|---|---|
| `apex import` overwriting existing app | Replaces ALL pages, packages refs, lists, themes | Run `apex export` FIRST as snapshot; commit; THEN import |
| `apex_util.remove_user` | Removes workspace user + audit chain | Confirm not ADMIN; confirm not the only workspace admin |
| `update apex_260100.wwv_flow_*` | Bypasses APEX validation, can leave orphan rows | NEVER except SYS rescue with explicit user request |
| Delete a workspace | Cascades to apps, themes, files | Almost never the right answer — ask twice |

## 5. Transaction-boundary rules

- Reusable PL/SQL procedures should **never** issue `commit` or `rollback` — caller owns the transaction. Only exception: routines explicitly marked `pragma autonomous_transaction`.
- Scripts that change data/metadata: make `commit` and `rollback` calls explicit; don't rely on sqlplus auto-commit.
- After SYS rescue updates: always `commit;` on the same connection that did the `update`.

## 6. Environment guard

Before any destructive op, confirm:
- Which container? (`apex_db`, not a prod target)
- Which PDB? (`FREEPDB1`)
- Which schema? (`APP_DATA`, not `SYSTEM` / `APEX_260100`)
- Which APEX workspace? (`APEX_DEV`)
- Which app id? (`100` = SCAFF; do NOT touch 4000-4999 = APEX internals)

If user is working with a real customer/prod DB — STOP and require explicit confirmation including the target host.

## 7. After-action verification

- Row count matches the pre-count
- `select count(*) from user_objects where status='INVALID';` returns 0 (or only the objects you knew would break)
- Did APEX page still render? Open in browser, hard-refresh
- Did dependent reports / jobs still pass?

## 8. Recovery patterns

- **Wrong UPDATE/DELETE not yet committed** → `rollback;` immediately on the same session
- **Already committed** → Flashback if enabled: `select * from <table> as of timestamp systimestamp - interval '5' minute;` then restore rows
- **Dropped table** → `flashback table <name> to before drop;` (only works if not `purge`d)
- **Dropped package** → restore from git (`db/packages/<name>.sql`) and recompile

## Hard rules

- ❌ NEVER `commit;` blindly inside a script doing multiple destructive statements.
- ❌ NEVER skip the row-count check on `UPDATE`/`DELETE`.
- ❌ NEVER `DROP USER … CASCADE` without explicit user instruction with the exact username.
- ✅ ALWAYS export + git-commit before any APEX `import` that touches an existing app.
- ✅ ALWAYS prefer `CREATE OR REPLACE` over `DROP + CREATE`.
- ✅ ALWAYS surface row counts and a sample before user confirms.
