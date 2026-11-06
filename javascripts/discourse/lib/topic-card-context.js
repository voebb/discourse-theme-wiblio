const TOPIC_CARD_CONTEXTS = [
  "discovery",
  "suggested",
  "related",
  "group-activity",
  "user-activity",
  "zlb-community-dashboard-topic-list",
  "zlb-community-dashboard-pinned-topic",
];

export default function isTopicCardContext({ listContext, category }) {
  return (
    TOPIC_CARD_CONTEXTS.includes(listContext) && !category?.doc_index_topic_id
  );
}
