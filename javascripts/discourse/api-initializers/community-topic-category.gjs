import Component from "@glimmer/component";
import { hash } from "@ember/helper";
import { apiInitializer } from "discourse/lib/api";
import { categoryLinkHTML } from "discourse/ui-kit/helpers/d-category-link";

export default apiInitializer((api) => {
  if (!api.container.lookup("service:site-settings").zlb_community_enabled) {
    return;
  }

  class CommunityTopicCategory extends Component {
    static shouldRender(outletArgs) {
      return (
        outletArgs.category &&
        api.container
          .lookup("service:community-category-service")
          .communityCategoryIdForCategory(outletArgs.category)
      );
    }

    <template>
      {{#unless @outletArgs.topic.isPrivateMessage}}
        {{categoryLinkHTML @outletArgs.category (hash hideParent=true)}}
      {{/unless}}
    </template>
  }

  api.renderInOutlet("topic-category-link-wrapper", CommunityTopicCategory);
  api.renderInOutlet("header-categories-wrapper", CommunityTopicCategory);
});
