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
            disjoinSetTest = false;
          "
        >
          <a href="#">rtc聊天channel测试</a>
        </li>
        <li
          @click="
            rtcChatChannelTest = false;
            rtmMessageTest = true;
            disjoinSetTest = false;
          "
        >
          <a href="#">rtm实时message测试</a>
        </li>
        <li
          @click="
            rtcChatChannelTest = false;
            rtmMessageTest = false;
            disjoinSetTest = true;
          "
        >
          <a href="#">并查集算法测试</a>
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

    <div class="container" v-if="rtcChatChannelTest || rtmMessageTest">
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

    <div v-if="disjoinSetTest">
        <div style="width:80%;display:inline-grid">
          <p style="font-weight:bold;font-size:xlarge">算法效果</p>
          <input type="text" placeholder="网络名" required v-model="disjoinSetName" style="width:200px"/>
          <textarea rows="5" cols="5" required v-model="disjoinSetChartDataText" v-if='disjoinSetName'></textarea>
        </div>
        
        <div style="display: inline-flex" v-if='disjoinSetName'>
          <DisjoinSetTest :key='disjoinSetName' :chartDataText='disjoinSetChartDataText' :setName='disjoinSetName+" (转换前)"' :needDisjoinSet='false'/>
          <p style="width:0px;font-weight:bold;writing-mode:vertical-rl;-webkit-text-combine:horizontal">=></p>
          <p style="width:10px;font-weight:bold;writing-mode:vertical-rl">转换后</p>
          <DisjoinSetTest :key='disjoinSetName+"1"' :chartDataText='disjoinSetChartDataText' :setName='disjoinSetName' :needDisjoinSet='true'/>
        </div>

        <div style="width:80%;margin-top:50px;display:inline-grid">
           <p style="font-weight:bold;font-size:xlarge">demo</p>
           <ShareBuyItemDemo/>
        </div>
    </div>
  </div>
</template>

<script>
import RtcChatChannelTest from "@/components/rtc-chatchannel/RtcChatChannelTest.vue";
import RtmMessageTest from "@/components/rtm-message/RtmMessageTest.vue";
import DisjoinSetTest from "@/components/demo-algorithm/DisjoinSetTest.vue";
import ShareBuyItemDemo from "@/components/demo-algorithm/ShareBuyItemDemo.vue"
export default {
  name: "HelloWorld",
  components: {
    RtcChatChannelTest,
    RtmMessageTest,
    DisjoinSetTest,
    ShareBuyItemDemo,
  },
  data() {
    return {
      msg: "Welcome to Your Vue.js App",
      rtcChatChannelTest: true,
      rtmMessageTest: false,
      disjoinSetTest: false,
      option: {
        appid: "",
        token: "",
        uid: 0,
        channel: "",
      },
      disjoinSetChartData :{
        pointList: [
        {
         "id": "xxa",
         "name": "A"
        },{
         "id": "xxc",
         "name": "C"
        },
        {
         "id": "xxb",
         "name": "B",
         "value": 1000
        },
        {
         "id": "xxd",
         "name": "D"
        },{
         "id": "xxe",
         "name": "E"
        },{
         "id": "xxf",
         "name": "f"
        },{
         "id": "xxg",
         "name": "g"
        }],
        edgeList: [
        {
          "from": "xxa",
          "to": "xxb",
          "weight": 10
        },{
          "from": "xxc",
          "to": "xxb",
          "weight": 7
        },
        {
          "from": "xxe",
          "to": "xxd",
          "weight": 3
        },
        {
          "from": "xxb",
          "to": "xxd",
          "weight": 3
        },
        {
          "from": "xxd",
          "to": "xxf",
          "weight": 3
        },
        {
          "from": "xxf",
          "to": "xxg",
          "weight": 3
        }
        ]
      },
      disjoinSetName: '',
      disjoinSetChartDataText: '{"pointList":[], "edgeList":[]}',
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
