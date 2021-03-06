require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def test_validation_error member, error_string
    bad_order = Order.new
    bad_order.save
    assert(bad_order.errors.on(member).to_a.include?(error_string))
  end

  test "validates name" do
    test_validation_error 'name', "can't be blank"
  end

  test "validates address" do
    test_validation_error 'address', "can't be blank"
  end

  test "validates email" do
    test_validation_error 'email', "can't be blank"
  end

  test "validates pay_type presence" do
    test_validation_error 'pay_type', "can't be blank"
  end

  test "validates pay_type inclusion" do
    test_validation_error 'pay_type', "is not included in the list"
  end

  test "line item added from cart" do
    order = orders(:one)
    cart = Cart.new
    cart.add_product products(:one)
    order.add_line_items_from_cart(cart)

    assert_equal(1,(LineItem.find_all_by_order_id order.id).size)
  end

  test "multiple line items added from cart" do
    order = orders(:two)
    cart = Cart.new
    cart.add_product products(:one)
    cart.add_product products(:two)
    order.add_line_items_from_cart(cart)

    assert_equal(2,(LineItem.find_all_by_order_id order.id).size)
  end
end
