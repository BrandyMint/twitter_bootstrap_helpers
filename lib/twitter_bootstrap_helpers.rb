module TwitterBootstrap
  module Helpers

    include ::ActionView::Helpers::UrlHelper
    include ::ActionView::Helpers::TagHelper
    attr_accessor :output_buffer

  #
  # generate_menu_item :divider
  #
  #   <li class='divider' />
  #
  #
  # generate_menu_item :link => '#',
  #                    :title => 'Menu item',
  #                    :active => true,
  #                    :items => [
  #                      {
  #                        *some_options*
  #                      }
  #
  #
  def generate_menu_item(item)

    return tag :li, :class => 'divider-vertical' if item == :divider

    html_options = {}

    li_class = item[:li_class] ? [item[:li_class]] : []
    li_class << :active if item[:active]
    li_class << :dropdown if item[:items]

    link_options = {}

    link_options[:class] = item[:link_class] ? [item[:link_class]] : []

    if item[:items]
      link_options[:class] << 'dropdown-toggle'
      link_options[:data] = { :toggle => :dropdown } 
    end

    li_class = li_class.blank? ? nil : { :class => li_class.join(' ') }

    content_tag :li, li_class, false do
      inner = link_to item[:title], item[:link], link_options

      inner << generate_menu_items( item[:items], 'dropdown-menu' ) if item[:items]
      inner
    end
  end


  #  generate_menu_items [
  #                       {
  #                         :link => '#',
  #                         :title => 'Menu item'
  #                       }
  #                      ]
  #
  def generate_menu_items(items, ul_class=:nav)
    return '' unless items
    content_tag(:ul, :class => ul_class) do
      items = items.values if items.is_a? Hash
      items.map { |i| generate_menu_item(i) }.join.html_safe
    end
  end

  end
end

module TwitterBootstrapHelpers

end

require 'twitter_bootstrap_helpers/engine'
require 'twitter_bootstrap_helpers/tabs_generator'
require 'twitter_bootstrap_helpers/button_group_builder'
