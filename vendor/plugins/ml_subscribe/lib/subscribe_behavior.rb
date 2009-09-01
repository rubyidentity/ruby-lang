require 'behavior'
require 'mailing_list_mailer'

class SubscribeBehavior < Behavior::Base

  register 'Subscribe'
  
  define_tags do
  
    tag "subscribe" do |tag|
      tag.expand
    end
  
    tag "subscribe:form" do |tag|
      a = tag.attr.dup
      list = a.delete('list')
      attrs = attributes(a, 'action' => tag.globals.page.url, 'method' => 'post')
      %{<form#{attrs}>#{tag.expand}</form>}
    end
    
    tag "subscribe:form:first_name_input" do |tag|
      attrs = attributes(tag.attr, 'name' => 'first_name', 'value' => first_name)
      %{<input#{attrs} />}
    end
    
    tag "subscribe:form:last_name_input" do |tag|
      attrs = attributes(tag.attr, 'name' => 'last_name', 'value' => last_name)
      %{<input#{attrs} />}
    end
    
    tag "subscribe:form:email_input" do |tag|
      attrs = attributes(tag.attr, 'name' => 'email', 'value' => email)
      %{<input#{attrs} />}
    end
    
    tag "subscribe:form:action_select" do |tag|
      attrs = attributes(tag.attr, 'name' => 'action')
      options = ['Subscribe', 'Unsubscribe'].map do |opt|
        selected = %{ selected="true"} if opt.downcase == action
        %{<option value="#{opt.downcase}"#{selected}>#{opt}</option>}
      end
      %{<select#{attrs}>#{options.join}</select>}
    end
    
    tag "subscribe:form:list_select" do |tag|
      attrs = attributes(tag.attr, 'name' => 'list')
      lists = List.find_all
      options = lists.map do |list|
        name = list.name
        selected = %{ selected="true"} if name.downcase == list_name.downcase
        %{<option value="#{name.downcase}"#{selected}>#{name}</option>}
      end
      %{<select#{attrs}>#{options.join}</select>}
    end
    
    tag "subscribe:if_error" do |tag|
      tag.expand if error?
    end
    
    tag "subscribe:unless_error" do |tag|
      tag.expand unless error?
    end
    
    tag "subscribe:error_message" do |tag|
      error_message
    end
    
    tag "subscribe:if_success" do |tag|
      tag.expand if success
    end
    
    tag "subscribe:unless_success" do |tag|
      tag.expand unless success
    end
    
    tag "subscribe:if_success:list_name" do |tag|
      list_name
    end    
  end

  def render_page
    if request.post?
      @list       = List.lookup(params[:list] || 'ruby-talk')
      @first_name = get_param(:first_name)     
      @last_name  = get_param(:last_name)
      @email      = get_param(:email)
      @action     = get_param(:action).downcase
      if @action =~ /^(subscribe|unsubscribe)$/
        if @list
          unless @first_name.blank? or @last_name.blank?
            if @email =~ /^[^@;\s]+@[^@;\s]+\.[^@;\s]+$/
              case action
              when "subscribe"
                MailingListMailer.deliver_subscribe_message(@first_name, @last_name, @email, @list)
              when "unsubscribe"
                MailingListMailer.deliver_unsubscribe_message(@email, @list)
              end
              @success = true
            else
              @error_message = 'Invalid e-mail address.'
            end
          else
            @error_message = 'Please enter a first name and last name.'
          end
        else
          @error_message = 'Invalid list.'
        end
      else
        @error_message = 'Invalid action.'
      end
    else
      @success = false
    end
    super
  end

  def cache_page?
    false
  end

  class List
    attr_accessor :name, :post_address, :ctl_address
    
    def initialize(name, post_address = nil, ctl_address = nil)
      @name = name
      @post_address = post_address || "#{name.downcase}@ruby-lang.org"
      @ctl_address = ctl_address || "#{name.downcase}-ctl@ruby-lang.org"
    end
    
    def self.find_all
      ['Ruby-Talk', 'Ruby-Core', 'Ruby-Doc', 'Ruby-CVS'].map { |name| new(name) }
    end
    
    def self.lookup(name)
      lists = find_all.inject({}) { |h, l| h[l.name.downcase] = l; h }
      lists[name.to_s.strip.downcase]
    end
  end

  private
    
    def params
      @params ||= request.params.inject({}) { |h,(k,v)| h[k.to_s.intern] = v.first; h }
    end
    
    def get_param(param)
      (params[param] || '').strip   
    end
    
    def attributes(tag_attrs, defaults)
      defaults.dup.update(tag_attrs).map { |k,v| %{ #{k}="#{v}"} }.join
    end
    
    def first_name
      @first_name || ''
    end
    
    def last_name
      @last_name || ''
    end
    
    def email
      @email || ''
    end
    
    def action
      @action || ''
    end
    
    def list_name
      if @list
        @list.name
      else
        ''
      end
    end
    
    def success
      @success
    end
    
    def error?
      !!@error_message
    end
    
    def error_message
      (@error_message || '').strip
    end
end