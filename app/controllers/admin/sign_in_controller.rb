class Admin::SignInController < ApplicationController
  with_themed_layout '1_column'
  def show
    render template: "admin/sign_in"
  end
end

