<template>
  <div id="rtcDiv">
    <div class="agora-view">
      <div class="agora-video">
        <StreamPlayer
          :stream="localStream"
          :domId="localStream.getId()"
          v-if="localStream"
        ></StreamPlayer>
      </div>
      <div class="agora-video" :key="index" v-for="(stream, index) in streams">
        <StreamPlayer :stream="stream" :domId="stream.getId()"></StreamPlayer>
      </div>
      <div class="agora-video" v-show="!streams.length > 0"></div>
    </div>
  </div>
</template>

<script>
import StreamPlayer from "@/components/common/StreamPlayer.vue";
import RTCClient from "@/utils/agora-rtc-client";
import { log } from "@/utils/agoraLogUtil";
import "@/utils/AgoraRTCSDK-3.2.1";

export default {
  components: {
    StreamPlayer,
  },
  data() {
    return {
      localStream: null,
      streams: [],
    };
  },
  created() {
    if (!AgoraRTC.checkSystemRequirements()) {
      alert.error("不兼容当前浏览器");
    }
  },
  methods: {
    joinChannel() {
      AgoraRTC.getDevices(
        function (devices) {
          let videoinput = devices.find((item) => {
            return item.kind == "videoinput";
          });
          let audioinput = devices.find((item) => {
            return item.kind == "audioinput";
          });
          if (!audioinput) {
            alert.error("未检测到麦克风！");
          }
          if (!videoinput) {
            alert.error("未检测到摄像头！");
          }
        },
        function (errStr) {
          console.error("Failed to getDevice", errStr);
        }
      );

      if (this.rtc && this.rtc.localStream) {
        this.rtc.localStream.close();
      }
      this.rtc = new RTCClient();
      let rtc = this.rtc;
      rtc.on("stream-added", (evt) => {
        let { stream } = evt;
        rtc.client.subscribe(stream);
      });
      rtc.on("stream-subscribed", (evt) => {
        let { stream } = evt;
        if (!this.streams.find((it) => it.getId() === stream.getId())) {
          this.streams.push(stream);
        }
      });
      rtc.on("stream-removed", (evt) => {
        let { stream } = evt;
        // log("[agora] [stream-removed] stream-removed", stream.getId());
        this.streams = this.streams.filter(
          (it) => it.getId() !== stream.getId()
        );
      });
      //有人进来
      rtc.on("peer-online", (evt) => {
        //触发加入逻辑
      });
      //有人离开
      rtc.on("peer-leave", (evt) => {
        this.streams = this.streams.filter((it) => it.getId() !== evt.uid);
      });

      this.rtc
        .joinChannel(this.$parent.option)
        .then(() => {
          this.rtc
            .publishStream()
            .then((stream) => {
              this.localStream = stream;
            })
            .catch((err) => {
              // this.$message.error("Publish Failure");
              log("publish local error", err);
            });
          let _this = this;
          //对方关闭视频流了
          this.rtc.client.on("mute-video", function (evt) {});
          //对方开启视频流了
          this.rtc.client.on("unmute-video", function (evt) {});
          //对方关闭语音
          this.rtc.client.on("mute-audio", function (evt) {
            // var uid = evt.uid;
            console.log("对方关闭语音");
          });
          //开启语音
          this.rtc.client.on("unmute-audio", function (evt) {
            // var uid = evt.uid;
            console.log("对方开启语音");
          });
        })
        .catch((err) => {
          this.$message.error("Join Failure");
          log("join channel error", err);
        });
    },
    leaveChannel() {
      if (this.rtc && this.rtc.localStream) {
        try {
          var that = this;
          this.rtc
            .leaveChannel()
            .then(() => {
              console.info("Leave Success");
            })
            .catch((err) => {
              // this.$message.error("Leave Failure");
              log("leave error", err);
            });
          this.rtc.localStream.close();
          this.rtc.localStream = null;
          this.localStream = null;
          this.streams = [];
        } catch (e) {}
      }
    },
  },
};
</script>

<style scoped>
#rtcDiv {
  width: 100%;
}
.agora-view {
  width: 80%;
  margin-left: 10%;
  margin-top: 10px;
  height: 500px;
  display: flex;
  flex-wrap: wrap;
  flex-direction: row;
  align-content: flex-start;
  position: relative;
  background-color: black;
}

.agora-video {
  height: 100%;
  flex: 1;
}
</style>