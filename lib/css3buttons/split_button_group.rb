module Css3buttons
  class SplitButtonGroup
    include ActionView::Helpers::TagHelper
    attr_reader :template, :button_count, :options

    def initialize(template, options)
      @button_count = 0
      @template = template
      @options = options
      @options[:wrapper_tag] ||= :div
    end

    def render(&block)
      # parse the passed in block's content
      content     = @template.capture(&block)

      # convert the string to an array of links
      links       = content.strip.gsub(/\r*?\n+\t*?\s+/, "::").split("::")

      # extract the first link from the array
      main_action = links.shift 
      
      # wrap the remaining links in an <li> tag
      list  = links.map { |link| content_tag(:li, link, :class => 'split-menu-item') }
      menu  = content_tag(:ul, list.join("\n").html_safe, :class => 'split-menu')
      
      dropdown_link_classes =  "dropdown icon button"
      dropdown_link_classes += " pill" if @options[:pill]
      
      dropdown_link = "<a href='javascript:void(0);' class='" + dropdown_link_classes + "'></a>"
      
      dropdown = content_tag(:li,  dropdown_link.html_safe + menu, :class => 'split dropdown')
      split_btn =  content_tag(:ul, content_tag(:li, main_action, :class => 'split main') + dropdown, :class => 'split-menu-wrap')
      
      html_options = @options.clone
      html_options.delete(:wrapper_tag)
      html_options.delete(:pill)
      html_options[:class] ||= ''
      html_options[:class] = (html_options[:class].split(" ") + ['split-button-group']).join(" ")
      html_options[:class] = (html_options[:class].split(" ") + ['pill-group']).join(" ") if @options[:pill]
      
      content_tag(@options[:wrapper_tag], split_btn, html_options) if block_given?
    end
  end
end

