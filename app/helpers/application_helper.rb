# frozen_string_literal: true

module ApplicationHelper
  def current_namespace
    section = request.path.split("/").second
    section == "support" ? "support_interface" : "find_interface"
  end

  def custom_title(page_title)
    [page_title, service_name].compact.join(" - ")
  end

  def custom_header
    govuk_header(
      homepage_url: t("govuk.url"),
      service_name: t("service.name"),
      service_url: t("service.url")
    ) do |header|
      case try(:current_namespace)
      when "support_interface"
        header.navigation_item(
          active: current_page?(support_interface_features_path),
          href: support_interface_features_path,
          text: "Features"
        )
        header.navigation_item(
          active: false,
          href: support_interface_sidekiq_web_path,
          text: "Sidekiq"
        )
      end
    end
  end
end
