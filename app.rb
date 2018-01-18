require 'sinatra'
require 'rubygems'
require 'sinatra/reloader' #이걸 사용하면 서버를 자동으로 껐다 켜준다. gem install sinatra-contrib를 설치해야 한다.
require 'data_mapper' # metagem, requires common plugins too.

# vagrant에서 실행시 ruby app.rb -o 0.0.0.0 에서 뒷 부분을 추가하지 않아도 되도록 써준다.
set :bind, '0.0.0.0'


# need install dm-sqlite-adapter
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

# 데이터 테이블 제목과 내용을 저장하는 데이터 테이블
# 데이터 테이블을 생성할때마다 이름.auto_upgrade! 해주기!!!!!
class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, Text
  property :created_at, DateTime
end

class User
  include DataMapper::Resource
  property :id, Serial
  property :email, String
  property :password, String
  property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
# 밑에 있는 것을 해주어야 정상적으로 사용이 가능하다.
DataMapper.finalize

# automatically create the post table
Post.auto_upgrade!
User.auto_upgrade!


get '/' do
  @posts = Post.all.reverse
  erb :index
end

get '/abap' do
  Post.create(
      :title => params["title"],
      :body => params["content"]
  )

  # 다 하고 난다면 루트페이지 (/)로 돌아간다.
  redirect to '/'
end

get '/sign_up' do
  erb :sign_up
end

get '/register' do
  User.create(
      :email => params["email"],
      :password => params["password"]
  )

  redirect to '/'
end

get '/admin' do
  # 모든 유저를 불러와
  # admin.erb에서 모든 유저를 보여준다.
  @user = User.all
  erb :admin
end
