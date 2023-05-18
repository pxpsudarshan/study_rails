class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_response_headers, except: [ ]
  helper_method :occupation_list
  before_action :authenticate_user!
  before_action :force_tablet_html
#  has_mobile_fu
  before_action do
    RecordWithOperator.operator = current_user || User.first
  end

  def force_tablet_html
      session[:tablet_view] = false
  end

  def set_response_headers
    response.headers['Pragma']        = 'no-cache'
    response.headers['Cache-Control'] = 'no-store'
    response.headers['Expires']       = 'Thu, 01 Dec 1994 16:00:00 GMT'
  end

  module OccupationType
    ALL     = 0
    KEIEI   = 1
    KANRI   = 2
    EIGYO   = 3
    JINJI   = 4
    CONSULT = 5
    IT      = 6
    MARKET  = 7
    PROJECT = 8
    KIKAI   = 9
    SENMON  = 10
  end

  include OccupationType

  OCCUPATION_MAP = {
    ALL     => '全て',
    KEIEI   => '経営',
    KANRI   => '管理',
    EIGYO   => '営業',
    JINJI   => '人事',
    CONSULT => 'コンサルタント',
    IT      => 'IT技術職',
    MARKET  => 'マーケテェング',
    PROJECT => 'プロジェクト管理',
    KIKAI   => '機械',
    SENMON  => '専門職など',
  }

  def occupation_list
    OCCUPATION_MAP.map{ |k,v| [v, k] }
  end
end
