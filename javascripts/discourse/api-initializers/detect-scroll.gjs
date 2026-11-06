import { registerDestructor } from "@ember/destroyable";
import { withPluginApi } from "discourse/lib/plugin-api";

function updateScrolledState() {
  document.body.classList.toggle("scrolled", window.scrollY > 10);
}

export default {
  name: "detect-scroll",

  initialize(_container, app) {
    window.addEventListener("scroll", updateScrolledState, { passive: true });
    registerDestructor(app, () => {
      window.removeEventListener("scroll", updateScrolledState);
      document.body.classList.remove("scrolled");
    });
    updateScrolledState();

    withPluginApi((api) => {
      api.onPageChange(updateScrolledState);
    });
  },
};
