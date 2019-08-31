require 'sinatra'
require 'sinatra/reloader'
require 'redis'
require 'json'

redis = Redis.new(url: 'redis://localhost:6379')

get '/teste' do
  'Oi!'
end

post '/usuarios' do
  usuario = JSON.parse(request.body.read)

  halt(401, { message:'Nome nao pode estar em branco'}.to_json) if nome.nil?
  halt(401, { message:'CPF nao pode esta em branco'}.to_json) if cpf.nil?
  halt(401, { message:'Email nao pode estar em branco'}.to_json) if email.nil?
  halt(401, { message:'Nascimento nao pode estar em branco'}.to_json) if nascimento.nil? 

  id = redis.incr('id_usuarios')
  user['id'] = id
  headers 'Location' = "/usuarios/#{usuario['id']}"
  
  redis.hset('usuarios', id, JSON.dump(usuario))
end 

get '/usuarios/:id' do
  content_type :json

  id = params['id']
  resposta = redis.hget('usuarios', id)
  halt(404, '{"mensagem": "usuario não encontrado"}') if resposta.nil?
  resposta
end

get '/usuarios/:id/idade' do
  content_type :json

  id = params['id']
  usuario_redis = redis.hget('usuarios', id)
  halt(404, '{"mensagem": "usuario não encontrado"}') if usuario_redis.nil?
  usuario = JSON.parse(usuario_redis)
  
  '{"idade": '+ AgeCalculator.calculate(usuario['nascimento']) + '}'
end

delete '/usuarios/:id' do
  id = params['id']
  redis.hdel('usuarios', id)
  204
end

put '/usuarios/:id' do
  content_type :json
 
  usuario = JSON.parse(request.body.read)
 
  id = params['id']
  nome = usuario.fetch('nome', nil)
  cpf = usuario.fetch('cpf', nil)
  email = usuario.fetch('email', nil)
  nascimento = usuario.fetch('nascimento', nil)
 
  halt(401, { message:'Nome nao pode estar em branco'}.to_json) if nome.nil?
  halt(401, { message:'CPF nao pode esta em branco'}.to_json) if cpf.nil?
  halt(401, { message:'Email nao pode estar em branco'}.to_json) if email.nil?
  halt(401, { message:'Nascimento nao pode estar em branco'}.to_json) if nascimento.nil?
 
   redis.hset('usuarios', id, JSON.dump(usuario))
  204
 end
 