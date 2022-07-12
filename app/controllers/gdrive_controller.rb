class GdriveController < ApplicationController

#  def JWT_token_decode
#    require 'jwt'
#
#    payload = [
#      { 
#        alg: 'RS256',
#        typ: 'JWT',
#        kid: Figaro.env.private_key_id
#      }
#      ,
#      {
#        iss: Figaro.env.client_email
#        sub: Figaro.env.client_email
#        aud: 'https://drive.googleapis.com/'
#        iat: date.to_time.to_i
#        exp: date.to_time.to_i+3600.seconds
#      }
#    ]
#
#    rsa_private = OpenSSL::PKey::RSA.generate 2048
#    rsa_public  = rsa_private.public_key
#
#    token = JWT.encode payload, rsa_private, 'RS256'
#  end

  def initialize_drive
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
    client = Signet::OAuth2::Client.new(client_id: Figaro.env.client_id, client_secret: Figaro.env.google_api_secret, access_token: token, refresh_token: token, token_credential_uri: Figaro.env.token_uri, scope:'drive')

#    if client.expired?
#      new_token = client.refresh?
#      @new_tokens = 
#        {
#          :access_token  => new_token["access_token"],
#          :refresh_token => new_token["refresh_token"]
#        }
#      client.access_token  = @new_tokens[ :access_token ]
#      client.refresh_token = @new_tokens[ :refresh_token ]
#    end
     drive = Google::Apis::DriveV3
     service = Drive::DriveService.new

     driveobj = Google::Apis::DriveV3::Drive.new()
  end
