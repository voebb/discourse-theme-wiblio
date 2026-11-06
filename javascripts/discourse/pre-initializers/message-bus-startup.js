export default {
  before: "inject-discourse-objects",

  initialize(container) {
    // Topic tracking can subscribe before the AJAX adapter is configured.
    // The regular MessageBus initializer starts polling once it is ready.
    container.lookup("service:message-bus").stop();
  },
};
