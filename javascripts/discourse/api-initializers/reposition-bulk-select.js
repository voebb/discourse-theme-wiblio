import { apiInitializer } from "discourse/lib/api";
import isTopicCardContext from "../lib/topic-card-context";

export default apiInitializer((api) => {
  const router = api.container.lookup("service:router");
  const topicTrackingState = api.container.lookup(
    "service:topic-tracking-state"
  );

  api.registerValueTransformer("bulk-select-in-nav-controls", ({ value }) => {
    if (
      router.currentRouteName?.startsWith("discovery.") &&
      isTopicCardContext({
        listContext: "discovery",
        category: topicTrackingState.filterCategory,
      })
    ) {
      return true;
    }

    return value;
  });
});
