//启动select2, 
//参数 obj: 对象如input , 
//参数 data: json数组,有id和name
function start_select2(obj,data){
  $(obj).removeClass('form-control').css('width','100%').select2({
    allowClear: true,
    data:{
      results: data,
      //定义查询字段
      text: function(item){
        return item.id + item.name;
      };
    },
    //返回内容
    formatSelection: function(item){
      return item.name;
    },
    //下拉列表显示内容
    formatResult: function(item){
      return item.name;
    };
  });
};
//打印指定元素
//参数 elem: 指定要打印的对象
function print_element(elem){
  var body = document.body.innerHTML;
  document.body.innerHTML = elem.innerHTML;
  window.print();
  location.reload();
  // document.body.innerHTML = body;
};