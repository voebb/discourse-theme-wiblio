import { apiInitializer } from "discourse/lib/api";
import ForumCategoryBreadcrumbs from "../components/forum-category-breadcrumbs";

export default apiInitializer((api) => {
  api.renderInOutlet("discovery-above", ForumCategoryBreadcrumbs);
});
