require 'helper'

class TestTwitterBootstrapHelpers < ActionDispatch::IntegrationTest # MiniTest::Unit::TestCase
  include TwitterBootstrap::Helpers

  # include ActionView::Context
  attr_accessor :output_buffer

  def test_generate_divider
    assert_equal "<li class=\"divider\" />", generate_menu_item(:divider)
  end

  def test_generate_menu_item
    assert_equal "<li class=\"active\"><a href=\"#\">Menu</a></li>", generate_menu_item(:link => '#', :title=>'Menu', :active=>true)
  end

  def test_generate_menu_items
    result = generate_menu_items [
      { :link=>'#', :title=>'title' },
      { :link=>'#', :title=>'title2', :active=>true, :items => [
        { :link=>'#', :title=>'title2' },
        :divider
        ]
    }
    ]

    assert_equal "<ul class=\"nav\"><li><a href=\"#\">title</a></li><li class=\"active dropdown\"><a href=\"#\" class=\"dropdown-toggle\">title2</a><ul class=\"dropdown-menu\"><li><a href=\"#\">title2</a></li><li class=\"divider\" /></ul></li></ul>", result
  end

  def test_generate_menu_items_from_hash
    assert_equal "<ul class=\"nav\"><li><a href=\"#\">t</a></li><li><a href=\"#\">t2</a></li></ul>", 
      generate_menu_items( :key1 => { :link=>'#', :title=>'t' }, :key2 => { :link=>'#', :title=>'t2' } )
  end
end
