# Authenticated Wiblio browser checks

Date: 2026-11-06. Local instance: `http://localhost:3000`.

## Tested state

- Wiblio: `0390e8e` on `darkmode`; metadata still declares `1.0.0`.
- Community plugin checkout: `551ab19`.
- Chat bubbles component checkout: `252e485`.
- Account: `donnaa`, active and approved, without staff rights; default community 5.
- Browser: Playwright Chromium, with mobile emulation at 375px and desktop
  contexts at 768, 1024, and 1280px. Each width used light and dark preferences;
  the actual Wiblio palette values were checked after loading.
- The local running checkout was tested. This does not establish compatibility
  with an unmodified Discourse installation, Safari, or Firefox.

These checks precede the metadata-only version bump to `2.0.0-rc.1`. The tested
UI scope is accepted for staging with the desktop assertion tracked as an open
issue; stable release acceptance still requires staging and upgrade checks.

No posts or messages were submitted, and no user permissions or preferences were
changed. The temporary test session was revoked and its credential files removed
after the browser runs. Visits can update ordinary read/view/presence state.

## Results

| Viewport | Light | Dark |
| --- | --- | --- |
| 375px, mobile | 10/10 checks passed | 10/10 checks passed |
| 768px | 9/10; tooltip assertion | 9/10; tooltip assertion |
| 1024px | 9/10; tooltip assertion | 9/10; tooltip assertion |
| 1280px | 9/10; tooltip assertion | 9/10; tooltip assertion |

The remaining failed check is the assertion that there are no uncaught browser
errors. All nine functional checks pass in every configuration. The mobile Light
scroll check initially ran before the topic list had finished rendering; a
focused rerun waiting for the rendered list passed all ten checks.

The following behavior was verified against actual page markup and app services:

1. The account reaches its community dashboard, sees topic cards and two overlay
   links, and receives the requested palette without horizontal page overflow.
2. Clicking a nested category tile navigates to that category rather than the
   parent card's destination. The selected category appears in the breadcrumbs.
3. The selected expander tile links to the community's `/all` list, retains its
   original category URL, and shows one clear-selection chip. Clicking it clears
   the selected state.
4. Community navigation remains visible, the hidden New tab stays hidden, and
   clearing a selection aligns the topic list below the sticky controls and
   breadcrumbs. Their measured edges matched across the matrix.
5. Scrolling shows the back-to-top button and header state; clicking the button
   returns to the top and clears that state.
6. Clicking a topic card's noninteractive author-info area opens the topic;
   the topic page has no horizontal overflow.
7. A non-community category renders without the community header or breadcrumbs.
8. The existing chat channel opens with an enabled composer. On mobile, the
   translated Community return link retains its icon and returns to the forum.
   Desktop navigation opens the drawer, which is expected Discourse behavior.
9. Repeating dashboard/category SPA navigation preserves the document, keeps one
   header scroll listener and one chip per selected tile, and does not duplicate
   dashboard overlay links. The MessageBus AJAX adapter is configured and its
   poll requests return HTTP 200.

Successful polling verifies startup in this environment with the current
MessageBus workaround. It does not verify new-message delivery or prove the
workaround can be removed. Live chat-label coverage was German; English was
covered by the earlier isolated initializer checks.

## Open desktop tooltip failure

The longer interaction sequence produces an uncaught development assertion:

```text
You attempted to update `_trigger` on `DTooltipInstance`, but it had already
been used previously in the same computation.
```

Observed sequence: dashboard tile selection and reset, forum navigation and
scrolling, opening a topic card, visiting a non-community category, opening the
chat drawer, and continuing dashboard/category navigation while it remains open.
The functional checks still pass, but the desktop console is not clean.

The stack reaches the trigger setter in
`frontend/discourse/float-kit/lib/d-tooltip-instance.ts` and the registration
modifier in `frontend/discourse/float-kit/components/d-tooltip.gts`. This locates
the failing code; it does not yet establish which caller causes the update.

A smaller fresh-browser comparison was also run with Wiblio and the existing
Foundation preview (`preview_theme_id=-1`). Merely opening the chat drawer and
then navigating between the dashboard and category did not reproduce the failure
in either theme. Foundation did not load the Wiblio main theme module; the same
attached theme components remained loaded. Consequently, the failure is not yet
isolated to core, Chat, a component, or Wiblio.

Keep this as an open release issue. Reduce the longer reproducer further before
changing code. Core and plugin files were not modified during this investigation.

## Remaining coverage

- Bulk-selection actions, documentation lists, user/group activity, and
  suggested/related lists were not exercised in the logged-in browser matrix.
- Sidebar header actions, calendar/event links, composer/modal interactions,
  live English, keyboard-only operation, contrast, and message delivery still
  need focused coverage.
- Installation, upgrade/rollback, and unmodified-core compatibility checks remain
  separate acceptance work. This report is not approval for a final 2.0 release.
