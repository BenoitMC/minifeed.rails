class UserSerializer < ApplicationSerializer
  def attributes
    list = [
      :id,
    ]

    if object == current_user
      list += %i[
        email
        auth_token
      ]
    end

    list
  end
end
