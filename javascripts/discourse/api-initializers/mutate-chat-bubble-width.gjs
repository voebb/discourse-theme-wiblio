import { withPluginApi } from "discourse/lib/plugin-api";

let measurementContainer = null;

const ensureMeasurementContainer = () => {
  if (measurementContainer) {
    return measurementContainer;
  }

  measurementContainer = document.createElement("div");
  const style = document.createElement("style");

  measurementContainer.className = "chat-content-measure";
  measurementContainer.style.position = "absolute";
  measurementContainer.style.visibility = "hidden";
  measurementContainer.style.left = "0";
  measurementContainer.style.top = "0";
  measurementContainer.style.width = "auto";
  measurementContainer.style.minWidth = "0";
  measurementContainer.style.maxWidth = "none";
  measurementContainer.style.whiteSpace = "normal";
  measurementContainer.style.pointerEvents = "none";
  measurementContainer.style.zIndex = "-1";

  style.textContent = `
    .chat-content-measure,
    .chat-content-measure * {
      width: auto !important;
      max-width: none !important;
      min-width: 0 !important;
    }

    .chat-content-measure table {
      table-layout: auto !important;
    }

    .chat-content-measure pre,
    .chat-content-measure code {
      white-space: pre !important;
    }
  `;

  measurementContainer.appendChild(style);
  document.body?.appendChild(measurementContainer);

  return measurementContainer;
};

const measureUnconstrainedWidth = (element) => {
  if (!(element instanceof HTMLElement)) {
    return 0;
  }

  const wrapper = ensureMeasurementContainer();
  const clone = element.cloneNode(true);

  wrapper.appendChild(clone);
  const width = wrapper.getBoundingClientRect().width;
  wrapper.removeChild(clone);

  return width;
};

const updateChatMessageWidths = () => {
  const hasDrawerChatContext = () =>
    document.documentElement?.classList.contains("has-drawer-chat");

  const maxWidth = hasDrawerChatContext()
    ? 300
    : window.innerWidth < 600
      ? 300
      : window.innerWidth < 1000
        ? 400
        : 500;

  document.querySelectorAll(".chat-message").forEach((message) => {
    const content = message.querySelector(".chat-message-content");

    if (!content) {
      return;
    }

    const contentWidth = measureUnconstrainedWidth(content);
    const naturalWidth = contentWidth + 56; //Adds .chat-message padding
    const targetWidth = Math.min(Math.ceil(naturalWidth), maxWidth);

    if (naturalWidth <= maxWidth) {
      message.style.width = `${targetWidth}px`;
      message.style.maxWidth = `${maxWidth}px`;
    } else {
      message.style.width = "";
      message.style.maxWidth = `${maxWidth}px`;
    }
  });
};

const hasChatContext = () =>
  document.documentElement?.classList.contains("has-chat");

const runUpdates = () => {
  if (!document.body || !hasChatContext()) {
    return;
  }

  if (document.querySelector(".chat-message")) {
    updateChatMessageWidths();
  }
};

export default {
  name: "mutate-chat-bubble-width",

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

      window.addEventListener("resize", runUpdates, { passive: true });

      api.onPageChange(() => {
        requestAnimationFrame(runUpdates);
      });
    });
  },
};
