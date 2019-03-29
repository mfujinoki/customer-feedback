class FeedbacksController < ApplicationController
    include AuthHelper
   
    APP_ID = '117' # kintoenのアプリケーションID
  
    def new # 初期ページロード状態では何もしない
    end
    
    def create
      @feedback = Feedback.new(feedback_params)
      if @feedback.save
        token = get_access_token
  
        if token
          # トークンがすでに取得されている場合、データをkintoneへポスト
          
          # ハッシュ形式でレコードを設定
          # 
          record = {
            "app" => APP_ID,
            "record" => {
              "Received_via" => {
                "value" => feedback_params[:received_via]
              },
              "Category" => {
                "value" => feedback_params[:category]
              },
              "Tenant_name" => {
                "value" => feedback_params[:tenant_name]
              },
              "Opinion" => {
                "value" => feedback_params[:opinion]
              }
            }
          }
          
          response = token.post('https://devxorudc.cybozu.com/k/v1/record.json', {:body => record.to_json, :headers => {'Authorization' => 'Bearer #{token.token}', 'Content-Type' => 'application/json'}})
          
          redirect_to feedbacks_url
        else
          # トークンが存在しない場合、ホームページへ戻理、承認のやり直し
          # 
          redirect_to root_url
        end
      else
        render 'new'
      end
    end
      
    private
      def feedback_params　# フォームからデータを取得
        params.require(:feedback).permit(:received_via, :category, :tenant_name, :opinion)
      end
  end
  