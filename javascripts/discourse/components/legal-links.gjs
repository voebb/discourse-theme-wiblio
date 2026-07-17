import { i18n } from "discourse-i18n";

const LegalLinks = <template>
  <ul class="w-legal-links">
    <li>
      <a href="/t/impressum">{{i18n (themePrefix "imprint")}}</a>
    </li>
    <li>
      <a href="/privacy">{{i18n (themePrefix "privacy")}}</a>
    </li>
    <li>
      <a href="/tos">{{i18n (themePrefix "tos")}}</a>
    </li>
  </ul>
</template>;

export default LegalLinks;
