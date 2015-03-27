module Erp::MenusHelper
  def render_menu org,menus,tally
    ret = ''
    (menus||[]).each_with_index do |item,i|
      if menu = item.classification
        ret << 
        "<tr class='hidden erp_menu_#{tally.join('_')}'>
          <td class='text_left'>#{tally.join('.')}.#{i}</td>
          <td class='text_left'>#{menu.title} </td>
          <td class='text_left'>#{menu.code.code} </td>
          <td class='text_left'>#{menu.text} </td>
          <td class='text_left'>#{menu.updated_at.strftime("%Y-%2m-%2d %H:%M:%S")}</td>
          <td style='text-align:center'>
            <span class='pull-right'>
              <a href='/erp/orgs/#{org.id}/menus/#{menu.id}/edit'>
                <i class='glyphicon glyphicon-edit'></i>
              </a>
              <a href='/erp/orgs/#{org.id}/menus/#{menu.id}'>
                <i class='glyphicon glyphicon-info-sign'></i>
              </a>
              #{ menu.component.present? ? "<span class='erp_sub_menu_key' id='erp_menu_#{tally.join('_')}_#{i}'><span class='badge'>子目录：#{menu.component.size}</span></span>" : "<a href='/erp/orgs/#{@organization.id}/menus/#{menu.id}/products'>
                <i class='glyphicon glyphicon-list-alt'></i>"}
              <a href='/erp/orgs/#{@organization.id}/menus/new?pre_menu_id=#{menu.id}'>
                <i class='glyphicon glyphicon-plus'></i>
              </a>
            </span>
          </td>
        </tr>
        #{render_menu(org,menu.component,tally+[i])}"
      end
    end
    ret
  end
end
