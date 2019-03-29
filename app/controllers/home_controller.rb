class HomeController < ApplicationController
    include AuthHelper

    def index
      # 承認リンクの表示
      @login_url = get_login_url
    end
end
