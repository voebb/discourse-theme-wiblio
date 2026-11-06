import { themePrefix } from "virtual:theme";
import { apiInitializer } from "discourse/lib/api";
import Category from "discourse/models/category";
import { i18n } from "discourse-i18n";

export default apiInitializer((api) => {
  api.onPageChange(() => {
    const router = api.container.lookup("service:router");
    const category = router.currentRoute?.attributes?.category;
    const categoryPath = category
      ? new URL(category.url, window.location.origin).pathname
      : null;
    const communityId = category
      ? api.container
          .lookup("service:community-category-service")
          .communityCategoryIdForCategory(category)
      : null;
    const communityCategory = Category.findById(communityId);
    const resetUrl =
      communityCategory && category.id !== communityId
        ? `${communityCategory.url}/all`
        : null;

    document
      .querySelectorAll(
        ".zlb-community-grid--category-expander .zlb-community-category-button"
      )
      .forEach((button) => {
        const categoryUrl = button.dataset.wiblioCategoryUrl || button.href;
        button.dataset.wiblioCategoryUrl = categoryUrl;
        const active =
          categoryPath !== null &&
          new URL(categoryUrl).pathname === categoryPath;

        button.classList.toggle("is-active", active);
        button.href = active && resetUrl ? resetUrl : categoryUrl;
        button.querySelector(".w-forum-category-reset")?.remove();
        if (
          button
            .getAttribute("aria-describedby")
            ?.startsWith("w-category-reset-")
        ) {
          button.removeAttribute("aria-describedby");
        }

        if (active && resetUrl) {
          // The plugin has no outlet inside category tiles.
          const chip = document.createElement("span");
          chip.className = "discourse-tag w-forum-category-reset";
          chip.id = `w-category-reset-${category.id}`;
          chip.textContent = i18n(themePrefix("clear_category_selection"));
          button.setAttribute("aria-describedby", chip.id);
          button.append(chip);
        }
      });
  });
});
