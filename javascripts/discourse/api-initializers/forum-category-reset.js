import { themePrefix } from "virtual:theme";
import { apiInitializer } from "discourse/lib/api";
import Category from "discourse/models/category";
import { i18n } from "discourse-i18n";

export default apiInitializer((api) => {
  api.onPageChange(() => {
    document.querySelectorAll(".w-forum-category-reset").forEach((chip) => {
      chip.remove();
    });

    const router = api.container.lookup("service:router");
    if (!router.currentRouteName?.startsWith("discovery.")) {
      return;
    }

    const title = document.querySelector(
      ".zlb-community-category-header .zlb-community-expander > .zlb-community-expander__summary > .zlb-community-expander__title"
    );
    const category = router.currentRoute?.attributes?.category;
    if (!title || !category) {
      return;
    }

    const communityService = api.container.lookup(
      "service:community-category-service"
    );
    const communityId =
      communityService.communityCategoryIdForCategory(category);
    if (!communityId || category.id === communityId) {
      return;
    }

    const communityCategory = Category.findById(communityId);
    if (!communityCategory) {
      return;
    }

    // The plugin has no outlet next to the expander title.
    const chip = document.createElement("a");
    chip.className = "discourse-tag w-forum-category-reset";
    chip.href = `${communityCategory.url}/all`;
    chip.textContent = i18n(themePrefix("clear_category_selection"));
    title.after(chip);
  });
});
