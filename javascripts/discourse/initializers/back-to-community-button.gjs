import { themePrefix } from "virtual:theme";
import { withPluginApi } from "discourse/lib/plugin-api";
import { i18n } from "discourse-i18n";

function updateBackToForumLabel() {
  const label = i18n(themePrefix("back_to_community"));
  document.querySelectorAll(".c-header a.back-to-forum").forEach((anchor) => {
    anchor.title = label;

    const text = Array.from(anchor.childNodes).find(
      (node) => node.nodeType === Node.TEXT_NODE && node.textContent.trim()
    );
    if (text) {
      text.textContent = ` ${label}`;
    } else {
      anchor.appendChild(document.createTextNode(` ${label}`));
    }
  });
}

export default {
  name: "back-to-community-button",

  initialize() {
    withPluginApi((api) => {
      if (
        !api.container.lookup("service:site-settings").zlb_community_enabled
      ) {
        return;
      }

      api.onPageChange(updateBackToForumLabel);
      updateBackToForumLabel();
    });
  },
};
