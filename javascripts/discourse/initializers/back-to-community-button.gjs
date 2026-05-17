import { withPluginApi } from "discourse/lib/plugin-api";

const BACK_TO_COMMUNITY_LABEL = "Community";

function updateBackToForumLabel() {
  document.querySelectorAll("a.back-to-forum").forEach((anchor) => {
    anchor.title = BACK_TO_COMMUNITY_LABEL;

    const svg = anchor.querySelector("svg");
    if (svg) {
      let node = svg.nextSibling;
      while (node) {
        const next = node.nextSibling;
        anchor.removeChild(node);
        node = next;
      }
      anchor.appendChild(
        document.createTextNode(` ${BACK_TO_COMMUNITY_LABEL}`)
      );
      return;
    }

    anchor.textContent = BACK_TO_COMMUNITY_LABEL;
  });
}

export default {
  name: "back-to-community-button",

  initialize() {
    withPluginApi((api) => {
      api.onPageChange(() => updateBackToForumLabel());
    });

    document.addEventListener("DOMContentLoaded", updateBackToForumLabel);
    updateBackToForumLabel();
  },
};
