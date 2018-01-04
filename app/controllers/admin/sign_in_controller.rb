class Admin::SignInController < ApplicationController
  def show
    render template: "admin/sign_in"
  end
end

