<template>
  <div id="rtmDiv">
    <div class="send-panel">
      <p>当前userId</p>
      <input
        id="from"
        type="text"
        placeholder="当前userId"
        v-model="option.from"
        style="margin-left: 10px; margin-right: 5px"
        disabled
      />
      <p>对方userId</p>
      <input
        id="to"
        type="text"
        placeholder="enter 对方userId"
        v-model="option.to"
        style="margin-left: 10px; margin-right: 5px"
      />
      <p>发送内容</p>
      <input
        id="content"
        type="text"
        placeholder="enter 发送内容"
        v-model="option.content"
        style="margin-left: 10px; margin-right: 5px"
      />
      <button
        id="send"
        type="button"
        class="btn btn-primary btn-sm"
        @click="sendMessage"
      >
        发送
      </button>
    </div>

    <div class="panel">
      <label class="panel-title">频道属性</label>
      <br />
      <div v-for="(channelInfo, index) in channelInfos" :key="index">
        <p style="display: inline-flex">{{ channelInfo }}</p>
      </div>
    </div>

    <div class="panel">
      <label class="panel-title">消息列表</label>
      <br />
      <div
        v-for="(message, index) in messages"
        :key="index"
        style="display: inline-flex"
      >
        <label>发送方:</label>
        <p>{{ message.from }}</p>
        <label>接收方:</label>
        <p>{{ message.to }}</p>
        <label>内容:</label>
        <p>{{ message.content }}</p>
        <label>是否已查收:</label>
        <p>{{ message.received }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import AgoraRTM from "agora-rtm-sdk";

export default {
  data() {
    return {
      messages: [],
      option: {
        from: "",
        to: "",
        content: "",
      },
      AgoraRTMObj: null,
      testChannelAttribute01: [],
      channelPeopleCount: 0,
      AgoraRTMObjChannel: null,
    };
  },
  computed: {
    channelInfos() {
      console.info(this.channelPeopleCount);
      return ["人数" + this.channelPeopleCount];
    },
  },
  mounted() {
    this.option.from = this.uuid();
    this.$parent.option.channel = "testRTM01";
    this.$axios
      .get(
        `https://chinaccelerator.t.gotin.online/api/videocall/rtm?userId=${this.option.from}&channelId=${this.$parent.option.channel}`
      )
      .then(({ data: data }) => {
        if (data.data) {
          this.$parent.option.appid = data.data.appId;
          this.$parent.option.token = data.data.token;
        }
      });

      setInterval(()=>{
        if(!window.testQueryOnlinePeerId || !this.AgoraRTMObj) {
          return
        }

        this.AgoraRTMObj.queryPeersOnlineStatus([window.testQueryOnlinePeerId]).then((peersOnlineStatusResult)=>{
            console.info(peersOnlineStatusResult)
        })
      }, 1000)
  },
  methods: {
    uuid() {
      var temp_url = URL.createObjectURL(new Blob());
      var uuid = temp_url.toString();
      URL.revokeObjectURL(temp_url);
      return uuid.substr(uuid.lastIndexOf("/") + 1);
    },
    joinChannel() {
      this.AgoraRTMObj = AgoraRTM.createInstance(this.$parent.option.appid, {
        enableLogUpload: false,
      });

      this.AgoraRTMObj.login({
        uid: this.option.from,
        token: this.$parent.option.token,
      })
        .then(() => {
          console.log("聊天室login");
          this.AgoraRTMObj._logined = true;
          let channelId = this.$parent.option.channel;
          var that = this;
          setTimeout(() => {
            this.AgoraRTMObj.getChannelAttributesByKeys(channelId, [
              "testChannelAttribute01",
            ])
              .then((res) => {
                if (res["testChannelAttribute01"]) {
                  that.testChannelAttribute01 = JSON.parse(
                    res["testChannelAttribute01"].value
                  );
                  that.messages = that.testChannelAttribute01.filter(
                    (attribute) => attribute.from != null
                  );
                }
              })
              .catch((err) => {
                console.log(err);
              });
          }, 2000);

          this.AgoraRTMObjChannel = this.AgoraRTMObj.createChannel(channelId);
          this.AgoraRTMObjChannel.join()
            .then((res) => {
              this.AgoraRTMObjChannel.on("MemberJoined", (memberId) => {
                console.log("用户加入", memberId);
              });
              this.AgoraRTMObjChannel.on("ChannelMessage", function (
                message,
                memberId
              ) {
                console.log("用户消息", message, memberId);
              });
              this.AgoraRTMObjChannel.on("MemberLeft", (memberId) => {
                console.log("用户离开", memberId);
              });
              this.AgoraRTMObjChannel.on(
                "MemberCountUpdated",
                (memberCount) => {
                  this.channelPeopleCount = memberCount;
                }
              );
              this.AgoraRTMObjChannel.on("AttributesUpdated", (evt) => {
                console.log("AttributesUpdated", evt);
                if (evt["testChannelAttribute01"]) {
                  this.testChannelAttribute01 = JSON.parse(
                    evt["testChannelAttribute01"].value
                  );
                }
              });
            })
            .catch((err) => {
              console.log(err);
            });
          this.AgoraRTMObj.on("MessageFromPeer", ({ text }, peerId) => {
            console.log("新消息", text, peerId);
            var messgaeJSON =
              text.startsWith("{") && text.endsWith("}")
                ? JSON.parse(text)
                : null;
            if (!messgaeJSON) {
              return;
            }

            this.messages.push(messgaeJSON);
            messgaeJSON["received"] = true;
            this.testChannelAttribute01.push(messgaeJSON);

            this.AgoraRTMObj.addOrUpdateChannelAttributes(
              channelId,
              {
                testChannelAttribute01: JSON.stringify(
                  this.testChannelAttribute01
                ),
              },
              { enableNotificationToChannelMembers: true }
            ).then((res) => {
              console.log(
                "修改channel属性testChannelAttribute01成功",
                this.testChannelAttribute01
              );
            });
          });
          this.AgoraRTMObj.subscribePeersOnlineStatus([this.option.from])
          this.AgoraRTMObj.on('PeersOnlineStatusChanged', (evt)=>{
            console.info('PeersOnlineStatusChanged', evt)
          })

        })
        .catch((err) => {
          console.log(err);
        });
    },
    leaveChannel() {
      if (this.AgoraRTMObjChannel) {
        this.AgoraRTMObjChannel.leave().then(() => {
          this.AgoraRTMObj.logout();
          this.AgoraRTMObjChannel = null;
          this.AgoraRTMObj = null;
        });
      }
    },
    sendMessage() {
      this.AgoraRTMObj.sendMessageToPeer(
        { text: JSON.stringify(this.option) },
        this.option.to
      )
        .then((sendResult) => {
          this.messages.push(JSON.parse(JSON.stringify(this.option)));
          if (sendResult.hasPeerReceived) {
            /* 远端用户收到消息的处理逻辑 */
            console.log("发送成功！！");
          } else {
            /* 服务器已接收、但远端用户不可达的处理逻辑 */
          }
        })
        .catch((err) => {
          console.log(err);
        });
    },
  },
};
</script>
<style>
#rtcDiv {
  width: 100%;
}

.send-panel {
  margin: 20px;
  width: 1000px;
  display: flex;
  align-items: baseline;
}

.panel {
  background-color: aliceblue;
  margin: 20px;
  width: 1000px;
  text-align: center;
}

.panel-title {
  font-size: 30px;
}

label {
  margin-left: 10px;
  margin-right: 5px;
}
</style>