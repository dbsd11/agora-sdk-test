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
        <label>对方已查收:</label>
        <p>{{ message.received }}</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      messages: [
        {
          from: "15726681696",
          to: "15726681696",
          content: "sadadsdasd",
          received: "true",
        },
        {
          from: "15726681696",
          to: "15726681696",
          content: "sadadsdasd",
          received: "true",
        },
      ],
      channelInfos: ["人数10"],
      option: {
        from: "",
        to: "",
        content: "",
      },
    };
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