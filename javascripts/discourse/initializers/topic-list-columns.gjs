import HeaderTopicCell from "discourse/components/topic-list/header/topic-cell";
import { withPluginApi } from "discourse/lib/plugin-api";
import HighContextTopicCard from "../components/card/high-context-topic-card";

const TOPIC_CARD_CONTEXTS = [
  "discovery",
  "suggested",
  "related",
  "group-activity",
  "user-activity",
];

const isTopicCardContext = ({ listContext, category }) =>
  TOPIC_CARD_CONTEXTS.includes(listContext) && !category?.doc_index_topic_id;

const HighContextCard = <template>
  <HighContextTopicCard
    @topic={{@topic}}
    @hideCategory={{@hideCategory}}
    @bulkSelectEnabled={{@bulkSelectEnabled}}
    @isSelected={{@isSelected}}
    @onBulkSelectToggle={{@onBulkSelectToggle}}
  />
</template>;

export default {
  name: "topic-list-customizations",

  initialize() {
    function applyHighContextLayout(columns) {
      columns.delete("topic");
      columns.delete("posters");
      columns.delete("replies");
      columns.delete("views");
      columns.delete("activity");
      columns.add("high-context-card", {
        header: HeaderTopicCell,
        item: HighContextCard,
      });
    }

    withPluginApi((api) => {
      api.registerValueTransformer("topic-list-class", ({ value: classes }) => {
        classes.push("--d-topic-cards");
        return classes;
      });

      api.registerValueTransformer(
        "topic-list-columns",
        ({ value: columns }) => {
          applyHighContextLayout(columns);
          return columns;
        }
      );

      api.registerValueTransformer(
        "topic-list-item-class",
        ({ value: classes, context }) => {
          classes.push("--high-context");

          if (context.topic.replyCount) {
            classes.push("--has-replies");
          }

          if (
            context.topic.is_hot ||
            context.topic.pinned ||
            context.topic.pinned_globally
          ) {
            classes.push("--has-status-card");
          }

          return classes;
        }
      );

      // Disable mobile layout for topic card contexts
      api.registerValueTransformer("topic-list-item-mobile-layout", () => {
        return false;
      });

      api.registerBehaviorTransformer(
        "topic-list-item-click",
        ({ context, next }) => {
          const { event, topic, listContext } = context;

          if (
            !isTopicCardContext({
              listContext,
              category: topic?.category,
            })
          ) {
            return next();
          }

          if (
            (event.target.closest("a, button, input") &&
              !event.target.closest(".topic-excerpt")) ||
            event.target.closest(".topic-excerpt-more")
          ) {
            return next();
          }

          event.preventDefault();
          event.stopPropagation();

          const topicLink = event.target
            .closest("tr")
            .querySelector("a.raw-topic-link");

          if (event.button === 1) {
            // click events with button=1 can't naturally trigger browser navigation
            window.open(topicLink.href, "_blank", "noopener,noreferrer");
            return;
          }

          topicLink.dispatchEvent(
            new MouseEvent("click", {
              ctrlKey: event.ctrlKey,
              metaKey: event.metaKey,
              shiftKey: event.shiftKey,
              button: event.button,
              which: event.which,
              bubbles: true,
              cancelable: true,
            })
          );
        }
      );
    });
  },
};
