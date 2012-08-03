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
  
  # Вывод кнопки с иконкой, можно и без иконки
  def button(text, url = nil, options = {})
    # ОПЦИИ
    # :color        цвет кнопки, может быть пустым, 
    #               :red, :blue, :green, :yellow, :black, либо согласно bootstrap (напр. :primary)
    #
    # :icon         имя иконки, символ или строка. если nil - иконки нет.
    #               список здесь: http://twitter.github.com/bootstrap/base-css.html#icons
    #
    # :icon_color   в идеале - не используется, цвет иконки выбирается автоматически, если :color задан корректно. 
    #               если нет, заменяет цвет иконки. может быть :white.
    #
    # другие параметры передаются напрямую хелперу link_to, можно использовать их        
    # 
    # ПРИМЕР
    # button 'Обновить', items_path, color: :blue, icon: :refresh, remote: true
    #
    # !!!ВАЖНО!!!
    # не вставлять в text пользовательский текст, он может содержать вредоносный код, вызывается html_safe
    button_class = case options[:color]
      when nil     then 'btn'
      when :red    then 'btn btn-danger'
      when :blue   then 'btn btn-primary'
      when :green  then 'btn btn-success'
      when :yellow then 'btn btn-warning'
      when :black  then 'btn btn-inverse'
      else              'btn btn-'+options[:color].to_s
    end
    if options[:icon]
      icon = '<i class="icon'+('-white' if options[:icon_color].to_s == "white" || [:red, :blue, :green, :black].include?(options[:color])).to_s+' icon-'+options[:icon].to_s+'"> </i> '
      text = icon+text
    end
    options.delete_if{|k,v|[:color, :icon, :icon_color].include?(k)}
    options[:class] = button_class
    # если кто-то сильно против тега A и хочет BUTTON - можно сделать, но будет адский костыль.
    link_to text.html_safe, url, options 
  end

end
