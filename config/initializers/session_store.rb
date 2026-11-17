#Rails.application.config.session_store :cookie_store, key: "_reserve_session", secure: true, expire_after: 1.days
#Rails.application.config.action_dispatch.cookies_serializer = :hybrid
Rails.application.config.session_store :cookie_store, 
                                        key: "_niho_session",
                                        secure: !(Rails.env.test? or Rails.env.development?),
                                        expire_after: 1.days