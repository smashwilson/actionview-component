# frozen_string_literal: true

module ActionView
  module Component
    module TestHelpers
      def render_inline(component, **args, &block)
        Nokogiri::HTML.fragment(controller.view_context.render(component, args, &block))
      end

      def controller
        @controller ||= Base.test_controller.constantize.new.tap { |c| c.request = request }.extend(Rails.application.routes.url_helpers)
      end

      def request
        @request ||= ActionDispatch::TestRequest.create
      end

      def render_component(component, **args, &block)
        ActiveSupport::Deprecation.warn(
          "`render_component` has been deprecated in favor of `render_inline`, and will be removed in v2.0.0."
        )

        render_inline(component, args, &block)
      end

      def with_variant(variant)
        old_variants = controller.view_context.lookup_context.variants

        controller.view_context.lookup_context.variants = variant
        yield
        controller.view_context.lookup_context.variants = old_variants
      end
    end
  end
end
