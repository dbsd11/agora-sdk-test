<template>
  <div class="agora-video-player" ref="player" :id="domId"></div>
</template>

<script>
export default {
  name: "stream-player",
  props: ["stream", "domId"],
  mounted() {
    var that = this;
    this.$nextTick(function () {
      if (this.stream && !this.stream.isPlaying()) {
        this.stream.play(`${this.domId}`, { fit: "cover" }, (err) => {
          if (err && err.status !== "aborted") {
            // 播放失败，一般为浏览器策略阻止。引导用户用手势触发恢复播放
            document
              .querySelectorAll(".agora-video-player")
              .forEach((playerDom) => {
                playerDom.onclick = function () {
                  that.stream
                    .resume()
                    .then(function (result) {
                      console.log("恢复成功：" + result);
                    })
                    .catch(function (reason) {
                      console.log("恢复失败：" + reason);
                    });
                };
              });
          }
        });
      }
    });
  },
  beforeDestroy() {
    if (this.stream) {
      if (this.stream.isPlaying()) {
        this.stream.stop();
      }
      this.stream.close();
    }
  },
};
</script>

<style>
.agora-video-player {
  height: 100%;
  width: 100%;
}

video {
  margin-left: -50%;
}
</style>