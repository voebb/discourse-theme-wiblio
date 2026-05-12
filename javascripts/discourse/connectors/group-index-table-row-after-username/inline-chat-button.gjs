import ChatDirectMessageButton from "discourse/plugins/chat/discourse/components/chat/direct-message-button";
// Renders the Chat DM button directly inside the card body (user-card-post-below
// outlet), so it appears inline with the card content rather than inside the
// separate .usercard-controls footer strip.

<template>
  <ChatDirectMessageButton
    @user={{@outletArgs.member}}
    @modal={{true}}
  />
</template>
