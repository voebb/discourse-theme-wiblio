import { i18n } from "discourse-i18n";

<template>
  <ul class="w-sidebar-legal-links">
    <li>
      <a href="/tos">{{i18n (themePrefix "tos")}}</a>
    </li>
    <li>
      <a href="/privacy">{{i18n (themePrefix "privacy")}}</a>
    </li>
    <li>
      <a href="/t/impressum">{{i18n (themePrefix "imprint")}}</a>
    </li>
  </ul>
</template>
