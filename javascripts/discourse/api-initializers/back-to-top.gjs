import { apiInitializer } from "discourse/lib/api";
import BackToTop from "../components/back-to-top";

export default apiInitializer((api) => {
  if (api.container.lookup("service:site-settings").zlb_community_enabled) {
    api.renderInOutlet("above-main-container", BackToTop);
  }
});
