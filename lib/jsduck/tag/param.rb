require "jsduck/tag/tag"
require "jsduck/doc/subproperties"
require "jsduck/render/subproperties"
require "jsduck/docs_code_comparer"
require "jsduck/logger"

module JsDuck::Tag
  class Param < Tag
    def initialize
      @pattern = "param"
      @key = :params
      @merge_context = :method_like
      @html_position = POS_PARAM
    end

    # @param {Type} [name=default] (optional) ...
    def parse_doc(p)
      tag = p.standard_tag({:tagname => :params, :type => true, :name => true})
      tag[:optional] = true if parse_optional(p)
      tag[:doc] = :multiline
      tag
    end

    def parse_optional(p)
      p.hw.match(/\(optional\)/i)
    end

    def process_doc(h, tags, pos)
      h[:params] = JsDuck::Doc::Subproperties.nest(tags, pos)
    end

    def merge(h, docs, code)
      h[:params] = merge_params(docs, code, h[:files].first)
    end

    def format(m, formatter)
      m[:params].each {|p| formatter.format_subproperty(p) }
    end

    def to_html(m)
      JsDuck::Render::Subproperties.render_params(m[:params]) if m[:params].length > 0
    end

    private

    def merge_params(docs, code, file)
      explicit = docs[:params] || []
      implicit = JsDuck::DocsCodeComparer.matches?(docs, code) ? (code[:params] || []) : []
      ex_len = explicit.length
      im_len = implicit.length

      # Warn when less parameters documented than found from code.
      if ex_len < im_len && ex_len > 0
        JsDuck::Logger.warn(:param_count, "Detected #{im_len} params, but only #{ex_len} documented.", file[:filename], file[:linenr])
      end

      # Override implicit parameters with explicit ones
      # But if explicit ones exist, don't append the implicit ones.
      params = []
      (ex_len > 0 ? ex_len : im_len).times do |i|
        im = implicit[i] || {}
        ex = explicit[i] || {}
        params << {
          :type => ex[:type] || im[:type] || "Object",
          :name => ex[:name] || im[:name] || "",
          :doc => ex[:doc] || im[:doc] || "",
          :optional => ex[:optional] || false,
          :default => ex[:default],
          :properties => ex[:properties] || [],
        }
      end
      params
    end

  end
end
