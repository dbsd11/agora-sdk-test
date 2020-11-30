<template>
  <div class="hello">
    <div>
      <h1>{{ msg }}</h1>
      <h2>测试 Links</h2>
      <ul data-growing-container>
        <li
          @click="
            rtcChatChannelTest = true;
            rtmMessageTest = false;
          "
        >
          <a href="#">rtc聊天channel测试</a>
        </li>
        <li
          @click="
            rtcChatChannelTest = false;
            rtmMessageTest = true;
          "
        >
          <a href="#">rtm实时message测试</a>
        </li>
      </ul>
    </div>

    <div
      id="success-alert"
      class="alert alert-success alert-dismissible fade show"
      role="alert"
    >
      <strong>Congratulations!</strong
      ><span> You can invite others join this channel by click </span
      ><a href="" target="_blank">here</a>
      <button
        type="button"
        class="close"
        data-dismiss="alert"
        aria-label="Close"
      >
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <div
      id="success-alert-with-token"
      class="alert alert-success alert-dismissible fade show"
      role="alert"
    >
      <strong>Congratulations!</strong><span> Joined room successfully. </span>
      <button
        type="button"
        class="close"
        data-dismiss="alert"
        aria-label="Close"
      >
        <span aria-hidden="true">&times;</span>
      </button>
    </div>
    <div
      id="success-alert-with-token"
      class="alert alert-success alert-dismissible fade show"
      role="alert"
    >
      <strong>Congratulations!</strong><span> Joined room successfully. </span>
      <button
        type="button"
        class="close"
        data-dismiss="alert"
        aria-label="Close"
      >
        <span aria-hidden="true">&times;</span>
      </button>
    </div>

    <div class="container">
      <form id="join-form">
        <div class="row join-info-group">
          <div class="col-sm">
            <p class="join-info-text">AppID</p>
            <input
              id="appid"
              type="text"
              placeholder="enter appid"
              required
              v-model="option.appid"
            />
            <p class="tips">
              If you don`t know what is your appid, checkout
              <a
                href="https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#a-nameappidaapp-id"
                >this</a
              >
            </p>
          </div>
          <div class="col-sm">
            <p class="join-info-text">Token(optional)</p>
            <input
              id="token"
              type="text"
              placeholder="enter token"
              v-model="option.token"
            />
            <p class="tips">
              If you don`t know what is your token, checkout
              <a
                href="https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#a-namekeyadynamic-key"
                >this</a
              >
            </p>
          </div>
          <div class="col-sm">
            <p class="join-info-text">Channel</p>
            <input
              id="channel"
              type="text"
              placeholder="enter channel name"
              required
              v-model="option.channel"
            />
            <p class="tips">
              If you don`t know what is your channel, checkout
              <a
                href="https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#channel"
                >this</a
              >
            </p>
          </div>
        </div>

        <div class="button-group">
          <button
            id="join"
            type="button"
            class="btn btn-primary btn-sm"
            @click="joinChannel"
          >
            Join
          </button>
          <button
            id="leave"
            type="button"
            class="btn btn-primary btn-sm"
            @click="leaveChannel"
          >
            Leave
          </button>
        </div>
      </form>

      <div class="row video-group">
        <RtcChatChannelTest v-if="rtcChatChannelTest" />
        <RtmMessageTest v-if="rtmMessageTest" />
      </div>
    </div>
  </div>
</template>

<script>
import RtcChatChannelTest from "@/components/rtc-chatchannel/RtcChatChannelTest.vue";
import RtmMessageTest from "@/components/rtm-message/RtmMessageTest.vue";
export default {
  name: "HelloWorld",
  components: {
    RtcChatChannelTest,
    RtmMessageTest,
  },
  data() {
    return {
      msg: "Welcome to Your Vue.js App",
      rtcChatChannelTest: true,
      rtmMessageTest: false,
      option: {
        appid: "",
        token: "",
        uid: 0,
        channel: "",
      },
    };
  },
  methods: {
    joinChannel() {
      if (this.$children.length == 0) {
        return;
      }

      console.info("join channel option:", this.option);
      this.$children[0].joinChannel();
    },
    leaveChannel() {
      if (this.$children.length == 0) {
        return;
      }

      console.info("leave channel option:", this.option);
      this.$children[0].leaveChannel();
    },
  },
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1,
h2 {
  font-weight: normal;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}

.banner {
  padding: 0;
  background-color: #52575c;
  color: white;
}

.banner-text {
  padding: 8px 20px;
  margin: 0;
}

#join-form {
  margin-top: 10px;
}

.tips {
  font-size: 12px;
  margin-bottom: 2px;
  color: gray;
}

.join-info-text {
  margin-bottom: 2px;
}

input {
  width: 100%;
  margin-bottom: 2px;
}

.player {
  width: 480px;
  height: 320px;
}

.player-name {
  margin: 8px 0;
}

#success-alert,
#success-alert-with-token {
  display: none;
}

@media (max-width: 640px) {
  .player {
    width: 320px;
    height: 240px;
  }
}
</style>
