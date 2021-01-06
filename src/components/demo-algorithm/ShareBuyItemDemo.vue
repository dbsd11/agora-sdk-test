<template>
  <div id="shareBuyItemDemo">
    <div style="display:inline-flex">
      <p style="width: 100px">当前用户</p>
      <input type="text" placeholder="当前用户" required v-model="shareUid" style="width:200px;margin-right:100px"/>
      <button type="button" class="close" data-dismiss="alert" aria-label="Close" @click="clearShareItems">清除分享数据</button>
    </div>
    
    <div style="width:90%;overflow:hidden;display:inline-flex">
      <div style="margin-top:-260px;margin-right:100px">
        <iframe src="https://uland.taobao.com/sem/tbsearch?refpid=mm_26632258_3504122_32538762&keyword=%E6%B7%98%E5%AE%9D&clk1=741ebadd1759b629e8f280342a22ce20&upsId=741ebadd1759b629e8f280342a22ce20" width="820px" height="600px" frameborder="0" scrolling="no" >
        </iframe>
      </div>
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <a style="color:red" :href='"?shareUid="+shareUid' target="_blank">分享</a>
      </button>
    </div>

    <div style="width:90%;display: inline-flex;margin-top: 50px;">
        <p style="width: 100px">圈子数</p>
        <input style="width: 100px" v-model="shareGroupNum"/>

        <p style="width: 100px">感兴趣的人</p>
        <input style="width: 300px" v-model="groupUserList"/>

        <p style="width: 100px">推荐</p>
        <input style="width: 300px" v-model="recommendGroupUserList"/>
    </div>

    <div style="display: inline-flex;width: 50%;margin-top: 20px;" v-if='disjoinSetName'>
      <DisjoinSetTest :key='disjoinSetTestKey2' :chartData='disjoinSetChartData' :setName='disjoinSetName' :needDisjoinSet='true' v-show='false'/>
      <textarea rows="5" cols="100" required v-model="disjoinSetChartDataText"></textarea>
    </div>
  </div>
</template>

<script>
import DisjoinSetTest from "@/components/demo-algorithm/DisjoinSetTest.vue";
export default {
  name: "",
  components: {
    DisjoinSetTest
  },
  data() {
    return {
      shareUid: '',
      disjoinSetTestKey1: 1,
      disjoinSetTestKey2: 10000,
      disjoinSetChartData: {},
      disjoinSetChartDataText: '',
      disjoinSetName: '购买商品分享网络',
      shareGroupNum: 0,
      groupUserList: '',
      recommendGroupUserList: ''
    };
  },
  watch: {
      disjoinSetTestKey2(val) {
        let disjointSet = this.$children[0].disjointSet
        if(!disjointSet){
          return 
          0
        }
        this.shareGroupNum = disjointSet.forestSets

        let rootPoint = disjointSet.findSet({"id":this.shareUid, "name": this.shareUid})
        if(!rootPoint){
          return
        }

        let recommendGroupUserList={}

        let pointList = this.disjoinSetChartData['pointList']
        let groupPointList = pointList.filter((point)=> {
          let groupRootPoint = disjointSet.findSet(point)
          if(groupRootPoint && (groupRootPoint.id != rootPoint.id)) {
              recommendGroupUserList[groupRootPoint.name]=1
          }
          return groupRootPoint&&(groupRootPoint.id == rootPoint.id)
        })
        let groupUserList = groupPointList.map((point)=>point.name)
        this.groupUserList = JSON.stringify(groupUserList)
        this.recommendGroupUserList = JSON.stringify(Object.keys(recommendGroupUserList))
      }
  },
  created() {
  },
  mounted() {
    this.shareUid = this.randomName()

    this.saveShareInfo()

    setInterval(()=>{
      let shareItemStr = localStorage.getItem('shareItems')
      let shareItems = JSON.parse(shareItemStr?shareItemStr:'[]')

      //获取当前节点显示网络
      let showShareItems = []
      
      //添加当前节点的上游节点
      let toAddShareItems = shareItems.filter((shareItem)=>{
        return Object.values(shareItem)[0] == this.shareUid
      })
      showShareItems = showShareItems.concat(toAddShareItems)

      //添加当前节点下游节点
      let i =0;
      let showShareUid = [this.shareUid]
      while((i++<3) && (showShareUid.length !=0)){
        toAddShareItems = shareItems.filter((shareItem)=>{
          return showShareUid.includes(Object.keys(shareItem)[0])
        })
        showShareItems = showShareItems.concat(toAddShareItems)
        showShareUid = toAddShareItems.map((shareItem) => Object.values(shareItem)[0])
      }

      //随机返回不包含当前网络的分享节点
      toAddShareItems = shareItems.filter((shareItem)=>{
          return showShareItems.indexOf(shareItem) == -1
      })
      toAddShareItems = this.getRandomArrayElements(toAddShareItems, toAddShareItems.length>3?3:toAddShareItems.length)
      showShareItems = showShareItems.concat(toAddShareItems)

      var points = {}
      var edges = {}
      showShareItems.forEach((shareItem)=>{
        let shareUid = Object.keys(shareItem)[0]
        let shareToUid = shareItem[shareUid]
        points[shareUid]={"id": shareUid, "name":shareUid, "weight": shareUid ==this.shareUid?1000:1}
        points[shareToUid]={"id": shareToUid, "name":shareToUid}
        edges[shareUid+shareToUid]={"from": shareUid, "to": shareToUid, "weight": 1}
      })

      this.disjoinSetChartData = {
        pointList: Object.values(points),
        edgeList: Object.values(edges)
      }

      this.disjoinSetChartDataText = JSON.stringify(this.disjoinSetChartData)
      this.disjoinSetTestKey1 = this.disjoinSetTestKey1+1
      this.disjoinSetTestKey2 = this.disjoinSetTestKey2+1
    }, 5000)
  },
  methods: {
    uuid() {
      var temp_url = URL.createObjectURL(new Blob());
      var uuid = temp_url.toString();
      URL.revokeObjectURL(temp_url);
      return uuid.substr(uuid.lastIndexOf("/") + 1);
    },
    randomName() {
      var familyNames = new Array(
      "赵", "钱", "孙", "李", "周", "吴", "郑", "王", "冯", "陈", 
      "褚", "卫", "蒋", "沈", "韩", "杨", "朱", "秦", "尤", "许",
      "何", "吕", "施", "张", "孔", "曹", "严", "华", "金", "魏", 
      "陶", "姜", "戚", "谢", "邹", "喻", "柏", "水", "窦", "章",
      "云", "苏", "潘", "葛", "奚", "范", "彭", "郎", "鲁", "韦", 
      "昌", "马", "苗", "凤", "花", "方", "俞", "任", "袁", "柳",
      "酆", "鲍", "史", "唐", "费", "廉", "岑", "薛", "雷", "贺", 
      "倪", "汤", "滕", "殷", "罗", "毕", "郝", "邬", "安", "常",
      "乐", "于", "时", "傅", "皮", "卞", "齐", "康", "伍", "余", 
      "元", "卜", "顾", "孟", "平", "黄", "和", "穆", "萧", "尹"
      );
      var givenNames = new Array(
      "子璇", "淼", "国栋", "夫子", "瑞堂", "甜", "敏", "尚", "国贤", "贺祥", "晨涛", 
      "昊轩", "易轩", "益辰", "益帆", "益冉", "瑾春", "瑾昆", "春齐", "杨", "文昊", 
      "东东", "雄霖", "浩晨", "熙涵", "溶溶", "冰枫", "欣欣", "宜豪", "欣慧", "建政", 
      "美欣", "淑慧", "文轩", "文杰", "欣源", "忠林", "榕润", "欣汝", "慧嘉", "新建", 
      "建林", "亦菲", "林", "冰洁", "佳欣", "涵涵", "禹辰", "淳美", "泽惠", "伟洋", 
      "涵越", "润丽", "翔", "淑华", "晶莹", "凌晶", "苒溪", "雨涵", "嘉怡", "佳毅", 
      "子辰", "佳琪", "紫轩", "瑞辰", "昕蕊", "萌", "明远", "欣宜", "泽远", "欣怡", 
      "佳怡", "佳惠", "晨茜", "晨璐", "运昊", "汝鑫", "淑君", "晶滢", "润莎", "榕汕", 
      "佳钰", "佳玉", "晓庆", "一鸣", "语晨", "添池", "添昊", "雨泽", "雅晗", "雅涵", 
      "清妍", "诗悦", "嘉乐", "晨涵", "天赫", "玥傲", "佳昊", "天昊", "萌萌", "若萌"
      );
      var i = parseInt(familyNames.length * Math.random());
      var familyName = familyNames[i];
      var j = parseInt(givenNames.length * Math.random());
      var givenName = givenNames[j];
      var name = familyName + givenName;
      return name
    },
    saveShareInfo() {
      if(window.location.href.indexOf('shareUid') == -1){
        return
      }

      let shareUid = decodeURI(window.location.href).replace('#','')
      shareUid = shareUid.substr(shareUid.indexOf("shareUid=")+9)

      let shareToUid = this.shareUid

      let shareItemStr = localStorage.getItem('shareItems')
      let shareItems = JSON.parse(shareItemStr?shareItemStr:'[]')
      let shareItem = {}
      shareItem[shareUid]=shareToUid
      shareItems.push(shareItem)
      localStorage.setItem('shareItems', JSON.stringify(shareItems))
    },
    clearShareItems(){
      localStorage.setItem('shareItems', '')
    },
    getRandomArrayElements(arr, count) {
        var shuffled = arr.slice(0), i = arr.length, min = i - count, temp, index;
        while (i-- > min) {
            index = Math.floor((i + 1) * Math.random());
            temp = shuffled[index];
            shuffled[index] = shuffled[i];
            shuffled[i] = temp;
        }
        return shuffled.slice(min);
    }
  }
};


</script>

<style scoped>
</style>