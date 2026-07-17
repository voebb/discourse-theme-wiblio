import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "detect-scroll",

  initialize() {
    withPluginApi((api) => {
      api.onPageChange(() => {
        window.addEventListener("scroll", () => {
          if (window.scrollY > 10) {
            document.body.classList.add("scrolled");
          } else {
            document.body.classList.remove("scrolled");
          }
        });
      });
    });
  },
};
