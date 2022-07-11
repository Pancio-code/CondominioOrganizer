class GdriveController < ApplicationController

  def JWT_token_decode
    require 'jwt'

    payload = [
      { 
        alg: 'RS256',
        typ: 'JWT',
        kid: Figaro.env.private_key_id
      }
      ,
      {
        iss: Figaro.env.client_email
        sub: Figaro.env.client_email
        aud: 'https://drive.googleapis.com/'
        iat: date.to_time.to_i
        exp: date.to_time.to_i+3600.seconds
      }
    ]

    rsa_private = OpenSSL::PKey::RSA.generate 2048
    rsa_public  = rsa_private.public_key

    token = JWT.encode payload, rsa_private, 'RS256'
  end

  def initialize_drive
    token, refresh_token = *JSON.parse(File.read('credentials.data'))
    client = 
  end

end
