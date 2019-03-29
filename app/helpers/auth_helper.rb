module AuthHelper
    # kintone側のOAuth設定のクライアントID
    CLIENT_ID = 'l.1.6yj9tvyxuue0iclewfa3gp3thug4zjrm'
    # kintone側のOAuth設定のクライアントシークレット
    CLIENT_SECRET = 'em9pph5rzj91duv42v0ry4kkkcothzm4vjd487ykfkxwlaafuwl3e5eiodwsq2dk'
    # kintoneのURL
    SITE = 'https://devxorudc.cybozu.com'
    # 認可エンドポイント
    AUTHORIZE_URL = '/oauth2/authorization'
    # トークンエンドポイント
    TOKEN_URL = '/oauth2/token'
  
    # APIアクセスのスコープ設定 read/write権限
    SCOPES = [ 'k:app_record:read','k:app_record:write' ]
  
    # CSRF対策のランダムな値
    STATE = 'state1'
  
    # ログインURLの生成
    def get_login_url
      client = OAuth2::Client.new(CLIENT_ID,
                                  CLIENT_SECRET,
                                  :site => SITE,
                                  :authorize_url => AUTHORIZE_URL,
                                  :token_url => TOKEN_URL)
  
      login_url = client.auth_code.authorize_url( :redirect_uri => authorize_url, # Railsの認可ページへのルートパス
                                                  :scope => SCOPES.join(' '), 
                                                  :state => STATE)
    end
  
    # トークン取得のためのコードを送信
    def get_token_from_code(auth_code)
      client = OAuth2::Client.new(CLIENT_ID,
                                  CLIENT_SECRET,
                                  :site => SITE,
                                  :authorize_url => AUTHORIZE_URL,
                                  :token_url => TOKEN_URL)
                                  
      token = client.auth_code.get_token(auth_code,
                                          :redirect_uri => authorize_url,
                                          :scope => SCOPES.join(' '))
    end
  
    # アクセストークンの取得
    def get_access_token
      # セッションから現在のトークンハッシュを取得
      token_hash = session[:kintone_token]
  
      client = OAuth2::Client.new(CLIENT_ID,
                                  CLIENT_SECRET,
                                  :site => SITE,
                                  :authorize_url => AUTHORIZE_URL,
                                  :token_url => TOKEN_URL)
  
      token = OAuth2::AccessToken.from_hash(client, token_hash)
  
      # トークンが期限切れの場合、トークンをリフレッシュ
      if token.expired?
        new_token = token.refresh!
        # 新トークンをセッションへ保存
        session[:kintone_token] = new_token.to_hash
        access_token = new_token
      else
        access_token = token
      end
    end
  end
  