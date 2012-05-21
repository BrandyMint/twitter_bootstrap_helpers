class TwitterBootstrap::TabsGenerator
  #unloadable
  #include ::ActionView::Helpers::UrlHelper
  #include ::ActionView::Helpers::TagHelper

  attr_accessor :panes, :active_pane, :context, :options

  def initialize _context, opts={}
    self.context = _context
    self.panes = {}
    self.options = opts
  end

  def active_pane
    options[:active]
  end

  def active_pane= pane
    options[:active] = pane
  end

  def generate block
    buffer = context.content_tag :ul, :class=>'nav nav-tabs' do
      block.call(self)
    end
    buffer << generate_tab_content
    buffer

    #buffer = ''

    #if options[:position] == :belowe
      #raise 'not ready'
      #buffer << context.content_tag( :div,
                                    #(generate_tab_content + generate_tab_navs).html_safe,
                                    #:class => 'tabbable tabs-below')
    #else
      #context.content_tag :ul, :class=>'nav nav-tabs' do
        #buffer << block.call(self)
      #end
      #buffer << generate_tab_content
    #end
    #buffer.html_safe
  end

  def pane id, title=nil, content_or_options=nil, options={}, &content_block
    pane = {}
    if block_given?
      pane[:content] = content_block
      options = content_or_options || {}
    else
      pane[:content] = content_or_options
    end

    pane[:link] = options[:link] if options.has_key?(:link)
    pane[:tooltip] = options[:tooltip]
    pane[:class] = ['tab-pane', options[:pane_class]].compact
    pane[:title] = title ||= id
    pane[:data] = options[:data]

    if active_pane == id or options[:active]
      self.active_pane = id
      pane[:class] << :active
      pane[:nav_class] ||= []
      pane[:nav_class] << :active
    end

    self.panes[id] = pane

    generate_nav_tab id, pane
  end

  private

  def generate_tab_navs
    context.content_tag :ul, :class=>'nav nav-tabs' do
      buffer = ''
      self.panes.each_pair do |id, pane|
        buffer << generate_nav_tab(id, pane)
      end
      buffer.html_safe
    end
  end

  def generate_nav_tab id, pane
    attrs = {}
    attrs[:class] = pane[:nav_class] * ' ' if pane.has_key? :nav_class
    context.content_tag :li, attrs do
      pane_attr = {:data => pane[:data] || {}}
      if pane[:tooltip]
        pane_attr[:title] = pane[:tooltip]
        pane_attr[:rel] = :tooltip
      end

      if pane.has_key?(:link)
        context.link_to pane[:title], pane[:link], pane_attr
      else
        pane_attr[:data][:toggle] = :tab
        context.link_to pane[:title], "##{id}", pane_attr
      end
    end
  end

  def generate_tab_content
    context.content_tag :div, :class=>'tab-content' do
      buffer = ''
      self.panes.each_pair do |id, pane|
        buffer << generate_pane_content(id, pane)
      end
      buffer.html_safe
    end
  end

  def generate_pane_content id, pane
    if pane[:content].is_a? Proc
      context.content_tag( :div, :class=>pane[:class], :id=>id, &pane[:content] ).html_safe
    else
      context.content_tag( :div, pane[:content], :class=>pane[:class], :id=>id ).html_safe
    end
  end
end

