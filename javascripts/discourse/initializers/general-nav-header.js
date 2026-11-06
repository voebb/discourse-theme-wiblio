import { withPluginApi } from "discourse/lib/plugin-api";
import { customPanels } from "discourse/lib/sidebar/custom-sections";
import DiscourseURL from "discourse/lib/url";
import Category from "discourse/models/category";

export default {
  name: "wiblio-general-nav-header",
  after: "zlb-community-sidebar",

  initialize() {
    withPluginApi((api) => {
      const siteSettings = api.container.lookup("service:site-settings");
      if (!siteSettings.zlb_community_enabled) {
        return;
      }

      const panel = customPanels.find(({ key }) => key === "main");
      if (!panel) {
        return;
      }

      panel.sections = panel.sections.map((Section) => {
        if (new Section().name !== "general-nav") {
          return Section;
        }

        return class extends Section {
          get actionsIcon() {
            return "far-note-sticky";
          }

          get actions() {
            const category = Category.findById(
              siteSettings.zlb_community_nav_category
            );

            return category
              ? [
                  {
                    id: "wiblio-general-nav-category",
                    title: category.displayName,
                    action: () => DiscourseURL.routeTo(category.path),
                  },
                ]
              : [];
          }
        };
      });
    });
  },
};
