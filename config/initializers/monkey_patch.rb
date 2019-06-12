module NyulibrariesTemplates
  module LoginHelper
    # Login link and icon
    def login(params={})
      return unless defined?(current_user)
      current_user ? link_to_logout(params) : link_to_login(params)
    end

    # Link to logout
    def link_to_logout(params={})
      return unless defined?(logout_url)
      icon_tag(:logout) + link_to("Log-out #{username}".strip, logout_url(params), class: "logout", method: :post)
    end

    # Link to login
    def link_to_login(params={})
      return unless defined?(login_url)
      icon_tag(:login) + link_to("Login", login_url(params), class: "login", method: :post)
    end

    def username
      return unless defined?(current_user)
      if current_user.respond_to?(:firstname) && current_user.firstname.present?
        current_user.firstname
      elsif current_user.respond_to?(:username)
        current_user.username
      end
    end
  end
end