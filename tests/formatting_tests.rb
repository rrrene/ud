#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-

class FakeHTMLElement

  attr_reader :text

  def initialize(txt='')
    @text = txt
  end
end

class UD_Formatting_test < Test::Unit::TestCase

  # == UD#text == #

  def test_text_empty
    el = FakeHTMLElement.new
    assert_equal('', UD.text(el))
  end

  def test_text_trailing_spaces
    el = FakeHTMLElement.new('foo    ')
    assert_equal('foo', UD.text(el))

    el = FakeHTMLElement.new(" bar \n")
    assert_equal('bar', UD.text(el))
  end

  def test_text_newline
    el = FakeHTMLElement.new("a\rb")
    assert_equal("a\nb", UD.text(el))

    el = FakeHTMLElement.new("a\nb")
    assert_equal("a\nb", UD.text(el))
  end

  def test_text_invalid_element
    assert_equal('', UD.text(nil))
    assert_equal('', UD.text(true))
    assert_equal('', UD.text('foo'))
  end

  # == UD#format_results == #

  def test_format_results_empty_list
    assert_equal('', UD.format_results([]))
  end

  def test_format_results_one_element_no_color
    res = {
      :word => 'XYZ',
      :upvotes => 42,
      :downvotes => 78,
      :definition => 'xyz',
      :example => 'zyx'
    }

    output = UD.format_results([res], false).strip
    expected = <<EOS
* XYZ (42/78):

    xyz

 Example:
    zyx
EOS

    assert_equal(expected.strip, output)
  end

  def test_format_results_one_element_color
    green = "\e[32m"
    bold  = "\e[1m"
    red   = "\e[31m"
    reset = "\e[0m"
    res = {
      :word => 'XYZ',
      :upvotes => 42,
      :downvotes => 78,
      :definition => 'xyz',
      :example => 'zyx'
    }

    output = UD.format_results([res], true).strip
    expected = <<EOS
* #{bold}XYZ#{reset} (#{green}42#{reset}/#{red}78#{reset}):

    xyz

 Example:
    zyx
EOS

    assert_equal(expected.strip, output)
  end

  # == UD::Formatting#fit == #

  def test_fit_0_width
    assert_equal([], UD::Formatting.fit('foo', 0))
  end

  def test_fit_negative_width
    assert_equal([], UD::Formatting.fit('foo', -1))
  end

  def test_fit_right_width
    assert_equal(['foo'], UD::Formatting.fit('foo', 3))
  end

  def test_fit_larger_width
    assert_equal(['foo'], UD::Formatting.fit('foo', 4))
  end

  def test_fit_smaller_width
    assert_equal(['a', 'b'], UD::Formatting.fit('a b', 2))
  end

  # == UD::Formatting#tab == #

  def test_tab_0_width
    assert_equal('foo', UD::Formatting.tab('foo', 0))
  end

  def test_tab_negative_width
    assert_equal('foo', UD::Formatting.tab('foo', -1))
  end

  def test_tab_2_width
    assert_equal('  foo', UD::Formatting.tab('foo', 2))
  end

  def test_tab_array
    assert_equal([' a', ' b'], UD::Formatting.tab(['a', 'b'], 1))
  end

end
