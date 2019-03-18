require 'rack/test'
require 'minitest/autorun'

OUTER_APP = Rack::Builder.parse_file("#{__dir__}/../config.ru").first

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  def test_root
    get '/'
    assert last_response.ok?
    assert_equal last_response.content_type, 'text/plain'
    assert_equal 'Hello World', last_response.body
  end

  def test_params
    get '/params?foo=1'
    assert last_response.ok?
    assert_equal last_response.content_type, 'application/json'
    assert_equal last_request.params.to_json, last_response.body
  end

  def test_not_found
    get '/bar'
    assert last_response.not_found?
    assert_equal 'Not found', last_response.body
  end
  
end