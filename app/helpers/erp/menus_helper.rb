module Erp::MenusHelper
  def render_menu org,menus,tally
    return '' unless menus.present?
    ret = "<ul class='list-group list-group-item erp_menu_#{tally.join('_')} hidden'>"
    menus.each_with_index do |item,i|
      if menu = item.classification
        ret <<
        "<li class='list-group-item'><div class='row'>
          <div class='col-xs-1 col-sm-1 col-md-1 col-lg-1 text_left'>#{tally.join('.')}.#{i}</div>
          <div class='col-xs-2 col-sm-2 col-md-2 col-lg-2 text_left'>#{menu.title} </div>
          <div class='col-xs-2 col-sm-2 col-md-2 col-lg-2 text_left'>#{menu.code.code} </div>
          <div class='col-xs-3 col-sm-3 col-md-3 col-lg-3 text_left'>#{menu.text} </div>
          <div class='col-xs-2 col-sm-2 col-md-2 col-lg-2 text_left'>#{menu.updated_at.strftime("%Y-%2m-%2d %H:%M:%S")}</div>
          <div style='text-align:center'>
            <span class='pull-right'>
              <a type='button' class='btn btn-default btn-xs' href='/erp/orgs/#{org.id}/menus/#{menu.id}/edit'>
                <i class='glyphicon glyphicon-edit'></i>
              </a>
              <a type='button' class='btn btn-default btn-xs' href='/erp/orgs/#{org.id}/menus/#{menu.id}'>
                <i class='glyphicon glyphicon-info-sign'></i>
              </a>
              #{ menu.component.present? ? "<button class='erp_sub_menu_key btn btn-default btn-xs' id='erp_menu_#{tally.join('_')}_#{i}'><span class='badge'>子目录：#{menu.component.size}</span></button>" : "<a type='button' class='btn btn-default btn-xs' href='/erp/orgs/#{@organization.id}/menus/#{menu.id}/products'><i class='glyphicon glyphicon-list-alt'></i></a>"}
              <a type='button' class='btn btn-default btn-xs' href='/erp/orgs/#{@organization.id}/menus/new?pre_menu_id=#{menu.id}'>
                <i class='glyphicon glyphicon-plus'></i>
              </a>
            </span>
          </div>
        </div></li>
        #{render_menu(org,menu.component,tally+[i])}"
      end
    end
    ret << "</ul>"
    ret
  end
end
