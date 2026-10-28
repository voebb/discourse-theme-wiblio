import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  const router = api.container.lookup("service:router");

  api.onPageChange(() => {
    const category = router.currentRoute?.attributes?.category;
    const categoryPath = category
      ? new URL(category.url, window.location.origin).pathname
      : null;

    document
      .querySelectorAll(
        ".zlb-community-grid--category-expander .zlb-community-category-button"
      )
      .forEach((button) => {
        button.classList.toggle(
          "is-active",
          categoryPath !== null &&
            new URL(button.href).pathname === categoryPath
        );
      });
  });
});
