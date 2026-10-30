# Verification record

Build reviewed on 30 October 2026. Source saved locally; no commit, push, DNS change, deployment or real message send performed by the coding agent.

## Automated logic tests

19 passing Node tests cover:
- quoted CSV commas/newlines/escaped quotes/BOM, semicolon/tab files and malformed quotes;
- duplicate/blank headings, source row numbers, selectable heading rows and prototype-safe column indexing;
- row/column limits and semantic/value-based mapping;
- selected-only fields, unresolved placeholders, Quick Message isolation and deliberate private-field inclusion;
- exact Unicode/emoji/plus/ampersand/hash/newline mailto encoding;
- common To/CC/BCC deduplication and Gmail/Outlook Personal/Work compose parameters;
- header/address injection rejection, WhatsApp international/local-prefix normalization;
- template schema/caps and progress backup validation.

Run: node --test tests/core.test.mjs

## Browser checks performed

- Local HTTP server returned 200; application loaded with local scripts and CSP.
- Fictional demo mapped Name/Email/Phone correctly; private password column was masked and unchecked.
- Selecting the next person changed the preview correctly, including selected Course data.
- Email progress mark survived reload and reloading the same demo, and remained separate from WhatsApp.
- A real generated XLSX test fixture loaded through the bundled worker; two records appeared. Selecting a second sheet and heading row 2 selected its intended record and mapping.
- Template save and duplicate created separate library entries; Use in Excel Converter reused the edited template.
- Login opened its account dialog; credentials/submission disabled. Create Account tab switched correctly; Continue Free closed the dialog. Quick Guide navigated steps; Escape restored focus to its launcher.
- Mobile menu retained navigation; 390px layout checked for page overflow in Quick Message and My Templates.
- Gmail Web handoff requested a draft using fictional data and opened Google's logged-out Gmail landing page. No claim is made that a signed-in Gmail composer was verified.

## Boundaries

Node tests validate generated URLs, not native app behavior. Physical Android/iOS Gmail, Outlook and WhatsApp handoff was not tested. Installed/default app routing cannot be guaranteed by a website. A message must be reviewed and sent by the user.

The browser upload check covered XLSX; CSV quoting/delimiters are covered by core tests. Drag/drop event wiring and legacy XLS support are implemented; direct native drag/drop and a browser legacy-XLS upload remain manual smoke-test items. Large-file/timeout behavior has explicit guards; this is not a forensic audit of every malformed spreadsheet archive.

Template/progress import/export should be smoke-tested on the final HTTPS origin with fictional data, including transferring backups to another browser. Localhost and production storage are intentionally separate. Do not use real student credentials in public screenshots or test fixtures.
