class AddFirstUser < ActiveRecord::Migration
  def self.up
    User.delete_all

    User.create(:name => 'mathew', :password => 'secret',
                :password_confirmation => 'secret')


  end

  def self.down
    User.delete_all
  end
end
