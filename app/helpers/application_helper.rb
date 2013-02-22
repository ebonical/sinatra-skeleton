module ApplicationHelper
  def partial(template, *args)
    options = args.extract_options!
    options.merge!(layout: false)
    # Iterate over collection if provided
    if collection = options.delete(:collection)
      as = options.delete(:as) || File.basename(template)
      collection.inject([]) do |mem, obj|
        mem << partial(template, options.merge(locals: { as.to_sym => obj }))
      end.join("\n")
    else
      if template =~ /\//
        parts = template.split('/')
        file = '_' + parts.pop
        template = File.join(parts, file)
      else
        template = "_#{template}"
      end
      haml template.to_sym, options
    end
  end
end
