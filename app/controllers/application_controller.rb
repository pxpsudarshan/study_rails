class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_response_headers, except: [ ]
  helper_method :occupation_list
  before_action :authenticate_users
  before_action :force_tablet_html
#  has_mobile_fu
  before_action do
    RecordWithOperator.operator = current_user || User.first
  end

  def authenticate_users
    if controller_path.split('/').first.to_s == 'kaisha'
      authenticate_comp!
    else
      authenticate_user!
    end
  end

  def force_tablet_html
      session[:tablet_view] = false
  end

  def set_response_headers
    response.headers['Pragma']        = 'no-cache'
    response.headers['Cache-Control'] = 'no-store'
    response.headers['Expires']       = 'Thu, 01 Dec 1994 16:00:00 GMT'
  end

  OCCUPATION_MAP = {
    0     => '全て',
    1     => ' 管理的職業',
    2     => ' 研究・技術の職業',
    3     => ' 法務・経営・文化芸術等の専門的職業',
    4     => ' 医療・看護・保健の職業',
    5     => ' 保育・教育の職業',
    6     => ' 事務的職業',
    7     => ' 販売・営業の職業',
    8     => ' 福祉・介護の職業',
    9     => ' サービスの職業',
    10     => ' 警備・保安の職業',
    11     => ' 農林漁業の職業',
    12     => ' 製造・修理・塗装・製図等の職業',
    13     => ' 配送・輸送・機械運転の職業',
    14     => ' 建設・土木・電気工事の職業',
    15     => ' 運搬・清掃・包装・選別等の職業',
  }

  def occupation_list
    OCCUPATION_MAP.map{ |k,v| [v, k] }
  end

  protected
#  def after_sign_out_path_for(resource_or_scope)
#  end

  def after_sign_in_path_for(resource)
    if current_user.present?
#      login_flg = current_user.user_info.login_flg
#      unless login_flg
#        sign_out User.find(current_user.id)
#      end
    end
    stored_location_for(resource) || (current_user.present? ? menus_path : kaisha_menus_path)
  end
end
