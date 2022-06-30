# frozen_string_literal: true

class ArticlesController < ApplicationController

  before_action :load_article, only: [:show, :update, :destroy]

  def index
    @articles = Article.all
    render json: { articles: @articles }, status: :ok
  end

  def show
    render json: { article: @article }, status: :ok
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    if @article.save
      render json: { article: @article }, status: :created
    else
      render json: { errors: @article.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      render json: { article: @article }, status: :ok
    else
      render json: { errors: @article.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    head :no_content
  end

  private

  def article_params
    params.require(:article).permit(:subject, :description)
  end

  def load_article
    @article = Article.find_by(id: params[:id])
    head :not_found and return unless @article
  end

end
