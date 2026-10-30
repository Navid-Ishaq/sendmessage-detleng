# Send Message · DeTLeng

Prepare personalized Email and WhatsApp drafts from a spreadsheet, then review and send them yourself from your own app.

**Website:** https://sendmessage.detleng.com/  
**Local source:** `D:\DETLENG2\sendmessage-detleng`  
**Build:** static HTML, CSS and JavaScript. No backend, mailing service, account database or API key is required.

## Start locally

Install Node.js if it is not already available. Open PowerShell:

```powershell
Set-Location 'D:\DETLENG2\sendmessage-detleng'
node serve.mjs
```

Open **http://127.0.0.1:8094/**. Keep that terminal running while using the preview; Ctrl+C stops it. To use a different port, set `$env:PORT='8095'` before starting. Use HTTP localhost or HTTPS hosting: double-clicking index.html as a file is not supported because modules, workers and browser clipboard/security APIs behave differently under file://.

No npm install or build is necessary. The complete spreadsheet reader is bundled locally in assets/vendor. A page load needs the hosting server; reading a file does not upload that file to a third party. This is not an installable offline/PWA app.

## The three modes

### 1. Quick Message

Use this without a spreadsheet. Enter one or more email addresses in To. Commas, semicolons and new lines separate addresses. Expand CC/BCC for a common group email. CC is visible to recipients; BCC hides those recipients from each other. Every recipient gets the same body. Do not put one person's private information into a group email.

For WhatsApp, enter one international number. Write the subject/message, choose a template if useful, and review the preview. Quick Message never fills placeholders from the last spreadsheet recipient. If a personalized template still contains {Name}, edit that token into the intended text before opening a draft.

### 2. Excel Converter

1. Browse or drag one .xlsx, .xls or UTF-8 CSV file onto the drop area. Maximum input size: 10 MB. Parsing occurs in a local worker for Excel; CSV supports quoted commas, embedded line breaks, escaped quotes, BOM, and comma/semicolon/tab delimiters.
2. Select the worksheet and heading row (first 20 rows). Blank column headings become Column N; duplicate labels receive a suffix, for example Name (2). Source row numbers remain visible, including gaps caused by blank rows.
3. Confirm Name, Email and Phone mappings. Suggestions use headings and email-value samples; they are suggestions, so review them. Arbitrary organizations can map unusual column names manually.
4. Select one radio button. Search the non-private values or source row; use paging for large lists and Previous/Next person for the filtered list. One personalized message can have only one destination email. The app does not send to a group from this mode.
5. Check the fields to include. Name is selected when detected; other fields require deliberate selection. Insert a selected field with its {Column label} button. Selected fields not already used in the subject/body are appended as labelled details. Unchecked fields are excluded; unresolved or unchecked placeholders visibly block draft opening.
6. Review the complete subject/body and destination. Private columns are masked in the table and unchecked by default. Including a private field asks for confirmation; opening an external draft containing it asks you to check the destination again. An email/phone override applies only to the selected person and clears when the person, sheet or file changes.
7. Open Email/WhatsApp. Review inside your own app and press Send yourself. Return to mark progress manually if desired.

Limits: up to 30 worksheets, 10,000 nonblank records per selected sheet, 100 columns, and 15 seconds for the Excel worker. Oversized ranges are rejected rather than silently cut off. Formatted spreadsheet text is used, but a phone number whose leading zeros were already lost in the source cannot be reconstructed automatically. Store phone numbers as text and include country codes when possible. Malformed, encrypted/password-protected or unsupported files may need conversion to a normal XLSX/UTF-8 CSV first.

**Clear file** removes the loaded rows from memory; it does not delete saved templates or progress. No real student spreadsheet is included in the repository. Try fictional demo uses deliberately fictional records and example.com addresses; replace the destination with your own address/number to test app handoff.

### 3. My Templates

Create, save, edit, duplicate or delete reusable templates. Each has a name, subject and body. Names are unique when saving. Use exact column labels in braces, such as {Name}, {Course} or {Password (private)}. Choosing a template does not bypass field selection.

- Export JSON backs up the whole library. Import JSON restores it.
- Merge keeps current templates and renames incoming duplicate names.
- Replace asks before replacing the library.
- Export selected TXT is a human-readable copy; TXT is not a template-library import format.
- Up to 100 templates, 100 characters per name, 200 per subject and 10,000 per body; JSON imports are limited to 2 MB.
- Use in Quick Message / Excel Converter copies the editor text to that mode's own composer.

Only the template structure is saved automatically; a spreadsheet recipient's substituted values are never saved into a template by the app. Anything you manually type and save is stored exactly, so use placeholders instead of actual passwords or other private values. Browser-local storage is not an encrypted vault.

Example import JSON:

```json
[
  {
    "name": "Personal welcome",
    "subject": "Welcome",
    "body": "Dear {Name},\n\nWelcome! Please review the information below.\n\nThank you."
  }
]
```

## Email and WhatsApp: what the buttons actually do

**Nothing is sent automatically. No messages are sent by this website's own email address.** Your own app/provider account determines the sender. A compose-link request cannot confirm that an app actually opened, which sending account was selected, or whether the message was delivered.

| Email option | Route |
|---|---|
| Default Email App | mailto: handled by the configured device/browser email handler |
| Gmail Web | Gmail browser compose |
| Outlook Personal Web | Personal Outlook browser compose |
| Outlook Work / School | Organization Outlook browser compose |

Remember this email option stores your preference on this browser. Having Gmail/Outlook installed does not automatically make it the default mailto handler. Configure the default email app in device/browser settings. Desktop may use a desktop app or webmail; mobile routing depends on OS, browser, installed apps and defaults. This website cannot force every device into a particular installed app.

WhatsApp uses the official https://wa.me/internationalnumber?text=... format. Include country code, for example +34 600 111 222. Spaces, brackets, dashes and an international 00 prefix are normalized. Optionally enter a country-code prefix for local numbers; leave it blank when values are already international. Extensions and letters are rejected. A click can open WhatsApp or its normal app/web handoff page; users must still send themselves.

Unicode, emoji, +, &, # and line breaks are encoded. mailto uses percent-encoded text and CRLF line breaks. A compose URL exceeding 1,800 characters is blocked instead of risking silent truncation. Use Copy message, open your app, paste and address it manually. This conservative threshold is a fallback rule, not a claim of a universal provider limit. Draft links do not attach the workbook or files.

Copy message includes the email subject followed by the body. WhatsApp receives only the body. Clipboard failure offers manual selection/copy from the preview. No window-open success or delivery status is invented.

## Manual progress: remembered for each person

Email and WhatsApp marks are independent and timestamped. They are a personal checklist, not delivery receipts. Opening a draft does not mark a person sent.

Progress is scoped by the SHA-256 fingerprint of the exact file bytes, selected worksheet, header row, campaign name and source row. The same unchanged file and campaign restores marks after refresh/re-upload on the same origin/browser. Changing file contents/order, exporting a workbook again, or choosing another worksheet/header/campaign can create a new scope. The app deliberately does not guess that changed rows are the same person. Duplicate recipients remain separate source rows.

- Mark Email sent / Mark WhatsApp sent: after you have sent in your app.
- Undo removes the selected person's channel mark.
- Change Campaign name to track another message separately; the last name is remembered locally.
- Export progress creates a JSON backup with opaque scope/row IDs, channels and times. It contains no raw email addresses, passwords or message text.
- Import merges valid marks, retaining the latest time for a duplicate key/channel. Reopen the same file and campaign to see the marks. Backup validation caps entries at 20,000 and input at 2 MB.
- Reset this campaign asks before clearing only its own marks. Export first if you need recovery.

Localhost, an HTTP site and the HTTPS production domain are different storage origins. Use backups to transfer; there is no cloud sync. Clearing browser storage/private browsing can erase templates, preferences and marks. A file fingerprint is not encryption or a secrecy guarantee.

## Interactive Quick Guide

Header Quick Guide opens an accessible, eight-step guide:

1. Choose a mode.
2. Add a file and confirm columns.
3. Choose one recipient and fields.
4. Create/reuse/import templates.
5. Preview and request an external draft.
6. Remember and back up manual progress.
7. Troubleshoot default apps and number formats.
8. Understand privacy, accounts and backups.

Each step has an example, Back/Next navigation and Take me there. When a destination needs a loaded sheet, the guide asks you to load one or try the demo. The guide and README describe the same workflows; local setup, deployment and developer checks stay in this README. The guide never sends a real message.

## Header, footer and account controls

This project follows the supplied DeTLeng Ecosystem V4A document:

- Header: project identity, How it works, Quick Guide, Privacy, About, Login and Discuss at Automation Desk ↗.
- Automation Desk: https://automation.detleng.com/#desk — anchor retained.
- Forest-green footer cards: DeTLeng https://www.detleng.com/ → LFDS https://lfds.detleng.com/ → DeTLeng Network https://network.detleng.com/ in that exact desktop/mobile order.
- All four ecosystem links open a new tab using target=_blank and rel=noopener noreferrer.
- Mobile navigation retains all actions. Visible keyboard focus, accessible tab navigation, dialogs, Escape, focus restoration, labelled controls and reduced-motion support are included.

Add Login / Create Account was checked in the supplied document. Authentication is intentionally inactive at launch. Header/footer actions open a native centered modal with Login/Create Account tabs. Credential entry and submission are disabled. It says “Account features are being prepared. No account is required right now.” and “You’re early — enjoy Send Message free.” Continue Free closes the modal. No fake account creation or password collection occurs. No AI chat was requested or added.

## Privacy and security

There is no upload backend, analytics, AI processing, mailing service, tracker or remote file-reading CDN. A restrictive Content Security Policy permits local scripts/workers and blocks fetch connections. User-controlled cells/templates are rendered as text, not HTML. Contact validation and single-recipient restrictions protect personalized drafts. Private headings are detected by a heuristic, which is not a complete sensitive-data classifier; always review the columns yourself.

Opening a compose link deliberately gives the message and destination to the chosen app/provider. URLs can appear in browser/app history; treat private data accordingly. This tool is not a secure credential-delivery service. Copying places text on the system clipboard. Hosting providers receive ordinary website requests. Saved browser data and exported JSON are not encrypted; keep private workbooks/backups out of public repositories.

## Files and dependencies

- index.html, assets/styles.css: responsive application shell.
- assets/app.mjs: mode isolation, file workflow, templates, progress, guide and dialogs.
- assets/core.mjs: parsing, mapping, validation, interpolation and compose URLs.
- assets/reader-worker.js: isolated Excel parsing with timeout/range limits.
- assets/vendor/xlsx.full.min.js: SheetJS CE 0.20.3, Apache-2.0; upstream license is beside it.
- serve.mjs: dependency-free local preview server, loopback-only, for development.
- tests/core.test.mjs: executable logic regression checks.
- CNAME, .nojekyll: GitHub Pages custom-domain support.
- PUSH.ps1: explicit allowlist publish helper; never includes user files or password exports.

Upstream references: [SheetJS standalone distribution](https://docs.sheetjs.com/docs/getting-started/installation/standalone/), [mailto RFC 6068](https://www.rfc-editor.org/rfc/rfc6068), [WhatsApp app links](https://faq.whatsapp.com/425247423114725/), [Apple default apps](https://support.apple.com/en-euro/guide/iphone/iphc57feab64/27/ios/27).

## Checks

```powershell
Set-Location 'D:\DETLENG2\sendmessage-detleng'
node --test tests/core.test.mjs
```

See TESTING.md for the checks actually performed and their limits. Browser viewport emulation does not prove native Android/iOS Gmail/Outlook/WhatsApp app handoff. After hosting, test your own device with a harmless message to yourself and review which sender account is selected. No real email/WhatsApp message was sent during development.

## Publish yourself

Repository: https://github.com/Navid-Ishaq/sendmessage-detleng

Run the supplied helper in PowerShell (it is not run automatically):

```powershell
& 'D:\DETLENG2\sendmessage-detleng\PUSH.ps1'
```

It clones/reuses a separate sibling publish checkout, checks that checkout is clean, pulls before copying the explicit website-file allowlist, runs logic tests, commits only changed website files and pushes main. It does not copy spreadsheets, private exports, node_modules or files outside that allowlist. It stops on errors and never force-pushes. Existing remote README/CNAME are integrated through the ordinary clone/pull flow.

In GitHub Pages settings choose the main branch/root for deployment. Keep CNAME as sendmessage.detleng.com, ensure its DNS targets the repository owner's GitHub Pages host, and enable Enforce HTTPS when GitHub has issued the certificate. These DNS/hosting settings are not changed by the helper. The requested HTTP address should redirect to HTTPS once hosting supports it. Prefer HTTPS for clipboard and browser security APIs.
