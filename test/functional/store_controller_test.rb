require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "session contains cart" do
    get :index
    assert session[:cart]
  end

  test "add to cart adds a product to the cart" do
    post :add_to_cart, :id => products(:one).id
    assert_response :success
    assert cart = assigns(:cart)
    assert_equal 1, cart.items.length
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)

    Product.find_products_for_sale.each do |product|
      assert_tag :tag => 'h3', :content => product.title
      assert_match /#{sprintf("%01.2f", product.price)}/, @response.body
    end
  end

  test "empty cart removes all products from cart" do
    post :add_to_cart, :id => products(:one).id
    assert_response :success
    get :index
    assert_response :success
    post :add_to_cart, :id => products(:two).id
    assert cart = assigns(:cart)
    assert_equal 2, cart.items.length

    get :empty_cart
    assert_nil session[:cart]
    assert_redirected_to :action => 'index'
    get :index
    assert_match /id=\"cart\" style=\"display: none\"/i, @response.body
  end

  test "fake product redirects to index with flash" do
    post :add_to_cart, :id => 987654321
    assert_redirected_to :action => 'index'
    assert flash[:notice]
  end

  def localization_test_template
    locales = LANGUAGES.to_a.map{ |locale|
      locale.last
    }
    locales.each { |locale|
      translations = YAML.load_file("#{LOCALES_DIRECTORY}#{locale}.yml")
      yield(locale, translations)
    }
  end

  test "store controller index is localized" do
    localization_test_template { |locale, translations|
      @request.session[:user_id] = users(:one).id
      get :index, :locale => locale

      assert_match translations[locale]['layout']['side']['questions'], @response.body
      assert_match translations[locale]['layout']['title'], @response.body
      assert_match translations[locale]['main']['title'], @response.body
    }
  end

  test "cart is localize" do
    post :add_to_cart, :id => products(:one).id

    localization_test_template { |locale, translations|
      @request.session[:user_id] = users(:one).id
      get :index, :locale => locale
      assert_match translations[locale]['layout']['cart']['button']['empty'], @response.body
    }
  end

  test "checkout is localized" do
    post :add_to_cart, :id => products(:one).id

    localization_test_template { |locale, translations|
      @request.session[:user_id] = users(:one).id
      post :checkout, :locale => locale
      assert_match translations[locale]['checkout']['address'], @response.body
      assert_match translations[locale]['checkout']['legend'], @response.body
    }
  end
end

