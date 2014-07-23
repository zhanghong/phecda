$ = jQuery  
  
zTreeNodes = null;  
zTreeObj = null;  
  
#浏览器报错cannot resolve symbol 'msie' 解决方法  
jQuery.browser = {}  
$ ->  
  jQuery.browser.msie = false  
  jQuery.browser.version = 0  
  if(navigator.userAgent.match(/MSIE ([0-9]+)\./))  
    jQuery.browser.msie = true  
    jQuery.browser.version = RegExp.$1  
  
#ztree设置  
setting = {  
  async: {  
    enable:true,     #异步加载可用  
    dataType: "json",     #接收json数据  
    type: "get",          #使用get请求  
    url: "/core/seller_areas/area_nodes.json",   #请求url
    otherParam: ["seller_id", $("#seller_id").html()]
    autoParam: ["id"]            #异步加载是请求的参数  
  },  
  check: {
    enable: true,
    chkboxType: { "Y" : "ps", "N" : "ps" },
    chkStyle: "checkbox"
  },  
  data: {  
    simpleData: {  
      enable: true,  
      idKey: "id",  
      pIdKey: "parent_id",  
      rootKey: null 
    }  
  },  
  view: {
    dbClickExpand: true,       #双击展开不可用
    showLine: true             #显示下划线
  },
  callback: {  
    onAsyncSuccess: zTreeOnAsyncSuccess,         #请求成功后的回调函数
    onCheck: zTreeOnCheck                       #捕获checkbox被勾选 或 取消勾选的事件回调函数
  }  
}  
  
zTreeOnAsyncSuccess = (event, treeId, treeNode, data) ->
  zTreeNodes = data

zTreeOnCheck = (event, treeId, treeNode) ->
  $.ajax({
    type: "post",
    url: "/core/seller_aeras/node_click",
    async: true,
    dataType: script
  })

zTreeObj = $.fn.zTree.init($("#treeDemo"), setting, zTreeNodes);