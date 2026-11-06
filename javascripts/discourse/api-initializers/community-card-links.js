import { apiInitializer } from "discourse/lib/api";
import { iconElement } from "discourse/lib/icon-library";
import { i18n } from "discourse-i18n";

export default apiInitializer((api) => {
  const router = api.container.lookup("service:router");
  let observer;

  api.onPageChange(() => {
    observer?.disconnect();

    if (router.currentRouteName !== "zlbCommunityDashboard") {
      return;
    }

    const model = router.currentRoute.attributes;
    const categoryId = model?.community?.category.id;
    if (!categoryId) {
      return;
    }

    const links = [
      {
        selector: ".zlb-community-upcoming-events .zlb-community-card",
        href: router.urlFor("zlbCommunityCalendar", categoryId),
        title: i18n("zlb_community.sidebar.calendar"),
      },
      {
        selector: ".qa-dashboard-forum",
        href: model.category?.url || `/c/${categoryId}`,
        title: i18n("zlb_community.sidebar.forum"),
      },
    ];

    const pendingLinks = new Set(links);

    // The plugin cards have no outlet for a card-wide navigation link.
    const addLinks = () => {
      for (const entry of pendingLinks) {
        const { selector, href, title } = entry;
        const card = document.querySelector(selector);
        if (!card) {
          continue;
        }

        pendingLinks.delete(entry);
        if (card.querySelector(".w-community-card-link")) {
          continue;
        }

        const link = document.createElement("a");
        link.className = "w-community-card-link";
        link.href = href;
        link.title = title;
        link.setAttribute("aria-label", title);
        link.append(iconElement("arrow-right"));
        card.classList.add("w-community-card");
        card.append(link);
      }

      if (pendingLinks.size === 0) {
        observer.disconnect();
      }
    };

    observer = new MutationObserver(addLinks);
    observer.observe(document.querySelector("#main-outlet"), {
      childList: true,
      subtree: true,
    });
    addLinks();
  });
});
