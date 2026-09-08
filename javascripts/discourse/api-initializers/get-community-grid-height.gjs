import { apiInitializer } from "discourse/lib/api";

const desktopViewport = window.matchMedia("(min-width: 64rem)");

let resizeObserver;

function setTopicListHeight() {
  document
    .querySelectorAll(".zlb-community-grid--dashboard")
    .forEach((dashboard) => {
      const communityGrid = dashboard.querySelector(
        ":scope > .zlb-community-grid",
      );
      const topicList = dashboard.querySelector(
        ":scope > .zlb-community-dashboard-topic-list",
      );

      if (!communityGrid || !topicList) {
        return;
      }

      topicList.style.blockSize = desktopViewport.matches
        ? `${communityGrid.offsetHeight}px`
        : "";
    });
}

function observeCommunityGridHeight() {
  resizeObserver?.disconnect();

  const communityGrids = document.querySelectorAll(
    ".zlb-community-grid--dashboard > .zlb-community-grid",
  );

  if (!communityGrids.length) {
    return;
  }

  resizeObserver = new ResizeObserver(setTopicListHeight);
  communityGrids.forEach((communityGrid) => resizeObserver.observe(communityGrid));
  setTopicListHeight();
}

export default apiInitializer((api) => {
  requestAnimationFrame(observeCommunityGridHeight);

  desktopViewport.addEventListener("change", setTopicListHeight);
  window.addEventListener("resize", setTopicListHeight, { passive: true });

  api.onPageChange(() => requestAnimationFrame(observeCommunityGridHeight));
});
