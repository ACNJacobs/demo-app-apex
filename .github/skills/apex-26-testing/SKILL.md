---
name: apex-26-testing
description: Efficient browser-based testing protocol for Oracle APEX 26.1 apps in this workspace. Covers login, navigation, form validation, i18n verification, and visual regression checks. Use whenever the user says "test the app", "check if it works", "verify the changes", or "smoke test".
---

# APEX 26.1 Testing Protocol

## When to invoke

User says any of:
- "test de app"
- "controleer of het werkt"
- "verify the changes"
- "smoke test"
- "check de pagina's"
- "test de knoppen / formulieren / vertalingen"
- ANY request to verify APEX runtime behaviour

## Golden Rules (learned from SCAFF APP testing)

### 1. Preserve Session — Never navigate by direct URL
❌ BAD: `navigate_page(url="http://localhost:8080/ords/f?p=100:30")`  
→ Loses session, forces re-login, wastes ~8 steps

✅ GOOD: Click UI elements (cards, links, buttons) inside the app  
→ Session preserved, no re-login needed

### 2. Reuse Browser Page
Open ONE browser page at the start. Reuse it for the entire test session.  
Only call `open_browser_page` once per test run.

### 3. Login Once, Test Everything
```
1. Open app URL (f?p=100)
2. Login with SMOKETEST / Welkom_APEX_2026!
3. Test home page + language switch
4. Click through cards to test sub-pages
5. Test forms
6. Navigate back via UI (not URL)
7. Logout (optional)
```

### 4. Efficient Dropdown Handling
For language switchers and select lists, use Playwright `selectOption()` instead of multiple click/type steps:

```javascript
await page.locator('select#P1_LANG').selectOption('nl');
```

### 5. Batch Visual Checks
Take screenshots at key points (home, form, list) instead of reading every element.

## Standard Test Flow

### Phase 1: Login & Home
1. `open_browser_page("http://localhost:8080/ords/f?p=100")`
2. Type username: `SMOKETEST`
3. Type password: `Welkom_APEX_2026!`
4. Click Sign In
5. Verify home page loads (4 cards visible)
6. Switch language: `selectOption('nl')` or `selectOption('en')`
7. Verify translated labels

### Phase 2: Navigation Test
8. Click each card:
   - Materiaal aanvraag (page 10)
   - Retour aanvraag (page 20)
   - Transfer aanvraag (page 30)
   - Mijn aanvragen (page 50)
9. For each: verify page loads, no error regions

### Phase 3: Form Test
10. From list page, click first PO
11. Verify form fields render
12. Fill required fields
13. Submit form
14. Verify success (redirect or confirmation)

### Phase 4: Verification
15. Navigate to "Mijn aanvragen"
16. Verify created request appears
17. Screenshot for visual confirmation

## Quick Checks (when user says "just verify X")

| What | How | Expected |
|---|---|---|
| Knoppen rechthoekig? | Screenshot form page | `border-radius: 0` |
| Taal NL werkt? | `selectOption('nl')`, read card labels | Dutch text |
| Taal EN werkt? | `selectOption('en')`, read card labels | English text |
| PO lijst laadt? | Click Materiaal card | List of POs visible |
| Formulier opslaan? | Fill + submit | Redirect to list |
| CSS changes applied? | Screenshot home + form | Visual match |

## Known Pitfalls

| Issue | Cause | Fix |
|---|---|---|
| Session lost | Direct URL navigation | Always use UI clicks |
| Login loop | Session timeout | Re-open browser page |
| Dropdown fails | `type_in_page` on `<select>` | Use `selectOption()` |
| Element not clickable | Behind overlay | Scroll or dismiss modal first |
| Page not found | Wrong app id / alias | Check `deployments/default.json` |

## Credentials (dev only)

| Environment | User | Password |
|---|---|---|
| APEX_DEV workspace | SMOKETEST | Welkom_APEX_2026! |
| INTERNAL workspace | ADMIN | Welkom_APEX_2026! |

## App URLs

| App | URL |
|---|---|
| SCAFF APP (id 100) | `http://localhost:8080/ords/f?p=100` |
| APEX Builder | `http://localhost:8080/ords/` |

## Token-Efficient Patterns

### Pattern A: Minimal Smoke Test (5 steps)
```
1. Open app
2. Login
3. Screenshot home
4. Click one card
5. Screenshot form
```

### Pattern B: Full Flow Test (12 steps)
```
1-4. Login + home
5. Click Materiaal card
6. Click first PO
7. Fill form
8. Submit
9. Verify redirect
10. Click Mijn aanvragen
11. Verify entry
12. Screenshot
```

### Pattern C: i18n Spot Check (6 steps)
```
1-4. Login + home
5. Switch to NL
6. Screenshot
7. Switch to EN
8. Screenshot
9. Compare
```

## After Testing

Always report:
- ✅ What worked
- ⚠️ What needs attention
- 📸 Screenshots taken
- 🎯 Recommendation (commit / fix / investigate)
