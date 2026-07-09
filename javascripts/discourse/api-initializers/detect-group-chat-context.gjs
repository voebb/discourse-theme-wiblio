import { withPluginApi } from "discourse/lib/plugin-api";

const addClassName = () => {
  const el = document.querySelector(".c-navbar");

  if (!el) {
    return;
  }

  const isGroupChat = () => {
    const icon = el.querySelector(".chat-channel-icon");

    if (
      icon.classList.contains("--users-count") ||
      icon.classList.contains("--icon")
    ) {
      return true;
    } else {
      return false;
    }
  };
  document.body.classList.toggle("has-group-chat", isGroupChat());
};

const hasChatContext = () =>
  document.documentElement?.classList.contains("has-chat");

const runUpdates = () => {
  if (!document.body || !hasChatContext()) {
    return;
  }

  if (document.querySelector(".chat-channel-icon")) {
    addClassName();
  }
};

export default {
  name: "detect-group-chat",

  initialize() {
    withPluginApi((api) => {
      requestAnimationFrame(runUpdates);

      const observer = new MutationObserver((mutations) => {
        const shouldUpdate = mutations.some((mutation) => {
          const addedNodes = Array.from(mutation.addedNodes);

          return addedNodes.some((node) => {
            if (!(node instanceof HTMLElement)) {
              return false;
            }

            return (
              node.matches?.(".chat-message") ||
              node.querySelector?.(".chat-message")
            );
          });
        });

        if (shouldUpdate) {
          requestAnimationFrame(runUpdates);
        }
      });

      if (document.body) {
        observer.observe(document.body, {
          childList: true,
          subtree: true,
        });
      }

      api.onPageChange(() => {
        runUpdates;
      });
    });
  },
};
