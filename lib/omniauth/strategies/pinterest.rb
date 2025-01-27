require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Pinterest < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://www.pinterest.com/',
        :authorize_url => 'https://www.pinterest.com/oauth/',
        :token_url => 'https://api.pinterest.com/v5/oauth/token'
      }

      def request_phase
        options[:scope] ||= 'scope=boards:read,pins:read'
        options[:response_type] ||= 'code'
        super
      end

      uid { raw_info['id'] }

      info { raw_info }
      
      def authorize_params
        super.tap do |params|
          %w[redirect_uri].each do |v| 
            params[:redirect_uri] = request.params[v] if request.params[v]
          end 
        end 
      end 

      def raw_info
        fields = 'first_name,id,last_name,url,account_type,username,bio,image'
        @raw_info ||= access_token.get("/v1/me/?fields=#{fields}").parsed['data']
      end

      def ssl?
        true
      end

    end
  end
end
