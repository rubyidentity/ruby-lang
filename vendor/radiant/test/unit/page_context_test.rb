require File.dirname(__FILE__) + '/../test_helper'

class PageContextTest < Test::Unit::TestCase
  fixtures :pages, :page_parts, :layouts, :snippets, :users
  
  def setup
    setup_for_page(:radius)
  end
    
  def test_initialize
    assert_equal(@page, @context.page)
  end
  
  def test_tag_page
    assert_parse_output 'Radius Test Page', "<r:title />"
    assert_parse_output 'Ruby Home Page | Radius Test Page', %{<r:find url="/"><r:title /> | <r:page:title /></r:find>}
  end
  
  def test_tags_page_attributes
    @page.attributes.keys.each do |attr|
      value = @page.send(attr)
      unless [:created_by, :updated_by].include? attr.to_s.intern
        assert_parse_output value.to_s, "<r:#{attr} />"
      end
    end
  end
  
  def test_tag_children
    expected = 'Radius Test Child 1 Radius Test Child 2 Radius Test Child 3 '
    input = '<r:children:each><r:title /> </r:children:each>'
    assert_parse_output expected, input
  end
  def test_tag_children_each
    assert_parse_output 'radius/child-1 radius/child-2 radius/child-3 ' , '<r:children:each><r:page><r:slug />/<r:child:slug /> </r:page></r:children:each>'
  end
  def test_tag_children_each_attributes
    setup_for_page(:assorted)
    assert_parse_output 'a b c d e f g h i j ', page_children_each_tags
    assert_parse_output 'a b c d e ',           page_children_each_tags(%{limit="5"})
    assert_parse_output 'd e f g h ',           page_children_each_tags(%{offset="3" limit="5"})
    assert_parse_output 'j i h g f e d c b a ', page_children_each_tags(%{order="desc"})
    assert_parse_output 'f e d c b a j i h g ', page_children_each_tags(%{by="breadcrumb"})
    assert_parse_output 'g h i j a b c d e f ', page_children_each_tags(%{by="breadcrumb" order="desc"})
  end
  def test_tag_children_each_with_status_attribute
    setup_for_page(:assorted)
    assert_parse_output_match /^(draft |)a b c d e f g h i j( draft|) $/, page_children_each_tags(%{status="all"})
    assert_parse_output 'draft ', page_children_each_tags(%{status="draft"})
    assert_parse_output 'a b c d e f g h i j ', page_children_each_tags(%{status="published"})
    assert_parse_output_match "`status' attribute of `each' tag must be set to a valid status", page_children_each_tags(%{status="askdf"})
  end
  def test_tag_children_each_attributes_with_invalid_limit
    message = "`limit' attribute of `each' tag must be a positive number between 1 and 4 digits"
    assert_parse_output_match message, page_children_each_tags(%{limit="a"})
    assert_parse_output_match message, page_children_each_tags(%{limit="-10"})
    assert_parse_output_match message, page_children_each_tags(%{limit="50000"})
  end
  def test_tag_children_each_attributes_with_invalid_offset
    message = "`offset' attribute of `each' tag must be a positive number between 1 and 4 digits"
    assert_parse_output_match message, page_children_each_tags(%{offset="a"})
    assert_parse_output_match message, page_children_each_tags(%{offset="-10"})
    assert_parse_output_match message, page_children_each_tags(%{offset="50000"})
  end
  def test_tag_children_each_attributes_with_invalid_by_field_name
    message = "`by' attribute of `each' tag must be set to a valid field name"
    assert_parse_output_match message, page_children_each_tags(%{by="non-existant-field"})
  end
  def test_tag_children_each_attributes_with_invalid_limit
    message = %{`order' attribute of `each' tag must be set to either "asc" or "desc"}
    assert_parse_output_match message, page_children_each_tags(%{order="asdf"})
  end
  def test_tag_children_each_does_not_list_virtual_pages
    setup_for_page(:archive)
    assert_parse_output 'article article-2 article-3 article-4 article-5 ', '<r:children:each><r:slug /> </r:children:each>'
    assert_parse_output_match /^(draft |)article article-2 article-3 article-4 article-5( draft|) $/, '<r:children:each status="all"><r:slug /> </r:children:each>'
  end
  
  def test_tag_children_each_header
    setup_for_page(:archive)
    assert_parse_output '[May/00] article [Jun/00] article-2 article-3 [Aug/00] article-4 [Aug/01] article-5 ', '<r:children:each><r:header>[<r:date format="%b/%y" />] </r:header><r:slug /> </r:children:each>'
  end
  def test_tag_children_each_header_with_name_attribute
    setup_for_page(:archive)
    assert_parse_output '[2000] (May) article (Jun) article-2 article-3 (Aug) article-4 [2001] article-5 ', %{<r:children:each><r:header name="year">[<r:date format='%Y' />] </r:header><r:header name="month">(<r:date format="%b" />) </r:header><r:slug /> </r:children:each>}  
  end
  def test_tag_children_each_header_with_restart_attribute
    setup_for_page(:archive)
    assert_parse_output(
      '[2000] (May) article (Jun) article-2 article-3 (Aug) article-4 [2001] (Aug) article-5 ',
      %{<r:children:each><r:header name="year" restart="month">[<r:date format='%Y' />] </r:header><r:header name="month">(<r:date format="%b" />) </r:header><r:slug /> </r:children:each>}
    )
    assert_parse_output(
      '[2000] (May) <01> article (Jun) <09> article-2 <10> article-3 (Aug) <06> article-4 [2001] (Aug) <06> article-5 ',
      %{<r:children:each><r:header name="year" restart="month;day">[<r:date format='%Y' />] </r:header><r:header name="month" restart="day">(<r:date format="%b" />) </r:header><r:header name="day"><<r:date format='%d' />> </r:header><r:slug /> </r:children:each>}
    )
  end
  
  def test_tag_children_count
    assert_parse_output '3', '<r:children:count />'
  end
  
  def test_tag_children_first
    assert_parse_output 'Radius Test Child 1', '<r:children:first:title />'
  end
  def test_tag_children_first_is_nil
    setup_for_page(:textile)
    assert_parse_output '', '<r:children:first:title />'
  end
  
  def test_tag_children_last
    assert_parse_output 'Radius Test Child 3', '<r:children:last:title />'
  end
  def test_tag_children_last_nil
    setup_for_page(:textile)
    assert_parse_output '', '<r:children:last:title />'
  end
  
  def test_tag_content
    expected = "<h1>Radius Test Page</h1>\n\n\n\t<ul>\n\t<li>Radius Test Child 1</li>\n\t\t<li>Radius Test Child 2</li>\n\t\t<li>Radius Test Child 3</li>\n\t</ul>"
    assert_parse_output expected, '<r:content />'
  end
  def test_tag_content_with_part_attribute
    assert_parse_output "Just a test.\n", '<r:content part="extended" />'
  end
  def test_tag_content_with_inherit_attribute
    assert_parse_output '', '<r:content part="sidebar" />'
    assert_parse_output '', '<r:content part="sidebar" inherit="false" />'
    assert_parse_output 'Radius Test Page sidebar.', '<r:content part="sidebar" inherit="true" />'
    assert_parse_output_match %{`inherit' attribute of `content' tag must be set to either "true" or "false"}, '<r:content part="sidebar" inherit="weird value" />'

    assert_parse_output '', '<r:content part="part_that_doesnt_exist" inherit="true" />'
  end
  def test_tag_content_with_inherit_and_contextual_attributes
    assert_parse_output 'Radius Test Page sidebar.', '<r:content part="sidebar" inherit="true" contextual="true" />'
    assert_parse_output 'Ruby Home Page sidebar.', '<r:content part="sidebar" inherit="true" contextual="false" />'
    
    setup_for_page(:inheritance_test_page_grandchild)
    assert_parse_output 'Inheritance Test Page Grandchild inherited body.', '<r:content part="body" inherit="true" contextual="true" />'
  end
  
  def test_tag_child_content
    expected = "Radius test child 1 body.\nRadius test child 2 body.\nRadius test child 3 body.\n"
    assert_parse_output expected, '<r:children:each><r:content /></r:children:each>'
  end
  
  def test_tag_if_content_without_body_attribute
    assert_parse_output 'true', '<r:if_content>true</r:if_content>'
  end
  def test_tag_if_content_with_body_attribute
    assert_parse_output 'true', '<r:if_content part="body">true</r:if_content>'
  end
  def test_tag_if_content_with_nonexistant_body_attribute
    assert_parse_output '', '<r:if_content part="asdf">true</r:if_content>'
  end
  
  def test_tag_unless_content_without_body_attribute
    assert_parse_output '', '<r:unless_content>false</r:unless_content>'
  end
  def test_tag_unless_content_with_body_attribute
    assert_parse_output '', '<r:unless_content part="body">false</r:unless_content>'
  end
  def test_tag_unless_content_with_nonexistant_body_attribute
    assert_parse_output 'false', '<r:unless_content part="asdf">false</r:unless_content>'
  end
  
  def test_tag_author
    assert_parse_output 'Admin User', '<r:author />'
  end
  def test_tag_author_nil
    setup_for_page(:textile)
    assert_parse_output '', '<r:author />'
  end
  
  def test_tag_date
    assert_parse_output 'Monday, January 30, 2006', '<r:date />'
  end
  def test_tag_date_with_format_attribute
    assert_parse_output '30 Jan 2006', '<r:date format="%d %b %Y" />'
  end
  
  def test_tag_link
    assert_parse_output '<a href="/radius/">Radius Test Page</a>', '<r:link />'
  end
  def test_tag_link__attributes
    expected = '<a href="/radius/" class="test" id="radius">Radius Test Page</a>'
    assert_parse_output expected, '<r:link class="test" id="radius" />'
  end
  def test_tag_link__block_form
    assert_parse_output '<a href="/radius/">Test</a>', '<r:link>Test</r:link>'
  end
  def test_tag_link__anchor
    assert_parse_output '<a href="/radius/#test">Test</a>', '<r:link anchor="test">Test</r:link>'
  end
  def test_tag_child_link
    expected = "<a href=\"/radius/child-1/\">Radius Test Child 1</a> <a href=\"/radius/child-2/\">Radius Test Child 2</a> <a href=\"/radius/child-3/\">Radius Test Child 3</a> "
    assert_parse_output expected, '<r:children:each><r:link /> </r:children:each>' 
  end
  
  def test_tag_snippet
    assert_parse_output 'test', '<r:snippet name="first" />'
  end
  def test_tag_snippet_not_found
    assert_parse_output_match 'snippet not found', '<r:snippet name="non-existant" />'
  end
  def test_tag_snippet_without_name
    assert_parse_output_match "`snippet' tag must contain `name' attribute", '<r:snippet />'
  end
  def test_tag_snippet_with_markdown
    assert_parse_output '<p><strong>markdown</strong></p>', '<r:page><r:snippet name="markdown" /></r:page>'
  end

  def test_tag_random
    assert_parse_output_match /^(1|2|3)$/, "<r:random> <r:option>1</r:option> <r:option>2</r:option> <r:option>3</r:option> </r:random>"
  end
  
  def test_tag_comment
    assert_parse_output 'just a test', 'just a <r:comment>small </r:comment>test'
  end
  
  def test_tag_navigation_1
    tags = %{<r:navigation urls="Home: Boy: /; Archives: /archive/; Radius: /radius/; Docs: /documentation/">
               <r:normal><a href="<r:url />"><r:title /></a></r:normal>
               <r:here><strong><r:title /></strong></r:here>
               <r:selected><strong><a href="<r:url />"><r:title /></a></strong></r:selected>
               <r:between> | </r:between>
             </r:navigation>}
    expected = %{<strong><a href="/">Home: Boy</a></strong> | <a href="/archive/">Archives</a> | <strong>Radius</strong> | <a href="/documentation/">Docs</a>}
    assert_parse_output expected, tags
  end
  def test_tag_navigation_2
    tags = %{<r:navigation urls="Home: /; Archives: /archive/; Radius: /radius/; Docs: /documentation/">
               <r:normal><r:title /></r:normal>
             </r:navigation>}
    expected = %{Home Archives Radius Docs}
    assert_parse_output expected, tags
  end
  def test_tag_navigation_3
    tags = %{<r:navigation urls="Home: /; Archives: /archive/; Radius: /radius/; Docs: /documentation/">
               <r:normal><r:title /></r:normal>
               <r:selected><strong><r:title/></strong></r:selected>
             </r:navigation>}
    expected = %{<strong>Home</strong> Archives <strong>Radius</strong> Docs}
    assert_parse_output expected, tags
  end
  def test_tag_navigation_without_urls
    assert_parse_output '', %{<r:navigation></r:navigation>}
  end
  def test_tag_navigation_without_urls
    assert_parse_output_match  "`navigation' tag must include a `normal' tag", %{<r:navigation urls="something:here"></r:navigation>}
  end
  def test_tag_navigation_with_urls_without_slashes
    tags = %{<r:navigation urls="Home: ; Archives: /archive; Radius: /radius; Docs: /documentation">
               <r:normal><r:title /></r:normal>
               <r:here><strong><r:title /></strong></r:here>
             </r:navigation>}
    expected = %{Home Archives <strong>Radius</strong> Docs}
    assert_parse_output expected, tags
  end
  
  def test_tag_find
    assert_parse_output 'Ruby Home Page', %{<r:find url="/"><r:title /></r:find>}
  end
  def test_tag_find_without_url
    assert_parse_output_match "`find' tag must contain `url' attribute", %{<r:find />}
  end
  def test_tag_find_with_nonexistant_url
    assert_parse_output '', %{<r:find url="/asdfsdf/"><r:title /></r:find>}
  end
  
  def test_tag_find_and_children
    assert_parse_output 'a-great-day-for-ruby another-great-day-for-ruby ', %{<r:find url="/news/"><r:children:each><r:slug /> </r:children:each></r:find>}
  end
  
  def test_tag_escape_html
    assert_parse_output '&lt;strong&gt;a bold move&lt;/strong&gt;', '<r:escape_html><strong>a bold move</strong></r:escape_html>'
  end
  
  def test_tag_rfc1123_date
    @page.published_at = Time.utc(2004, 5, 2)
    assert_parse_output 'Sun, 02 May 2004 00:00:00 GMT', '<r:rfc1123_date />'
  end
  
  def test_tag_breadcrumbs
    setup_for_page(:deep_nested_child_for_breadcrumbs)
    assert_parse_output '<a href="/">Home</a> &gt; <a href="/radius/">Radius Test Page</a> &gt; <a href="/radius/child-1/">Radius Test Child 1</a> &gt; Deeply nested child',
      '<r:breadcrumbs />'
  end
  
  def test_tag_breadcrumbs_with_separator_attribute
    setup_for_page(:deep_nested_child_for_breadcrumbs)
    assert_parse_output '<a href="/">Home</a> :: <a href="/radius/">Radius Test Page</a> :: <a href="/radius/child-1/">Radius Test Child 1</a> :: Deeply nested child',
      '<r:breadcrumbs separator=" :: " />'
  end
  
  def test_tag_if_url_does_not_match
    assert_parse_output '', '<r:if_url matches="fancypants">true</r:if_url>'
  end
 
  def test_tag_if_url_matches
     assert_parse_output 'true', '<r:if_url matches="r.dius/$">true</r:if_url>'
  end
   
  def test_tag_if_url_without_ignore_case
    assert_parse_output 'true', '<r:if_url matches="rAdius/$">true</r:if_url>'
  end
  
  def test_tag_if_url_with_ignore_case_true
    assert_parse_output 'true', '<r:if_url matches="rAdius/$" ignore_case="true">true</r:if_url>'
  end
 
  def test_tag_if_url_with_ignore_case_false
    assert_parse_output '', '<r:if_url matches="rAdius/$" ignore_case="false">true</r:if_url>'
  end
  
  def test_tag_if_url_with_malformatted_regexp
    assert_parse_output_match "Malformed regular expression in `matches' argument of `if_url' tag:", '<r:if_url matches="r(dius/$">true</r:if_url>'
  end
  
  def test_tag_if_url_empty
    assert_parse_output_match "`if_url' tag must contain a `matches' attribute", '<r:if_url>test</r:if_url>'
  end
  
  def test_tag_unless_url_does_not_match
    assert_parse_output 'true', '<r:unless_url matches="fancypants">true</r:unless_url>'
  end
  
  def test_tag_unless_url_matches
    assert_parse_output '', '<r:unless_url matches="r.dius/$">true</r:unless_url>'
  end
  
  def test_tag_unless_url_without_ignore_case
    assert_parse_output '', '<r:unless_url matches="rAdius/$">true</r:unless_url>'
  end
  
  def test_tag_unless_url_with_ignore_case_true
    assert_parse_output '', '<r:unless_url matches="rAdius/$" ignore_case="true">true</r:unless_url>'
  end
  
  def test_tag_unless_url_with_ignore_case_false
    assert_parse_output 'true', '<r:unless_url matches="rAdius/$" ignore_case="false">true</r:unless_url>'
  end
  
  def test_tag_unless_url_with_malformatted_regexp
    assert_parse_output_match "Malformed regular expression in `matches' argument of `unless_url' tag:", '<r:unless_url matches="r(dius/$">true</r:unless_url>'
  end
  
  def test_tag_unless_url_empty
    assert_parse_output_match "`unless_url' tag must contain a `matches' attribute", '<r:unless_url>test</r:unless_url>'
  end

  def test_tag_missing
    assert_parse_output_match "undefined tag `missing'", '<r:missing />'
  end
    
  protected
    
    def setup_for_page(page)
      @page = pages(page)
      @context = PageContext.new(@page)
      @parser = Radius::Parser.new(@context, :tag_prefix => 'r')
    end
    
    def page_children_each_tags(attr = nil)
      attr = ' ' + attr unless attr.nil?
      "<r:children:each#{attr}><r:slug /> </r:children:each>"
    end
    
    def assert_parse_output(expected, input)
      output = @parser.parse(input)
      assert_equal expected, output
    end
    
    def assert_parse_output_match(regexp, input)
      output = @parser.parse(input)
      assert_match regexp, output
    end
end
