	// sidenav
	$(function(){
		var e = e || window.event
		$('.sidenavBtn').click(function(e){
			e.preventDefault()
			$('.sidenav').toggleClass('open')
			$(this).toggleClass('open')
		})
		$(window).resize(function(){
			if(parseInt($("#currentMedia").css("max-width"), 10) <= 1200 && parseInt($("#currentMedia").css("min-width"), 10) >= 768) {
				$('.sidenav .list-group').each(function(){
					var clone = $(this).clone()
					var a = $(this).prev('.list-group-item')
					$(this).remove()
					a.append(clone)
				})	
			}else {
				$('.sidenav .list-group-item > .list-group').each(function(){
					var clone = $(this).clone()
					var a = $(this).parent('.list-group-item')
					$(this).remove()
					a.after(clone)
				})	
			}
			if(parseInt($("#currentMedia").css("min-width"), 10) > 992) {
				$('.sidenav .list-group-item > span').show()
			} 
		})
		$('.sidenav').on('mouseenter','.list-group-item', function(e) { //拉开或关闭二级菜单
			var $this = $(this);
			$this.siblings('.list-group-item').removeClass('link');
			for(var i=0; i<$this.siblings('.list-group').length; i++){
				var item = $this.siblings('.list-group').eq(i);
				if(item.html() == $this.next('.list-group').html()) {
					item.addClass('open');
					item.prev().children('i:last-child').toggleClass('up');
				}else{
					item.removeClass('open');
					item.prev().children('i:last-child').removeClass('up');
				}
			}
			if(!$this.hasClass('link')) {
				// $this.parent('.sidenav').find('.list-group-item.link').removeClass('link');
				$this.toggleClass('link');
			}
		});

		// 点击页面其他地方的时候关闭二级菜单
		document.onclick = function (e) {
			var event = e || window.event;
			var ele = event.srcElement || event.target;
			if($(ele).parents('.sidenav').length < 1){//鼠标点击的范围不在指定范围内
				$('.sidenav').find('.list-group-item.link').removeClass('link');
				$('.sidenav').find('i.up').removeClass('up');
				$('.sidenav').find('.list-group.open').removeClass('open');
			}
		}
	})
	// sidenav end