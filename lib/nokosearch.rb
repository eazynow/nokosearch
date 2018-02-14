require 'nokosearch/version'

module Nokosearch
  # Searcher is the main class that can be used to search html
  class Searcher
    # html = File.read('.path_to/some_file.html')
    # h = Nokogiri::HTML(html)

    # TODO: put an init on the class in that passes in the html and
    # parses it rather than having it on every method

    # find the text string in the html document
    def find_text(h, text)
      h.search "[text()*='#{text}']"
    end

    # convert a nokogiri element into a simple hash
    def simple_tag(t, keys = %w[id class name])
      h = t.to_h
      h = h.keep_if { |k, _| keys.include?(k) }
      h['text'] = t.text
      h
    end

    # wrapper to map an array of nokogiri elements ea
    # into simple hashes
    def simplify_elements(ea)
      ea.elements.map { |e| simple_tag(e) }
    end

    # checks if the class in nokogiri elemente
    # is either unqiue as a whole string or as
    # individual classes
    def unique_class?(h, e)
      # first try "whole text" combination
      return true if unique_attr?(h, 'class', e)
      classes = e.value.split
      classes.each do |c|
        # is this a unique class?
        return true if h.css(".#{c}").one?
      end
      false
    end

    # checks if the id passes in really is unique in the html document
    def unique_id?(h, id)
      h.at_css("[id='#{id}']").one?
    end

    # checks is attribute matching value v is unique in the html document
    def unique_attr?(h, a, v)
      v = v.value if v.instance_of? Nokogiri::XML::Attr
      h.search("[#{a}='#{v}']").one?
    end
  end
end
