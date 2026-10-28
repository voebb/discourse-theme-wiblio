import Component from "@glimmer/component";
import { hash } from "@ember/helper";
import { service } from "@ember/service";
import { themePrefix } from "virtual:theme";
import Category from "discourse/models/category";
import { categoryLinkHTML } from "discourse/ui-kit/helpers/d-category-link";
import dIcon from "discourse/ui-kit/helpers/d-icon";
import { i18n } from "discourse-i18n";

export default class ForumCategoryBreadcrumbs extends Component {
  @service communityCategoryService;
  @service siteSettings;

  get category() {
    return this.args.outletArgs.category;
  }

  get communityCategory() {
    if (!this.siteSettings.zlb_community_enabled || !this.category) {
      return null;
    }
    return Category.findById(
      this.communityCategoryService.communityCategoryIdForCategory(
        this.category
      )
    );
  }

  get subcategory() {
    return this.category?.id !== this.communityCategory?.id
      ? this.category
      : null;
  }

  get subcategoriesHidden() {
    return Boolean(this.args.outletArgs.model?.noSubcategories);
  }

  get selectionResetUrl() {
    if (this.subcategory) {
      return `${this.communityCategory.url}/all`;
    }
    return null;
  }

  get subcategoryFilterUrl() {
    const filter = this.subcategoriesHidden ? "all" : "none";
    return `${this.communityCategory.url}/${filter}`;
  }

  get subcategoryFilterLabel() {
    return themePrefix(
      this.subcategoriesHidden ? "show_subcategories" : "hide_subcategories"
    );
  }

  <template>
    {{#if this.communityCategory}}
      <nav class="w-forum-breadcrumbs" aria-label={{i18n "categories"}}>
        {{categoryLinkHTML this.communityCategory (hash hideParent=true)}}
        {{#if this.subcategory}}
          {{dIcon "angle-right"}}
          <span aria-current="page">
            {{categoryLinkHTML this.subcategory (hash hideParent=true)}}
          </span>
        {{/if}}
        {{#if this.selectionResetUrl}}
          <a
            class="discourse-tag w-forum-breadcrumbs__filter"
            href={{this.selectionResetUrl}}
          >
            {{i18n (themePrefix "clear_category_selection")}}
          </a>
        {{/if}}
        {{#unless this.subcategory}}
          <a
            class="discourse-tag w-forum-breadcrumbs__filter
              {{if this.subcategoriesHidden 'is-active'}}"
            href={{this.subcategoryFilterUrl}}
            aria-label={{i18n this.subcategoryFilterLabel}}
            title={{i18n this.subcategoryFilterLabel}}
          >
            {{i18n (themePrefix "hide_subcategories")}}
            {{#if this.subcategoriesHidden}}
              {{dIcon "xmark"}}
            {{/if}}
          </a>
        {{/unless}}
      </nav>
    {{/if}}
  </template>
}
