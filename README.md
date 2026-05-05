# wiblio

**Theme Summary**

For more information, please see: **url to meta topic**

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
