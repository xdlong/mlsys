function get_products_data(obj,source){
  obj.each(function(i,input_elm){
    var par_td = input_elm.parentNode;
    if($(input_elm).hasClass('tt-input')){
      par_td = par_td.parentNode;
      $(input_elm).removeClass('tt-input');
    }
    var oldop = $(par_td).find('.twitter-typeahead')[0]
    if(oldop){
      par_td.replaceChild(input_elm,oldop);
    };
  });
  var states = new Bloodhound({
    //指定查询字段
    limit: source.length,
    datumTokenizer: function(d) {
      console.log(d.ii)
      var test = Bloodhound.tokenizers.whitespace(d.ii);
      var arr = ['name', 'desc', 'qty', 'unit'], str = '';
      for(var i=0; i<arr.length; i++){
        str = d[arr[i]];
        if(!str)str = '';
        test.push(str.trim())
      }
      if(!!d.ii.trim()){
        i = 0;
        while( i < d.ii.length ){
          test.push(d.ii.substr(i, d.ii.length));
          i++;
        }
      }
      if(!!d.name.trim()){
        i = 0;
        while( i < d.name.length ){
          test.push(d.name.substr(i, d.name.length));
          i++;
        }
      }
      return test;
    },
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    local: $.map(source, function(state) { return state; })
  });
  states.initialize();
  obj.typeahead({
    hint: true,
    highlight: true,
    minLength: 0,
  },
  {
    name: 'states',
    displayKey: function(d){
      var input = this.$el.parents('td').find('.tt-input');
      // 处理数据重复
      var trs = $('.data-edit-table tbody tr'),
          tr = input.parents('tr');
      for(var i=0; i<trs.length; i++) {
        if(i==tr.index())continue;
        if(trs.eq(i).find('.product-ii.tt-input').val() == d.ii){
          return '';
        }
      }
      return d.ii;
    },
    valueKey: 'ii',
    source: states.ttAdapter(),
    // 显示模板
    templates: {
      empty: '<a>未找到</a>',
      suggestion: Handlebars.compile('<div class="row" style="width: 100%;"><div class="col-sm-6 col-md-6 col-lg-6">{{ii}}</div><div class="col-sm-6 col-md-6 col-lg-6">现有{{qty}}</div></div>')
    }
  }).on('typeahead:selected', function(e, data) {
    selected_product($(this), data);
  });
  //注册一个比较大小的Helper,判断v1是否大于v2
  Handlebars.registerHelper("compare",function(v1,v2,options){
    if(v1>v2){
      //满足添加继续执行
      return options.fn(this);
    }else{
      //不满足条件执行{{else}}部分
      return options.inverse(this);
    }
  });
}

function selected_product(obj, data){
  var trs = $('.data-edit-table tbody tr');
  var tr = obj.parents('tr');
  for(var i=0; i<trs.length; i++) {
    if(i==tr.index())continue;
    if(trs.eq(i).find('.product-ii.tt-input').val() == data.ii){
      tr.find('.product-ii.tt-input').blur();
      tr.find('.product-ii.tt-input').focus();
      return '';
    }
  }
  tr.find('.product-ii.tt-input').val(data.ii);
  tr.find('.product-name-td').html('<h5>'+data.name+'</h5>');
  tr.find('.product-qty').focus();
  tr.find('.product-unit-td').html('<h5>'+data.unit+'</h5>');
  tr.find('.product-inventory-td').html('<h5>'+data.qty+'</h5>');
  tr.find('.product-desc-td').html('<h5>'+data.desc+'</h5>');
}

function add_line(obj){
  var line_tr = obj.find('tr:last')[0].outerHTML;
  obj.append(line_tr);
  obj = obj.find('tr:last');
  obj.find('input').each(function(k) {
    $(this).removeAttr('value');
  });
  obj.find('.product-ii-td').html('<input class="form-control product-ii" name="erp_reg[products][0][ii][extension]" type="text" placeholder="产品型号" data-provide="typeahead">');
  obj.find('.product-name-td').html('<input class="form-control product-name" name="erp_reg[products][0][name]" type="text" placeholder="产品名称">');
  obj.find('.product-qty-td').html('<input class="form-control product-qty" name="erp_reg[products][0][quantity][value]" type="number" placeholder="数量" style="text-align:center">');
  obj.find('.product-unit-td').html('<input class="form-control product-unit" name="erp_reg[products][0][quantity][unit]" type="text" placeholder="单位" style="text-align:left">');
  obj.find('.product-inventory-td').html('<h5>无</h5>');
  obj.find('.product-desc-td').html('<input class="form-control product-desc" name="erp_reg[products][0][desc]" type="text" placeholder="产品描述">');
  get_products_data(obj.find('.product-ii'),JSON.parse(localStorage.getItem('erp_products_data')));
  setTimeout(function() {
    $('.data-edit-table').find('tbody tr:last input.product-ii').focus();
  }, 200 );
}

function refresh_trs(obj){
  console.log(obj);
  obj.find('tr').each(function(i,v){
    console.log(v);
    $(v).find('input').each(function(k,input){
      var name = input.getAttribute('name');
      if(!!name){
        name = name.replace(/\[\d*?\]/,'['+i+']')
        console.log(name);
        input.setAttribute('name',name);
      }
    });
  });
}

var Tab;
document.onkeydown = function (e) {
  var element = document.activeElement;
  e=window.event||e;
  if(event.keyCode==9)
    Tab = true;
  if( window.event.shiftKey && event.keyCode==9)  
    Tab = false;
  if(e.keyCode==117){//F6保存
    $('[accesskey="s"]').click();
  }
  if(e.keyCode==120){//F9新建，添加行
    $('[accesskey="a"]').click();
  }
  if(e.keyCode==121){//F10删除行
    if($('.data-edit-table tbody tr').length==1){
      add_line($('.data-edit-table').find('tbody'))
    }
    $(element).parents('tr').remove();
    setTimeout(function() {
      $('.data-edit-table').find('tbody tr:last input.product-ii.tt-input').focus();
    }, 200 );
    refresh_trs();
  }
  if(e.keyCode==119){//F8打印
    $('[accesskey="p"]').click();
  }
}
