import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  if (!api.container.lookup("service:site-settings").zlb_community_enabled) {
    return;
  }

  const router = api.container.lookup("service:router");
  const communityCategoryService = api.container.lookup(
    "service:community-category-service"
  );

  api.registerValueTransformer("navigation-bar-dropdown-mode", ({ value }) => {
    const category = router.currentRoute?.attributes?.category;
    if (
      router.currentRouteName?.startsWith("discovery.") &&
      category &&
      communityCategoryService.communityCategoryIdForCategory(category)
    ) {
      return false;
    }

    return value;
  });
});
