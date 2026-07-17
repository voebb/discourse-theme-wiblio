import routeAction from "discourse/helpers/route-action";
import DButton from "discourse/ui-kit/d-button";
import LegalLinks from "../../components/legal-links.gjs";

<template>
  <div class="w-welcome">
    <DButton
      @action={{routeAction "showLogin"}}
      @icon="arrow-right"
      @label="log_in"
      class="btn-primary w-welcome__button"
    />

    <LegalLinks />
  </div>
</template>
