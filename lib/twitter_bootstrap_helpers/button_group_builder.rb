# encoding: utf-8

include ::ActionView::Helpers::TagHelper

module TwitterBootstrap

  class ButtonGroupBuilder
    def initialize(id,view_context)
      @id = id
      @view_context = view_context
      @buttons = ""
    end

    def build(block)
      block.call(self)
      @view_context.content_tag(:div, @buttons.html_safe, class: 'btn-group',id: @id);
    end

    def button(label, options = {})
      button_class = ['btn']

      button_class << options[:class] if options[:class]
      button_class << 'active' if options[:active]

      button_class = button_class.join(' ')

      data = {toggle: 'button'}
      data[:target] = "##{options[:target]}" if options[:target]

      @buttons << @view_context.content_tag(:button, label, class: button_class, data: data)

      ""
    end

    def dropdown_button(item_title,dropdown_menu)
      title = (item_title << ' ' << content_tag(:span, nil, class: 'caret')).html_safe
      link  = content_tag(:a, title, :href => '#', :class => 'btn btn-mini dropdown-toggle', 'data-toggle' => 'dropdown')

      @buttons << (link << dropdown_menu) 
    end
  end

  class ButtonGroupWithTabsBuilder < ButtonGroupBuilder
    def initialize(view_context)
      super(:radio, view_context)
      @tabs = ""
    end

    def build(block)
      block.call(self)

      buttons = @view_context.content_tag(:div, @buttons.html_safe, class: 'btn-group', data: {toggle: 'buttons-radio'})
      tabs = @view_context.content_tag(:div, @tabs.html_safe, class: 'tab-content')

      @view_context.content_tag(:div, buttons << tabs, class: 'tabbable')
    end

    def button(label, target, options = {}, &block)
      super(label, options.merge!(target: target))

      tab_class = ['tab-pane']
      tab_class << 'active' if options[:active]

      tab_class = tab_class.join(' ')

      @tabs << @view_context.content_tag(:div, @view_context.capture(&block), id: target, class: tab_class)

      ""
    end
  end

end
