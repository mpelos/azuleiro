class ShowFor::BootstrapBuilder < ShowFor::Builder
  def wrap_with(type, content, options)
    tag = options.delete(:"#{type}_tag") || ShowFor.send(:"#{type}_tag")

    if tag
      html_options = options.delete(:"#{type}_html") || {}
      html_options[:class] = "#{html_options[:class]}".strip
      @template.content_tag(tag, content, html_options)
    else
      content
    end
  end
end
