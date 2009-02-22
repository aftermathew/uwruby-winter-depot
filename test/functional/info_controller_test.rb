require 'test_helper'
require 'nokogiri'

class InfoControllerTest < ActionController::TestCase
  def setup
    @request.session[:user_id] = users(:one).id
  end

  test "xml format" do
    get :who_bought, :id => products(:one).id,
      :format => 'xml'

    doc = Nokogiri::XML(@response.body)
    assert_equal 1, doc.xpath('/product').length
  end

  test "xml format with multiple orders" do
    cart = Cart.new
    cart.add_product products(:one)
    orders(:two).add_line_items_from_cart(cart)
    orders(:one).add_line_items_from_cart(cart)

    get :who_bought, :id => products(:one).id,
      :format => 'xml'

    doc = Nokogiri::XML(@response.body)
    assert_equal 1, doc.xpath('/product').length
    assert_equal 2, doc.xpath('/product/orders/order').length
  end

  test "json format" do
    get :who_bought, :id => products(:one).id,
      :format => 'json'

    doc = ActiveSupport::JSON.decode(@response.body)
    assert doc['product']
    assert doc['product']['title']
    assert_equal assigns(:product).title, doc['product']['title']
  end
end

