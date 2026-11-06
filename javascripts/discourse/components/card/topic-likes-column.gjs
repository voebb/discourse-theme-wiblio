import icon from "discourse/ui-kit/helpers/d-icon";

const TopicLikesColumn = <template>
  {{#if @topic.like_count}}
    <span class="topic-likes">{{icon "heart"}}{{@topic.like_count}}</span>
  {{/if}}
</template>;

export default TopicLikesColumn;
