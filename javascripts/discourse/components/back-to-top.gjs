import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { registerDestructor } from "@ember/destroyable";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { themePrefix } from "virtual:theme";
import DButton from "discourse/ui-kit/d-button";
import { i18n } from "discourse-i18n";

export default class BackToTop extends Component {
  @service router;
  @service capabilities;
  @service communityCategoryService;

  @tracked scrolled = false;

  constructor() {
    super(...arguments);
    this.updateScroll();
    window.addEventListener("scroll", this.updateScroll, { passive: true });
    registerDestructor(this, () => {
      window.removeEventListener("scroll", this.updateScroll);
    });
  }

  get visible() {
    if (!this.scrolled) {
      return false;
    }

    const routeName = this.router.currentRouteName;
    if (routeName === "zlbCommunityDashboard") {
      return !this.capabilities.viewport.md;
    }

    const category = this.router.currentRoute?.attributes?.category;
    return (
      routeName?.startsWith("discovery.") &&
      category &&
      this.communityCategoryService.communityCategoryIdForCategory(category)
    );
  }

  @action
  updateScroll() {
    this.scrolled = window.scrollY > 300;
  }

  @action
  scrollToTop() {
    window.scrollTo({
      top: 0,
      behavior: window.matchMedia("(prefers-reduced-motion: reduce)").matches
        ? "instant"
        : "smooth",
    });
  }

  <template>
    {{#if this.visible}}
      <DButton
        class="btn-default w-back-to-top"
        @icon="arrow-up"
        @action={{this.scrollToTop}}
        @translatedTitle={{i18n (themePrefix "back_to_top")}}
        @translatedAriaLabel={{i18n (themePrefix "back_to_top")}}
      />
    {{/if}}
  </template>
}
