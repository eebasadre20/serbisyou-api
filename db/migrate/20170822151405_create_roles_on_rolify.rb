class CreateRolesOnRolify < ActiveRecord::Migration[5.0]
  def up 
      ['super_user', 'office_admin', 'admin', 'service_provider', 'client'].each do | role |
        Role.create! name: role 
      end
  end

  def down
    Role.all.destroy_all
  end
end
