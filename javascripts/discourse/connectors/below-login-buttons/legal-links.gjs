import DButton from "discourse/components/d-button";
import routeAction from "discourse/helpers/route-action";
import { i18n } from "discourse-i18n";

<template>
  <DButton
    @action={{routeAction "showLogin"}}
    @icon="user"
    @label="log_in"
    class="btn-primary login-button w-welcome__button"
  />

  <ul class="w-welcome__legal-links">
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
