import icon from "discourse/ui-kit/helpers/d-icon";
import number from "discourse/ui-kit/helpers/d-number";

const TopicRepliesColumn = <template>
  {{#if @topic.replyCount}}
    <span class="topic-replies">{{icon "reply"}}{{number
        @topic.replyCount
      }}</span>
  {{/if}}
</template>;

export default TopicRepliesColumn;
