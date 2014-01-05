module Admin::PermissionsHelper
  def permissions
    # This hash only displays one permission, 
    # but we should add the permissions configurable by admins
    {
      "view" => "View",
      "create tickets" => "Create tickets",
      "edit tickets" => "Edit tickets",
      "delete tickets" => "Delete tickets"
    }
  end
end
