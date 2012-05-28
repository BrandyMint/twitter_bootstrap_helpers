# encoding: utf-8

module BootstrapHelper

  def icon name, opts={}, &block
    icon_args = {}
    span_args = {}

    icon_args[:class] = ["icon-#{name}", opts[:class]].compact * ' '

    if opts[:tooltip]
      span_args[:rel] = :tooltip
      span_args[:title] = opts[:tooltip]
    end

    if block_given?
      content_tag :span, span_args do
        content_tag( :i, '', icon_args ) << content_tag( :span, block.call, :class=>'icon-text' )
      end
    else
      content_tag :i, '', icon_args.merge(span_args)
    end
  end

  def white_icon name, opts={}, &block
    opts[:class] = [opts[:class], 'icon-white'].compact * ' '
    icon name, opts, &block
  end

  def gray_icon name, opts={}, &block
    opts[:class] = [opts[:class], 'icon-gray'].compact * ' '
    icon name, opts, &block
  end

  # Call it for form object
  #
  def error_notification(form)
    if form.error_notification
      show_alert :error, :close=>true do
        form.error_notification
      end
    end
  end


  #Примеры использования

  # = alert do
  # Мама мыла раму

  # = alert :info do
  # Съешь ещё этих мягких французских булок

  # Возможные типы
  # error
  # info
  # success

  # = alert :info, :close=>true, :block=>true do
  # Да выпей чаю

  # = alert :close=>true, :block=>true do
  # Можно и так, без типа

  def show_alert type_or_options=nil, options={}, &block
    alert_classes = ['alert']

    if type_or_options.is_a?(Hash)
      options = type_or_options
    elsif type_or_options.present?
      alert_classes << "alert-#{type_or_options}"
    end

    alert_classes << "alert-block" if options[:block]
    alert_classes << options[:class] if options[:class]

    content = ''
    content << link_to('×', '#', :class=>:close, :'data-dismiss'=>'alert').html_safe if options[:close]
    content << capture(&block).html_safe

    content_tag :div, content.html_safe, :class => alert_classes.join(' ')
  end

  def show_flashes
    flashes=''
    flash.each do |type,content|
      flashes << show_alert(type, :close=>true) do
        content
      end
    end
    flashes.html_safe
  end

  def breadcrumbs items
    divider = ''
    content_tag :ul, :class=>'breadcrumb' do
      items.map do |i|
        content_tag :li, i[:url] ? link_to( i[:title], i[:url] ) : i[:title], :class=>(:active if i[:active])
      end.join("<li class='divider'>#{divider}</li>").html_safe
    end.html_safe
  end

  def nav_tabs opts={}, &block
    @tabs = TwitterBootstrap::TabsGenerator.new self, opts
    @tabs.generate block
  end

  # Public: Создает группу объединенных кнопок.
  #
  # type - тип кпопок (:radio, :checkbox)
  #
  # Examples:
  #   = button_group(:radio) do |g|
  #     = g.button('Home')
  #     = g.button('Posts')
  #
  def button_group(id,&block)
    builder = TwitterBootstrap::ButtonGroupBuilder.new(id,self)
    builder.build(block)
  end

  # Public: Создает группу кнопок и связанные с ними вкладки.
  #
  # Examples
  #
  #   = button_group_with_tabs do |g|
  #     = g.button('Home','home', active: true) do
  #       %h3 Home
  #       ...
  #     = g.button('Posts', 'posts') do
  #       %h3 Posts
  #       ....
  #
  def button_group_with_tabs(&block)
    builder = TwitterBootstrap::ButtonGroupWithTabsBuilder.new(self)
    builder.build(block)
  end

end
