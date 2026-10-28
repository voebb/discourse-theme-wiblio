import { apiInitializer } from "discourse/lib/api";
import { headerOffset } from "discourse/lib/offset-calculator";

export default apiInitializer((api) => {
  let navigationPending = false;

  document.addEventListener(
    "click",
    (event) => {
      if (
        event.defaultPrevented ||
        event.button !== 0 ||
        event.metaKey ||
        event.ctrlKey ||
        event.shiftKey ||
        event.altKey
      ) {
        return;
      }

      const link = event.target.closest(
        ".list-controls a[href], .w-forum-breadcrumbs a[href], .zlb-community-category-header .zlb-community-expander a[href]"
      );
      if (
        !link ||
        !document.querySelector(".zlb-community-category-header") ||
        link.hasAttribute("download") ||
        (link.target && link.target !== "_self")
      ) {
        return;
      }

      const destination = new URL(link.href);
      navigationPending =
        destination.origin === window.location.origin &&
        (destination.pathname !== window.location.pathname ||
          destination.search !== window.location.search);
    },
    { capture: true }
  );

  api.onPageChange(() => {
    if (!navigationPending) {
      return;
    }
    navigationPending = false;

    // Wait until the new list and its sticky controls have their final layout.
    requestAnimationFrame(() => {
      const list = document.querySelector("#list-area");
      if (!list || !document.querySelector(".zlb-community-category-header")) {
        return;
      }

      let offset = headerOffset();
      for (const selector of [".list-controls", ".w-forum-breadcrumbs"]) {
        const element = document.querySelector(selector);
        if (!element) {
          continue;
        }
        const style = getComputedStyle(element);
        if (style.position === "sticky") {
          offset = Math.max(
            offset,
            (parseFloat(style.top) || 0) +
              element.getBoundingClientRect().height
          );
        }
      }

      window.scrollTo({
        top: Math.max(
          0,
          window.scrollY + list.getBoundingClientRect().top - offset
        ),
        behavior: "instant",
      });
    });
  });
});
