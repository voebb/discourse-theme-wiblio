# Wiblio 2.0 stylesheet audit

Source review: 2026-11-06, current working tree, followed by the cleanup passes
recorded below. Original scope: 66 SCSS files in `stylesheets/` and `common/`;
Discourse core and the separate chat component are excluded from cleanup.

## Method and limits

Parsed all 66 files with the installed `postcss-scss` parser. Checked for files
without active nodes, repeated properties within a rule, identical ordered
declaration blocks of at least three declarations, and partial overlaps of at
least five declarations. Also inspected comments, import usage, repeated
selectors, and current design-token/mixin usage manually.

All files parsed. No complete identical ordered declaration blocks of at least
three declarations were found by that scan. Partial duplication and redundant
individual declarations do exist. The initial audit was source-only; subsequent
compilation and browser comparisons are recorded below. No dead-selector analysis
is claimed. A missing namespace reference alone does not prove that a Sass import
is safe to remove: imported modules can emit CSS.

Line references below describe the audited working tree and can move during
cleanup.

## Completed first cleanup

Removed all inactive files, their imports, unused imports, and the immediately
overwritten declaration identified in the following table. It preserves the
original findings and source line references; these files or lines may no longer
exist in the cleaned tree. The following sections distinguish completed
consolidation from remaining design and behavior decisions.

Validation: compiled the full Wiblio `common/common.scss` entry point before and
after cleanup with `sass-embedded`, using the checkout's core Sass modules and
fixed asset URLs. The generated CSS is exactly identical after accounting for
removal of the single immediately overwritten `border-radius: unset` declaration.
Removing files/imports caused no other generated CSS change. This verifies the
standalone theme compilation, not a Discourse application boot or browser run.

| Source | Finding | Recommended cleanup |
| --- | --- | --- |
| `stylesheets/atoms/nav-pill.scss:1` | All 26 lines are comments or whitespace, including an old navigation implementation. Still imported from `common/common.scss:30`. | Remove the inactive implementation and its import; delete the file if no other references remain. |
| `stylesheets/atoms/select-kit.scss:1` | All 72 lines are comments or whitespace, including multiple discarded implementations. Still imported from `common/common.scss:32`. | Remove the inactive implementation and its import; delete the file if no other references remain. |
| `stylesheets/molecules/modal.scss` and `common/common.scss:50` | The stylesheet is empty and its import is commented out. | Remove the empty file and commented import. Keep the separate active modal-specific stylesheets. |
| `stylesheets/atoms/button-create-topic.scss:1` | Contains only `@use "lib/viewport"`; no active rules or namespace calls. `common/common.scss:25` still loads it. | Remove the placeholder file and its import after checking references. Current button rules live in `atoms/button.scss`. |
| `stylesheets/organisms/header-lobby.scss:32` | `border-radius: unset` is immediately overwritten by a valid `border-radius` declaration in the same rule. | Remove the first declaration. |
| `stylesheets/organisms/grid.scss:1` | The local mixin module is loaded without any `mixins.*` references. That module only defines mixins and a map. | Remove the unused import. |
| `stylesheets/organisms/list-controls.scss:1`, `stylesheets/organisms/navbar.scss:1`, `stylesheets/organisms/topic-list.scss:1` | Load `lib/viewport` without any namespace references. The inspected viewport module defines breakpoint mixins and emits no rules. | Remove these unused imports. |

## Duplication and simplification candidates

The badge and create-topic consolidation is complete. The remaining four
candidates below are deferred; they require a design or cascade decision.

| Source | Finding | Recommendation and caveat |
| --- | --- | --- |
| `stylesheets/atoms/badge-category.scss:3`, `:41`, `:92` | The same badge-background expression appears three times. Wrapper and quote badge also share text colors, presentation, and responsive font sizes. | Completed using shared selector groups, without new mixins. Category colors still resolve on the actual badge element. Quote padding, wrapper dimensions/line height, icon geometry, and hover colors remain local. |
| `stylesheets/atoms/button.scss:126` and `:408` | `.topic-create-button__combo` was opened twice in the same file. | Completed: moved mobile icon spacing and draft-trigger margin into the existing create-topic section. |
| `stylesheets/organisms/sidebar.scss:59` | Both arguments to `light-dark()` are `var(--primary-low-mid)`. | Candidate for a direct variable value. On supported browsers the selected color is the same; verify the supported browser baseline before treating the function's removal as universally equivalent. |
| `stylesheets/organisms/grid.scss:31` and `stylesheets/_design-tokens/color-mappings.scss:8` | Dashboard action background repeats the expression already exposed as `--w-overlay`. | Use the shared token if dashboard actions should follow future overlay-token changes. That coupling is a design decision, even though current values match. |
| `stylesheets/atoms/badge-category.scss:82` | `border: 0 !important` is followed by `border-color: transparent !important`. | The color has no visible border at zero width, but can matter if another rule later supplies a width/style. Check the cascade before removing it. |
| `stylesheets/molecules/category-chooser.scss:1` and `:17` | Two different chooser contexts repeat hiding badges and showing the last badge. | A small shared selector group is possible; keep the two context boundaries and specificity. Only a small amount of repetition, so low priority. |

## Comment review

Removed the redundant selector descriptions, informal Foundation remarks, and
unactionable plugin-move TODO identified below. Kept useful section labels and
reasons for focus spacing, color-property placement, border visibility, and
inline-height overrides. Behavior TODOs were moved to the explicit follow-up
list below; the related declarations remain unchanged. The table preserves the
original comment assessment and line references.

| Source | Assessment |
| --- | --- |
| `stylesheets/organisms/navbar.scss:15`, `:29`; `stylesheets/organisms/sidebar.scss:45`; `stylesheets/organisms/user-menu.scss:8` | Comments such as “modernize thing” and “annooyying modernize thing” do not explain the mechanism or constraint. Remove them or replace them with the actual reason if it can be established. Do not delete the associated overrides just because their comments are weak. |
| `stylesheets/organisms/navbar.scss:47` | “All them buttons” adds little beyond the selector list. Removable. |
| `stylesheets/atoms/badge-category.scss:72`, `:79`, `:91`, `:115`; `stylesheets/organisms/list-controls.scss:77`, `:83`; `stylesheets/organisms/header-lobby.scss:97` | Mostly repeat what the selectors or declarations already say. Remove where they add no structural help. The “closed category” wording should not be relied on to describe restricted-category permissions. |
| `stylesheets/atoms/badge-category.scss:39` | The wrapper-versus-span distinction is useful context for the repeated declarations. Preserve that reason concisely if the code remains separate; remove the conversational wording. |
| `stylesheets/organisms/grid.scss:73` | Suggests moving code into a plugin and says it could be more elegant. It gives no actionable constraint and conflicts with this release's theme-only scope. Move any concrete follow-up into the release plan; removing the comment does not authorize a plugin change. |
| `stylesheets/organisms/topic-list.scss:3` | “only needed for desktop” is questionable because the block contains a mobile media query. Verify the behavior and describe why the bulk-selection override is needed. Attribution alone does not explain it. |
| `stylesheets/molecules/language-switcher.scss:1`; `stylesheets/atoms/badge.scss:14`; `stylesheets/templates/static.scss:165` | Scoping and behavior TODOs need investigation or a concrete tracked follow-up. Do not silently discard unresolved behavior concerns as comment cleanup. |
| `stylesheets/_base/html.scss:58`, `:66`, `:72`; `stylesheets/atoms/card.scss:9`; `stylesheets/organisms/header-lobby.scss:65`; `stylesheets/organisms/sidebar.scss:50`; `stylesheets/organisms/topic-timeline.scss:10` | Explain non-obvious geometry, browser rounding, nested-link layering, scroll-shadow covers, focus clipping, or inline-style overrides. Keep the reason, shortening wording where useful. |

Short section labels in `common/common.scss`, design tokens, and the long
`atoms/button.scss` help navigation. Removing every section comment would not
improve maintainability.

## Remaining behavior follow-ups from comments

- [ ] Verify the language switcher's header-only scope against other uses of the
      component; the removed generic scoping TODO did not identify a concrete leak.
- [ ] Review the topic-post "New" badge text currently hidden through its text
      color, including German/English, Light/Dark, and accessibility behavior.
- [ ] Review the always-visible email-login link's spacing and enabled/disabled
      semantics on the login page.
- [ ] Verify bulk-selection controls on desktop and mobile; the removed
      desktop-only comment did not match the stylesheet's mobile media query.
- [ ] Review the forum grid's width-dependent column choices in the theme; its
      removed TODO does not authorize moving this behavior into a plugin.

## Consolidation validation

Compiled the full theme before and after this second pass. Parsed the resulting
CSS and compared all 2,400 combinations of selector, property, and at-rule
conditions, including ordered values and importance flags, normalizing only
formatting whitespace in values. All combinations match. Selector text and media
conditions remain unchanged after expanding shared selector groups.

A source-order check of same-property declarations with different values and
equal importance found one inversion: the wrapper's responsive font size versus
the quote badge's base font size. The quote selector has greater specificity,
and its responsive font-size rule still follows its base rule. That inversion
does not change the winner, including when both badge classes occur together.

After the missing system libraries were installed, Chromium started successfully.
Ran 96 before/after computed-style comparisons across 18 representative elements
at 375, 640, 768, and 1280px, with both Wiblio Light and Wiblio Dark palette values
from `about.json`. All comparisons passed. The matrix covers normal state, eight
hover targets, and focused, active, and disabled create-topic controls.

The isolated markup covers standard badges, quote badges, an element carrying
both badge classes, selected badges, category icons, the header logo, and both
create-topic variants with draft triggers. Each comparison checks every enumerated
computed CSS property of the marked elements, including their names and icons.
The fixture supplies base variables and loads the full compiled Wiblio CSS;
transitions and animations are disabled to compare settled states.

This confirms equivalent computed styles for the fixture. It does not boot
Discourse, load its full core/plugin styles, or verify SPA behavior, accessibility,
contrast, or layout on live site pages. Those release checks remain outstanding.

## Repetition to retain

- `atoms/button.scss` versus `organisms/navbar.scss`, `atoms/back-to-top.scss`,
  and `atoms/button-category.scss`: shared appearance and local layout are
  intentionally separate. Repeated selectors alone are not duplicate CSS.
- `button-shadow` and `button-special`: reusable visual behavior is already
  shared through mixins. Keep the callers' different geometry and movement.
- `:root` plus `:where(.uc-modernize-foundation-theme)`: declarations on different
  elements can be necessary to override inherited Foundation variables. Do not
  merge or remove scopes based on matching values alone, including logo height.
- Matching flex-column declarations in lobby overlays and login/invite pages:
  these describe unrelated layouts and do not justify another generic mixin.
- Similar numeric color-scale expressions represent separate palette steps.
  Preserve their independent values and semantic aliases.

## Suggested cleanup order

1. Remove inactive code, placeholders, unused imports, and the immediately
   overwritten declaration. Keep this separate from visual changes.
2. Remove low-value comments; retain useful constraints and unresolved behavior
   issues in the appropriate source comment or release checklist.
3. Consolidate category-badge styling and the split create-topic section, checking
   emitted selectors, declaration order, specificity, and custom-property scope.
4. Make token-coupling decisions separately. Compare compiled CSS before/after,
   run focused lint, and browser-check badges, chooser states, quote badges,
   create-topic controls, and responsive layouts in Light and Dark.
