import { apiInitializer } from "discourse/lib/api";
import { extraNavItemProperties } from "discourse/models/nav-item";
import { i18n } from "discourse-i18n";

export default apiInitializer(() => {
  extraNavItemProperties((filterType) => {
    if (filterType === "hot") {
      return { displayName: i18n(themePrefix("hot_nav_label")) };
    }

    return {};
  });
});
