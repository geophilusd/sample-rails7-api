# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe '#create' do
    let(:params) do
      password = Faker::Lorem.word
      {
        user: {
          email: Faker::Internet.email,
          password: password,
          password_confirmation: password
        }
      }
    end

    let(:admin_user) do
      User.create(email: Faker::Internet.email, password: 'test1234', password_confirmation: 'test1234', role: 'admin')
    end

    context 'when invalid credentials' do
      it 'should throw unauthorized with invalid user' do
        request.headers['Authorization'] = "Basic #{Base64.encode64("#{Faker::Internet.email}:test1234")}"
        post :create, params: params
        expect(response.status).to eq(401)
      end

      it 'should throw unauthorized with wrong password' do
        request.headers['Authorization'] = "Basic #{Base64.encode64("#{admin_user.email}:aaaaa")}"
        post :create, params: params
        expect(response.status).to eq(401)
      end

      it 'should throw forbidden with normal user' do
        admin_user.update(role: 'user')
        request.headers['Authorization'] = "Basic #{Base64.encode64("#{admin_user.email}:#{admin_user.password}")}"
        post :create, params: params
        expect(response.status).to eq(403)
      end
    end

    context 'when invalid params' do
      before do
        request.headers['Authorization'] = "Basic #{Base64.encode64("#{admin_user.email}:#{admin_user.password}")}"
      end

      it 'should throw bad request when email is not in the right format' do
        params[:user][:email] = Faker::Lorem.word
        post :create, params: params
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['errors']['email'][0]).to eq('is invalid')
      end

      it 'should throw bad request when password doesnt match' do
        params[:user][:password_confirmation] = Faker::Lorem.word
        post :create, params: params
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['errors']['password_confirmation'][0]).to eq('doesn\'t match Password')
      end
    end

    context 'when valid params' do
      before do
        request.headers['Authorization'] = "Basic #{Base64.encode64("#{admin_user.email}:#{admin_user.password}")}"
      end

      it 'should create user with user role' do
        post :create, params: params
        expect(response.status).to eq(201)
        user = User.find_by(email: params[:user][:email])
        expect(user).not_to be_nil
        expect(user.role).to eq('user')
      end
    end
  end
end
