class Organization::UsersController < ApplicationController
  include OrganizationHelper

  before_action :find_org
  before_action :find_user, only: :destroy

  def create
    @user = User.where(github_handle: params[:user][:github_handle]).first

    puts @user.inspect

    if @user
      @org.users << @user
      redirect_via_turbolinks_to organization_path(@org)
    else
      @user = User.new(github_handle: params[:user][:github_handle])
      @user.errors.add(:github_handle, I18n.t('user.not_exist_in_system'))
    end
  end

  def destroy
    @org.users.delete(@user)

    redirect_to organization_path(@org)
  end

  private

  def find_user
    @user = @org.users.where(id: params[:id]).first

    unless @user
      redirect_to root_path, notice: I18n.t('messages.not_foud')
    end
  end

end