<template>
  <div class="hello">
    <div>
      <h1>{{ msg }}</h1>
      <h2>测试 Links</h2>
      <ul data-growing-container>
        
      </ul>
    </div>
  </div>
</template>

<script>
import Flow from "@/components/flow/Flow.vue";
export default {
  name: "HelloWorld",
  components: {
    Flow,
  },
  data() {
    return {
      msg: "Welcome to Your Vue.js App"
    };
  },
  methods: {
    
  },
};
</script>
