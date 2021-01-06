<template>
  <div id="disjointSetDiv">
    <!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
        <div id="main" ref="chart">
        </div>
  </div>
</template>

<script>
const echarts = require("echarts");
export default {
  data() {
    return {
      title: '',
      nodes: [],
      links: [],
      categories: [],
      color: ["#b8d9ff", "#0198e5", "#ff6c66"],
      disjointSet: null
    };
  },
  props: {
    chartData: {
      type: Object,
    },
    chartDataText: {
      type: String
    },
    setName: {
      type: String,
    },
    needDisjoinSet: {
      type: Boolean
    }
  },
  created() {
    this.initData();
  },
  mounted() {
    this.initCharts();
  },
  methods: {
    initDemoData(){
      this.title = '家族关系网'
      this.nodes = [
                {category:0, name: '乔布斯', value : 10, label: '乔布斯\n（主要）'},
                {category:1, name: '丽萨-乔布斯',value : 2},
                {category:1, name: '保罗-乔布斯',value : 3},
                {category:1, name: '克拉拉-乔布斯',value : 3},
                {category:1, name: '劳伦-鲍威尔',value : 7},
                {category:2, name: '史蒂夫-沃兹尼艾克',value : 5},
                {category:2, name: '奥巴马',value : 8},
                {category:2, name: '比尔-盖茨',value : 9},
                {category:2, name: '乔纳森-艾夫',value : 4},
                {category:2, name: '蒂姆-库克',value : 4},
                {category:2, name: '龙-韦恩',value : 1},
            ]
      this.links = [
                {source : '丽萨-乔布斯', target : '乔布斯', weight : 1, name: '女儿\r'},
                {source : '保罗-乔布斯', target : '乔布斯', weight : 2, name: '父亲'},
                {source : '克拉拉-乔布斯', target : '乔布斯', weight : 1, name: '母亲'},
                {source : '劳伦-鲍威尔', target : '乔布斯', weight : 2},
                {source : '史蒂夫-沃兹尼艾克', target : '乔布斯', weight : 3, name: '合伙人'},
                {source : '奥巴马', target : '乔布斯', weight : 1},
                {source : '比尔-盖茨', target : '乔布斯', weight : 6, name: '竞争对手'},
                {source : '乔纳森-艾夫', target : '乔布斯', weight : 1, name: '爱将'},
                {source : '蒂姆-库克', target : '乔布斯', weight : 1},
                {source : '龙-韦恩', target : '乔布斯', weight : 1},
                {source : '克拉拉-乔布斯', target : '保罗-乔布斯', weight : 1},
                {source : '奥巴马', target : '保罗-乔布斯', weight : 1},
                {source : '奥巴马', target : '克拉拉-乔布斯', weight : 1},
                {source : '奥巴马', target : '劳伦-鲍威尔', weight : 1},
                {source : '奥巴马', target : '史蒂夫-沃兹尼艾克', weight : 1},
                {source : '比尔-盖茨', target : '奥巴马', weight : 6},
                {source : '比尔-盖茨', target : '克拉拉-乔布斯', weight : 1},
                {source : '蒂姆-库克', target : '奥巴马', weight : 1}
            ]
      this.categories = [{name:"核心人物"},{name:"家人"},{name:"朋友"}]
    },
    initDisjoinSetData() {
      this.title = this.setName;

      var chartData = this.chartData?this.chartData:JSON.parse(this.chartDataText)
      var pointList = chartData["pointList"]
      var edgeList = chartData["edgeList"]

      if(!pointList || (pointList.length == 0)){
        return
      }

      var maxValuePoint = pointList.reduce((point1, point2)=>(point1['value']||0)>(point2['value']||0)?point1:point2)

      var pointFroms = {}
      edgeList.forEach((edge)=> pointFroms[edge.to]=edge.from)
      edgeList.sort((edge1, edge2)=> (!pointFroms[edge1.from]&&pointFroms[edge2.from])?-1:(pointFroms[edge1.from]&&!pointFroms[edge2.from])?1:edge1.from==maxValuePoint['id']?-1:edge2.from==maxValuePoint['id']?1:0)

      if(this.needDisjoinSet){
          var disjointSet = new DisjointSet((point)=>point.id ? point.id : point);
          pointList.forEach((point)=> disjointSet.makeSet(point))
          edgeList.forEach((edge)=> disjointSet.union(edge.from, edge.to))

          var nodes = []
          var links = []
          var categories = [] 
          for(var i in pointList){
            var point = pointList[i]
            var rootPoint = disjointSet.findSet(point)
            var edge = edgeList.find((edgeI) => edgeI.from == rootPoint['id'] && edgeI.to == point['id'])
            var category = '核心节点-' + (rootPoint?rootPoint["name"]:'')
            if(!(category in categories)){
              categories.push({name: category})
            }
            nodes.push({category:category, name: point['name'],value : i})
            links.push({source : rootPoint['name'], target : point['name'], weight :(edge?edge['weight']:0), name: (edge?'直接连接':'间接连接')})
          }
          this.nodes = nodes;
          this.links = links;
          this.categories = categories;
          this.disjointSet = disjointSet;
      }else{
          var pointsMap = {}
          pointList.forEach((point)=> pointsMap[point.id]=point)

          var nodes = []
          for(var i in pointList){
            var point = pointList[i]
            nodes.push({category:0, name: point['name'],value : i})
          }

          var links = []
          for(var i in edgeList){
            var edge = edgeList[i]
            links.push({source : pointsMap[edge.from]['name'], target : pointsMap[edge.to]['name'], weight : edge.weight, name: '直接连接'})
          }

          this.nodes = nodes;
          this.links = links;
          this.categories = [{name:'图'}];
      }
    },
    initData() {
      if(!this.setName){
        this.initDemoData();
      }else {
        this.initDisjoinSetData();
      }

      this.nodes.forEach(function (node) {
          //node.itemStyle = null;//
          //node.symbolSize = node.size;//强制指定节点的大小   
          // Use random x, y
          node.x = node.y = null;
          node.draggable = true;
      });
    },
    initCharts() {
      const myChart = echarts.init(this.$refs.chart, 'macarons');
      var option = {
            title : {
                text:this.title,
                x:'right',
                y:'bottom'
            },
            tooltip : {
                trigger: 'item',
                formatter: function(params){
                  return params.data.name
                }
            },
            color:['#EE6A50','#4F94CD','#B3EE3A','#DAA520'],
            toolbox: {
                show : true,
                feature : {
                    restore : {show: true},
                    magicType: {show: true, type: ['force', 'chord']},
                    saveAsImage : {show: true}
                }
            },
            legend: {
                x: 'left',
                data: this.categories.map(function (a) {//显示策略
                    return a.name;
                })
            },
            series : [
                {
                    type: 'graph',
                    layout : 'force',
                    name : this.title,
                    ribbonType: false,
                    categories : this.categories,
                    legendHoverLink : true,//是否启用图例 hover(悬停) 时的联动高亮。
                    hoverAnimation : true,//是否开启鼠标悬停节点的显示动画
                    coordinateSystem : null,//坐标系可选
                    xAxisIndex : 0, //x轴坐标 有多种坐标系轴坐标选项
                    yAxisIndex : 0, //y轴坐标 
                    force : { //力引导图基本配置
                        //initLayout: ,//力引导的初始化布局，默认使用xy轴的标点
                        repulsion : 100,//节点之间的斥力因子。支持数组表达斥力范围，值越大斥力越大。
                        gravity : 0.03,//节点受到的向中心的引力因子。该值越大节点越往中心点靠拢。
                        edgeLength :80,//边的两个节点之间的距离，这个距离也会受 repulsion。[10, 50] 。值越小则长度越长
                        layoutAnimation : true
                    //因为力引导布局会在多次迭代后才会稳定，这个参数决定是否显示布局的迭代动画，在浏览器端节点数据较多（>100）的时候不建议关闭，布局过程会造成浏览器假死。                        
                    },
                    roam : true,//是否开启鼠标缩放和平移漫游。默认不开启。如果只想要开启缩放或者平移，可以设置成 'scale' 或者 'move'。设置成 true 为都开启
                    nodeScaleRatio : 0.6,//鼠标漫游缩放时节点的相应缩放比例，当设为0时节点不随着鼠标的缩放而缩放
                    draggable : true,//节点是否可拖拽，只在使用力引导布局的时候有用。
                    focusNodeAdjacency : true,//是否在鼠标移到节点上的时候突出显示节点以及节点的边和邻接节点。
                    symbol:'roundRect',//关系图节点标记的图形。ECharts 提供的标记类型包括 'circle'(圆形), 'rect'（矩形）, 'roundRect'（圆角矩形）, 'triangle'（三角形）, 'diamond'（菱形）, 'pin'（大头针）, 'arrow'（箭头）  也可以通过 'image://url' 设置为图片，其中 url 为图片的链接。'path:// 这种方式可以任意改变颜色并且抗锯齿
                    symbolSize:20 ,//也可以用数组分开表示宽和高，例如 [20, 10] 如果需要每个数据的图形大小不一样，可以设置为如下格式的回调函数：(value: Array|number, params: Object) => number|Array
                    //symbolRotate:,//关系图节点标记的旋转角度。注意在 markLine 中当 symbol 为 'arrow' 时会忽略 symbolRotate 强制设置为切线的角度。
                    //symbolOffset:[0,0],//关系图节点标记相对于原本位置的偏移。[0, '50%']
                    edgeSymbol : [ 'none', 'arrow' ],//边两端的标记类型，可以是一个数组分别指定两端，也可以是单个统一指定。默认不显示标记，常见的可以设置为箭头，如下：edgeSymbol: ['circle', 'arrow']
                    edgeSymbolSize : 10,
                    itemStyle: {
                        normal: {
                            label: {
                                show: true,
                                textStyle: {
                                    color: '#333'
                                }
                            },
                            nodeStyle : {
                                brushType : 'both',
                                borderColor : 'rgba(255,215,0,0.4)',
                                borderWidth : 1
                            },
                            linkStyle: {
                                type: 'curve'
                            }
                        },
                        emphasis: {
                            label: {
                                show: true
                                // textStyle: null      // 默认使用全局文本样式，详见TEXTSTYLE
                            },
                            nodeStyle : {
                                //r: 30
                            },
                            linkStyle : {}
                        }
                    },
                    useWorker: false,
                    minRadius : 15,
                    maxRadius : 25,
                    gravity: 1.1,
                    scaling: 1.1,
                    roam: 'move',
                    nodes: this.nodes,
                    links: this.links
                }
            ]
        };
      myChart.setOption(option, false);
      myChart.on('click', function (params) {
                  var data=params.value
                  //点没有source属性
                  if(data && data.source==undefined){
                      var nodeName=params.name
                      // window.open("http://www.baidu.com")
                  }
      });
      myChart.hideLoading();
   }
  }
};

class DisjointSet {
  constructor(idAccessorFn) {
    this._parent = {};
    this._rank = {};
    this._size = {};
    this._sets = 0;
    this._idAccessorFn = idAccessorFn || this._id;
  }

  _findSet(value) {
    const id = this._idAccessorFn(value);

    if (this._parent[id] !== value) {
      this._parent[id] = this._findSet(this._parent[id]);
    }

    return this._parent[id];
  }

  _id(x) {
    return x;
  }

  get forestElements() {
    return Object.keys(this._parent).length;
  }

  get forestSets() {
    return this._sets;
  }

  areConnected(x, y) {
    if (!this.includes(x) || !this.includes(y)) {
      return false;
    }

    return this._findSet(x) === this._findSet(y);
  }

  clear() {
    this._parent = {};
    this._rank = {};
    this._size = {};
    this._sets = 0;
    return this;
  }

  findSet(value) {
    if (this.includes(value)) {
      return this._findSet(value);
    }

    return undefined;
  }

  getId(value) {
    if (!this.includes(value)) {
      return undefined;
    }

    return this._idAccessorFn(value);
  }

  includes(value) {
    return Object.prototype.hasOwnProperty.call(this._parent, this._idAccessorFn(value));
  }

  isEmpty() {
    return this.forestElements === 0;
  }

  isRepresentative(value) {
    if (!this.includes(value)) {
      return false;
    }

    return this._parent[this._idAccessorFn(value)] === value;
  }

  isSingleton(value) {
    return this._size[this._idAccessorFn(value)] === 1;
  }

  makeSet(value) {
    if (!this.includes(value)) {
      const id = this._idAccessorFn(value);
      this._parent[id] = value;
      this._rank[id] = 0;
      this._size[id] = 1;
      this._sets += 1;
    }

    return this;
  }

  setSize(value) {
    if (!this.includes(value)) {
      return 0;
    }

    return this._size[this._idAccessorFn(this._findSet(value))];
  }

  union(x, y) {
    if (this.includes(x) && this.includes(y)) {
      let xRep = this._findSet(x);
      let yRep = this._findSet(y);

      if (xRep !== yRep) {
        let xRepId = this._idAccessorFn(xRep);
        let yRepId = this._idAccessorFn(yRep);
        const rankDiff = this._rank[xRepId] - this._rank[yRepId];

        if (rankDiff === 0) {
          this._rank[xRepId] += 1;
        } else if (rankDiff < 0) {
          [xRep, yRep] = [yRep, xRep];
          [xRepId, yRepId] = [yRepId, xRepId];
        }

        this._parent[yRepId] = xRep;
        this._size[xRepId] += this._size[yRepId];
        delete this._size[yRepId];
        this._sets -= 1;
      }
    }

    return this;
  }
}
</script>

<style scoped>
#disjointSetDiv {
  padding:20px;
  width:100%;
  height:100%;
}

#main {
  width: 500px;
  height:464px;
}

body {
   margin-top: 3em; background: #eee; color: #555; font-family: "Open Sans", "Segoe UI", Helvetica, Arial, sans-serif;
}

p, p a {
   font-value: 12px;text-align: center; color: #888;
}
</style>