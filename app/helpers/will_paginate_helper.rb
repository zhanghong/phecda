module WillPaginateHelper
  class WillPaginateAjaxLinkRenderer < BootstrapPagination::Rails
    def prepare(collection, options, template)
      options[:params] ||= {}
      options[:params]["_"] = nil
      @@remote = options[:remote]
      super(collection, options, template)
    end

    protected
    def link(text, target, attributes = {})
      attributes['data-remote'] = @@remote if @@remote
      super
    end
  end

  def ajax_will_paginate(collection, options = {})
    will_paginate(collection, options.merge({:renderer => WillPaginateHelper::WillPaginateAjaxLinkRenderer, :remote => options[:remote]}))
  end
end