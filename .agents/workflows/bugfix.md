# Bugfix workflow

1. Capture symptom, expected result and reproducible steps.
2. Gather the narrowest useful logs and failing test.
3. Identify the root cause before editing.
4. Define the smallest safe fix and protected areas.
5. Add a regression test or explain why one is not practical.
6. Run targeted checks, then broader checks when justified.
7. Report root cause, changed behavior and remaining risk.

Do not combine cleanup or refactoring with the fix unless required to make the fix safe.
