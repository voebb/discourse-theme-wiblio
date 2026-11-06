# Changelog

## 2.0.0-rc.1 — 2026-11-06

Staging candidate for Wiblio 2.0.

- Add Wiblio Light and Dark palettes and consolidate shared control styles.
- Improve community category selection, navigation, dashboard links, and topic
  cards, including reply avatars and translated activity labels.
- Scope topic-list and bulk-selection customizations to their intended contexts.
- Prevent duplicate header scroll listeners and preserve mobile chat-header
  icons and rendering markers when updating the translated return label.
- Extract chat styling into the required `wiblio-chat-bubbles` component.
- Remove inactive stylesheets, unused imports, and repeated badge declarations.

### Upgrading

New installations declare the chat component through `about.json`. When updating
an existing Wiblio installation, verify that
`https://github.com/voebb/wiblio-chat-bubbles` is installed and attached. See the
[README](README.md) for installation details.

### Known issues and validation

A longer desktop navigation sequence with the chat drawer open raises a FloatKit
tooltip assertion. The failing layer is identified, but the originating caller
is not yet confirmed. Functional checks pass; the issue remains tracked for
staging. The existing MessageBus startup workaround is retained.

Installation and upgrade acceptance will be completed in staging. See the
[release plan](docs/release-2.0.md) and
[authenticated browser report](docs/authenticated-browser-check-2.0.md) for the
tested scope and remaining checks.
