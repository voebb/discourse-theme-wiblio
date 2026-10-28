# wiblio

The dashboard events and forum cards have full-card navigation links, added
by `community-card-links.js` and styled with `.w-community-card-link`. Individual
event and subcategory links stay independently clickable above the card link.
The top-corner arrow slides in on hover or keyboard focus, stays visible on touch
devices, and respects reduced motion.

The forum expander marks the current subcategory button with
`.zlb-community-category-button.is-active`. The theme updates this class on navigation.

`ForumCategoryBreadcrumbs` renders the community category and selected subcategory
in the `discovery-above` outlet above the topic list at all viewport widths.
On the main category, a button switches between all topics (`/all`) and topics
directly in that category (`/none`). The community header and its title remain unchanged.
`forum-category-reset.js` adds a clear-selection chip next to the forum expander
title through `api.onPageChange`, using the same styles as the breadcrumb filter.
It only reads services after navigation and does not mount a component into the
plugin’s managed DOM. The same clear-selection action also appears after the last
category badge in the breadcrumbs. Both clear-selection chips use the inactive
filter style and appear only when a subcategory is selected.

Community topic pages show only the topic’s direct category in `.topic-category`
and below the title in the header, without its ancestors, via
`community-topic-category.gjs`.

The "New" navigation tab is hidden on community forum category pages via
`list-controls.scss`; direct URLs remain accessible.

Community topic-list filters use segmented navigation styled in
`list-controls.scss`. `community-topic-navigation.js` keeps the links visible on
mobile as well, with horizontal scrolling when space is limited.

**Theme Summary**

For more information working with and installing Discourse, please see the [Discourse documentation](https://meta.discourse.org/t/introduction-to-discourse-development).

## Developing locally

To develop the theme on a local instance of discourse, you need the `discourse_theme` gem. Run the following commands in the root folder of the theme:

```sh
gem install discourse_theme
```

Once it’s installed, run:

```sh
discourse_theme watch .
```

You‘ll be asked for:

- The default URL of your discourse instance. You should check this, but it’s probably `http://localhost:4200`
- An API key for your discourse instance. To get this, in your browser go to the admin section of your running discourse instance, and choose the `Advanced` section in the main navigation. In there, click the `API keys` link. Create a new API key, scoped to your user.

When asked which theme, if this is your first time developing the theme locally, choose `Create and sync with a new theme`. If you are continuing development of the theme, choose `Sync with existing theme: 'wiblio' (id:2)` (the `id` mentioned will vary, dependent on how many time you’ve chosen to `Create and sync with a new theme`).

When successful, you’ll see the messages below (your URL may differ). Visit the URL given to see your discourse instance rendered with the local Wiblio theme. Any changes you make will be visible in your browser.

```
✔ Theme uploaded (id:1)
i Preview: http://localhost:4200/?preview_theme_id=1
```

`forum-list-scroll.js` positions the topic list below the sticky header, list
controls, and breadcrumbs after same-tab link navigation from forum controls,
breadcrumbs, or the category expander. Direct visits and browser history navigation
retain the normal scroll behavior.
