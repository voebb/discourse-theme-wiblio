# Wiblio 2.0 release plan

Status: `2.0.0-rc.1`, approved for staging on 2026-11-06 for the tested Wiblio UI
scope. The desktop tooltip assertion is accepted as an open issue for staging;
its cause remains unconfirmed. Additional coverage and installation/upgrade
testing remain outstanding before the stable release.

## Scope and boundaries

The release includes Wiblio Light and Dark, shared button styling, community
navigation and topic cards, and extraction of chat styling into the separate
`wiblio-chat-bubbles` theme component.

The chat component is a required part of the Wiblio installation, declared via
the repository URL in `about.json`'s `components` list. Standard new installations
with component installation enabled install and attach it automatically. Existing
installations and local watch workflows must verify the attachment explicitly;
administrators can still detach components. The component remains independently
usable with Foundation.

Only the Wiblio repository belongs to this release. Leave local Discourse core,
plugin, runtime, and tooling changes untouched and exclude them from release
commits. Use `git -C themes/wiblio` from the Discourse checkout. Compatibility
checks must use an unmodified supported Discourse revision in a separate test
environment; do not reset the working checkout to obtain that environment.

Wiblio intentionally changes the appearance of standard forum pages. Shared
colors and controls may remain global within the active theme where that is
intentional. Community-specific behavior must have community-specific guards.
Existing unrelated theme changes must be preserved during this review.

## Current inventory

- `about.json` declares `2.0.0-rc.1` and includes Wiblio Light and Wiblio Dark.
  No minimum or maximum Discourse version is declared.
- Preparation commits on `darkmode` cover colors, controls, navigation, cards,
  layout, translations, chat extraction, and the new `general-nav-header.js`.
- `color-mappings.scss` and `color-transformations.scss` define shared colors
  using `light-dark()` and OKLCH. Their effects extend beyond community pages.
- `button.scss` centralizes shared controls and several component-specific
  treatments. `common/common.scss` no longer imports the modal stylesheet.
- Chat styles, the chat initializer, and the chat asset are removed from this
  theme. The README describes the replacement component; its installation and
  behavior still need upgrade verification.

## Containment review

These findings identify review targets, not confirmed failures in the browser.

The separate [stylesheet audit](stylesheet-audit-2.0.md) records inactive code,
comment cleanup, and duplication candidates detected before release cleanup.
Its first cleanup removes inactive files/imports and an immediately overwritten
declaration. A full standalone theme CSS comparison found no other output
changes. A second pass consolidates badge and create-topic rules and removes
low-value comments, preserving behavior follow-ups in the audit. Its compiled
selector/property comparison and 96 isolated Chromium computed-style comparisons
pass. The [authenticated browser report](authenticated-browser-check-2.0.md)
records the completed local checks and the remaining desktop tooltip failure.

| Priority | Source | Finding and required decision or verification |
| --- | --- | --- |
| Known issue accepted for staging | Desktop chat/navigation; FloatKit trigger registration | The logged-in desktop interaction sequence raises a `DTooltipInstance._trigger` assertion in Light and Dark. Functional checks pass, but the console is not clean. A smaller Wiblio/Foundation comparison did not reproduce it; ownership remains unconfirmed. Track the issue during staging and reduce the reproducer before changing code. See the authenticated browser report. |
| Release gate | `javascripts/discourse/pre-initializers/message-bus-startup.js` | Stops MessageBus globally before object injection. Reproduce the original ordering issue on unmodified supported core, establish whether the workaround remains necessary, and verify topic tracking, notifications, chat updates, and anonymous login-required behavior. Remove or narrow only after that evidence. |
| Browser check pending | `javascripts/discourse/initializers/topic-list-columns.gjs` | Class, column, mobile-layout, and click transformers now share `isTopicCardContext`, using the list category supplied by core. Callback checks cover the seven intended contexts, unknown contexts, and documentation categories. Verify rendered discovery, dashboard, user/group activity, suggested/related topics, and documentation lists. |
| Verified in tested contexts | `javascripts/discourse/api-initializers/detect-scroll.gjs` | Registers one passive scroll listener per app instance, updates state on navigation, and removes the listener and body class through an app destructor. Logged-in repeated SPA navigation retains exactly one header listener and correct rendered scroll state. Destructor behavior is covered by callback checks. |
| Authenticated browser check pending | `javascripts/discourse/api-initializers/reposition-bulk-select.js`, `stylesheets/organisms/topic-list.scss` | Now enables desktop bulk selection in navigation only on discovery routes whose current category passes the shared `lib/topic-card-context.js` check. Documentation categories and other routes retain the incoming value; core still controls permission and mobile visibility. Related header/selection CSS is scoped to `.topic-list.--d-topic-cards`. Callback and isolated Chromium checks pass; verify rendered list controls when logged in. |
| Review | `stylesheets/atoms/badge-category.scss` | Shared badge styling is global. `.restricted .d-icon-lock` hides lock icons for all matching descendants, and `.categories-wrapper` hides matching badges. Check the intended surfaces and restrict selectors where the effect is community-specific. |
| Review | `stylesheets/atoms/button.scss`, `stylesheets/_design-tokens/`, `stylesheets/organisms/sidebar.scss` | Global tokens, standard control selectors, Foundation overrides, and `!important` rules affect broad surfaces. Retain intentional Wiblio design, but check admin, composer, modals, menus, and the separate chat component for unintended effects. |
| Review | `stylesheets/organisms/list-controls.scss` | Segmented navigation and tab hiding are community-scoped, while sticky `.list-controls` layout is global. Verify non-community lists and small viewports. Hidden tabs do not restrict direct URL access. |
| Review | `javascripts/discourse/initializers/general-nav-header.js` | Guards on the community setting but replaces the registered sidebar section through `customPanels`. Verify initialization order, the configured category, permissions, and active states against the supported plugin revision. |
| Review | `javascripts/discourse/api-initializers/community-card-links.js` | Observer is dashboard-scoped and disconnects on navigation or after finding both cards. Test missing cards, subsequent rerenders, nested actions, keyboard navigation, and leaving the dashboard. |
| Partially verified | `javascripts/discourse/api-initializers/forum-list-scroll.js` | Document listener has community checks. Logged-in selection-reset navigation positions the list below sticky controls at all four tested widths in both modes; ordinary category pages retain their own context. Browser history and modified clicks remain unverified. |
| Verified mobile DE; further coverage pending | `javascripts/discourse/initializers/back-to-community-button.gjs` | Uses the translated `back_to_community` theme key only for `.c-header a.back-to-forum` while the community plugin is enabled. The logged-in mobile header displays Community, retains its SVG, and returns to the previous forum list in both modes. Isolated checks cover EN, disabled integration, unaffected links, repeated navigation, and preserved rendering markers. |

## Suggested commit groups

Review changes by purpose before staging. Shared files such as `button.scss`,
`common/common.scss`, and the README may require staging individual hunks.

1. Chat extraction: deleted chat implementation, removed imports and asset
   registration, installation instructions. Coordinate the external component
   release without folding its repository into Wiblio commits.
2. Shared appearance: color mappings, mixins, buttons, badges, and corresponding
   removal of duplicated component rules.
3. Community navigation: category selection, sidebar action, list controls, and
   related translations and documentation.
4. Topic cards and layout: responder display, dashboard contexts, card styling,
   and remaining layout adjustments, after reviewing each diff.
5. Containment fixes: focused commits for confirmed issues from the table, each
   with appropriate validation.
6. Release documentation and metadata: changelog, upgrade instructions, supported
   versions, and final version bump after acceptance.

Implementation is committed in functional groups on the existing `darkmode`
branch. The `2.0.0-rc.1` candidate is prepared on that branch for staging. Keep
published history and unrelated repositories untouched. Deploy and validate the
candidate in staging before creating the stable release branch or tag.

## Acceptance checklist

- [x] Agree the 2.0 scope; place additional features in a later release.
- [ ] Resolve release gates and record decisions for every containment finding.
- [ ] Record the tested Discourse revision, community plugin revision, chat
      component revision, browsers, viewport sizes, and results here.
- [ ] Confirm operation on unmodified supported core without local patches.
- [ ] Check dashboard, forum/category lists, topics, composer, search, modals,
      sidebar, user menus, and admin in Light and Dark on desktop and mobile.
- [ ] Check normal, hover, focus, active, disabled, loading, and error states;
      measure text/control contrast and test keyboard access.
- [ ] Check manual color switching, system preference behavior, persistence after
      reload, and navigation without a full reload.
- [ ] Check community and ordinary forum pages, logged-in and anonymous states,
      and repeated SPA navigation for layout, listener, and live-update issues.
- [ ] Check German and English labels, wrapping, and rendered spacing.
- [ ] Verify that a new Wiblio installation installs and attaches the declared
      chat component, and reuses an existing installation of that repository.
- [ ] Test chat with the required component attached. Check standalone component
      compatibility separately.
- [ ] Rehearse upgrading an existing installation, including existing palettes,
      user color preferences, theme settings, and component attachment.
- [ ] Run focused functional tests for behavior changes, then
      `bin/lint --fix <changed-files>` and review the resulting diff.
- [ ] Finish `CHANGELOG.md` and README upgrade instructions, including component
      setup and supported versions. Set a minimum Discourse version only from
      compatibility evidence.
- [ ] Record the previous production revision, configuration, and component
      attachments, and rehearse restoring them as the rollback procedure.
- [ ] Deploy `2.0.0-rc.1` from `darkmode` to the staging installation and record
      remaining defects. Create another candidate if fixes are needed.
- [ ] After acceptance, set `theme_version` to `2.0.0`, validate the final commit,
      and tag that commit `v2.0.0` before publication.

## Validation record

- 2026-11-06, authenticated local checks with non-staff account `donnaa`, theme
  `0390e8e`: all functional checks passed at 375/768/1024/1280px in Light and Dark;
  mobile also passed the uncaught-error check. Desktop runs retain an open
  FloatKit tooltip assertion after the longer interaction sequence. The
  [authenticated browser report](authenticated-browser-check-2.0.md) documents
  results, limitations, the inconclusive Foundation comparison, and session cleanup.
- 2026-11-06, bulk-selection and chat-label working tree: compiled-module callback
  checks passed for the shared topic-card predicate, discovery/documentation and
  other routes, current-category changes, and both incoming boolean values.
  Isolated Chromium tests using the actual initializer source and locale entries
  passed for DE/EN, enabled/disabled community integration, header-only scope,
  preserved links/icons/comment nodes, 20 repeated page changes, and a rerendered
  header. Application services and page-change events were simulated in this test.
  Full theme compilation also passed after scoping header/selection CSS to card
  lists. Twenty isolated Chromium scenarios at 375/576/640/768/1280px, two color
  scheme preferences, and normal/private-message body contexts confirm unchanged
  card-list computed styles, restored standard-table headers/checkboxes/avatar
  cells, and the retained private-message exception. These use fixture markup and
  baseline table styles rather than authenticated Discourse pages.
- 2026-11-06, live anonymous smoke check at `http://localhost:3000`: login page
  returned HTTP 200 with no uncaught JavaScript errors at 375/640/768/1280px for
  light and dark system preferences. Verified actual palette switching
  (`--primary`/`--secondary`), visible login action, no horizontal overflow, and
  the `scrolled` body class after scrolling. The live module registry includes
  the new shared topic-card helper and both modified initializers under theme 1.
  The site presents its login page to the fresh browser, so authenticated
  community, list, and chat behavior is still unverified. These are smoke checks,
  not a full visual or accessibility review.
- 2026-11-06, badge/button consolidation and comment cleanup working tree:
  standalone theme compilation and comparison of 2,400 selector/property/at-rule
  combinations passed, including values and importance flags. One relative-order
  inversion of unequal-specificity font-size selectors was reviewed; the winning
  declarations are preserved. After resolving the missing system libraries,
  Chromium passed 96 before/after computed-style comparisons on 18 fixture
  elements at 375/640/768/1280px with the Wiblio Light/Dark palettes. Covered normal,
  hover, focus, active, and disabled states. This uses isolated markup, base
  variables, and the compiled theme CSS, without booting Discourse or loading its
  full core/plugin styles; live-site integration checks remain outstanding.
- 2026-11-06, stylesheet cleanup working tree: full standalone `sass-embedded`
  compilation before and after removing inactive stylesheets, unused imports,
  and a redundant declaration. Generated CSS is identical except for the removed
  immediately overwritten `border-radius: unset` declaration. No selectors or
  other declarations changed. This does not replace browser or upgrade checks.
- 2026-11-06, working tree: processed both modified initializers with the installed
  `content-tag` compiler and exercised their callbacks in an isolated Node VM
  with mocked application services. All seven card contexts retain card columns
  and classes; unknown contexts and documentation lists retain incoming columns,
  classes, mobile-layout values, and delegated clicks. Nested interactive controls
  retain delegated clicks. Scroll checks passed for the 10px threshold, state
  updates on navigation, one callback after 20 page changes, and destructor
  cleanup. These checks do not render components or boot Discourse.
- MessageBus source review confirms topic tracking starts in the application
  initializer while its AJAX adapter is configured in an instance initializer.
  The workaround remains unchanged pending reproduction on unmodified supported
  core and live-update checks.

Browser coverage includes isolated comparisons, live anonymous login smoke checks,
and the authenticated checks linked above. Authenticated coverage remains partial
and the desktop assertion is unresolved. No upgrade, contrast, or rollback result
is claimed yet. Record each later check with its revision, result, and limitations.
